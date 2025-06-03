//
//  oneSDKInternalSingleCase.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchInternalSingleCase.h"
#import "./oneSDKBranchSyFloatView.h"
#import "./../info/oneSDKBranchUserInfoView.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../listener/oneSDKBranchListener.h"
#import "./../oneSDKBranchBaseActivity.h"

@interface oneSDKBranchInternalSingleCase()

@property(nonatomic, strong)oneSDKBranchSyFloatView* suspended;

@end

@implementation oneSDKBranchInternalSingleCase

static oneSDKBranchSyFloatView* oneSuspended = NULL;
static oneSDKBranchInternalSingleCase* singleCase = nil;

+(instancetype)getInstance
{
    if (singleCase == nil)
    {
        singleCase = [[oneSDKBranchInternalSingleCase alloc] init];
    }
    return singleCase;
}

// 显示悬浮球
-(void)showSyFloatView
{
    if(oneSuspended == NULL)
    {
        UIWindow* rootWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [rootWindow addSubview:self];
        
        self.layer.position = self.center;
        self.frame = [UIScreen mainScreen].bounds;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        // 数字越大, 越在最上层
        self.layer.zPosition = 10000;
        
        oneSDKBranchSyFloatView* _suspensionButton = [oneSDKBranchSyFloatView buttonWithType:UIButtonTypeCustom];
        _suspensionButton.backgroundColor = [UIColor clearColor];
        _suspensionButton.layer.masksToBounds = YES;
        _suspensionButton.layer.cornerRadius = self.suspended.frame.size.width / 2;
        [_suspensionButton addTarget:self action:@selector(suspensionClick) forControlEvents:UIControlEventTouchUpInside];
        oneSuspended = _suspensionButton;
        [self addSubview:_suspensionButton];
    }
}

// 关闭悬浮球
-(void)hideFloatView
{
    if (oneSuspended != NULL)
    {
        [oneSuspended removeFromSuperview];
        oneSuspended = NULL;
        // 删除自身
        [self removeFromSuperview];
    }
}

-(void)suspensionClick
{
   // 如果没有移动
   if (![oneSuspended isMoveIcon])
   {
       // 个人信息界面存在
       if ([oneSDKBranchUserInfoView getApp] != NULL)
       {
           return;
       }

       // 打开个人信息界面
       oneSDKBranchUserInfoView* infoView = [[oneSDKBranchUserInfoView alloc] initView];
       [[oneSDKBranchUtils getCurrentVC].view addSubview:infoView];
   }
}

// 解决触摸屏蔽的问题
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self)
    {
        return nil;
    }
    return hitView;
}

@end
