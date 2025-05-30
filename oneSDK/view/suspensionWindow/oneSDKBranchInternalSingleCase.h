//
//  oneSDKInternalSingleCase.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchInternalSingleCase : UIView

+(instancetype)getInstance;

// 显示悬浮球
-(void)showSyFloatView;
// 关闭悬浮球
-(void)hideFloatView;

@end

NS_ASSUME_NONNULL_END
