//
//  oneSDKSyFloatView.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchSyFloatView : UIButton

@property(nonatomic, assign)BOOL MoveEnable;
@property(nonatomic, assign)BOOL MoveEnabled;
@property(nonatomic, assign)CGPoint beginpoint;

// 是否拖动了图标
-(Boolean)isMoveIcon;

@end

NS_ASSUME_NONNULL_END
