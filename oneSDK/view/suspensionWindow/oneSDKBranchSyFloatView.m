//
//  oneSDKSyFloatView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchSyFloatView.h"
#import "./../../utils/oneSDKBranchUtils.h"

@implementation oneSDKBranchSyFloatView

int contentSize = 45;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImage* iamge = [oneSDKBranchUtils getImageFromBundle:@"sy_ball"];
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - contentSize, contentSize, contentSize, contentSize);
        [self setBackgroundImage:iamge forState:UIControlStateNormal];
        _MoveEnable = YES;
    }
    
    [self showHemisphere];
    return self;
}

// 开始触摸的方法
// 触摸-清扫
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    _MoveEnabled = false;
    if (!_MoveEnable)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    _beginpoint = [touch locationInView:self];
}

// 触摸移动的方法
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    _MoveEnabled = true;
    if (!_MoveEnable)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    // 偏移量
    float offsetX = currentPosition.x - _beginpoint.x;
    float offsetY = currentPosition.y - _beginpoint.y;
    // 移动后的中心坐标
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    // x轴左右极限坐标
    if (self.center.x > (self.superview.frame.size.width - self.frame.size.width * 0.5))
    {
        CGFloat x = self.superview.frame.size.width - self.frame.size.width * 0.5;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }
    else if (self.center.x < self.frame.size.width * 0.5)
    {
        CGFloat x = self.frame.size.width * 0.5;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }
    
    // y轴上下极限坐标
    if (self.center.y > (self.superview.frame.size.height - self.frame.size.height))
    {
        CGFloat x = self.center.x;
        CGFloat y = self.superview.frame.size.height - self.frame.size.height * 1.5;
        self.center = CGPointMake(x, y);
    }
    else if (self.center.y <= self.frame.size.height)
    {
        CGFloat x = self.center.x;
        CGFloat y = self.frame.size.height * 1.2;
        self.center = CGPointMake(x, y);
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (!_MoveEnable)
    {
        return;
    }
    
    if (self.center.x >= self.superview.frame.size.width * 0.5)
    {
        // 向右侧移动
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        self.frame = CGRectMake(self.superview.frame.size.width - contentSize, self.center.y - contentSize * 0.5, contentSize, contentSize);
        [UIView setAnimationDelay:2];
        self.frame = CGRectMake(self.superview.frame.size.width - contentSize + contentSize * 0.5, self.center.y - contentSize * 0.5, contentSize, contentSize);
        // 提交UIView动画
        [UIView commitAnimations];
    }
    else
    {
        // 向左侧移动
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        self.frame = CGRectMake(0.f, self.center.y - contentSize * 0.5, contentSize, contentSize);
        [UIView setAnimationDelay:2];
        self.frame = CGRectMake(-contentSize * 0.5, self.center.y - contentSize * 0.5, contentSize, contentSize);
        // 提交UIView动画
        [UIView commitAnimations];
    }
    // 不加此句, UIButton将一直处于按下状态
    [super touchesEnded: touches withEvent: event];
}

-(void)showHemisphere
{
    if (self.center.x >= self.superview.frame.size.width * 0.5)
    {
        self.frame = CGRectMake(self.superview.frame.size.width - contentSize + contentSize * 0.5, self.center.y - contentSize * 0.5, contentSize, contentSize);
    }
    else
    {
        self.frame = CGRectMake(-contentSize * 0.5, self.center.y - contentSize * 0.5, contentSize, contentSize);
    }
}

// 是否拖动了图标
-(Boolean)isMoveIcon
{
    return _MoveEnabled;
}

@end
