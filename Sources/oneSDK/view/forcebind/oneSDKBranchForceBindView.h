//
//  oneSDKBranchForceBindView.h
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchForceBindView : UIView<UITextFieldDelegate>

-(instancetype)initView;

// 昵称输入框
@property(nonatomic, strong)UITextField* nickname;
// 验证码
@property(nonatomic, strong)UITextField* code;

// 获取本类信息
+(oneSDKBranchForceBindView*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
