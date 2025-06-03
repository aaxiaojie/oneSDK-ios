//
//  oneSDKGameJniHelper.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchGameJniHelper.h"

@implementation oneSDKBranchGameJniHelper

// 登录成功消息
+(void)sendLoginSuccess:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchLoginSuccessListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

// 登录失败消息
+(void)sendLoginFailed:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchLoginFailedListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

// 删除账号成功消息
+(void)sendDeleteAccountSuccess:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchDeleteAccountSuccessListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

// 删除账号失败消息
+(void)sendDeleteAccountFailed:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchDeleteAccountFailedListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

// 发送切换账号消息
+(void)sendSwitchAccountSuccess
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchSwitchAccountSuccessListener" object:nil userInfo:nil];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

+(void)sendSwitchAccountFailed
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchSwitchAccountFailedListener" object:nil userInfo:nil];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

// 发送下单消息
+(void)sendPorderSuccess:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchPorderSuccessListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

+(void)sendPorderFailed:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchPorderFailedListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

// 发送支付消息
+(void)sendPaySuccess:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchPaySuccessListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

+(void)sendPayFailed:(id)obj
{
    // 创建一个消息对象
    NSNotification* notice = [NSNotification notificationWithName:@"oneSDKBranchPayFailedListener" object:nil userInfo:obj];
    // 发送消息
    [[NSNotificationCenter defaultCenter] postNotification: notice];
}

@end
