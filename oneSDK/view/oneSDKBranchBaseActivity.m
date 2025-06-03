//
//  oneSDKBranchBaseActivity.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchBaseActivity.h"
#import "./../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../http/oneSDKBranchHttpManager.h"
#import "./../utils/oneSDKBranchUtils.h"
#import "./../view/login/oneSDKBranchLoginView.h"
#import "./../utils/oneSDKBranchToastUtils.h"

// mineTAG
NSString* mineTAGoneSDKBranchBaseActivity;

@implementation oneSDKBranchBaseActivity

// 获取总接口(sdk一旦初始化, 就需要调用这个接口)
+(void)getGeneralInterface
{
    mineTAGoneSDKBranchBaseActivity = @"oneSDKBranchBaseActivity";
    
    // 如果没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    // 请求总接口名称
    [oneSDKBranchBaseActivity doSDKInterfaceInfo];
}

// 总json
+(NSMutableDictionary*)getBaseJson
{
//    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",@"v2",@"key2",nil];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue: [[oneSDKBranchPlayerConfig getInstance] getChannelId] forKey: @"CHANNEL_ID"];
    [dict setValue: [[oneSDKBranchPlayerConfig getInstance] getMacAddress] forKey: @"phone_md5_code"];
    [dict setValue: [[oneSDKBranchPlayerConfig getInstance] getAppId] forKey: @"APPID"];
    [dict setValue: [[oneSDKBranchPlayerConfig getInstance] getPlatformId] forKey: @"PLATFORM_ID"];
    return dict;
}

// 请求域名以及其余接口名称
+(void)doSDKInterfaceInfo
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    NSString* mineCode = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_phone_md5_code"].length == 0 ? @"1" : [oneSDKBranchUtils permanentLoad:@"onesdkbranch_phone_md5_code"];
    
    [[oneSDKBranchPlayerConfig getInstance] setMacAddress:mineCode];
    
    oneSDKBranchLogUtils(@"getMacAddress is %@, mineCode is %@", [[oneSDKBranchPlayerConfig getInstance] getMacAddress], mineCode);
    
    NSString* mineSign_str = @"";
    NSString* mineSign = @"";
    NSString* encryptionStr = @"";
    
    //# sdk 测试服域名
    //安卓加密证书使用：zzyl-sdk.cibmall.net
    //苹果加密证书使用：zzyl-sdkios.cibmall.net
    
    // 测试服
    NSString* url = @"";
    if ([[[oneSDKBranchPlayerConfig getInstance] getProducteState] isEqual:@"1"])
    {
        // 测试服
        url = @"https://zzyl-sdkios.cibmall.net/interface_v2.php?c=IGoGame&m=ISdkConf";
    }
    else if ([[[oneSDKBranchPlayerConfig getInstance] getProducteState] isEqual:@"2"])
    {
        // 正式服
        url = @"https://zzyl-sdk.playparksdk.com/interface_v2.php?c=IGoGame&m=ISdkConf";
    }
    
    if (url.length == 0)
    {
        return;
    }
    
    mineSign_str = [mineSign_str stringByAppendingFormat:@"APPID=%@&CHANNEL_ID=%@&EqType=ios&PLATFORM_ID=%@&phone_md5_code=%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], [[oneSDKBranchPlayerConfig getInstance] getChannelId], [[oneSDKBranchPlayerConfig getInstance] getPlatformId], mineCode];
    
    oneSDKBranchLogUtils(@"mineSign_str is %@", mineSign_str);
    mineSign = [mineSign stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], mineSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    encryptionStr = [oneSDKBranchUtils getSHA256:mineSign];
    
    oneSDKBranchLogUtils(@"%@, mineSign is %@", mineTAGoneSDKBranchBaseActivity, mineSign);
    oneSDKBranchLogUtils(@"%@, encryptionStr is %@", mineTAGoneSDKBranchBaseActivity, encryptionStr);
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doSDKInterfaceInfo newUrl is %@", mineTAGoneSDKBranchBaseActivity, newUrl);
    
    NSMutableDictionary* mineJson = [NSMutableDictionary dictionary];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getAppId] forKey: @"APPID"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getChannelId] forKey: @"CHANNEL_ID"];
    [mineJson setValue:@"ios" forKey: @"EqType"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getPlatformId] forKey: @"PLATFORM_ID"];
    [mineJson setValue:mineCode forKey: @"phone_md5_code"];
    [mineJson setValue:encryptionStr forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        oneSDKBranchLogUtils(@"%@, code:%@", mineTAGoneSDKBranchBaseActivity, code);
        
        // 如果请求成功
        if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
        {
            [oneSDKBranchBaseActivity setSDKInterfaceInfo:object];
            
            // 从后台获取唯一码
            // 判断本地是否有唯一码
            if ([[[oneSDKBranchPlayerConfig getInstance] getMacAddress] isEqual:@"1"])
            {
                NSString* phone_md5_code = [oneSDKBranchUtils isContains:object andKey:@"phone_md5_code"];
                [[oneSDKBranchPlayerConfig getInstance] setMacAddress:phone_md5_code];
                // 保存一下唯一码
                [oneSDKBranchUtils permanentSave:@"onesdkbranch_phone_md5_code" Value:[[oneSDKBranchPlayerConfig getInstance] getMacAddress]];
            }
        }
        else
        {
            // 返回失败, 告诉用户失败原因
            NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
            [oneSDKBranchToastUtils show:msg duration:2.0f];
        }
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchBaseActivity, error);
    }];
}

// 设置总名称
+(void)setSDKInterfaceInfo:(NSMutableDictionary*)json
{
    NSString* loginFuncName = [oneSDKBranchUtils isContains:json andKey:@"loginFuncName"];
    NSString* logoutFuncName = [oneSDKBranchUtils isContains:json andKey:@"logoutFuncName"];
    NSString* registerFuncName = [oneSDKBranchUtils isContains:json andKey:@"registerFuncName"];
    NSString* guestFuncName = [oneSDKBranchUtils isContains:json andKey:@"guestFuncName"];
    NSString* appleLoginFuncName = [oneSDKBranchUtils isContains:json andKey:@"appleLoginFuncName"];
    NSString* facebookLoginFuncName = [oneSDKBranchUtils isContains:json andKey:@"facebookLoginFuncName"];
    NSString* googleLoginFuncName = [oneSDKBranchUtils isContains:json andKey:@"googleLoginFuncName"];
    NSString* forgetPasswordFuncName = [oneSDKBranchUtils isContains:json andKey:@"forgetPasswordFuncName"];
    NSString* modifyPasswordFuncName = [oneSDKBranchUtils isContains:json andKey:@"modifyPasswordFuncName"];
    NSString* bindFuncName = [oneSDKBranchUtils isContains:json andKey:@"bindFuncName"];
    NSString* submitForgetPasswordFuncName = [oneSDKBranchUtils isContains:json andKey:@"submitForgetPasswordFuncName"];
    NSString* submitModifyPasswordFuncName = [oneSDKBranchUtils isContains:json andKey:@"submitModifyPasswordFuncName"];
    NSString* submitBindFuncName = [oneSDKBranchUtils isContains:json andKey:@"submitBindFuncName"];
    NSString* forceBindEmailFuncName = [oneSDKBranchUtils isContains:json andKey:@"forceBindEmailFuncName"];
    NSString* submitForceBindEmailFuncName = [oneSDKBranchUtils isContains:json andKey:@"submitForceBindEmailFuncName"];
    NSString* updateUserLogsFuncName = [oneSDKBranchUtils isContains:json andKey:@"updateUserLogsFuncName"];
    NSString* updateGameInfoFuncName = [oneSDKBranchUtils isContains:json andKey:@"updateGameInfoFuncName"];
    NSString* realNameFuncName = [oneSDKBranchUtils isContains:json andKey:@"realNameFuncName"];
    NSString* md5CodeFuncName = [oneSDKBranchUtils isContains:json andKey:@"md5CodeFuncName"];
    NSString* pOrderFuncName = [oneSDKBranchUtils isContains:json andKey:@"pOrderFuncName"];
    NSString* delUserFuncName = [oneSDKBranchUtils isContains:json andKey:@"delUserFuncName"];
    NSString* pOrderCallBackFuncName = [oneSDKBranchUtils isContains:json andKey:@"pOrderCallBackFuncName"];
    NSString* autologinFuncName = [oneSDKBranchUtils isContains:json andKey:@"authloginFuncName"];
    NSString* modifyNickNameFuncName = [oneSDKBranchUtils isContains:json andKey:@"modifyNickNameFuncName"];
    NSString* checkBindName = [oneSDKBranchUtils isContains:json andKey:@"getCheckBindName"];
    NSString* unbindEmailName = [oneSDKBranchUtils isContains:json andKey:@"setIUnbindEmailName"];
    NSMutableDictionary* btn = [oneSDKBranchUtils isContains:json andKey:@"btn"];
    NSString* guest_btn = [oneSDKBranchUtils isContains:btn andKey:@"guest_btn"];
    NSString* facebook_btn = [oneSDKBranchUtils isContains:btn andKey:@"facebook_btn"];
    NSString* google_btn = [oneSDKBranchUtils isContains:btn andKey:@"google_btn"];
    NSString* apple_btn = [oneSDKBranchUtils isContains:btn andKey:@"apple_btn"];
    NSString* isShowClearBtn = [oneSDKBranchUtils isContains:json andKey:@"isShowClearBtn"];
    
    [[oneSDKBranchPlayerConfig getInstance] setLoginFuncName:loginFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setLogoutFuncName:logoutFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setRegisterFuncName:registerFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setGuestFuncName:guestFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setAppleLoginFuncName:appleLoginFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setFacebookLoginFuncName:facebookLoginFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setGoogleLoginFuncName:googleLoginFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setForgetPasswordFuncName:forgetPasswordFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setModifyPasswordFuncName:modifyPasswordFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setBindFuncName:bindFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setSubmitForgetPasswordFuncName:submitForgetPasswordFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setSubmitModifyPasswordFuncName:submitModifyPasswordFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setSubmitBindFuncName:submitBindFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setForceBindFuncName:forceBindEmailFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setSubmitForceBindEmailFuncName:submitForceBindEmailFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setUpdateUserLogsFuncName:updateUserLogsFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setUpdateGameInfoFuncName:updateGameInfoFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setRealNameFuncName:realNameFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setMd5CodeFuncName:md5CodeFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setPOrderFuncName:pOrderFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setClearAccountFuncName:delUserFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setPayCallbackFuncName:pOrderCallBackFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setAutologinFuncName:autologinFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setModifyNickNameFuncName:modifyNickNameFuncName];
    [[oneSDKBranchPlayerConfig getInstance] setCheckPlayerForceBindStateFuncName:checkBindName];
    [[oneSDKBranchPlayerConfig getInstance] setUnForceBindFuncName:unbindEmailName];
    [[oneSDKBranchPlayerConfig getInstance] setGuestBtnIsCanShow:[[oneSDKBranchUtils toNSString:guest_btn] isEqualToString:@"1"]];
    [[oneSDKBranchPlayerConfig getInstance] setFbBtnIsCanShow:[[oneSDKBranchUtils toNSString:facebook_btn] isEqualToString:@"1"]];
    [[oneSDKBranchPlayerConfig getInstance] setGoogleBtnIsCanShow:[[oneSDKBranchUtils toNSString:google_btn] isEqualToString:@"1"]];
    [[oneSDKBranchPlayerConfig getInstance] setAppleBtnIsCanShow:[[oneSDKBranchUtils toNSString:apple_btn] isEqualToString:@"1"]];
    [[oneSDKBranchPlayerConfig getInstance] setIsShowClearBtn:[[oneSDKBranchUtils toNSString:isShowClearBtn] isEqualToString:@"1"]];
    
    oneSDKBranchLogUtils(@"loginFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getLoginFuncName]);
    oneSDKBranchLogUtils(@"logoutFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getLogoutFuncName]);
    oneSDKBranchLogUtils(@"registerFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getRegisterFuncName]);
    oneSDKBranchLogUtils(@"guestFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getGuestFuncName]);
    oneSDKBranchLogUtils(@"appleLoginFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getAppleLoginFuncName]);
    oneSDKBranchLogUtils(@"facebookLoginFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getFacebookLoginFuncName]);
    oneSDKBranchLogUtils(@"googleLoginFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getGoogleLoginFuncName]);
    oneSDKBranchLogUtils(@"forgetPasswordFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getForgetPasswordFuncName]);
    oneSDKBranchLogUtils(@"modifyPasswordFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getModifyPasswordFuncName]);
    oneSDKBranchLogUtils(@"bindFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getBindFuncName]);
    oneSDKBranchLogUtils(@"submitForgetPasswordFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getSubmitForgetPasswordFuncName]);
    oneSDKBranchLogUtils(@"submitModifyPasswordFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getSubmitModifyPasswordFuncName]);
    oneSDKBranchLogUtils(@"submitBindFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getSubmitBindFuncName]);
    oneSDKBranchLogUtils(@"forceBindFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getForceBindFuncName]);
    oneSDKBranchLogUtils(@"submitForceBindEmailFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getSubmitForceBindEmailFuncName]);
    oneSDKBranchLogUtils(@"updateUserLogsFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getUpdateUserLogsFuncName]);
    oneSDKBranchLogUtils(@"updateGameInfoFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getUpdateGameInfoFuncName]);
    oneSDKBranchLogUtils(@"realNameFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getRealNameFuncName]);
    oneSDKBranchLogUtils(@"md5CodeFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getMd5CodeFuncName]);
    oneSDKBranchLogUtils(@"pOrderFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getPOrderFuncName]);
    oneSDKBranchLogUtils(@"clearAccountFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getClearAccountFuncName]);
    oneSDKBranchLogUtils(@"payCallbackFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getPayCallbackFuncName]);
    oneSDKBranchLogUtils(@"autologinFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getAutologinFuncName]);
    oneSDKBranchLogUtils(@"modifyNickNameFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getModifyNickNameFuncName]);
    oneSDKBranchLogUtils(@"checkPlayerForceBindStateFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getCheckPlayerForceBindStateFuncName]);
    oneSDKBranchLogUtils(@"unForceBindFuncName is %@", [[oneSDKBranchPlayerConfig getInstance] getUnForceBindFuncName]);
    oneSDKBranchLogUtils(@"id_btn is %s", ([[oneSDKBranchPlayerConfig getInstance] getGuestBtnIsCanShow]) ? "true" : "false");
    oneSDKBranchLogUtils(@"facebook_btn is %s", ([[oneSDKBranchPlayerConfig getInstance] getFbBtnIsCanShow]) ? "true" : "false");
    oneSDKBranchLogUtils(@"google_btn is %s", ([[oneSDKBranchPlayerConfig getInstance] getGoogleBtnIsCanShow]) ? "true" : "false");
    oneSDKBranchLogUtils(@"apple_btn is %s", ([[oneSDKBranchPlayerConfig getInstance] getAppleBtnIsCanShow]) ? "true" : "false");
    oneSDKBranchLogUtils(@"getIsShowClearBtn is %s", ([[oneSDKBranchPlayerConfig getInstance] getIsShowClearBtn]) ? "true" : "false");
}

@end
