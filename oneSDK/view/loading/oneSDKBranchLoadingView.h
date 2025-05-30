//
//  oneSDKBranchLoadingView.h
//  oneSDK
//
//  Created by 天下 on 2024/8/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchLoadingView : UIView

-(instancetype)initView;

// 获取本类信息
+(oneSDKBranchLoadingView*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
