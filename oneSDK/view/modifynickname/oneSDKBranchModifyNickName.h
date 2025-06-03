//
//  oneSDKBranchModifyNickName.h
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchModifyNickName : UIView<UITextFieldDelegate>

// 昵称输入框
@property(nonatomic, strong)UITextField* nickname;

-(instancetype)initView;

// 获取本类信息
+(oneSDKBranchModifyNickName*)getApp;
// 删除自身
+(void)removeSelf;

@end

NS_ASSUME_NONNULL_END
