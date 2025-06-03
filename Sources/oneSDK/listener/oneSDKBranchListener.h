//
//  oneSDKListener.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchListener : NSObject

// 监听登录(用户必须自己实现onLoginSuccess和onLoginFailed方法)
+(void)addLoginSuccess:(id)obj;
+(void)addLoginFailed:(id)obj;

// 监听删除账号(用户必须自己实现onDeleteAccountSuccess和onDeleteAccountFailed方法)
+(void)addDeleteAccountSuccess:(id)obj;
+(void)addDeleteAccountFailed:(id)obj;

// 监听切换账号(用户必须自己实现onSwitchAccountSuccess和onSwitchAccountFailed方法)
+(void)addSwitchAccountSuccess:(id)obj;
+(void)addSwitchAccountFailed:(id)obj;

// 监听下单(用户必须自己实现onPorderSuccess和onPorderFailed方法)
+(void)addPorderSuccess:(id)obj;
+(void)addPorderFailed:(id)obj;

// 监听支付(用户必须自己实现onPaySuccess和onPayFailed方法)
+(void)addPaySuccess:(id)obj;
+(void)addPayFailed:(id)obj;

// 根据名字移除监听
+(void)removeListenerByName:(id)obj Name:(NSString*)name;
// 移除所有监听器
+(void)removeAllListener:(id)obj;

@end

NS_ASSUME_NONNULL_END
