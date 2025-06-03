//
//  paySDKPayView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchPayView : NSObject

// 下单(内购点, 订单号, 玩家id, 玩家昵称, 玩家等级, 玩家vip等级, 服务器id, 服务器名称, 金额(人民币), 金额(美金), 套餐个数)
+(void)placeOrder:(NSString*)payCode Oid:(NSString*)oid AdPayId:(NSString*)adPayId PlayerId:(NSString*)playerId PlayerName:(NSString*)playerName PlayerLevel:(NSString*)playerLevel PlayerVipLevel:(NSString*)playerVipLevel ServerId:(NSString*)serverId ServerName:(NSString*)serverName Rmb:(double)rmb Doller:(double)doller OrderNumber:(int)orderNumber;

// 支付成功
+(void)payCallback:(NSString*)applePayToken;

@end

NS_ASSUME_NONNULL_END
