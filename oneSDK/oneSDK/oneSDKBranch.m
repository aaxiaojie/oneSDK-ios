//
//  oneSDK.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranch.h"
#import "./../always/always.h"
#import "./../utils/oneSDKBranchToastUtils.h"
#import "./../utils/oneSDKBranchUtils.h"

static bool isInit = false;

@implementation oneSDKBranch

// 初始化
+(void)initSDK:(id)tContent
{
    if (isInit)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"sdkAlreadyInit"] duration:2.0f];
        return;
    }
    
    isInit = true;
    [always init:tContent];
}

// 登录
+(void)sendLogin
{
    [always sendLogin];
}

// 切换账号
+(void)sendSwitchAccount
{
    [always sendSwitchAccount];
}

// 下单
+(void)sendPorder:(oneSDKBranchOrderInfo*)info
{
    [always sendPorder:info];
}

// 支付
+(void)sendPay:(NSURL*)url
{
    [always sendPay:url];
}

// 广告
+(void)sendSDKTrack:(NSString*)code
{
    [always sendSDKTrack:code];
}

// 上报游戏内日志
+(void)sendUpdateGameInfo:(NSString*)roleId AndNickName:(NSString*)nickName AndGameGrade:(NSString*)gameGrade AndZoneId:(NSString*)zoneId AndZoneName:(NSString*)zoneName AndSid:(NSString*)sid
{
    [always updateGameInfo:roleId andNickName:nickName andGameGrade:gameGrade andZoneId:zoneId andZoneName:zoneName andSid:sid];
}

@end
