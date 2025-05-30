//
//  oneSDK.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <oneSDK/oneSDKBranchOrderInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranch : NSObject

// 初始化
+(void)initSDK:(id)tContent;
// 登录
+(void)sendLogin;
// 切换账号
+(void)sendSwitchAccount;
// 下单
+(void)sendPorder:(oneSDKBranchOrderInfo*)info;
// 下单回调
//+(void)onPorderCallback:(NSMutableDictionary*)value;
// 支付
+(void)sendPay:(NSURL*)url;
// 支付回调
//+(void)onPayCallback:(NSMutableDictionary*)value;
// 广告
+(void)sendSDKTrack:(NSString*)code;
// 上报游戏内日志
+(void)sendUpdateGameInfo:(NSString*)roleId AndNickName:(NSString*)nickName AndGameGrade:(NSString*)gameGrade AndZoneId:(NSString*)zoneId AndZoneName:(NSString*)zoneName AndSid:(NSString*)sid;

@end

NS_ASSUME_NONNULL_END
