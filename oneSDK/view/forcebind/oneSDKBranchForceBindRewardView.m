//
//  oneSDKBranchForceBindView.m
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import "./oneSDKBranchForceBindRewardView.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./oneSDKBranchForceBindView.h"
#import "./../../always/always.h"

// mineTAG
NSString* mineTAGoneSDKBranchForceBindRewardView;

@implementation oneSDKBranchForceBindRewardView

// app
static oneSDKBranchForceBindRewardView* apponeSDKBranchForceBindRewardView = NULL;

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
        mineTAGoneSDKBranchForceBindRewardView = @"oneSDKBranchForceBindRewardView";
        apponeSDKBranchForceBindRewardView = self;
        
        // 强制绑定
        if ([oneSDKBranchForceBindView getApp] != NULL)
        {
            [[oneSDKBranchForceBindView getApp] removeFromSuperview];
            [oneSDKBranchForceBindView removeSelf];
        }
        
        // 添加背景
        UIImageView* bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 500, 333);
        bg.contentMode = UIViewContentModeCenter;
        bg.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"info_bg_h"];
        [self addSubview:bg];

        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 150, 0, 400, 40) textContainer:nil];
        titleText.font = [UIFont systemFontOfSize:25];
        titleText.userInteractionEnabled = NO;
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor blackColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"Account Bind Successfully";
        // 创建NSAttributedString
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
        // 设置加粗属性
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
        // 应用属性到UITextView
        titleText.attributedText = attributedString;
        [bg addSubview:titleText];

        // gift code
        UITextView* tishi = [[UITextView alloc] initWithFrame:CGRectMake(-35, 50, 180, 30) textContainer:nil];
        tishi.font = [UIFont systemFontOfSize:20];
        tishi.userInteractionEnabled = NO;
        [tishi setBackgroundColor:[UIColor clearColor]];
        tishi.textColor = [UIColor blackColor];
        tishi.textAlignment = NSTextAlignmentCenter;
        tishi.text = @"Gift code:";
        [bg addSubview:tishi];
        
        // bar
        UIImageView* bar = [[UIImageView alloc] init];
        bar.userInteractionEnabled = YES;
        bar.frame = CGRectMake((bg.frame.size.width - 289) * 0.5, tishi.frame.origin.y + 3, 289, 37);
        bar.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        bar.image = [oneSDKBranchUtils getImageFromBundle:@"reward_bar_h"];
        [bg addSubview:bar];
        
        // code
        UITextView* code = [[UITextView alloc] initWithFrame:CGRectMake(bar.frame.origin.x, tishi.frame.origin.y, 250, 30) textContainer:nil];
        // 左对齐
        code.textAlignment = NSTextAlignmentLeft;
        code.font = [UIFont systemFontOfSize:20];
        code.userInteractionEnabled = NO;
        [code setBackgroundColor:[UIColor clearColor]];
        code.textColor = [UIColor blackColor];
        code.text = [[oneSDKBranchPlayerConfig getInstance] getGoodsCode];
        [bg addSubview:code];
        
        // claimed
        UITextView* claimed = [[UITextView alloc] initWithFrame:CGRectMake(bar.frame.origin.x + bar.frame.size.width + 10, bar.frame.origin.y, 70, 30) textContainer:nil];
        claimed.font = [UIFont systemFontOfSize:20];
        claimed.userInteractionEnabled = NO;
        [claimed setBackgroundColor:[UIColor clearColor]];
        claimed.textColor = [UIColor blackColor];
        claimed.text = @"Claimed";
        claimed.hidden = YES;
        [bg addSubview:claimed];
        
        // 复制按钮
        UIButton* copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        copyBtn.frame = CGRectMake(bar.frame.origin.x + bar.frame.size.width + 10, bar.frame.origin.y, 70, 35);
        [copyBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
        [copyBtn addTarget:self action:@selector(copyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [copyBtn setTitle:@"copy" forState:UIControlStateNormal];
        copyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        copyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        copyBtn.hidden = YES;
        [bg addSubview:copyBtn];
        
        // 物品领取状态(0不显示、1未领取、2已领取)
        if ([[[oneSDKBranchPlayerConfig getInstance] goodsStatus] isEqual:@"1"])
        {
            copyBtn.hidden = NO;
            claimed.hidden = YES;
        }
        else if ([[[oneSDKBranchPlayerConfig getInstance] goodsStatus] isEqual:@"2"])
        {
            copyBtn.hidden = YES;
            claimed.hidden = NO;
        }
        
        // rewards
        UITextView* rewards = [[UITextView alloc] initWithFrame:CGRectMake(tishi.frame.origin.x + 40, tishi.frame.origin.y + 40, 100, 30) textContainer:nil];
        rewards.font = [UIFont systemFontOfSize:20];
        rewards.userInteractionEnabled = NO;
        [rewards setBackgroundColor:[UIColor clearColor]];
        rewards.textColor = [UIColor blackColor];
        rewards.textAlignment = NSTextAlignmentCenter;
        rewards.text = @"Rewards:";
        [bg addSubview:rewards];
        
        float dis_s = 25;
        float textWidth = 350;
        float textHeight = 30;
        float x = rewards.frame.origin.x + 10;
        
        UITextView* reward1 = [[UITextView alloc] initWithFrame:CGRectMake(x, rewards.frame.origin.y + dis_s, textWidth, textHeight) textContainer:nil];
        reward1.font = [UIFont systemFontOfSize:20];
        reward1.userInteractionEnabled = NO;
        [reward1 setBackgroundColor:[UIColor clearColor]];
        reward1.textColor = [UIColor blackColor];
        reward1.textAlignment = NSTextAlignmentLeft;
        reward1.hidden = YES;
        reward1.text = @"reward1:";
        [bg addSubview:reward1];
        
        UITextView* reward2 = [[UITextView alloc] initWithFrame:CGRectMake(x, reward1.frame.origin.y + dis_s, textWidth, textHeight) textContainer:nil];
        reward2.font = [UIFont systemFontOfSize:20];
        reward2.userInteractionEnabled = NO;
        [reward2 setBackgroundColor:[UIColor clearColor]];
        reward2.textColor = [UIColor blackColor];
        reward2.textAlignment = NSTextAlignmentLeft;
        reward2.hidden = YES;
        reward2.text = @"reward2:";
        [bg addSubview:reward2];
        
        UITextView* reward3 = [[UITextView alloc] initWithFrame:CGRectMake(x, reward2.frame.origin.y + dis_s, textWidth, textHeight) textContainer:nil];
        reward3.font = [UIFont systemFontOfSize:20];
        reward3.userInteractionEnabled = NO;
        [reward3 setBackgroundColor:[UIColor clearColor]];
        reward3.textColor = [UIColor blackColor];
        reward3.textAlignment = NSTextAlignmentLeft;
        reward3.hidden = YES;
        reward3.text = @"reward3:";
        [bg addSubview:reward3];
        
        UITextView* reward4 = [[UITextView alloc] initWithFrame:CGRectMake(x, reward3.frame.origin.y + dis_s, textWidth, textHeight) textContainer:nil];
        reward4.font = [UIFont systemFontOfSize:20];
        reward4.userInteractionEnabled = NO;
        [reward4 setBackgroundColor:[UIColor clearColor]];
        reward4.textColor = [UIColor blackColor];
        reward4.textAlignment = NSTextAlignmentLeft;
        reward4.hidden = YES;
        reward4.text = @"reward4:";
        [bg addSubview:reward4];
        
        UITextView* reward5 = [[UITextView alloc] initWithFrame:CGRectMake(x, reward4.frame.origin.y + dis_s, textWidth, textHeight) textContainer:nil];
        reward5.font = [UIFont systemFontOfSize:20];
        reward5.userInteractionEnabled = NO;
        [reward5 setBackgroundColor:[UIColor clearColor]];
        reward5.textColor = [UIColor blackColor];
        reward5.textAlignment = NSTextAlignmentLeft;
        reward5.hidden = YES;
        reward5.text = @"reward5:";
        [bg addSubview:reward5];
        
        [self showRewards:reward1 andReward2:reward2 andReward3:reward3 andReward4:reward4 andReward5:reward5];
        
        // 底下提示
        UILabel* goText = [[UILabel alloc] init];
        goText.frame = CGRectMake(bg.frame.size.width * 0.5 - 480 * 0.5, reward5.frame.origin.y + 40, 480, 60);
        goText.font = [UIFont systemFontOfSize:20];
        goText.userInteractionEnabled = NO;
        goText.numberOfLines = 2;
        goText.textAlignment = NSTextAlignmentCenter;
        [goText setBackgroundColor:[UIColor clearColor]];
        goText.textColor = [UIColor blackColor];
        goText.text = @"Bind successful! Please redeem the gift code in game.\nSetting > Redeem > Enter the gift code > Reddem";
        [bg addSubview:goText];
        
        // 关闭按钮
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(bg.frame.size.width - 15, -15, 30, 30);
        [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"closebtn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:closeBtn];
    }
    return self;
}

-(void)showRewards:(UITextView*)reward1 andReward2:(UITextView*)reward2 andReward3:(UITextView*)reward3 andReward4:(UITextView*)reward4 andReward5:(UITextView*)reward5
{
    NSString* string = [[oneSDKBranchPlayerConfig getInstance] getGoods];
    NSArray* array = [string componentsSeparatedByString:@";"];

    NSMutableArray* rewardArray = [[NSMutableArray alloc] init];
    [rewardArray addObject:reward1];
    [rewardArray addObject:reward2];
    [rewardArray addObject:reward3];
    [rewardArray addObject:reward4];
    [rewardArray addObject:reward5];
    
    for (int i = 0; i < array.count; i++)
    {
        // 文本
        NSString* text = [array objectAtIndex:i];
        // 显示
        UITextView* textView = [rewardArray objectAtIndex:i];
        textView.hidden = NO;
        
        NSString* str1 = [NSString stringWithFormat:@" %d: ", (i + 1)];
        NSString* str = [str1 stringByAppendingString:text];
        textView.text = str;
    }
}

// 关闭
-(void)closeBtn:(id)sender
{
    apponeSDKBranchForceBindRewardView = NULL;
    [self removeFromSuperview];
}

// 复制
-(void)copyBtn:(id)sender
{
    NSString* str = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getGoodsCode]];
    // 获取系统剪贴板
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    // 设置剪贴板的字符串内容
    pasteboard.string = str;

    [oneSDKBranchToastUtils show:@"copy success" duration:2.0];
}

// 获取本类信息
+(oneSDKBranchForceBindRewardView*)getApp
{
    return apponeSDKBranchForceBindRewardView;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchForceBindRewardView = NULL;
}

// 点击屏幕空白处什么都不做(屏蔽触摸)
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

@end
