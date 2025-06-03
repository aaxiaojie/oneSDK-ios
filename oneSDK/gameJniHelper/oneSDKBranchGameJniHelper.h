//
//  oneSDKGameJniHelper.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchGameJniHelper : NSObject

// 登录成功消息
+(void)sendLoginSuccess:(id)obj;
// 登录失败消息
+(void)sendLoginFailed:(id)obj;

// 删除账号成功消息
+(void)sendDeleteAccountSuccess:(id)obj;
// 删除账号失败消息
+(void)sendDeleteAccountFailed:(id)obj;

// 发送切换账号成功消息
+(void)sendSwitchAccountSuccess;
// 发送切换账号失败消息
+(void)sendSwitchAccountFailed;

// 下单成功消息
+(void)sendPorderSuccess:(id)obj;
// 下单失败消息
+(void)sendPorderFailed:(id)obj;

// 支付成功消息
+(void)sendPaySuccess:(id)obj;
// 支付失败消息
+(void)sendPayFailed:(id)obj;

@end

NS_ASSUME_NONNULL_END
