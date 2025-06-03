//
//  oneSDKBranchTipsView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchTipsView : UIView

-(instancetype)initViewWithType:(int)index andValue:(NSString*)value;
// 获取本类信息
+(oneSDKBranchTipsView*)getApp;
// 删除自身
+(void)removeSelf;

// 1游客登录
// 2删除账号(需要开启定时器)
// 3修改昵称
@property int type;
@property NSString* value;

@end

NS_ASSUME_NONNULL_END
