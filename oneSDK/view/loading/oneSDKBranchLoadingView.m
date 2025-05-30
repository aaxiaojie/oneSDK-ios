//
//  oneSDKBranchLoadingView.m
//  oneSDK
//
//  Created by 天下 on 2024/8/27.
//

#import "oneSDKBranchLoadingView.h"
#import "./../../utils/oneSDKBranchUtils.h"

// mineTAG
NSString* mineTAGoneSDKBranchLoadingView;
CGFloat _rotation;
UIImageView* bg;
CADisplayLink* _displayLink;

@implementation oneSDKBranchLoadingView

// app
static oneSDKBranchLoadingView* apponeSDKBranchLoadingView = NULL;

-(instancetype)initView
{
    if (self == [super init])
    {
        UIWindow* rootWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [rootWindow addSubview:self];
        self.layer.position = self.center;
        self.transform = CGAffineTransformMakeScale(0.90, 0.90);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished){}];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        mineTAGoneSDKBranchLoadingView = @"oneSDKBranchLoadingView";
        apponeSDKBranchLoadingView = self;
        
        // 半透明背景
        UIColor* transparentColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.backgroundColor = transparentColor;
        
        // 添加背景
        bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 48, 48);
        bg.contentMode = UIViewContentModeCenter;
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"loading"];
        [self addSubview:bg];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotateImage)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _rotation = 0.0;
        
        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 100, self.frame.size.height * 0.5 + 30, 200, 40) textContainer:nil];
        titleText.userInteractionEnabled = NO;
        titleText.font = [UIFont systemFontOfSize:25];
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor whiteColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"loading...";
        [self addSubview:titleText];
    }
    return self;
}

-(void)rotateImage
{
    // 每帧旋转10度
    _rotation += M_PI / 18.0;
    bg.transform = CGAffineTransformMakeRotation(_rotation);
}

//// 关闭
//-(void)closeBtn:(id)sender
//{
//    if (_displayLink != NULL)
//    {
//        [_displayLink invalidate];
//        _displayLink = NULL;
//    }
//    apponeSDKBranchLoadingView = NULL;
//    [self removeFromSuperview];
//}

// 获取本类信息
+(oneSDKBranchLoadingView*)getApp
{
    return apponeSDKBranchLoadingView;
}

// 删除自身
+(void)removeSelf
{
    if (_displayLink != NULL)
    {
        [_displayLink invalidate];
        _displayLink = NULL;
    }
    apponeSDKBranchLoadingView = NULL;
}

@end
