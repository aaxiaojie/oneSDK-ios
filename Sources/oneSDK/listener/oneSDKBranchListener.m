//
//  oneSDKListener.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchListener.h"

@implementation oneSDKBranchListener

// 监听登录(用户必须自己实现onLoginSuccess方法)
+(void)addLoginSuccess:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onLoginSuccess:)name:@"oneSDKBranchLoginSuccessListener" object:nil];
}

+(void)addLoginFailed:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onLoginFailed:)name:@"oneSDKBranchLoginFailedListener" object:nil];
}

// 监听删除账号(用户必须自己实现onDeleteAccountSuccess和onDeleteAccountFailed方法)
+(void)addDeleteAccountSuccess:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onDeleteAccountSuccess:)name:@"oneSDKBranchDeleteAccountSuccessListener" object:nil];
}

+(void)addDeleteAccountFailed:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onDeleteAccountFailed:)name:@"oneSDKBranchDeleteAccountFailedListener" object:nil];
}

// 监听切换账号(用户必须自己实现onSwitchAccountSuccess和onSwitchAccountFailed方法)
+(void)addSwitchAccountSuccess:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onSwitchAccountSuccess)name:@"oneSDKBranchSwitchAccountSuccessListener" object:nil];
}

+(void)addSwitchAccountFailed:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onSwitchAccountFailed)name:@"oneSDKBranchSwitchAccountFailedListener" object:nil];
}

// 监听下单(用户必须自己实现onPorderSuccess和onPorderFailed方法)
+(void)addPorderSuccess:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onPorderSuccess:)name:@"oneSDKBranchPorderSuccessListener" object:nil];
}

+(void)addPorderFailed:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onPorderFailed:)name:@"oneSDKBranchPorderFailedListener" object:nil];
}

// 监听支付(用户必须自己实现onPaySuccess和onPayFailed方法)
+(void)addPaySuccess:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onPaySuccess:)name:@"oneSDKBranchPaySuccessListener" object:nil];
}

+(void)addPayFailed:(id)obj
{
    // 获取通知中心单例对象
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    // 添加当前类对象为一个观察者(B)响应的通知的对象, name为@1234表示可以接收通知的名字
    // object设置为nil, 表示接收一切通知
    [center addObserver:obj selector:@selector(onPayFailed:)name:@"oneSDKBranchPayFailedListener" object:nil];
}

// 根据名字移除监听
+(void)removeListenerByName:(id)obj Name:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:name object:nil];
}

// 移除所有监听器
+(void)removeAllListener:(id)obj
{
    [[NSNotificationCenter defaultCenter]  removeObserver:obj];
}

//-(void)onLoginResult:(NSNotification*)info
//{
//    NSDictionary* dic = info.userInfo;
//    NSString* name = [dic objectForKey:@"name"];
//    NSString* token = [dic objectForKey:@"token"];
//    NSString* uid = [dic objectForKey:@"uid"];
//    NSString* loginType = [dic objectForKey:@"loginType"];
//    NSString* unique_id = [dic objectForKey:@"unique_id"];
//    oneSDKBranchLogUtils(@"onLoginResult name is %@, token is %@, uid is %@, loginType is %@, unique_id is %@", name, token, uid, loginType, unique_id);
//}


@end
