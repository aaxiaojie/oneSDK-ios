//
//  oneSDKBranchRegisterView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchRegisterView : UIView<UITextFieldDelegate>

// 账户和密码输入框
@property(nonatomic, strong)UITextField* account;
@property(nonatomic, strong)UITextField* password;
// 确认密码
@property(nonatomic, strong)UITextField* confirmPassword;

-(instancetype)initView;
// 获取本类信息
+(oneSDKBranchRegisterView*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
