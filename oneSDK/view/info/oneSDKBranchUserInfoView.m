//
//  oneSDKBranchUserInfoView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchUserInfoView.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../forget/oneSDKBranchForgetView.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./../../oneSDK/oneSDKBranch.h"
#import "./../login/oneSDKBranchLoginView.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../tips/oneSDKBranchTipsView.h"
#import "./../modifynickname/oneSDKBranchModifyNickName.h"
#import "./../forcebind/oneSDKBranchForceBindRewardView.h"
#import "./../forcebind/oneSDKBranchForceBindView.h"
#import "./../../always/always.h"

// mineTAG
NSString* mineTAGoneSDKBranchUserInfoView;

@implementation oneSDKBranchUserInfoView
// app
static oneSDKBranchUserInfoView* apponeSDKBranchUserInfoView = NULL;

-(instancetype)initView
{
    if (self == [super init])
    {
        //    UIWindow* rootWindow = [UIApplication sharedApplication].keyWindow;
        UIWindow* rootWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [rootWindow addSubview:self];
        self.layer.position = self.center;
        self.transform = CGAffineTransformMakeScale(0.90, 0.90);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished){}];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        mineTAGoneSDKBranchUserInfoView = @"oneSDKBranchUserInfoView";
        apponeSDKBranchUserInfoView = self;
        
        if ([oneSDKBranchUtils isHorizontal])
        {
            [self addHorizontalView];
        }
        else
        {
            [self addVerticalView];
        }
    }
    return self;
}

-(void)addHorizontalView
{
    // 添加背景
    UIImageView* bg = [[UIImageView alloc] init];
    bg.userInteractionEnabled = YES;
    bg.frame = CGRectMake(0, 0, 500, 333);
    bg.contentMode =  UIViewContentModeScaleAspectFill;
//        [bg setContentMode:UIViewContentModeScaleToFill];
    bg.layer.position = self.center;
    bg.image = [oneSDKBranchUtils getImageFromBundle:@"info_bg_h"];
    [self addSubview:bg];
    
    // 小背景
    UIImageView* smallBg = [[UIImageView alloc] init];
    smallBg.userInteractionEnabled = YES;
    smallBg.frame = CGRectMake(bg.frame.size.width * 0.5 - 430 * 0.5, bg.frame.size.width * 0.11, 430, 140);
    smallBg.image = [oneSDKBranchUtils getImageFromBundle:@"info_small_h"];
    [bg addSubview:smallBg];
    
    // accountText
    UITextView* accountText = [[UITextView alloc] initWithFrame:CGRectMake(smallBg.frame.size.width * 0.1, smallBg.frame.size.height * 0.15, 80, 25) textContainer:nil];
    accountText.userInteractionEnabled = NO;
    accountText.font = [UIFont systemFontOfSize:16];
    [accountText setBackgroundColor:[UIColor clearColor]];
    accountText.textColor = [UIColor blackColor];
    accountText.textAlignment = NSTextAlignmentRight;
    accountText.text = @"Account:";
    [smallBg addSubview:accountText];
    
    // account
    UITextView* account = [[UITextView alloc] initWithFrame:CGRectMake(smallBg.frame.size.width * 0.265, accountText.frame.origin.y, 240, 25) textContainer:nil];
    account.userInteractionEnabled = NO;
    account.font = [UIFont systemFontOfSize:16];
    [account setBackgroundColor:[UIColor clearColor]];
    account.textColor = [UIColor blackColor];
    account.text = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getAccount]];
    [smallBg addSubview:account];
    
    // idText
    UITextView* idText = [[UITextView alloc] initWithFrame:CGRectMake(accountText.frame.origin.x, smallBg.frame.size.height * 0.5 - account.frame.size.height * 0.5, 80, 25) textContainer:nil];
    idText.userInteractionEnabled = NO;
    idText.font = [UIFont systemFontOfSize:16];
    [idText setBackgroundColor:[UIColor clearColor]];
    idText.textColor = [UIColor blackColor];
    idText.textAlignment = NSTextAlignmentRight;
    idText.text = @"ID:";
    [smallBg addSubview:idText];
    
    // id
    UITextView* idStr = [[UITextView alloc] initWithFrame:CGRectMake(account.frame.origin.x, idText.frame.origin.y, 240, 25) textContainer:nil];
    idStr.userInteractionEnabled = NO;
    idStr.font = [UIFont systemFontOfSize:16];
    [idStr setBackgroundColor:[UIColor clearColor]];
    idStr.textColor = [UIColor blackColor];
    idStr.text = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getUid]];
    [smallBg addSubview:idStr];
    
    // nameText
    UITextView* nameText = [[UITextView alloc] initWithFrame:CGRectMake(accountText.frame.origin.x, smallBg.frame.size.height * 0.85 - account.frame.size.height, 80, 25) textContainer:nil];
    nameText.userInteractionEnabled = NO;
    nameText.font = [UIFont systemFontOfSize:16];
    [nameText setBackgroundColor:[UIColor clearColor]];
    nameText.textColor = [UIColor blackColor];
    nameText.textAlignment = NSTextAlignmentRight;
    nameText.text = @"Name:";
    [smallBg addSubview:nameText];
    
    // name
    UITextView* name = [[UITextView alloc] initWithFrame:CGRectMake(account.frame.origin.x, nameText.frame.origin.y, 200, 25) textContainer:nil];
    name.userInteractionEnabled = NO;
    name.font = [UIFont systemFontOfSize:16];
    [name setBackgroundColor:[UIColor clearColor]];
    name.textColor = [UIColor blackColor];
    name.text = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getName]];
    [smallBg addSubview:name];
    
    CGFloat fontSize = 12;
    
    // 复制按钮
    UIButton* copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.frame = CGRectMake(account.frame.origin.x + account.frame.size.width, account.frame.origin.y + 5, 60, 25);
    [copyBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn setTitle:@"copy" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    copyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [smallBg addSubview:copyBtn];
    
    // 删除账号按钮
    UIButton* clearAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearAccountBtn.frame = CGRectMake(bg.frame.size.width * 0.12, bg.frame.size.height * 0.62, 105, 40);
    [clearAccountBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [clearAccountBtn addTarget:self action:@selector(clearAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [clearAccountBtn setTitle:@"Account\nDeletion" forState:UIControlStateNormal];
    clearAccountBtn.titleLabel.numberOfLines = 2;
    clearAccountBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    clearAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearAccountBtn.hidden = YES;
    [bg addSubview:clearAccountBtn];
    
    // 登出按钮
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(bg.frame.size.width * 0.5 - clearAccountBtn.frame.size.width * 0.5, clearAccountBtn.frame.origin.y, 105, 40);
    [logoutBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    logoutBtn.hidden = YES;
    [bg addSubview:logoutBtn];

    // 切换账户按钮
    UIButton* switchAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchAccountBtn.frame = CGRectMake(bg.frame.size.width * 0.88 - 105, logoutBtn.frame.origin.y, 105, 40);
    [switchAccountBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [switchAccountBtn addTarget:self action:@selector(switchAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [switchAccountBtn setTitle:@"Switch\nAccount" forState:UIControlStateNormal];
    switchAccountBtn.titleLabel.numberOfLines = 2;
    switchAccountBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    switchAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [switchAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switchAccountBtn.hidden = YES;
    [bg addSubview:switchAccountBtn];
    
    // 修改昵称
    UIButton* modifyNicknameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyNicknameBtn.frame = CGRectMake(clearAccountBtn.frame.origin.x, bg.frame.size.height * 0.78, 105, 40);
    [modifyNicknameBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [modifyNicknameBtn addTarget:self action:@selector(modifyNicknameBtn:) forControlEvents:UIControlEventTouchUpInside];
    [modifyNicknameBtn setTitle:@"Change\nNickname" forState:UIControlStateNormal];
    modifyNicknameBtn.titleLabel.numberOfLines = 2;
    modifyNicknameBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    modifyNicknameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [modifyNicknameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    modifyNicknameBtn.hidden = YES;
    [bg addSubview:modifyNicknameBtn];
    
    // 绑定按钮
    UIButton* bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindBtn.frame = CGRectMake(logoutBtn.frame.origin.x, bg.frame.size.height * 0.78, 105, 40);
    [bindBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [bindBtn addTarget:self action:@selector(bindBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bindBtn setTitle:@"Bind" forState:UIControlStateNormal];
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    bindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bindBtn.hidden = YES;
    [bg addSubview:bindBtn];

    // 修改密码按钮
    UIButton* modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.frame = CGRectMake(logoutBtn.frame.origin.x, bindBtn.frame.origin.y, 105, 40);
    [modifyBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(modifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [modifyBtn setTitle:@"Change\nPassword" forState:UIControlStateNormal];
    modifyBtn.titleLabel.numberOfLines = 2;
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    modifyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    modifyBtn.hidden = YES;
    [bg addSubview:modifyBtn];

    // 实名认证按钮
    UIButton* realNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    realNameBtn.frame = CGRectMake(switchAccountBtn.frame.origin.x, bindBtn.frame.origin.y, 105, 40);
    [realNameBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [realNameBtn addTarget:self action:@selector(realNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    [realNameBtn setTitle:@"Real Name" forState:UIControlStateNormal];
    realNameBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    realNameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [realNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    realNameBtn.hidden = YES;
    [bg addSubview:realNameBtn];

    // 清除缓存
    UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(switchAccountBtn.frame.origin.x, bindBtn.frame.origin.y, 105, 40);
    [clearBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtn:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    clearBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearBtn.hidden = ![[oneSDKBranchPlayerConfig getInstance] getIsShowClearBtn];
    [bg addSubview:clearBtn];
    
    // 强制绑定按钮
    UIButton* forceBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forceBindBtn.frame = CGRectMake(switchAccountBtn.frame.origin.x, bindBtn.frame.origin.y, 105, 40);
    [forceBindBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [forceBindBtn addTarget:self action:@selector(forceBindBtn:) forControlEvents:UIControlEventTouchUpInside];
    [forceBindBtn setTitle:@"Bind Account" forState:UIControlStateNormal];
    forceBindBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    forceBindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [forceBindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forceBindBtn.hidden = ![[oneSDKBranchPlayerConfig getInstance] getIsShowClearBtn];
    [bg addSubview:forceBindBtn];
    
    // 解绑按钮
    UIButton* unBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unBindBtn.frame = CGRectMake(switchAccountBtn.frame.origin.x, bindBtn.frame.origin.y, 105, 40);
    [unBindBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [unBindBtn addTarget:self action:@selector(unBindBtn:) forControlEvents:UIControlEventTouchUpInside];
    [unBindBtn setTitle:@"unBind" forState:UIControlStateNormal];
    unBindBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    unBindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [unBindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    unBindBtn.hidden = ![[oneSDKBranchPlayerConfig getInstance] getIsShowClearBtn];
    [bg addSubview:unBindBtn];
    
    // 关闭按钮
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(bg.frame.size.width - 15, -15, 30, 30);
    [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"closebtn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:closeBtn];

    // 显示按钮
    [self showButtons:bg andClearAccountBtn:clearAccountBtn andLogoutBtn:logoutBtn andBSwitchAccountBtn:switchAccountBtn andModifyNicknameBtn:modifyNicknameBtn andBindBtn:bindBtn andModifyBtn:modifyBtn andRealNameBtn:realNameBtn andClearBtn:clearBtn andForceBindBtn:forceBindBtn andUnBindBtn:unBindBtn];
}

-(void)showButtons:(UIImageView*)bg andClearAccountBtn:(UIButton*)clearAccountBtn andLogoutBtn:(UIButton*)logoutBtn andBSwitchAccountBtn:(UIButton*)switchAccountBtn andModifyNicknameBtn:(UIButton*)modifyNicknameBtn andBindBtn:(UIButton*)bindBtn andModifyBtn:(UIButton*)modifyBtn andRealNameBtn:(UIButton*)realNameBtn andClearBtn:(UIButton*)clearBtn andForceBindBtn:(UIButton*)forceBindBtn andUnBindBtn:(UIButton*)unBindBtn
{
    CGPoint point1 = CGPointMake(bg.frame.size.width * 0.12, bg.frame.size.height * 0.62);
    CGPoint point2 = CGPointMake(bg.frame.size.width * 0.5 - 105 * 0.5, bg.frame.size.height * 0.62);
    CGPoint point3 = CGPointMake(bg.frame.size.width * 0.88 - 105, bg.frame.size.height * 0.62);
    CGPoint point4 = CGPointMake(bg.frame.size.width * 0.12, bg.frame.size.height * 0.78);
    CGPoint point5 = CGPointMake(bg.frame.size.width * 0.5 - 105 * 0.5, bg.frame.size.height * 0.78);
    CGPoint point6 = CGPointMake(bg.frame.size.width * 0.88 - 105, bg.frame.size.height * 0.78);
    
    NSArray* pointArray = [NSArray arrayWithObjects:NSStringFromCGPoint(point1), NSStringFromCGPoint(point2), NSStringFromCGPoint(point3), NSStringFromCGPoint(point4), NSStringFromCGPoint(point5), NSStringFromCGPoint(point6), nil];
    
    // 玩家登录方式(1:游客, 2:账号密码, 3:google, 4:facebook, 5:apple)
    NSString* loginType = [[oneSDKBranchPlayerConfig getInstance] getLoginType];
    NSString* isCanShowForceBindBtn = [[oneSDKBranchPlayerConfig getInstance] getForceBindBtnIsCanShow];
    
    // 获取登录方式
    oneSDKBranchLogUtils(@"%@ loginType is %@, isCanShowForceBindBtn is %@", mineTAGoneSDKBranchUserInfoView, loginType, isCanShowForceBindBtn);

    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:clearAccountBtn];
    [array addObject:logoutBtn];
    [array addObject:switchAccountBtn];
    [array addObject:modifyNicknameBtn];
    
    // 游客
    if ([loginType isEqual:@"1"])
    {
        [array addObject:bindBtn];
    }
    else if ([loginType isEqual:@"2"])
    {
        [array addObject:modifyBtn];
    }
    
    // 第三方登录(3:google, 4:facebook, 5:apple)
    if ([loginType isEqual:@"3"] || [loginType isEqual:@"4"] || [loginType isEqual:@"5"])
    {
        [array addObject:forceBindBtn];
    }
    
    // 测试服
    if ([[[oneSDKBranchPlayerConfig getInstance] getProducteState] isEqual:@"1"])
    {
        // 第三方登录(3:google, 4:facebook, 5:apple), 且已绑定
        if (([loginType isEqual:@"3"] || [loginType isEqual:@"4"] || [loginType isEqual:@"5"]) && [isCanShowForceBindBtn isEqual:@"0"])
        {
            [array addObject:unBindBtn];
        }
    }
    
    oneSDKBranchLogUtils(@"count is %lu", array.count);
    
    if (array.count > 6)
    {
        return;
    }
    
    for (int i = 0; i < array.count; i++)
    {
        // 取值
        CGPoint p = CGPointFromString([pointArray objectAtIndex:i]);
        float x = p.x;
        float y = p.y;
        
        oneSDKBranchLogUtils(@"x is %f, y is %f", x, y);
        
        UIButton* button = [array objectAtIndex:i];
        button.hidden = NO;
        button.frame = CGRectMake(x, y, 105, 40);
    }
}

-(void)addVerticalView
{
    // 添加背景
    UIImageView* bg = [[UIImageView alloc] init];
    bg.userInteractionEnabled = YES;
    bg.frame = CGRectMake(0, 0, 355, 505);
    bg.contentMode =  UIViewContentModeScaleAspectFill;
//        [bg setContentMode:UIViewContentModeScaleToFill];
    bg.layer.position = self.center;
    bg.image = [oneSDKBranchUtils getImageFromBundle:@"infobg"];
    [self addSubview:bg];
    
    // 小背景
    UIImageView* smallBg = [[UIImageView alloc] init];
    smallBg.frame = CGRectMake(bg.frame.size.width * 0.5 - 315 * 0.5, bg.frame.size.width * 0.18, 315, 150);
    smallBg.image = [oneSDKBranchUtils getImageFromBundle:@"smallnewbg"];
    [bg addSubview:smallBg];
    
    // title小背景
    UIImageView* titleBg = [[UIImageView alloc] init];
    titleBg.userInteractionEnabled = NO;
    titleBg.frame = CGRectMake(bg.frame.size.width * 0.5 - 215 * 0.5, -45 * 0.5 + 8, 215, 45);
    titleBg.image = [oneSDKBranchUtils getImageFromBundle:@"title"];
    [bg addSubview:titleBg];

    // title文本
    UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 100 * 0.5, -30 * 0.5, 100, 40) textContainer:nil];
    titleText.userInteractionEnabled = NO;
    titleText.font = [UIFont systemFontOfSize:25];
    [titleText setBackgroundColor:[UIColor clearColor]];
    titleText.textColor = [UIColor whiteColor];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.text = @"Info";
    [bg addSubview:titleText];
    
    // accountText
    UITextView* accountText = [[UITextView alloc] initWithFrame:CGRectMake(smallBg.frame.size.width * 0.01, smallBg.frame.size.height * 0.15, 80, 25) textContainer:nil];
    accountText.userInteractionEnabled = NO;
    accountText.font = [UIFont systemFontOfSize:16];
    [accountText setBackgroundColor:[UIColor clearColor]];
    accountText.textColor = [UIColor blackColor];
    accountText.textAlignment = NSTextAlignmentRight;
    accountText.text = @"Account:";
    [smallBg addSubview:accountText];
    
    // account
    UITextView* account = [[UITextView alloc] initWithFrame:CGRectMake(accountText.frame.size.width, accountText.frame.origin.y, 240, 25) textContainer:nil];
    account.userInteractionEnabled = NO;
    account.font = [UIFont systemFontOfSize:16];
    [account setBackgroundColor:[UIColor clearColor]];
    account.textColor = [UIColor blackColor];
    account.text = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getAccount]];
    [smallBg addSubview:account];
    
    // idText
    UITextView* idText = [[UITextView alloc] initWithFrame:CGRectMake(accountText.frame.origin.x, smallBg.frame.size.height * 0.5 - account.frame.size.height * 0.5, 80, 25) textContainer:nil];
    idText.userInteractionEnabled = NO;
    idText.font = [UIFont systemFontOfSize:16];
    [idText setBackgroundColor:[UIColor clearColor]];
    idText.textColor = [UIColor blackColor];
    idText.textAlignment = NSTextAlignmentRight;
    idText.text = @"ID:";
    [smallBg addSubview:idText];
    
    // id
    UITextView* idStr = [[UITextView alloc] initWithFrame:CGRectMake(idText.frame.size.width, idText.frame.origin.y, 240, 25) textContainer:nil];
    idStr.userInteractionEnabled = NO;
    idStr.font = [UIFont systemFontOfSize:16];
    [idStr setBackgroundColor:[UIColor clearColor]];
    idStr.textColor = [UIColor blackColor];
    idStr.text = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getUid]];
    [smallBg addSubview:idStr];
    
    // nameText
    UITextView* nameText = [[UITextView alloc] initWithFrame:CGRectMake(accountText.frame.origin.x, smallBg.frame.size.height * 0.85 - account.frame.size.height, 80, 25) textContainer:nil];
    nameText.userInteractionEnabled = NO;
    nameText.font = [UIFont systemFontOfSize:16];
    [nameText setBackgroundColor:[UIColor clearColor]];
    nameText.textColor = [UIColor blackColor];
    nameText.textAlignment = NSTextAlignmentRight;
    nameText.text = @"Name:";
    [smallBg addSubview:nameText];
    
    // name
    UITextView* name = [[UITextView alloc] initWithFrame:CGRectMake(nameText.frame.size.width, nameText.frame.origin.y, 240, 25) textContainer:nil];
    name.userInteractionEnabled = NO;
    name.font = [UIFont systemFontOfSize:16];
    [name setBackgroundColor:[UIColor clearColor]];
    name.textColor = [UIColor blackColor];
//        name.text = [[oneSDKBranchPlayerConfig getInstance] getName];
    name.text = [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getName]];
    [smallBg addSubview:name];
    
    CGFloat fontSize = 12;
    
    // 删除账号按钮
    UIButton* clearAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearAccountBtn.frame = CGRectMake(bg.frame.size.width * 0.12, bg.frame.size.height * 0.48, 105, 40);
    [clearAccountBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [clearAccountBtn addTarget:self action:@selector(clearAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [clearAccountBtn setTitle:@"Account\nDeletion" forState:UIControlStateNormal];
    clearAccountBtn.titleLabel.numberOfLines = 2;
    clearAccountBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    clearAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearAccountBtn.hidden = YES;
    [bg addSubview:clearAccountBtn];
    
    // 登出按钮
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(bg.frame.size.width * 0.88 - clearAccountBtn.frame.size.width, clearAccountBtn.frame.origin.y, 105, 40);
    [logoutBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    logoutBtn.hidden = YES;
    [bg addSubview:logoutBtn];

    // 切换账户按钮
    UIButton* switchAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchAccountBtn.frame = CGRectMake(clearAccountBtn.frame.origin.x, bg.frame.size.height * 0.6, 105, 40);
    [switchAccountBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [switchAccountBtn addTarget:self action:@selector(switchAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [switchAccountBtn setTitle:@"Switch\nAccount" forState:UIControlStateNormal];
    switchAccountBtn.titleLabel.numberOfLines = 2;
    switchAccountBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    switchAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [switchAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switchAccountBtn.hidden = YES;
    [bg addSubview:switchAccountBtn];
    
    // 绑定按钮
    UIButton* bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindBtn.frame = CGRectMake(logoutBtn.frame.origin.x, switchAccountBtn.frame.origin.y, 105, 40);
    [bindBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [bindBtn addTarget:self action:@selector(bindBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bindBtn setTitle:@"Bind" forState:UIControlStateNormal];
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    bindBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bindBtn.hidden = YES;
    [bg addSubview:bindBtn];
    
    // 修改密码按钮
    UIButton* modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.frame = CGRectMake(logoutBtn.frame.origin.x, switchAccountBtn.frame.origin.y, 105, 40);
    [modifyBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(modifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [modifyBtn setTitle:@"Change\nPassword" forState:UIControlStateNormal];
    modifyBtn.titleLabel.numberOfLines = 2;
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    modifyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    modifyBtn.hidden = YES;
    [bg addSubview:modifyBtn];
    
    // 实名认证按钮
    UIButton* realNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    realNameBtn.frame = CGRectMake(clearAccountBtn.frame.origin.x, bg.frame.size.height * 0.72, 105, 40);
    [realNameBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [realNameBtn addTarget:self action:@selector(realNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    [realNameBtn setTitle:@"Real Name" forState:UIControlStateNormal];
    realNameBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    realNameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [realNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    realNameBtn.hidden = YES;
    [bg addSubview:realNameBtn];
    
    // 清除缓存
    UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(clearAccountBtn.frame.origin.x, bg.frame.size.height * 0.72, 105, 40);
    [clearBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtn:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    clearBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearBtn.hidden = ![[oneSDKBranchPlayerConfig getInstance] getIsShowClearBtn];
    [bg addSubview:clearBtn];
    
    // 关闭按钮
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(bg.frame.size.width - 52, -18, 52, 52);
    [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"closebtn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:closeBtn];
    
    // 获取登录方式
    oneSDKBranchLogUtils(@"%@ loginType is %@", mineTAGoneSDKBranchUserInfoView, [NSString stringWithFormat:@"%@", [[oneSDKBranchPlayerConfig getInstance] getLoginType]]);
    
    // 删除账号按钮可见
    clearAccountBtn.hidden = NO;
    // 登出按钮可见
    logoutBtn.hidden = NO;
    // 切换账号按钮可见
    switchAccountBtn.hidden = NO;
    
    // 玩家登录方式(1:游客, 2:账号密码, 3:google, 4:facebook, 5:apple)
    if ([[[oneSDKBranchPlayerConfig getInstance] getLoginType] isEqual:@"1"])
    {
        // 绑定按钮可见
        bindBtn.hidden = NO;
    }
    else if ([[[oneSDKBranchPlayerConfig getInstance] getLoginType] isEqual:@"2"])
    {
        // 修改密码按钮可见
        modifyBtn.hidden = NO;
    }
}

// 复制按钮
-(void)copyBtn:(id)sender
{
    NSString* str = [NSString stringWithFormat:@"Account:%@\nID:%@\nNickname:%@", [[oneSDKBranchPlayerConfig getInstance] getAccount], [[oneSDKBranchPlayerConfig getInstance] getUid], [[oneSDKBranchPlayerConfig getInstance] getName]];
    // 获取系统剪贴板
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    // 设置剪贴板的字符串内容
    pasteboard.string = str;

    [oneSDKBranchToastUtils show:@"copy success" duration:2.0];
}

// 删除账号按钮
-(void)clearAccountBtn:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[oneSDKBranchPlayerConfig getInstance] getClearAccountFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getMacAddress] == nil || [[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getMacAddress]] isEqualToString:@""])
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    [self doClearAccount];
}

-(void)doClearAccount
{
    // 跳转到提示界面
    oneSDKBranchTipsView* view = [[oneSDKBranchTipsView alloc] initViewWithType:2 andValue:@""];
    [self addSubview:view];
}

// 登出按钮
-(void)logoutBtn:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[oneSDKBranchPlayerConfig getInstance] getLogoutFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getMacAddress] == nil || [[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getMacAddress]] isEqualToString:@""])
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    [self doLogout];
}

// 切换账号按钮
-(void)switchAccountBtn:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }

    [self doSwitchAccount];
}

// 修改密码按钮
-(void)modifyBtn:(id)sender
{
    [self doModify];
}

// 修改昵称
-(void)modifyNicknameBtn:(id)sender
{
    [self doModifyNickname];
}

// 绑定按钮
-(void)bindBtn:(id)sender
{
    [self doBind];
}

// 实名认证按钮
-(void)realNameBtn:(id)sender
{
    [self doRealName];
}

// 清除缓存按钮
-(void)clearBtn:(id)sender
{
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_phone_md5_code" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_account" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_token" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_logintype" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_email" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_userId" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_fullname" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_token" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_email" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_userId" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_fullname" Value:@""];
    [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_token" Value:@""];
    [oneSDKBranchUtils permanentClearAll];
}

// 强制绑定
-(void)forceBindBtn:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值
    if ([[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getCheckPlayerForceBindStateFuncName]] isEqualToString:@""])
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    [self doForceBind];
}

// 解绑
-(void)unBindBtn:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值
    if ([[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getUnForceBindFuncName]] isEqualToString:@""])
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    [self doUnBindBtn];
}

// 关闭本界面
-(void)closeBtn:(id)sender
{
    apponeSDKBranchUserInfoView = NULL;
    [self removeFromSuperview];
}

// 获取本类信息
+(oneSDKBranchUserInfoView*)getApp
{
    return apponeSDKBranchUserInfoView;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchUserInfoView = NULL;
}

// 登出
-(void)doLogout
{
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode: [[oneSDKBranchPlayerConfig getInstance] getName]] forKey: @"nickName"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginTime] forKey: @"logintime"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, doLogout newSign_str is %@", mineTAGoneSDKBranchUserInfoView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@, doLogout str is %@", mineTAGoneSDKBranchUserInfoView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, doLogout newSign is %@", mineTAGoneSDKBranchUserInfoView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getLogoutFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doLogout newUrl is %@", mineTAGoneSDKBranchUserInfoView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doLogout result is %@", mineTAGoneSDKBranchUserInfoView, object);
        
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        
        // 如果允许退出
        if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
        {
            [[UIApplication sharedApplication]performSelector:@selector(suspend)];
            exit(0);
        }
        else
        {
            NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
            // 通知用户失败原因
            [oneSDKBranchToastUtils show:msg duration:2.0f];
        }
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchUserInfoView, error);
    }];
}

// 切换账号
-(void)doSwitchAccount
{
    // 1:游客, 2:账号密码, 3:google, 4:facebook, 5:apple
    if ([[[oneSDKBranchPlayerConfig getInstance] loginType] isEqual:@"4"])  // facebook登录
    {
        [oneSDKBranchLoginView facebookLogout];
    }
    else if ([[[oneSDKBranchPlayerConfig getInstance] loginType] isEqual:@"5"])  // google登录
    {
        [oneSDKBranchLoginView googleLogout];
    }
    [always sendSwitchAccount];
}

// 修改密码
-(void)doModify
{
    // 获取本地储存的玩家账号
    NSString* str = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_account"];
    // 弹出忘记密码界面(修改密码)
    oneSDKBranchForgetView* view = [[oneSDKBranchForgetView alloc] initViewWithType:2 NEmail:str];
    [self addSubview:view];
}

// 绑定
-(void)doBind
{
    // 弹出忘记密码界面(绑定)
    oneSDKBranchForgetView* view = [[oneSDKBranchForgetView alloc] initViewWithType:3 NEmail:@""];
    [self addSubview:view];
}

// 修改昵称
-(void)doModifyNickname
{
    oneSDKBranchModifyNickName* view = [[oneSDKBranchModifyNickName alloc] initView];
    [self addSubview:view];
}

// 实名认证
-(void)doRealName
{
    oneSDKBranchLogUtils(@"%@, doRealName is called", mineTAGoneSDKBranchUserInfoView);
}

// 强制绑定
-(void)doForceBind
{
    NSString* jsonString = [[oneSDKBranchPlayerConfig getInstance] getEmpowerLoginData];
    oneSDKBranchLogUtils(@"jsonString is %@", jsonString);
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    oneSDKBranchLogUtils(@"jsonString is %@", jsonData);
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    oneSDKBranchLogUtils(@"dic is %@", dic);
    NSString* email  = [dic objectForKey:@"email"];
    NSString* idios = [dic objectForKey:@"id"];
    NSString* name  = [dic objectForKey:@"name"];
    NSString* token  = [dic objectForKey:@"token"];
    oneSDKBranchLogUtils(@"email is %@, idios is %@, name is %@, token is %@", email, idios, name, token);
    NSMutableDictionary* json = [oneSDKBranchBaseActivity getBaseJson];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getAccount] forKey:@"account"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey:@"user_id"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginType] forKey:@"type"];
    [json setValue:email forKey:@"email"];
    [json setValue:[oneSDKBranchUtils base64Encode:token] forKey:@"token"];
    [json setValue:[oneSDKBranchUtils base64Encode:name] forKey:@"name"];
    [json setValue:idios forKey:@"id"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:json];
    oneSDKBranchLogUtils(@"%@ newSign_str is %@", mineTAGoneSDKBranchUserInfoView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@ str is %@", mineTAGoneSDKBranchUserInfoView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@ newSign is %@", mineTAGoneSDKBranchUserInfoView, newSign);
    [json setValue:newSign forKey: @"SIGN"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getCheckPlayerForceBindStateFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@ newUrl is %@", mineTAGoneSDKBranchUserInfoView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@ result is %@", mineTAGoneSDKBranchUserInfoView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        
        // 已绑定, 显示兑换码信息
        if ([code isEqual:@"200"])
        {
            // 弹出奖励界面
            oneSDKBranchForceBindRewardView* view = [[oneSDKBranchForceBindRewardView alloc] initView];
            [self addSubview:view];
        }
        else if ([code isEqual:@"505"])  // 强制绑定流程
        {
            // 弹出奖励界面
            oneSDKBranchForceBindView* view = [[oneSDKBranchForceBindView alloc] initView];
            [self addSubview:view];
        }
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchUserInfoView, error);
    }];
}

// 解绑
-(void)doUnBindBtn
{
    NSString* jsonString = [[oneSDKBranchPlayerConfig getInstance] getEmpowerLoginData];
    oneSDKBranchLogUtils(@"jsonString is %@", jsonString);
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    oneSDKBranchLogUtils(@"jsonString is %@", jsonData);
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    oneSDKBranchLogUtils(@"dic is %@", dic);
    NSString* email  = [dic objectForKey:@"email"];
    NSString* idios = [dic objectForKey:@"id"];
    NSString* name  = [dic objectForKey:@"name"];
    NSString* token  = [dic objectForKey:@"token"];
    oneSDKBranchLogUtils(@"email is %@, idios is %@, name is %@, token is %@", email, idios, name, token);
    NSMutableDictionary* json = [oneSDKBranchBaseActivity getBaseJson];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getAccount] forKey:@"account"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey:@"user_id"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginType] forKey:@"type"];
    [json setValue:email forKey:@"email"];
    [json setValue:[oneSDKBranchUtils base64Encode:token] forKey:@"token"];
    [json setValue:[oneSDKBranchUtils base64Encode:name] forKey:@"name"];
    [json setValue:idios forKey:@"id"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:json];
    oneSDKBranchLogUtils(@"%@ newSign_str is %@", mineTAGoneSDKBranchUserInfoView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@ str is %@", mineTAGoneSDKBranchUserInfoView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@ newSign is %@", mineTAGoneSDKBranchUserInfoView, newSign);
    [json setValue:newSign forKey: @"SIGN"];
    [json setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getUnForceBindFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@ newUrl is %@", mineTAGoneSDKBranchUserInfoView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@ result is %@", mineTAGoneSDKBranchUserInfoView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        
        [oneSDKBranchToastUtils show:msg duration:2.0f];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchUserInfoView, error);
    }];
}

// 点击屏幕空白处什么都不做(屏蔽触摸)
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

@end
