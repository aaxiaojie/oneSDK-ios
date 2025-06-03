//
//  oneSDKBranchUserInfoView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchUserInfoView : UIView

-(instancetype)initView;
// 获取本类信息
+(oneSDKBranchUserInfoView*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
