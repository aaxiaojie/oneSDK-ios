//
//  oneSDKBranchLoginView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "GoogleSignIn/GoogleSignIn.h"

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchLoginView : UIViewController<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, /*GIDSignInDelegate, */UITextFieldDelegate>

@property(nonatomic, strong)UIView* loginView;
@property(nonatomic, strong)UIView* autoLoginView;
@property(nonatomic, strong)UITextField* emailText;
@property(nonatomic, strong)UITextField* passwordText;

// 获取本类信息
+(oneSDKBranchLoginView*)getApp;
// 删除自身
+(void)removeSelf;
// google登出接口
+(void)googleLogout;
// facebook登出接口
+(void)facebookLogout;

@end

NS_ASSUME_NONNULL_END
