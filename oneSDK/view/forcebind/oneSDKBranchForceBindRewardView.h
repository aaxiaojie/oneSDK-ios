//
//  oneSDKBranchForceBindView.h
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchForceBindRewardView : UIView

-(instancetype)initView;

// 获取本类信息
+(oneSDKBranchForceBindRewardView*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
