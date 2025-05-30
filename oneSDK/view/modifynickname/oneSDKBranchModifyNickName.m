//
//  oneSDKBranchModifyNickName.m
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import "./oneSDKBranchModifyNickName.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../tips/oneSDKBranchTipsView.h"

// mineTAG
NSString* mineTAGoneSDKBranchModifyNickNameView;

@implementation oneSDKBranchModifyNickName
// app
static oneSDKBranchModifyNickName* apponeSDKBranchModifyNickName = NULL;

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
        mineTAGoneSDKBranchModifyNickNameView = @"oneSDKBranchModifyNickName";
        apponeSDKBranchModifyNickName = self;
        
        // 添加背景
        UIImageView* bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 364, 329);
        bg.contentMode = UIViewContentModeCenter;
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"forget_bg_h"];
        [self addSubview:bg];
        
        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 90, 0, 400, 40) textContainer:nil];
        titleText.userInteractionEnabled = NO;
        titleText.font = [UIFont systemFontOfSize:25];
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor blackColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"Change Nickname";
        // 创建NSAttributedString
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
        // 设置加粗属性
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
        // 应用属性到UITextView
        titleText.attributedText = attributedString;
        [bg addSubview:titleText];
        
        // account
        UITextField* nickname = [[UITextField alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 150, bg.frame.size.height * 0.5 - 50, 300, 35)];
        nickname.placeholder = @"Enter new nickname";
        nickname.keyboardType = UIKeyboardTypeEmailAddress;
        nickname.borderStyle = UITextBorderStyleRoundedRect;
        nickname.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nickname.layer.borderWidth = 1;
        nickname.layer.cornerRadius = 6;
        nickname.returnKeyType = UIReturnKeyDone;
        nickname.delegate = self;
        self.nickname = nickname;
        [bg addSubview:nickname];
        
        // 确认按钮
        UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(bg.frame.size.width * 0.5 - 285 * 0.5, bg.frame.size.height - 130, 285, 34);
        [confirmButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"login_submit_btn"] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:28];
        confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bg addSubview:confirmButton];
        
        // 关闭按钮
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(bg.frame.size.width - 15, -15, 30, 30);
        [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"closebtn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:closeBtn];
    }
    return self;
}

// 确认
-(void)confirmButtonClick:(id)sender
{
    NSString* originalString = self.nickname.text;
    // 去除首尾空格
    NSString* trimmedString = [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除所有空格
    NSArray* components = [originalString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* noSpacesString = [components componentsJoinedByString:@""];
    if (noSpacesString.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nullNickName"] duration:2.0f];
        return;
    }
    
    oneSDKBranchLogUtils(@"confirmButtonClick noSpacesString is %lu", noSpacesString.length);
    
    if (noSpacesString.length < 4 || noSpacesString.length > 12)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nickNameLengthToast"] duration:2.0f];
        return;
    }
    
    oneSDKBranchTipsView* view = [[oneSDKBranchTipsView alloc] initViewWithType:3 andValue:noSpacesString];
    [self addSubview:view];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    return YES;
}

// 点击return按钮隐藏键盘, 在代理方法中实现想要的点击操作
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 点击屏幕空白处隐藏键盘
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.nickname resignFirstResponder];
}

// 关闭
-(void)closeBtn:(id)sender
{
    apponeSDKBranchModifyNickName = NULL;
    [self removeFromSuperview];
}

// 获取本类信息
+(oneSDKBranchModifyNickName*)getApp
{
    return apponeSDKBranchModifyNickName;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchModifyNickName = NULL;
}

@end
