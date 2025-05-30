//
//  always.h
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import <Foundation/Foundation.h>
// 特殊处理
#import <oneSDK/oneSDKBranchOrderInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface always : NSObject

// 初始化
+(void)init:(id)content;
// 登录
+(void)sendLogin;
// 登录回调
+(void)onLoginCallback:(NSMutableDictionary*)value;
// 删除账号回调
+(void)onDeleteAccountCallback:(NSMutableDictionary*)json;
// 切换账号
+(void)sendSwitchAccount;
// 切换账号回调
+(void)onSwitchAccountCallback:(NSString*)str;
// 下单
+(void)sendPorder:(oneSDKBranchOrderInfo*)info;
// 下单回调
+(void)onPorderCallback:(NSMutableDictionary*)value;
// 支付
+(void)sendPay:(NSURL*)url;
// 支付回调
+(void)onPayCallback:(NSMutableDictionary*)value;
// 上报游戏日志
+(void)updateGameInfo:(NSString*)roleId andNickName:(NSString*)nickName andGameGrade:(NSString*)gameGrade andZoneId:(NSString*)zoneId andZoneName:(NSString*)zoneName andSid:(NSString*)sid;
// 广告
+(void)sendSDKTrack:(NSString*)code;
// 设置授权登录信息
+(void)setEmpowerLoginData:(NSString*)email andId:(NSString*)pUid andName:(NSString*)name andToken:(NSString*)token;
// 关闭view
+(void)closeView;

@end

NS_ASSUME_NONNULL_END
