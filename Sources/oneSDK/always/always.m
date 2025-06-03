//
//  always.m
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import "./always.h"
#import "./../utils/oneSDKBranchToastUtils.h"
#import "./../utils/oneSDKBranchUtils.h"
#import "./../utils/oneSDKBranchRSAUtils.h"
#import "./../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../view/oneSDKBranchBaseActivity.h"
#import "./../view/login/oneSDKBranchLoginView.h"
#import "./../listener/oneSDKBranchListener.h"
#import "./../view/pay/oneSDKBranchPayView.h"
#import "./../http/oneSDKBranchHttpManager.h"
#import "./../view/login/oneSDKBranchLoginView.h"
#import "./../view/register/oneSDKBranchRegisterView.h"
#import "./../view/forget/oneSDKBranchForgetView.h"
#import "./../view/tips/oneSDKBranchTipsView.h"
#import "./../view/info/oneSDKBranchUserInfoView.h"
#import "./../view/oneSDKBranchBaseActivity.h"
#import "./../view/pay/oneSDKBranchPayView.h"
#import "./../view/forcebind/oneSDKBranchForceBindView.h"
#import "./../view/modifynickname/oneSDKBranchModifyNickName.h"
#import "./../view/forcebind/oneSDKBranchForceBindRewardView.h"
#import "./../gameJniHelper/oneSDKBranchGameJniHelper.h"
#import "./../view/loading/oneSDKBranchLoadingView.h"
#import "./../view/suspensionWindow/oneSDKBranchInternalSingleCase.h"
#import "AdjustSdk/AdjustSdk.h"

@implementation always

static id mContent = NULL;
static NSString* TAG = @"always";

// 初始化
+(void)init:(id)content
{
    // 已经初始化
    if (mContent != NULL)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"sdkAlreadyInit"] duration:2.0f];
        return;
    }
    
    mContent = content;
    
    [[oneSDKBranchPlayerConfig getInstance] setVersion:@"1.1.0"];
    
    // 获取info.plsit文件所有配置
    [always readInfo];
    
    // 配置adjust
    [always setSDKState];
    
    // 用户没有配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] getIsAllAllocationInInfoPlist])
    {
//        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    // 请求总接口
    [always initRootUrl];
}

// 获取fb参数
+(NSString*)getSchemesFacebookID
{
    NSString* facebookID = @"";
    NSArray* array = [oneSDKBranchUtils getSchemesArray];
    for (int i = 0; i < array.count; i++)
    {
        NSArray* innerArray = array[i];
        for (int j = 0; j < innerArray.count; j++)
        {
            // 包含google参数
            if ([oneSDKBranchUtils isContainStr:innerArray[j] andSpecify:@"fb"])
            {
                facebookID = innerArray[j];
            }
        }
    }
    return facebookID;
}

// 获取google参数
+(NSString*)getSchemesGoogle
{
    NSString* googleId = @"";
    NSArray* array = [oneSDKBranchUtils getSchemesArray];
    for (int i = 0; i < array.count; i++)
    {
        NSArray* innerArray = array[i];
        for (int j = 0; j < innerArray.count; j++)
        {
            // 包含google参数
            if ([oneSDKBranchUtils isContainStr:innerArray[j] andSpecify:@"com"])
            {
                // 倒序该参数
                googleId = [oneSDKBranchUtils reverseOrder:innerArray[j] andDelimiter:@"."];
            }
        }
    }
    return googleId;
}

+(void)readInfo
{
    oneSDKBranchLogUtils(@"readInfo is called");
    NSString* APPID = [oneSDKBranchUtils getInfoData:@"appId"];
    NSString* APPKEY = [oneSDKBranchUtils getInfoData:@"appKey"];
    NSString* CHANNEL_ID = [oneSDKBranchUtils getInfoData:@"channelId"];
    NSString* PLATFORM_ID = [oneSDKBranchUtils getInfoData:@"platformId"];
    NSString* token = [oneSDKBranchUtils getInfoData:@"adjustToken"];
    NSString* fbAppId = [oneSDKBranchUtils getInfoData:@"FacebookAppID"];
    NSString* producteState = [oneSDKBranchUtils getInfoData:@"producteState"];
    
    if (APPID == NULL)
    {
        oneSDKBranchLogUtils(@"APPID is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noappid"] duration:2.0f];
        return;
    }

    if (APPKEY == NULL)
    {
        oneSDKBranchLogUtils(@"APPKEY is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noappkey"] duration:2.0f];
        return;
    }

    if (CHANNEL_ID == NULL)
    {
        oneSDKBranchLogUtils(@"CHANNEL_ID is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nochannelId"] duration:2.0f];
        return;
    }

    if (PLATFORM_ID == NULL)
    {
        oneSDKBranchLogUtils(@"PLATFORM_ID is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noplatformId"] duration:2.0f];
        return;
    }
    
    if (token == NULL)
    {
        oneSDKBranchLogUtils(@"token is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noadjustToken"] duration:2.0f];
        return;
    }
    
    if (fbAppId == NULL)
    {
        oneSDKBranchLogUtils(@"fbAppId is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nofbAppID"] duration:2.0f];
        return;
    }
    
    if ([always getSchemesFacebookID].length == 0)
    {
        oneSDKBranchLogUtils(@"schemes facebookid is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nofbScheme"] duration:2.0f];
        return;
    }
    
    if ([always getSchemesGoogle].length == 0)
    {
        oneSDKBranchLogUtils(@"schemes googldid is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noschemesgoogleclientid"] duration:2.0f];
        return;
    }
    
    if (producteState == NULL)
    {
        oneSDKBranchLogUtils(@"producteState is null");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noProducteState"] duration:2.0f];
        return;
    }
    
    if (![producteState isEqualToString:@"1"] && ![producteState isEqualToString:@"2"])
    {
        oneSDKBranchLogUtils(@"producteState is error");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"notProducteState"] duration:2.0f];
        return;
    }
    
    oneSDKBranchLogUtils(@"APPID is %@, CHANNEL_ID is %@, APPKEY is %@, PLATFORM_ID is %@， token is %@, fbAppId is %@, schemesFacebookID is %@, schemesGoogle is %@, producteState is %@", APPID, CHANNEL_ID, APPKEY, PLATFORM_ID, token, fbAppId, [always getSchemesFacebookID], [always getSchemesGoogle], producteState);
    
    [[oneSDKBranchPlayerConfig getInstance] setAppId:APPID];
    [[oneSDKBranchPlayerConfig getInstance] setAppKey:APPKEY];
    [[oneSDKBranchPlayerConfig getInstance] setChannelId:CHANNEL_ID];
    [[oneSDKBranchPlayerConfig getInstance] setPlatformId:PLATFORM_ID];
    [[oneSDKBranchPlayerConfig getInstance] setMacAddress:[oneSDKBranchUtils permanentLoad:@"onesdkbranch_phone_md5_code"]];
    [[oneSDKBranchPlayerConfig getInstance] setAdjustToken:token];
    [[oneSDKBranchPlayerConfig getInstance] setGoogleID:[always getSchemesGoogle]];
    [[oneSDKBranchPlayerConfig getInstance] setProducteState:producteState];
    [[oneSDKBranchPlayerConfig getInstance] setIsAllAllocationInInfoPlist:true];
}

+(void)initRootUrl
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 请求总接口名称
    [oneSDKBranchBaseActivity getGeneralInterface];
}

+(void)sendLogin
{
    if (mContent == NULL)
    {
        return;
    }
    
    // 用户未配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] isAllAllocationInInfoPlist])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 从本地获取onesdkbranch_access_token和玩家账号
    NSString* access_token = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_token"];
    NSString* access = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_account"];
    
    // 输出一下
    oneSDKBranchLogUtils(@"%@, sendLogin access_token is %@, access is %@", TAG, access_token, access);
    
    // 如果登录界面存在
    if ([oneSDKBranchLoginView getApp] != NULL)
    {
        return;
    }
    
    // 添加登录界面
    oneSDKBranchLoginView* loginView = [[oneSDKBranchLoginView alloc] init];
    [[oneSDKBranchUtils getCurrentVC] addChildViewController:loginView];
    [[oneSDKBranchUtils getCurrentVC].view addSubview:loginView.view];
    
    // sdk内部监听
    // 登录
    [oneSDKBranchListener addLoginSuccess:mContent];
    [oneSDKBranchListener addLoginFailed:mContent];
    
    // 删除账号
    [oneSDKBranchListener addDeleteAccountSuccess:mContent];
    [oneSDKBranchListener addDeleteAccountFailed:mContent];
    
    // 切换账号
    [oneSDKBranchListener addSwitchAccountSuccess:mContent];
    [oneSDKBranchListener addSwitchAccountFailed:mContent];
    
    // 下单
    [oneSDKBranchListener addPorderSuccess:mContent];
    [oneSDKBranchListener addPorderFailed:mContent];
    
    // 支付
    [oneSDKBranchListener addPaySuccess:mContent];
    [oneSDKBranchListener addPayFailed:mContent];
}

// 登录回调
+(void)onLoginCallback:(NSMutableDictionary*)value
{
    if (mContent == NULL)
    {
        return;
    }
    
    if (value.count == 0)
    {
        return;
    }
    
    oneSDKBranchLogUtils(@"%@, onLoginCallback value is %@", TAG, value);
    
    // 隐藏loading
    [always hideLoading];
    
    // 返回给用户的json数据
    NSString* code = [oneSDKBranchUtils isContains:value andKey:@"code"];
    
    // 登录成功
    if ([code isEqualToString:@"200"])
    {
        [always loginSuccess:value];
    }
    else if ([code isEqualToString:@"505"])
    {
        // 设置登录方式
        NSString* type = [oneSDKBranchUtils isContains:value andKey:@"type"];
        [[oneSDKBranchPlayerConfig getInstance] setLoginType:type];
        
        // 跳转到绑定界面
        oneSDKBranchForceBindView* view = [[oneSDKBranchForceBindView alloc] initView];
        [[oneSDKBranchUtils getCurrentVC].view addSubview:view];
    }
    else
    {
        oneSDKBranchLogUtils(@"onLoginCallback loginFailed %@", value);
        [always loginFailed:value];
    }
}

+(void)loginSuccess:(NSMutableDictionary*)json
{
    NSString* code = [oneSDKBranchUtils isContains:json andKey:@"code"];
    NSString* pUid = [oneSDKBranchUtils isContains:json andKey:@"user_id"];
    NSString* unique_id = [oneSDKBranchUtils isContains:json andKey:@"unique_id"];
    NSString* account = [oneSDKBranchUtils isContains:json andKey:@"account"];
    NSString* pName = [oneSDKBranchUtils isContains:json andKey:@"name"];
    NSString* online = [oneSDKBranchUtils isContains:json andKey:@"online"];
    NSString* pToken = [oneSDKBranchUtils isContains:json andKey:@"access_token"];
    NSString* registTime = [oneSDKBranchUtils isContains:json andKey:@"regist_time"];
    NSString* loginType = [oneSDKBranchUtils isContains:json andKey:@"type"];
    NSString* logintime = [oneSDKBranchUtils isContains:json andKey:@"logintime"];
    NSString* forceBindBtn = [oneSDKBranchUtils isContains:json andKey:@"bind_btn"];
    
    // 设置礼包
    NSString* activation_code = [oneSDKBranchUtils isContains:json andKey:@"activation_code"];
    NSString* activation_config = [oneSDKBranchUtils isContains:json andKey:@"activation_config"];
    NSString* activation_status = [oneSDKBranchUtils isContains:json andKey:@"activation_status"];
    [[oneSDKBranchPlayerConfig getInstance] setGoodsCode:activation_code];
    [[oneSDKBranchPlayerConfig getInstance] setGoods:activation_config];
    [[oneSDKBranchPlayerConfig getInstance] setGoodsStatus:activation_status];
    
    // 设置玩家信息
    [[oneSDKBranchPlayerConfig getInstance] setName:pName];
    [[oneSDKBranchPlayerConfig getInstance] setToken:pToken];
    [[oneSDKBranchPlayerConfig getInstance] setUid:pUid];
    // 获取登录时间
    [[oneSDKBranchPlayerConfig getInstance] setLoginTime:logintime];
    //玩家账号
    [[oneSDKBranchPlayerConfig getInstance] setAccount:account];
    // 过期时间戳
    [[oneSDKBranchPlayerConfig getInstance] setOverdueTime:online];
    // 注册时间
    [[oneSDKBranchPlayerConfig getInstance] setRegisterTime:registTime];
    // 登录方式
    [[oneSDKBranchPlayerConfig getInstance] setLoginType:loginType];
    // 悬浮窗强制绑定按钮打开状态("1"显示, "0"隐藏)
    [[oneSDKBranchPlayerConfig getInstance] setForceBindBtnIsCanShow:forceBindBtn];
    
    // 储存玩家登录方式
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_logintype" Value:loginType];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_nickName" Value:pName];
    
    // 返回给用户
    NSMutableDictionary* rJson = [NSMutableDictionary dictionary];
    [rJson setValue:code forKey: @"code"];
    [rJson setValue:pName forKey: @"name"];
    [rJson setValue:pToken forKey: @"token"];
    [rJson setValue:pUid forKey: @"uid"];
    [rJson setValue:loginType forKey: @"loginType"];
    [rJson setValue:unique_id forKey: @"unique_id"];
    
    // 发送登录成功事件
    [oneSDKBranchGameJniHelper sendLoginSuccess:rJson];
    
    // 储存账号和token
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_token" Value:pToken];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_account" Value:account];
    
    // 上报日志
    [always updateSDKUserLogs];
    
    // 打开悬浮球
    [always showSyFloatView];
    
    // 关闭view
    [always closeView];
    
    // 移除登录监听
    [always removeListenerByName:@"oneSDKBranchLoginSuccessListener"];
}

+(void)loginFailed:(NSMutableDictionary*)json
{
    // 返回给用户
    NSMutableDictionary* rJson = [NSMutableDictionary dictionary];
    NSString* code = [oneSDKBranchUtils isContains:json andKey:@"code"];
    NSString* msg = [oneSDKBranchUtils isContains:json andKey:@"msg"];
    [rJson setValue:code forKey: @"code"];
    [rJson setValue:msg forKey: @"msg"];
    
    oneSDKBranchLogUtils(@"loginFailed code is %@, msg is %@", code, msg);
    [oneSDKBranchToastUtils show:msg duration:2.0];
    
    // 发送登录失败事件
    [oneSDKBranchGameJniHelper sendLoginFailed:rJson];
    
    // 清理本地缓存数据
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_token" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_account" Value:@""];
    
    // 移除登录监听
    [always removeListenerByName:@"oneSDKBranchLoginFailedListener"];
}

// 切换账号
+(void)sendSwitchAccount
{
    if (mContent == NULL)
    {
        return;
    }
    
    // 用户未配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] isAllAllocationInInfoPlist])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    // 开启loading
    [always showLoading];
    
    // 发送切换账号事件
    [always onSwitchAccountCallback:@""];
}

// 切换账号回调
+(void)onSwitchAccountCallback:(NSString*)str
{
    if (mContent == NULL)
    {
        return;
    }
    
    [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"switchSuccess"] duration:2.0f];
    
    // 清理缓存
    [always clearCache];
    
    // 关闭悬浮球
    [always hideSyFloatView];
    // 清理sdk信息
    [always clearSDKAllInfo];
    // 隐藏loading
    [always hideLoading];
    
    if (str.length == 0)
    {
        //  关闭view
        [always closeView];
    }
    
    // 发送切换账号成功事件
    [oneSDKBranchGameJniHelper sendSwitchAccountSuccess];
    // 移除切换账号监听
    [always removeListenerByName:@"oneSDKBranchSwitchAccountSuccessListener"];
}

// 删除账号回调
+(void)onDeleteAccountCallback:(NSMutableDictionary*)json
{
    if (mContent == NULL)
    {
        return;
    }
    
    if (json.count == 0)
    {
        return;
    }
    
    oneSDKBranchLogUtils(@"%@, onDeleteAccountCallback value is %@", TAG, json);
    
    // 隐藏loading
    [always hideLoading];
    
    // 解析json
    NSString* code = [oneSDKBranchUtils isContains:json andKey:@"code"];
    if ([code isEqualToString:@"200"])
    {
        // 清理缓存
        [always clearCache];
        
        // 关闭悬浮球
        [always hideSyFloatView];
        // 清理sdk信息
        [always clearSDKAllInfo];
        //  关闭view
        [always closeView];
        
        // 发送删除账号事件
        [oneSDKBranchGameJniHelper sendDeleteAccountSuccess:json];
        // 移除删除账号监听
        [always removeListenerByName:@"oneSDKBranchDeleteAccountSuccessListener"];
    }
    else
    {
        // 发送删除账号事件
        [oneSDKBranchGameJniHelper sendDeleteAccountFailed:json];
        // 移除删除账号监听
        [always removeListenerByName:@"oneSDKBranchDeleteAccountFailedListener"];
    }
}

// 支付
+(void)sendPorder:(oneSDKBranchOrderInfo*)info
{
    if (mContent == NULL)
    {
        return;
    }
    
    // 用户未配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] isAllAllocationInInfoPlist])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    NSString* payCode = info.payCode;
    NSString* oid = info.oid;
    NSString* adPayId = info.adPayId;
    NSString* playerId = info.playerId;
    NSString* playerName = info.playerName;
    NSString* playerLevel = info.playerLevel;
    NSString* playerVipLevel = info.playerVipLevel;
    NSString* serverId = info.serverId;
    NSString* serverName = info.serverName;
    double rmb = info.rmb;
    double dollor = info.doller;
    int orderNumber = info.orderNumber;
    
    NSString* stringPayCode = [NSString stringWithFormat:@"%@", payCode];
    NSString* stringOid = [NSString stringWithFormat:@"%@", oid];
    NSString* stringAdPayId = [NSString stringWithFormat:@"%@", adPayId];
    NSString* stringPlayerId = [NSString stringWithFormat:@"%@", playerId];
    NSString* stringPlayerName = [NSString stringWithFormat:@"%@", playerName];
    NSString* stringServerId = [NSString stringWithFormat:@"%@", serverId];

    if ([[oneSDKBranchUtils toNSString:stringPayCode] isEqualToString:@""])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nopayCode"] duration:2.0f];
        return;
    }

    if ([[oneSDKBranchUtils toNSString:stringOid] isEqualToString:@""])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nooid"] duration:2.0f];
        return;
    }
    
    if ([[oneSDKBranchUtils toNSString:stringPlayerId] isEqualToString:@""])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noplayerId"] duration:2.0f];
        return;
    }
    
    if ([[oneSDKBranchUtils toNSString:stringPlayerName] isEqualToString:@""])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noplayerName"] duration:2.0f];
        return;
    }

    if ([[oneSDKBranchUtils toNSString:stringServerId] isEqualToString:@""])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noserverId"] duration:2.0f];
        return;
    }
    
    if (rmb <= 0.0 && dollor <= 0.0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noPrice"] duration:2.0f];
        return;
    }
    
    if (orderNumber <= 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"orderNumberZero"] duration:2.0f];
        return;
    }
    
    // 下单(内购点, 订单号, 广告支付id, 玩家id, 玩家昵称, 玩家等级, 玩家vip等级, 服务器id, 服务器名称, 金额(人民币), 金额(美金), 套餐个数)
    [oneSDKBranchPayView placeOrder:payCode Oid:oid AdPayId:stringAdPayId PlayerId:playerId PlayerName:playerName PlayerLevel:playerLevel PlayerVipLevel:playerVipLevel ServerId:serverId ServerName:serverName Rmb:rmb Doller:dollor OrderNumber:orderNumber];
}

// 下单回调
+(void)onPorderCallback:(NSMutableDictionary*)value
{
    // 解析json
    NSString* code = [oneSDKBranchUtils isContains:value andKey:@"code"];
    if ([code isEqualToString:@"200"])
    {
        // 发送下单事件
        [oneSDKBranchGameJniHelper sendPorderSuccess:value];
        // 移除下单监听
//        [always removeListenerByName:@"oneSDKBranchPorderSuccessListener"];
    }
    else
    {
        // 发送下单事件
        [oneSDKBranchGameJniHelper sendPorderFailed:value];
        // 移除下单监听
//        [always removeListenerByName:@"oneSDKBranchPorderFailedListener"];
    }
}

+(void)sendPay:(NSURL*)url
{
    NSData* receipt = [NSData dataWithContentsOfURL:url];
    NSString* str = [receipt base64EncodedStringWithOptions:0];
    [oneSDKBranchPayView payCallback:str];
}

// 支付回调
+(void)onPayCallback:(NSMutableDictionary*)value
{
    // 解析json
    NSString* code = [oneSDKBranchUtils isContains:value andKey:@"code"];
    if ([code isEqualToString:@"200"])
    {
        // 发送支付事件
        [oneSDKBranchGameJniHelper sendPaySuccess:value];
        // 移除支付监听
//        [always removeListenerByName:@"oneSDKBranchPaySuccessListener"];
    }
    else
    {
        // 发送支付事件
        [oneSDKBranchGameJniHelper sendPayFailed:value];
        // 移除支付监听
//        [always removeListenerByName:@"oneSDKBranchPayFailedListener"];
    }
}

// 上报sdk日志
+(void)updateSDKUserLogs
{
    if (mContent == NULL)
    {
        return;
    }
    
    // 用户未配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] isAllAllocationInInfoPlist])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getUpdateUserLogsFuncName].length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 返回给用户
    NSMutableDictionary* mineJson = [NSMutableDictionary dictionary];
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getChannelId] forKey: @"CHANNEL_ID"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getMacAddress] forKey: @"phone_md5_code"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getAppId] forKey: @"APPID"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getPlatformId] forKey: @"PLATFORM_ID"];
    [mineJson setValue:[oneSDKBranchUtils getSDK] forKey: @"sdk"];
    [mineJson setValue:[oneSDKBranchUtils getModel] forKey: @"model"];
    [mineJson setValue:[oneSDKBranchUtils getRelease] forKey: @"release"];
    NSNumber* longNumber = [NSNumber numberWithLong:[oneSDKBranchUtils getTotalMemory]];
    NSString* longStr = [longNumber stringValue];
    [mineJson setValue:longStr forKey: @"totalMemory"];
    longNumber = [NSNumber numberWithLong:[oneSDKBranchUtils getAvailMemory]];
    longStr = [longNumber stringValue];
    [mineJson setValue:longStr forKey: @"availMemory"];
    longNumber = [NSNumber numberWithLong:[oneSDKBranchUtils getTotalInternalSize]];
    longStr = [longNumber stringValue];
    [mineJson setValue:longStr forKey: @"totalInternalSize"];
    longNumber = [NSNumber numberWithLong:[oneSDKBranchUtils getAvailableInternalSize]];
    longStr = [longNumber stringValue];
    [mineJson setValue:longStr forKey: @"availableInternalSize"];
    longNumber = [NSNumber numberWithLong:[oneSDKBranchUtils getTotalSDSize]];
    longStr = [longNumber stringValue];
    [mineJson setValue:longStr forKey: @"totalSDSize"];
    longNumber = [NSNumber numberWithLong:[oneSDKBranchUtils getAvailableSDSize]];
    longStr = [longNumber stringValue];
    [mineJson setValue:longStr forKey: @"availableSDSize"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getAccount] forKey: @"account"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getRegisterTime] forKey: @"regist_time"];
    [mineJson setValue:@"ios" forKey: @"phone_system"];
    [mineJson setValue:@"ios" forKey: @"equipmentType"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginType] forKey: @"type"];
    
    // 将mineJson转换成NSString
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:0];
    NSString* dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    oneSDKBranchLogUtils(@"%@, dataStr is %@", TAG, dataStr);
    [json setValue:[oneSDKBranchUtils base64Encode:dataStr] forKey: @"Logs"];
    
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:json];
    oneSDKBranchLogUtils(@"%@, newSign is %@", TAG, newSign);
    [json setValue:newSign forKey: @"SIGN"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 先将字典转换成字符串
    NSError* error;
//    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    if (!error)
    {
        // 拼接url
        NSString* url = [[oneSDKBranchPlayerConfig getInstance] getUpdateUserLogsFuncName];
        NSString* newUrl = @"";
        newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        oneSDKBranchLogUtils(@"%@, updateSDKUserLogs newUrl is %@", TAG, newUrl);
        
        [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
        {
            oneSDKBranchLogUtils(@"%@, updateSDKUserLogs result is %@", TAG, object);
            
            NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
            // 如果请求成功
            if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
            {
                oneSDKBranchLogUtils(@"%@, updateSDKUserLogs success", TAG);
            }
            else
            {
                oneSDKBranchLogUtils(@"%@, updateSDKUserLogs failed", TAG);
            }
        }
        FailBlock: ^(NSError* error)
        {
            oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", TAG, error);
        }];
    }
    else
    {
        oneSDKBranchLogUtils(@"Error: %@", error.localizedDescription);
    }
}

// 上报游戏日志
+(void)updateGameInfo:(NSString*)roleId andNickName:(NSString*)nickName andGameGrade:(NSString*)gameGrade andZoneId:(NSString*)zoneId andZoneName:(NSString*)zoneName andSid:(NSString*)sid
{
    if (mContent == NULL)
    {
        return;
    }
    
    // 用户未配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] isAllAllocationInInfoPlist])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getUpdateGameInfoFuncName].length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    if (roleId.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noroleId"] duration:2.0f];
        return;
    }
    
    if (nickName.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonickName"] duration:2.0f];
        return;
    }
    
    if (gameGrade.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nogameGrade"] duration:2.0f];
        return;
    }
    
    if (zoneId.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nozoneId"] duration:2.0f];
        return;
    }
    
    if (zoneName.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nozoneName"] duration:2.0f];
        return;
    }
    
    if (sid.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nosid"] duration:2.0f];
        return;
    }
    
    // 返回给用户
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getChannelId] forKey: @"CHANNEL_ID"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getMacAddress] forKey: @"phone_md5_code"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getAppId] forKey: @"APPID"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getPlatformId] forKey: @"PLATFORM_ID"];
    NSMutableDictionary* mineJson = [NSMutableDictionary dictionary];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [mineJson setValue:roleId forKey: @"role_id"];
    [mineJson setValue:nickName forKey: @"nickName"];
    [mineJson setValue:gameGrade forKey: @"game_grade"];
    [mineJson setValue:zoneId forKey: @"zoneId"];
    [mineJson setValue:zoneName forKey: @"zoneName"];
    [mineJson setValue:sid forKey: @"sid"];
    oneSDKBranchLogUtils(@"%@, updateGameInfo dataStr is %@", TAG, mineJson);
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:json];
    oneSDKBranchLogUtils(@"%@, newSign is %@", TAG, newSign);
    [json setValue:newSign forKey: @"SIGN"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 先将字典转换成字符串
    NSError* error;
//    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    if (!error)
    {
        // 拼接url
        NSString* url = [[oneSDKBranchPlayerConfig getInstance] getUpdateGameInfoFuncName];
        NSString* newUrl = @"";
        newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        oneSDKBranchLogUtils(@"%@, updateGameInfo newUrl is %@", TAG, newUrl);
        
        [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
        {
            oneSDKBranchLogUtils(@"%@, updateGameInfo result is %@", TAG, object);
            
            NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
            // 如果请求成功
            if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
            {
                oneSDKBranchLogUtils(@"%@, updateGameInfo success", TAG);
            }
            else
            {
                oneSDKBranchLogUtils(@"%@, updateGameInfo failed", TAG);
            }
        }
        FailBlock: ^(NSError* error)
        {
            oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", TAG, error);
        }];
    }
    else
    {
        oneSDKBranchLogUtils(@"Error: %@", error.localizedDescription);
    }
}

+(void)setSDKState
{
    NSString* token = [[oneSDKBranchPlayerConfig getInstance] getAdjustToken];
    NSString* state = [[oneSDKBranchPlayerConfig getInstance] getProducteState];
    NSString* environment = ([state isEqual:@"1"] ? ADJEnvironmentSandbox : ADJEnvironmentProduction);
    ADJConfig* adjustConfig = [[ADJConfig alloc] initWithAppToken:token environment:environment];
    [Adjust initSdk:adjustConfig];
}

+(void)sendSDKTrack:(NSString*)code
{
    if (mContent == NULL || code.length == 0)
    {
        return;
    }
    
    // 用户未配置所有值
    if (![[oneSDKBranchPlayerConfig getInstance] isAllAllocationInInfoPlist])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noAllSuccess"] duration:2.0f];
        return;
    }
    
    ADJEvent* event = [[ADJEvent alloc] initWithEventToken:code];
    [Adjust trackEvent:event];
}

// 关闭view
+(void)closeView
{
    // 登录界面
    if ([oneSDKBranchLoginView getApp] != NULL)
    {
        [[oneSDKBranchLoginView getApp] removeFromParentViewController];
        [[oneSDKBranchLoginView getApp].view removeFromSuperview];
        // 将登录界面设置为空
        [oneSDKBranchLoginView removeSelf];
    }
    
    // 注册界面
    if ([oneSDKBranchRegisterView getApp] != NULL)
    {
        [[oneSDKBranchRegisterView getApp] removeFromSuperview];
        [oneSDKBranchRegisterView removeSelf];
    }
    
    // 提示界面
    if ([oneSDKBranchTipsView getApp] != NULL)
    {
        [[oneSDKBranchTipsView getApp] removeFromSuperview];
        [oneSDKBranchTipsView removeSelf];
    }
    
    // 忘记密码界面
    if ([oneSDKBranchForgetView getApp] != NULL)
    {
        [[oneSDKBranchForgetView getApp] removeFromSuperview];
        [oneSDKBranchForgetView removeSelf];
    }
    
    // 强制绑定
    if ([oneSDKBranchForceBindView getApp] != NULL)
    {
        [[oneSDKBranchForceBindView getApp] removeFromSuperview];
        [oneSDKBranchForceBindView removeSelf];
    }
    
    // 奖励
    if ([oneSDKBranchForceBindRewardView getApp] != NULL)
    {
        [[oneSDKBranchForceBindRewardView getApp] removeFromSuperview];
        [oneSDKBranchForceBindRewardView removeSelf];
    }
    
    // 个人信息界面
    if ([oneSDKBranchUserInfoView getApp] != NULL)
    {
        [[oneSDKBranchUserInfoView getApp] removeFromSuperview];
        [oneSDKBranchUserInfoView removeSelf];
    }
    
    // 修改昵称
    if ([oneSDKBranchModifyNickName getApp] != NULL)
    {
        [[oneSDKBranchModifyNickName getApp] removeFromSuperview];
        [oneSDKBranchModifyNickName removeSelf];
    }
}

// 打开悬浮球
+(void)showSyFloatView
{
    [[oneSDKBranchInternalSingleCase getInstance] showSyFloatView];
}

// 隐藏悬浮球
+(void)hideSyFloatView
{
    [[oneSDKBranchInternalSingleCase getInstance] hideFloatView];
}

// 清理SDk所有数据
+(void)clearSDKAllInfo
{
    [[oneSDKBranchPlayerConfig getInstance] setName:@""];
    [[oneSDKBranchPlayerConfig getInstance] setUid:@""];
    [[oneSDKBranchPlayerConfig getInstance] setToken:@""];
    [[oneSDKBranchPlayerConfig getInstance] setAccount:@""];
    [[oneSDKBranchPlayerConfig getInstance] setLoginTime:@""];
    [[oneSDKBranchPlayerConfig getInstance] setOverdueTime:@""];
    [[oneSDKBranchPlayerConfig getInstance] setRegisterTime:@""];
    [[oneSDKBranchPlayerConfig getInstance] setLoginType:@""];
}

// 切换账号或者登录失效, 需要清除缓存
+(void)clearCache
{
    if (mContent == NULL)
    {
        return;
    }
    
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_account" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_token" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_logintype" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_nickName" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_email" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_userId" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_fullname" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_token" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_email" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_userId" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_fullname" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_token" Value:@""];
}

+(void)showLoading
{
    oneSDKBranchLoadingView* view = [[oneSDKBranchLoadingView alloc] initView];
    [[oneSDKBranchUtils getCurrentVC].view addSubview:view];
}

+(void)hideLoading
{
    // 加载界面
    if ([oneSDKBranchLoadingView getApp] != NULL)
    {
        [[oneSDKBranchLoadingView getApp] removeFromSuperview];
        [oneSDKBranchLoadingView removeSelf];
    }
}

+(void)clearSelf
{
    if (mContent != NULL)
    {
        mContent = NULL;
    }
}

// 设置授权登录信息
+(void)setEmpowerLoginData:(NSString*)email andId:(NSString*)pUid andName:(NSString*)name andToken:(NSString*)token
{
    // 返回给用户
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    [json setValue:email forKey: @"email"];
    [json setValue:pUid forKey: @"id"];
    [json setValue:name forKey: @"name"];
    [json setValue:token forKey: @"token"];
    
    // 先将字典转换成字符串
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    if (!error)
    {
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[oneSDKBranchPlayerConfig getInstance] setEmpowerLoginData:str];
    }
    else
    {
        oneSDKBranchLogUtils(@"Error: %@", error.localizedDescription);
    }
}

// 获取授权登录信息
+(NSString*)getEmpowerLoginData
{
    return [[oneSDKBranchPlayerConfig getInstance] getEmpowerLoginData];
}

// 根据名字移除监听
+(void)removeListenerByName:(NSString*)name
{
    [oneSDKBranchListener removeListenerByName:mContent Name:name];
}

@end

