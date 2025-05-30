//
//  oneSDKBranchForceBindView.m
//  oneSDK
//
//  Created by 天下 on 2024/8/5.
//

#import "./oneSDKBranchForceBindView.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./oneSDKBranchForceBindRewardView.h"
#import "./../../always/always.h"

// 获取验证码按钮
UIButton* getForceBindCode;
static int forceBindCountDown = 30;
// 是否开启了定时器
static bool forceBindIsRunHandle = NO;
// 定时器对象
NSTimer* forceBindTimer;

// mineTAG
NSString* mineTAGoneSDKBranchForceBindView;

@implementation oneSDKBranchForceBindView

// app
static oneSDKBranchForceBindView* apponeSDKBranchForceBindView = NULL;

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
        mineTAGoneSDKBranchForceBindView = @"oneSDKBranchForceBindView";
        apponeSDKBranchForceBindView = self;

        // 添加背景
        UIImageView* bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 364, 329);
        bg.contentMode = UIViewContentModeCenter;
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"forget_bg_h"];
        [self addSubview:bg];

        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 30, 0, 200, 40) textContainer:nil];
        titleText.font = [UIFont systemFontOfSize:25];
        titleText.userInteractionEnabled = NO;
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor blackColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"Bind";
        // 创建NSAttributedString
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
        // 设置加粗属性
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
        // 应用属性到UITextView
        titleText.attributedText = attributedString;
        [bg addSubview:titleText];

        // account
        UITextField* nickname = [[UITextField alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 150, titleText.frame.size.height + 20, 300, 35)];
        nickname.placeholder = @"Enter Email";
        nickname.keyboardType = UIKeyboardTypeEmailAddress;
        nickname.borderStyle = UITextBorderStyleRoundedRect;
        nickname.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nickname.layer.borderWidth = 1;
        nickname.layer.cornerRadius = 6;
        nickname.returnKeyType = UIReturnKeyDone;
        nickname.delegate = self;
        self.nickname = nickname;
        [bg addSubview:nickname];

        // code
        UITextField* code = [[UITextField alloc]initWithFrame:CGRectMake(nickname.frame.origin.x, nickname.frame.origin.y + 60, 180, 35)];
        code.placeholder = @"Enter Code";
        code.keyboardType = UIKeyboardTypeEmailAddress;
        code.borderStyle = UITextBorderStyleRoundedRect;
        code.layer.borderColor = [UIColor lightGrayColor].CGColor;
        code.layer.borderWidth = 1;
        code.layer.cornerRadius = 6;
        code.returnKeyType = UIReturnKeyDone;
        code.keyboardType = UIKeyboardTypeNumberPad;
        code.delegate = self;
        self.code = code;
        [bg addSubview:code];

        // Get Code按钮
        getForceBindCode = [UIButton buttonWithType:UIButtonTypeCustom];
        getForceBindCode.frame = CGRectMake(code.frame.size.width + code.frame.origin.x + 10, code.frame.origin.y - 4, 105, 40);
        [getForceBindCode setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
        [getForceBindCode addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [getForceBindCode setTitle:@"Get Code" forState:UIControlStateNormal];
        getForceBindCode.titleLabel.font = [UIFont systemFontOfSize:18];
        getForceBindCode.titleLabel.textAlignment = NSTextAlignmentCenter;
        [getForceBindCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bg addSubview:getForceBindCode];

        // 如果开启了定时器
        if (forceBindCountDown > 0 && forceBindIsRunHandle)
        {
            NSString* str = @"";
            NSString* stringInt = [NSString stringWithFormat:@"%d", forceBindCountDown];
            str = [str stringByAppendingFormat:@"%@S", stringInt];
            [getForceBindCode setEnabled:NO];
        }

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

        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(bg.frame.size.width * 0.5 - 300 * 0.5, bg.frame.size.height - 60, 400, 200);
        label.text = @"Please provide a valid email address\nOnce verified, the email cannot be changed.";
        label.font = [UIFont systemFontOfSize:15];
        [label setBackgroundColor:[UIColor clearColor]];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [label sizeToFit];
        [bg addSubview:label];

        // 关闭按钮
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(bg.frame.size.width - 15, -15, 30, 30);
        [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"closebtn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:closeBtn];
    }
    return self;
}

// 获取验证码
-(void)getCodeBtn:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getForceBindFuncName] == nil)
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 验证账号
    if (![oneSDKBranchUtils isEmail:self.nickname.text])
    {
        [oneSDKBranchToastUtils show:@"Not a normal email address" duration:2.0];
        return;
    }
    
    [self doGetVerificationCode];
}

// 获取验证码
-(void)doGetVerificationCode
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    if (self.nickname.text.length == 0)
    {
        return;
    }
    
    forceBindIsRunHandle = YES;
    // 开启一个定时器
    forceBindTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(MyCountDownTimer:) userInfo:nil repeats:YES];
    // 按钮设置为不可点
    [getForceBindCode setEnabled:NO];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getForceBindFuncName];
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode newUrl is %@", mineTAGoneSDKBranchForceBindView, url);
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode newUrl is %@", mineTAGoneSDKBranchForceBindView, newUrl);
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode began mineJson is %@", mineTAGoneSDKBranchForceBindView, mineJson);
    
    [mineJson setValue:self.nickname.text forKey: @"account"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginType] forKey: @"type"];
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:mineJson];
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode end mineJson is %@", mineTAGoneSDKBranchForceBindView, mineJson);
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode upStr is %@", mineTAGoneSDKBranchForceBindView, upStr);
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode newUrl is %@", mineTAGoneSDKBranchForceBindView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doGetVerificationCode result is %@", mineTAGoneSDKBranchForceBindView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        oneSDKBranchLogUtils(@"msg is %@", msg);
        [oneSDKBranchToastUtils show:msg duration:2.0f];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchForceBindView, error);
    }];
}

// 确认
-(void)confirmButtonClick:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getSubmitForceBindEmailFuncName] == nil)
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    if (self.code.text.length == 0 || self.nickname.text.length == 0)
    {
        return;
    }
    
    // 获取授权信息
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
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:email forKey: @"email"];
    [mineJson setValue:self.code.text forKey: @"code"];
    [mineJson setValue:self.nickname.text forKey: @"account"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginType] forKey: @"type"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:token] forKey: @"token"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:name] forKey: @"name"];
    [mineJson setValue:idios forKey: @"id"];
    
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:mineJson];
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getSubmitForceBindEmailFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, confirmButtonClick newUrl is %@", mineTAGoneSDKBranchForceBindView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, confirmButtonClick result is %@", mineTAGoneSDKBranchForceBindView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        if ([code isEqual:@"200"])
        {
            if (forceBindTimer)
            {
                // 暂停定时器
                [forceBindTimer invalidate];
                forceBindTimer = NULL;
            }
            
            NSString* activation_code = [oneSDKBranchUtils isContains:object andKey:@"activation_code"];
            NSString* activation_config = [oneSDKBranchUtils isContains:object andKey:@"activation_config"];
            NSString* activation_status = [oneSDKBranchUtils isContains:object andKey:@"activation_status"];
            
            [[oneSDKBranchPlayerConfig getInstance] setGoodsCode:activation_code];
            [[oneSDKBranchPlayerConfig getInstance] setGoods:activation_config];
            [[oneSDKBranchPlayerConfig getInstance] setGoodsStatus:activation_status];
            
            // 弹出奖励界面
            oneSDKBranchForceBindRewardView* view = [[oneSDKBranchForceBindRewardView alloc] initView];
            [self addSubview:view];
        }
        [oneSDKBranchToastUtils show:msg duration:2.0f];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchForceBindView, error);
    }];
}

-(void)MyCountDownTimer:(id)sender
{
    forceBindCountDown--;
    NSString* str = @"";
    NSString* stringInt = [NSString stringWithFormat:@"%d", forceBindCountDown];
    str = [str stringByAppendingFormat:@"%@S", stringInt];
    [getForceBindCode setTitle:str forState:UIControlStateNormal];
    if (forceBindCountDown <= 0)
    {
        forceBindIsRunHandle = NO;
        [getForceBindCode setTitle:@"Get Code" forState:UIControlStateNormal];
        forceBindCountDown = 30;
        [getForceBindCode setEnabled:YES];
        // 暂停定时器
        [forceBindTimer invalidate];
    }
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
    [self.code resignFirstResponder];
}

// 关闭
-(void)closeBtn:(id)sender
{
    apponeSDKBranchForceBindView = NULL;
    if (forceBindTimer)
    {
        // 暂停定时器
        [forceBindTimer invalidate];
        forceBindTimer = NULL;
    }
    [self removeFromSuperview];
}

// 获取本类信息
+(oneSDKBranchForceBindView*)getApp
{
    return apponeSDKBranchForceBindView;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchForceBindView = NULL;
}

@end
