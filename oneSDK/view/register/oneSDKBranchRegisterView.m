//
//  oneSDKBranchRegisterView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchRegisterView.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./../../oneSDK/oneSDKBranch.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../always/always.h"

// mineTAG
NSString* mineTAGoneSDKBranchRegisterView;

@implementation oneSDKBranchRegisterView
// app
static oneSDKBranchRegisterView* apponeSDKBranchRegisterView = NULL;

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
        mineTAGoneSDKBranchRegisterView = @"oneSDKBranchRegisterView";
        apponeSDKBranchRegisterView = self;
        
        // 添加背景
        UIImageView* bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 500, 329);
        bg.contentMode = UIViewContentModeCenter;
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"info_bg_h"];
        [self addSubview:bg];
        
        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 30, 0, 200, 40) textContainer:nil];
        titleText.userInteractionEnabled = NO;
        titleText.font = [UIFont systemFontOfSize:25];
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor blackColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"Register";
        // 创建NSAttributedString
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
        // 设置加粗属性
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
        // 应用属性到UITextView
        titleText.attributedText = attributedString;
        [bg addSubview:titleText];
        
        // account
        UITextField* account = [[UITextField alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 150, titleText.frame.size.height + 20, 300, 35)];
        account.placeholder = @"Enter Email";
        account.keyboardType = UIKeyboardTypeEmailAddress;
        account.borderStyle = UITextBorderStyleRoundedRect;
        account.layer.borderColor = [UIColor lightGrayColor].CGColor;
        account.layer.borderWidth = 1;
        account.layer.cornerRadius = 6;
        account.returnKeyType = UIReturnKeyDone;
        account.delegate = self;
        self.account = account;
        [bg addSubview:account];
        
        // password
        UITextField* password = [[UITextField alloc] initWithFrame:CGRectMake(account.frame.origin.x, account.frame.origin.y + 60, account.frame.size.width, account.frame.size.height)];
        password.placeholder = @"Enter Password";
        password.secureTextEntry = YES;
        password.borderStyle = UITextBorderStyleRoundedRect;
        password.layer.borderColor = [UIColor lightGrayColor].CGColor;
        password.layer.borderWidth = 1;
        password.layer.cornerRadius = 6;
        password.returnKeyType = UIReturnKeyDone;
        password.delegate = self;
        self.password = password;
        [bg addSubview:password];
        
        // confirmPassword
        UITextField* confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(password.frame.origin.x, password.frame.origin.y + 60, password.frame.size.width, password.frame.size.height)];
        confirmPassword.placeholder = @"Confirm Password";
        confirmPassword.secureTextEntry = YES;
        confirmPassword.borderStyle = UITextBorderStyleRoundedRect;
        confirmPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
        confirmPassword.layer.borderWidth = 1;
        confirmPassword.layer.cornerRadius = 6;
        confirmPassword.returnKeyType = UIReturnKeyDone;
        confirmPassword.delegate = self;
        self.confirmPassword = confirmPassword;
        [bg addSubview:confirmPassword];
        
        // 注册按钮
        UIButton* registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.frame = CGRectMake(bg.frame.size.width * 0.5 - 285 * 0.5, bg.frame.size.height - 80, 285, 34);
        [registerButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"login_submit_btn"] forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(registerButton:) forControlEvents:UIControlEventTouchUpInside];
        [registerButton setTitle:@"Confirm" forState:UIControlStateNormal];
        registerButton.titleLabel.font = [UIFont systemFontOfSize:28];
        registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bg addSubview:registerButton];
        
        // 关闭按钮
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(bg.frame.size.width - 15, -15, 30, 30);
        [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"closebtn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:closeBtn];
    }
    return self;
}

-(void)registerButton:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果方法名不存在, 或者没获取到唯一码
    if ([[oneSDKBranchPlayerConfig getInstance] getRegisterFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getMacAddress] == nil || [[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getMacAddress]] isEqualToString:@""])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 验证账号
    if (![oneSDKBranchUtils verificatAccount:self.account.text])
    {
        return;
    }
    
    // 验证密码
    if (![oneSDKBranchUtils verificatPassword:self.password.text])
    {
        return;
    }
    
    // 验证确认密码
    if (![oneSDKBranchUtils verificatPassword:self.confirmPassword.text])
    {
        return;
    }
    
    // 两次密码不符
    if (![[oneSDKBranchUtils toNSString:self.password.text] isEqualToString:self.confirmPassword.text])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noagreementpassword"] duration:2.0f];
        return;
    }
    
    // 发送注册请求
    [self doRegister:self.account.text Password:self.password.text];
}

-(void)doRegister:(NSString*)account Password:(NSString*)password
{
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:account forKey: @"account"];
    [mineJson setValue:password forKey: @"password"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, doRegister newSign_str is %@", mineTAGoneSDKBranchRegisterView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, doRegister newSign is %@", mineTAGoneSDKBranchRegisterView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getRegisterFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doRegister newUrl is %@", mineTAGoneSDKBranchRegisterView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doRegister result is %@", mineTAGoneSDKBranchRegisterView, object);
        
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        
        // 如果请求成功
        if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
        {
            // 通知客户登录结果
            [always onLoginCallback:object];
        }
        else
        {
            NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
            // 提示用户失败原因
            [oneSDKBranchToastUtils show:msg duration:2.0f];
        }
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchRegisterView, error);
    }];
}

// 关闭本界面
-(void)closeBtn:(id)sender
{
    apponeSDKBranchRegisterView = NULL;
    [self removeFromSuperview];
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
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

// 获取本类信息
+(oneSDKBranchRegisterView*)getApp
{
    return apponeSDKBranchRegisterView;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchRegisterView = NULL;
}

@end
