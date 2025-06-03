//
//  paySDKPayView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchPayView.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../../oneSDK/oneSDKBranch.h"
#import "./../../always/always.h"

// appid
NSString* APPIDoneSDKBranchPayView;
// appkey
NSString* APPKEYoneSDKBranchPayView;
// channel_id
NSString* CHANNEL_IDoneSDKBranchPayView;
// platform_id
NSString* PLATFORM_IDoneSDKBranchPayView;
// mineTAG
NSString* mineTAGoneSDKBranchPayView;
// 游戏单号
NSString* gamePayOrder;
// sdk单号
NSString* sdkPayOrder;
// 广告支付id
NSString* adjustCode;

@implementation oneSDKBranchPayView

// 下单(内购点, 订单号, 广告支付id, 玩家id, 玩家昵称, 玩家等级, 玩家vip等级, 服务器id, 服务器名称, 金额(人民币), 金额(美金), 套餐个数)
+(void)placeOrder:(NSString*)payCode Oid:(NSString*)oid AdPayId:(NSString*)adPayId PlayerId:(NSString*)playerId PlayerName:(NSString*)playerName PlayerLevel:(NSString*)playerLevel PlayerVipLevel:(NSString*)playerVipLevel ServerId:(NSString*)serverId ServerName:(NSString*)serverName Rmb:(double)rmb Doller:(double)doller OrderNumber:(int)orderNumber;
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    adjustCode = adPayId;
    
    // 如果没有获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getPOrderFuncName] == nil)
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    gamePayOrder = oid;
    sdkPayOrder = @"";
    APPIDoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getAppId];
    APPKEYoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getAppKey];
    CHANNEL_IDoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getChannelId];
    PLATFORM_IDoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getPlatformId];
    mineTAGoneSDKBranchPayView = @"oneSDKBranchPayView";
    
    NSMutableDictionary* mineNewJson = [NSMutableDictionary dictionary];
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [mineNewJson setValue:playerId forKey: @"uid"];                         // 玩家id
    [mineNewJson setValue:playerName forKey: @"nickname"];                  // 玩家昵称
    [mineNewJson setValue:playerLevel forKey: @"player_level"];             // 玩家等级
    [mineNewJson setValue:playerVipLevel forKey: @"player_vip_level"];      // 玩家vip等级
    [mineNewJson setValue:serverId forKey: @"server_id"];                   // 服务器id
    [mineNewJson setValue:serverName forKey: @"server_name"];               // 服务器名称
    // 将mineNewJson转换成NSString
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:mineNewJson options:0 error:0];
    NSString* dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // urlEncode加密
    NSString* newStr = [oneSDKBranchUtils base64Encode:dataStr];
    
    [json setValue:APPIDoneSDKBranchPayView forKey: @"APPID"];
    [json setValue:CHANNEL_IDoneSDKBranchPayView forKey: @"CHANNEL_ID"];
    [json setValue:PLATFORM_IDoneSDKBranchPayView forKey: @"PLATFORM_ID"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [json setValue:oid forKey: @"order_sign"];
    [json setValue:newStr forKey: @"game_log"];
    NSString* stringInt1 = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getLoginType]];
    [json setValue:stringInt1 forKey: @"type"];
    [json setValue:@"2" forKey: @"order_type"];
    [json setValue:[oneSDKBranchUtils base64Encode:payCode] forKey: @"product_id"];
    NSString* double1 = [NSString stringWithFormat:@"%.2f", rmb];
    [json setValue:double1 forKey: @"rmb"];
    NSString* double2 = [NSString stringWithFormat:@"%.2f", doller];
    [json setValue:double2 forKey: @"doller"];
    NSString* stringInt2 = [NSString stringWithFormat:@"%d", orderNumber];
    [json setValue:stringInt2 forKey: @"number"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:json];
    oneSDKBranchLogUtils(@"%@, placeOrder newSign_str is %@", mineTAGoneSDKBranchPayView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", APPIDoneSDKBranchPayView, newSign_str, APPKEYoneSDKBranchPayView];
    oneSDKBranchLogUtils(@"%@, placeOrder str is %@", mineTAGoneSDKBranchPayView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, placeOrder newSign is %@", mineTAGoneSDKBranchPayView, newSign);
    [json setValue:newSign forKey: @"SIGN"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getPOrderFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, placeOrder newUrl is %@", mineTAGoneSDKBranchPayView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, placeOrder result is %@", mineTAGoneSDKBranchPayView, object);
        
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        // 如果请求成功
        if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
        {
            NSString* order_number = [oneSDKBranchUtils isContains:object andKey:@"order_number"];
            sdkPayOrder = order_number;
        }
        else
        {
            
        }
        NSMutableDictionary* rjson = [object mutableCopy];
        [rjson setValue:payCode forKey: @"payCode"];
        // 通知客户端下单结果
        [always onPorderCallback:rjson];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchPayView, error);
    }];
}

// 支付成功
+(void)payCallback:(NSString*)applePayToken
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getPayCallbackFuncName] == nil)
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 没有单号
    if ([[oneSDKBranchUtils toNSString:sdkPayOrder] isEqualToString:@""])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"applepayorderfailed"] duration:2.0f];
        return;
    }
    
    // 上报给adjust
    [oneSDKBranch sendSDKTrack:adjustCode];
    
    APPIDoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getAppId];
    APPKEYoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getAppKey];
    CHANNEL_IDoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getChannelId];
    PLATFORM_IDoneSDKBranchPayView = [[oneSDKBranchPlayerConfig getInstance] getPlatformId];
    mineTAGoneSDKBranchPayView = @"oneSDKBranchPayView";
    
    NSMutableDictionary* mineNewJson = [NSMutableDictionary dictionary];
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [mineNewJson setValue:gamePayOrder forKey: @"appleOrderId"];
    [mineNewJson setValue:applePayToken forKey: @"appleToken"];
    
    // 将mineNewJson转换成NSString
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:mineNewJson options:0 error:0];
    NSString* dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // urlEncode加密
    NSString* newStr = [oneSDKBranchUtils base64Encode:dataStr];
    [json setValue:APPIDoneSDKBranchPayView forKey: @"APPID"];
    [json setValue:CHANNEL_IDoneSDKBranchPayView forKey: @"CHANNEL_ID"];
    [json setValue:PLATFORM_IDoneSDKBranchPayView forKey: @"PLATFORM_ID"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [json setValue:@"ios" forKey: @"order_sign"];
    [json setValue:sdkPayOrder forKey: @"sdk_order_id"];
    [json setValue:newStr forKey: @"pay_log"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:json];
    oneSDKBranchLogUtils(@"%@, payCallback newSign_str is %@", mineTAGoneSDKBranchPayView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", APPIDoneSDKBranchPayView, newSign_str, APPKEYoneSDKBranchPayView];
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, payCallback newSign is %@", mineTAGoneSDKBranchPayView, newSign);
    [json setValue:newSign forKey: @"SIGN"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getPayCallbackFuncName];
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, payCallback newUrl is %@", mineTAGoneSDKBranchPayView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, payCallback result is %@", mineTAGoneSDKBranchPayView, object);
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        [oneSDKBranchToastUtils show:msg duration:2.0f];
        // 通知客户端支付结果
        [always onPayCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchPayView, error);
    }];
}

@end
