//
//  oneSDKBranchForgetView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchForgetView : UIView<UITextFieldDelegate>

// 账户
@property(nonatomic, strong)UITextField* account;
// 验证码
@property(nonatomic, strong)UITextField* code;
// 密码
@property(nonatomic, strong)UITextField* password;

// 修改密码还是忘记密码(1忘记, 2修改, 3绑定)
@property int index;
// 显示的emial
@property(nonatomic, retain)NSString* nEmail;

-(instancetype)initViewWithType:(int)viewType NEmail:(NSString*)nEmail;
// 获取本类信息
+(oneSDKBranchForgetView*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
