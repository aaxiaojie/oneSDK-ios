//
//  oneSDKBranchOrderInfo.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchOrderInfo : NSObject

// 内购点
@property(nonatomic, retain)NSString* payCode;
// 订单号
@property(nonatomic, retain)NSString* oid;
// 广告支付id
@property(nonatomic, retain)NSString* adPayId;
// 玩家id
@property(nonatomic, retain)NSString* playerId;
// 玩家昵称
@property(nonatomic, retain)NSString* playerName;
// 玩家等级
@property(nonatomic, retain)NSString* playerLevel;
// 玩家vip等级
@property(nonatomic, retain)NSString* playerVipLevel;
// 服务器id
@property(nonatomic, retain)NSString* serverId;
// 服务器名称
@property(nonatomic, retain)NSString* serverName;
// 金额(人民币)
@property(readwrite)double rmb;
// 金额(美金)
@property(readwrite)double doller;
// 套餐数量
@property(readwrite)int orderNumber;

@end

NS_ASSUME_NONNULL_END
