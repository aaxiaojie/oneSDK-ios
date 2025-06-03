//
//  oneSDKBranchLoginView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchLoginView.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./../../listener/oneSDKBranchListener.h"
#import "./../../oneSDK/oneSDKBranch.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../register/oneSDKBranchRegisterView.h"
#import "./../forget/oneSDKBranchForgetView.h"
#import "./../loading/oneSDKBranchLoadingView.h"
#import "./../tips/oneSDKBranchTipsView.h"
#import "./../../always/always.h"

// mineTAG
NSString* mineTAGoneSDKBranchLoginView;
CGFloat _rotationLoginView;
UIImageView* loadingLoginView;
CADisplayLink* _displayLinkLoginView;

static UIButton* guestLoginButton;
static UIButton* googleLoginButton;
static UIButton* appleLoginButton;
static UIButton* fbLoginButton;
static UIView* linearLayout;

@implementation oneSDKBranchLoginView
// app
static oneSDKBranchLoginView* apponeSDKBranchLoginView = NULL;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
//    self.view.userInteractionEnabled = NO;
    mineTAGoneSDKBranchLoginView = @"oneSDKBranchLoginView";
    apponeSDKBranchLoginView = self;

    oneSDKBranchLogUtils(@"oneSDKBranchLoginView viewDidLoad is called");
    
    // 判断是否自动登录
    NSString* access_token = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_token"];
    NSString* access = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_account"];
    
    oneSDKBranchLogUtils(@"access_token is %@, access is %@", access_token, access);
    [self showView];
    
    if (access_token.length == 0 || access.length == 0)
    {
        [self setViewState:1];
    }
    else
    {
        [self setViewState:2];
    }
}

-(void)showView
{
    oneSDKBranchLogUtils(@"showView is called");
    // 半透明背景
    UIColor* transparentColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    UIView* loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    loginView.backgroundColor = transparentColor;
    loginView.hidden = YES;
    _loginView = loginView;
    [self.view addSubview:loginView];
    
    // 添加背景
    UIImageView* bg = [[UIImageView alloc] init];
    bg.userInteractionEnabled = YES;
    bg.frame = CGRectMake(0, 0, 500, 329);
    bg.contentMode = UIViewContentModeCenter;
    bg.layer.position = self.view.center;
    bg.image = [oneSDKBranchUtils getImageFromBundle:@"info_bg_h"];
    [loginView addSubview:bg];
    
    // title文本
    UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 90, 0, 200, 40) textContainer:nil];
    titleText.userInteractionEnabled = NO;
    titleText.font = [UIFont systemFontOfSize:25];
    [titleText setBackgroundColor:[UIColor clearColor]];
    titleText.textColor = [UIColor blackColor];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.text = @"Account Log In";
    // 创建NSAttributedString
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
    // 设置加粗属性
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
    // 应用属性到UITextView
    titleText.attributedText = attributedString;
    [bg addSubview:titleText];
    
    // email
    UITextField* emailText = [[UITextField alloc]initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 150, titleText.frame.size.height + 20, 300, 35)];
    emailText.placeholder = @"Enter Email";
    emailText.keyboardType = UIKeyboardTypeEmailAddress;
    emailText.borderStyle = UITextBorderStyleRoundedRect;
    emailText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    emailText.layer.borderWidth = 1;
    emailText.layer.cornerRadius = 6;
    emailText.returnKeyType = UIReturnKeyDone;
    emailText.delegate = self;
    self.emailText = emailText;
    [bg addSubview:emailText];
    
    // password
    UITextField* passwordText = [[UITextField alloc]initWithFrame:CGRectMake(emailText.frame.origin.x, emailText.frame.origin.y + 60, emailText.frame.size.width, emailText.frame.size.height)];
    passwordText.placeholder = @"Enter Password";
    passwordText.keyboardType = UIKeyboardTypeEmailAddress;
    passwordText.borderStyle = UITextBorderStyleRoundedRect;
    passwordText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordText.layer.borderWidth = 1;
    passwordText.layer.cornerRadius = 6;
    passwordText.returnKeyType = UIReturnKeyDone;
    passwordText.delegate = self;
    passwordText.secureTextEntry = YES;
    self.passwordText = passwordText;
    [bg addSubview:passwordText];
    
    // 注册
    UITextView* registerButton = [[UITextView alloc] initWithFrame:CGRectMake(passwordText.frame.origin.x - 5, passwordText.frame.origin.y + 40, 200, 25)];
    registerButton.text = @"Register Now";
    registerButton.font = [UIFont systemFontOfSize:15];
    [bg addSubview:registerButton];
    registerButton.textColor = [UIColor colorWithRed:0.0 green:0.79 blue:0.65 alpha:1.0];
    // 文本对其方式
    registerButton.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer* tapGestureRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doCreateAccount:)];
    tapGestureRegister.numberOfTapsRequired = 1;
    [registerButton addGestureRecognizer:tapGestureRegister];
    registerButton.editable = NO;
    
    // 忘记密码
    UITextView* forgetPasswordButton = [[UITextView alloc] initWithFrame:CGRectMake(passwordText.frame.origin.x + 105, registerButton.frame.origin.y, registerButton.frame.size.width, registerButton.frame.size.height)];
    forgetPasswordButton.text = @"Forget Password";
    forgetPasswordButton.font = [UIFont systemFontOfSize:15];
    [bg addSubview:forgetPasswordButton];
    forgetPasswordButton.textColor = [UIColor colorWithRed:0.0 green:0.79 blue:0.65 alpha:1.0];
    forgetPasswordButton.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer* tapGestureForgetPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doForgetPassword:)];
    tapGestureForgetPassword.numberOfTapsRequired = 1;
    [forgetPasswordButton addGestureRecognizer:tapGestureForgetPassword];
    forgetPasswordButton.editable = NO;
    
    // 登录
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(bg.frame.size.width * 0.5 - 285 * 0.5, forgetPasswordButton.frame.origin.y + 40, 285, 34);
    [loginButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"login_submit_btn"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doIDLogin:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:28];
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bg addSubview:loginButton];
    
    // 添加背景
    UIImageView* tishi = [[UIImageView alloc] init];
    tishi.userInteractionEnabled = YES;
    tishi.frame = CGRectMake(bg.frame.size.width * 0.5 - 280 * 0.5, loginButton.frame.origin.y + 50, 280, 13);
    tishi.contentMode = UIViewContentModeCenter;
    tishi.image = [oneSDKBranchUtils getImageFromBundle:@"login_line_h"];
    [bg addSubview:tishi];
    
    // apple登录按钮
    if (@available(iOS 13.0, *))  // 13以上版本
    {
        
    }
    else  // 13以下版本
    {
        [[oneSDKBranchPlayerConfig getInstance] setAppleBtnIsCanShow:false];
    }
    
    linearLayout = [[UIView alloc] init];
    linearLayout.frame = CGRectMake(bg.frame.size.width * 0.5 - 100, bg.frame.size.height - 50, 200, 35);
//    linearLayout.backgroundColor = [UIColor redColor];
    [bg addSubview:linearLayout];
    
    float x = 0;
    float y = linearLayout.frame.size.height * 0.5 - 15;
    
    // 游客登录按钮
    guestLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guestLoginButton.frame = CGRectMake(x, y, 30, 30);
    [guestLoginButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"guestbutton"] forState:UIControlStateNormal];
    [guestLoginButton addTarget:self action:@selector(doGuestLogin:) forControlEvents:UIControlEventTouchUpInside];
    guestLoginButton.enabled = YES;
    guestLoginButton.hidden = YES;
    [linearLayout addSubview:guestLoginButton];
    
    // google登录按钮
    googleLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    googleLoginButton.frame = CGRectMake(x, guestLoginButton.frame.origin.y, 30, 30);
    [googleLoginButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"googlebutton"] forState:UIControlStateNormal];
    [googleLoginButton addTarget:self action:@selector(gotoGoogleLogin:) forControlEvents:UIControlEventTouchUpInside];
    googleLoginButton.enabled = YES;
    googleLoginButton.hidden = YES;
    [linearLayout addSubview:googleLoginButton];
    
    // fb登录按钮
    fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLoginButton.frame = CGRectMake(x, guestLoginButton.frame.origin.y, 30, 30);
    [fbLoginButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"fbbutton"] forState:UIControlStateNormal];
    [fbLoginButton addTarget:self action:@selector(gotoFaceBookLogin:) forControlEvents:UIControlEventTouchUpInside];
    fbLoginButton.enabled = YES;
    fbLoginButton.hidden = YES;
    [linearLayout addSubview:fbLoginButton];
    
    // apple登录按钮
    appleLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    appleLoginButton.frame = CGRectMake(x, guestLoginButton.frame.origin.y, 30, 30);
    [appleLoginButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"applebutton"] forState:UIControlStateNormal];
    [appleLoginButton addTarget:self action:@selector(gotoAppleLogin:) forControlEvents:UIControlEventTouchUpInside];
    appleLoginButton.enabled = YES;
    appleLoginButton.hidden = YES;
    [linearLayout addSubview:appleLoginButton];
    
    [self setFourBtnStatus:bg andGuestBtn:[[oneSDKBranchPlayerConfig getInstance] getGuestBtnIsCanShow] andGoogleBtn:[[oneSDKBranchPlayerConfig getInstance] getGoogleBtnIsCanShow] andFacebookBtn:[[oneSDKBranchPlayerConfig getInstance] getFbBtnIsCanShow] andAppleBtn:[[oneSDKBranchPlayerConfig getInstance] getAppleBtnIsCanShow]];
    
    // 半透明背景
    UIView* autoLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    autoLoginView.backgroundColor = transparentColor;
    _autoLoginView = autoLoginView;
    autoLoginView.hidden = YES;
    [self.view addSubview:autoLoginView];
    
    // title
    UIImageView* title = [[UIImageView alloc] init];
    title.frame = CGRectMake(self.view.frame.size.width * 0.5 - 200, 0, 400, 40);
    title.contentMode = UIViewContentModeCenter;
    title.image = [oneSDKBranchUtils getImageFromBundle:@"auto_login_title_h"];
    [autoLoginView addSubview:title];
    
    // name
    UITextView* nickname = [[UITextView alloc] initWithFrame:CGRectMake(title.frame.size.width * 0.5 - 90, 0, 200, 30) textContainer:nil];
    nickname.userInteractionEnabled = NO;
    nickname.font = [UIFont systemFontOfSize:20];
    [nickname setBackgroundColor:[UIColor clearColor]];
    nickname.textColor = [UIColor blackColor];
    nickname.textAlignment = NSTextAlignmentCenter;
    NSString* localName = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_nickName"];
    if (localName.length > 0)
    {
        nickname.text = localName;
    }
    [title addSubview:nickname];
    
    // 关闭按钮
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(title.frame.size.width + title.frame.origin.x, title.frame.origin.y + 5, 30, 31);
    [closeBtn setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [autoLoginView addSubview:closeBtn];
    
    // 添加背景
    loadingLoginView = [[UIImageView alloc] init];
    loadingLoginView.userInteractionEnabled = YES;
    loadingLoginView.frame = CGRectMake(0, 0, 48, 48);
    loadingLoginView.contentMode = UIViewContentModeCenter;
    loadingLoginView.layer.position = self.view.center;
    loadingLoginView.image = [oneSDKBranchUtils getImageFromBundle:@"loading"];
    [autoLoginView addSubview:loadingLoginView];
    
    _displayLinkLoginView = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotateImage)];
    [_displayLinkLoginView addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _rotationLoginView = 0.0;
    
    // title文本
    UITextView* titleTextAuto = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 - 150, self.view.frame.size.height * 0.5 + 30, 300, 40) textContainer:nil];
    titleTextAuto.userInteractionEnabled = NO;
    titleTextAuto.font = [UIFont systemFontOfSize:25];
    [titleTextAuto setBackgroundColor:[UIColor clearColor]];
    titleTextAuto.textColor = [UIColor whiteColor];
    titleTextAuto.textAlignment = NSTextAlignmentCenter;
    
    NSString* loginType = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_logintype"];
    if ([loginType isEqual:@"1"])
    {
        titleTextAuto.text = @"Guest auto logining";
    }
    else if ([loginType isEqual:@"2"])
    {
        titleTextAuto.text = @"ID auto logining";
    }
    else if ([loginType isEqual:@"3"])
    {
        titleTextAuto.text = @"Google auto logining";
    }
    else if ([loginType isEqual:@"4"])
    {
        titleTextAuto.text = @"FaceBook auto logining";
    }
    [autoLoginView addSubview:titleTextAuto];
}

-(void)setViewState:(int)type
{
    // 登录
    if (type == 1)
    {
        oneSDKBranchLogUtils(@"显示登录界面");
        _loginView.hidden = NO;
        _autoLoginView.hidden = YES;
    }
    else if (type == 2)  // 自动登录
    {
        oneSDKBranchLogUtils(@"显示自动登录界面");
        _loginView.hidden = YES;
        _autoLoginView.hidden = NO;
        NSString* loginType = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_logintype"];
        if ([loginType isEqual:@"1"])
        {
            [self gotoAutoLogin];
        }
        else if ([loginType isEqual:@"2"])
        {
            [self gotoAutoLogin];
        }
        else if ([loginType isEqual:@"3"])
        {
            [self checkGoogleAuthorize];
        }
        else if ([loginType isEqual:@"4"])
        {
            [self checkFacebookAuthorize];
        }
        else if ([loginType isEqual:@"5"])
        {
            [self checkAppleAuthorize];
        }
    }
}

// 设置四个按钮状态
-(void)setFourBtnStatus:(UIImageView*)bg andGuestBtn:(bool)guestBtn andGoogleBtn:(bool)google andFacebookBtn:(bool)facebook andAppleBtn:(bool)apple
{
    if (apponeSDKBranchLoginView != NULL)
    {
        float y = linearLayout.frame.size.height * 0.5 - 15;
        
//        // 测试时打开
//        guestBtn = true;
//        google = true;
//        facebook = true;
//        apple = true;
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        
        if (guestBtn)
        {
            [array addObject:guestLoginButton];
        }
        if (google)
        {
            [array addObject:googleLoginButton];
        }
        if (facebook)
        {
            [array addObject:fbLoginButton];
        }
        if (apple)
        {
            [array addObject:appleLoginButton];
        }
        
        NSUInteger length = array.count;
        if (length <= 0 || length > 4)
        {
            return;
        }
        
        for (int i = 1; i <= length; i++)
        {
            UIButton* button = [array objectAtIndex:i - 1];
            button.hidden = NO;
            float x = linearLayout.frame.size.width / (length + 1) * i - 30 * 0.5;
            button.frame = CGRectMake(x, y, 30, 30);
        }
    }
}

-(void)closeBtn:(id)sender
{
    [always onSwitchAccountCallback:@""];
}

-(void)rotateImage
{
    // 每帧旋转10度
    _rotationLoginView += M_PI / 18.0;
    loadingLoginView.transform = CGAffineTransformMakeRotation(_rotationLoginView);
}

// 登录
-(void)doIDLogin:(UIButton*)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[oneSDKBranchPlayerConfig getInstance] getLoginFuncName].length == 0)
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    // 验证账号密码
    NSString* account = self.emailText.text;
    NSString* password = self.passwordText.text;
    if (![oneSDKBranchUtils verificatAccount:account] && ![oneSDKBranchUtils verificatPassword:password])
    {
        return;
    }
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:self.emailText.text forKey: @"account"];
    [mineJson setValue:self.passwordText.text forKey: @"password"];
    
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:mineJson];
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getLoginFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, loginButton newUrl is %@", mineTAGoneSDKBranchLoginView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, loginButton result is %@", mineTAGoneSDKBranchLoginView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        [always onLoginCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchLoginView, error);
    }];
}

// 忘记密码
-(void)doForgetPassword:(UITapGestureRecognizer*)gesture
{
    // 弹出忘记密码界面(忘记密码)
    oneSDKBranchForgetView* view = [[oneSDKBranchForgetView alloc] initViewWithType:1 NEmail:self.emailText.text];
    [self.view addSubview:view];
}

// 点击事件的响应方法
-(void)doCreateAccount:(UITapGestureRecognizer*)gesture
{
    // 弹出注册界面
    oneSDKBranchRegisterView* view = [[oneSDKBranchRegisterView alloc] initView];
    [self.view addSubview:view];
}

-(void)doGuestLogin:(id)sender
{
    // 提示界面
    oneSDKBranchTipsView* view = [[oneSDKBranchTipsView alloc] initViewWithType:1 andValue:@""];
    [self.view addSubview:view];
}

// 自动登录
-(void)gotoAutoLogin
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getAutologinFuncName] == nil)
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    NSString* access_token = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_token"];
    NSString* account = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_account"];
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:access_token forKey: @"access_token"];
    [mineJson setValue:account forKey: @"account"];
    
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:mineJson];
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getAutologinFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, gotoAutoLogin newUrl is %@", mineTAGoneSDKBranchLoginView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, gotoAutoLogin result is %@", mineTAGoneSDKBranchLoginView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        // 自动登录失败
        if (![code isEqual:@"200"])
        {
            [self setViewState:1];
        }
        [always onLoginCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchLoginView, error);
    }];
}

-(void)gotoGoogleLogin:(id)sender
{
    [self goGoogleLogin];
}

-(void)goGoogleLogin
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[[oneSDKBranchPlayerConfig getInstance] getGoogleLoginFuncName] isEqualToString:@""])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    oneSDKBranchLogUtils(@"%@, googleLoginDown is called", mineTAGoneSDKBranchLoginView);
    
//    // 已经登录过(退出游戏, 就不会进这个判断)
//    if ([GIDSignIn sharedInstance].currentUser != NULL)
//    {
//        GIDGoogleUser* user = [GIDSignIn sharedInstance].currentUser;
//        NSString* userId = user.userID;
//        NSString* idToken = user.authentication.idToken;
//        NSString* fullName = user.profile.name;
//        NSString* givenName = user.profile.givenName;
//        NSString* familyName = user.profile.familyName;
//        NSString* email = user.profile.email;
//
//        oneSDKBranchLogUtils(@"%@, auto already google login", mineTAGoneSDKBranchLoginView);
//        oneSDKBranchLogUtils(@"auto userId is %@, idToken is %@, fullName is %@, givenName is %@, familyName is %@, email is %@", userId, idToken, fullName, givenName, familyName, email);
//        [self handleGoogle:email UserId:userId Name:fullName Token:idToken];
//    }
//    else
//    {
        [self toGoogleLogin];
//    }
}

-(void)toGoogleLogin
{
    oneSDKBranchLogUtils(@"toGoogleLogin is called");
//    // google登录
//    [GIDSignIn sharedInstance].delegate = self;
//    // 必须设置 否则会Crash
//    [GIDSignIn sharedInstance].presentingViewController = self;
//    [GIDSignIn sharedInstance].clientID = [[oneSDKBranchPlayerConfig getInstance] getGoogleID];
//    [[GIDSignIn sharedInstance] signIn];
    
    
//    [GIDSignIn.sharedInstance handleURL:url];
    
    
    
//    - (void)handleGetURLEvent:(NSAppleEventDescriptor *)event
//               withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
//          NSString *URLString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
//          NSURL *URL = [NSURL URLWithString:URLString];
//          [GIDSignIn.sharedInstance handleURL:url];
//    }
    
    
    
    [GIDSignIn.sharedInstance
          signInWithPresentingViewController:self
                                  completion:^(GIDSignInResult * _Nullable signInResult,
                                               NSError * _Nullable error) {
        if (error) {
          return;
        }
        
        oneSDKBranchLogUtils(@"signInResult is %@", signInResult);

        // If sign in succeeded, display the app's main content View.
      }];
}

-(void)signIn:(GIDSignIn*)signIn presentViewController:(UIViewController*)viewController
{
    // 此处的rootViewControlle为当前显示的试图控制器
    [self presentViewController:viewController animated:YES completion:nil];
}
 
-(void)signIn:(GIDSignIn*)signIn dismissViewController:(UIViewController*)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

// 实现代理方法
-(void)signIn:(GIDSignIn*)signIn didSignInForUser:(GIDGoogleUser*)user withError:(NSError*)error
{
    /*
    // 没有出错
    if (!error)
    {
        NSString* userId = user.userID;
        NSString* idToken = user.authentication.idToken;
        NSString* fullName = user.profile.name;
        NSString* givenName = user.profile.givenName;
        NSString* familyName = user.profile.familyName;
        NSString* email = user.profile.email;

        oneSDKBranchLogUtils(@"%@, google login success", mineTAGoneSDKBranchLoginView);
        oneSDKBranchLogUtils(@"userId is %@, idToken is %@, fullName is %@, givenName is %@, familyName is %@, email is %@", userId, idToken, fullName, givenName, familyName, email);
        
        // 将ID保存到钥匙串
        if (email)
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_email" Value:email];
        }
        if (userId)
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_userId" Value:userId];
        }
        if (fullName)
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_fullname" Value:fullName];
        }
        if (idToken)
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_token" Value:idToken];
        }
        
        [self handleGoogle:email UserId:userId Name:fullName Token:idToken];
    }
    else  // google登录出错
    {
        oneSDKBranchLogUtils(@"%@, google login error is %@", mineTAGoneSDKBranchLoginView, error.debugDescription);
    }
     */
}

-(void)checkGoogleAuthorize
{
    NSString* email = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_google_email"];
    NSString* userId = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_google_userId"];
    NSString* fullName = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_google_fullname"];
    NSString* idToken = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_google_token"];
    
    if (email.length > 0 && userId.length > 0 && fullName.length > 0 && idToken.length > 0)
    {
        [self handleGoogle:email UserId:userId Name:fullName Token:idToken];
    }
    else
    {
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_email" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_userId" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_fullname" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_google_token" Value:@""];
        [self setViewState:1];
    }
}

-(void)handleGoogle:(NSString*)email UserId:(NSString*)userId Name:(NSString*)name Token:(NSString*)token
{
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:email forKey: @"email"];
    [mineJson setValue:userId forKey: @"id"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:name] forKey: @"name"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:token] forKey: @"token"];
    [always setEmpowerLoginData:email andId:userId andName:[oneSDKBranchUtils base64Encode:name] andToken:[oneSDKBranchUtils base64Encode:token]];
    
    [self tellToHttpAboutGoogle:mineJson];
}

-(void)tellToHttpAboutGoogle:(NSMutableDictionary*)mineJson
{
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutGoogle newSign_str is %@", mineTAGoneSDKBranchLoginView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutGoogle str is %@", mineTAGoneSDKBranchLoginView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutGoogle newSign is %@", mineTAGoneSDKBranchLoginView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getGoogleLoginFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutGoogle newUrl is %@", mineTAGoneSDKBranchLoginView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, tellToHttpAboutGoogle result is %@", mineTAGoneSDKBranchLoginView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        // 自动登录失败
        if (![code isEqual:@"200"])
        {
            [self setViewState:1];
        }
        
        // 通知客户端登录结果
        [always onLoginCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchLoginView, error);
    }];
}

// google登出接口
+(void)googleLogout
{
    if ([[GIDSignIn sharedInstance] currentUser] != NULL)
    {
        // google登出接口
        [[GIDSignIn sharedInstance] signOut];
    }
}

-(void)gotoFaceBookLogin:(id)sender
{
    [self goFacebookLogin];
}

-(void)goFacebookLogin
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[[oneSDKBranchPlayerConfig getInstance] getFacebookLoginFuncName] isEqualToString:@""])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    oneSDKBranchLogUtils(@"%@, fbLoginDown is called", mineTAGoneSDKBranchLoginView);
    
//    // 已经登录过
//    if ([FBSDKAccessToken currentAccessToken] != nil)
//    {
//        NSString* userId = [FBSDKAccessToken currentAccessToken].userID;
//        NSString* token = [FBSDKAccessToken currentAccessToken].tokenString;
////        NSString* userId1 = [FBSDKAccessToken currentAccessToken].email;
//        NSString* appId = [FBSDKAccessToken currentAccessToken].appID;
//        oneSDKBranchLogUtils(@"%@, facebook userId is %@, token is %@, appId is %@", mineTAGoneSDKBranchLoginView, userId, token, appId);
//
//        [self handleFacebook:@"1" UserId:userId Name:@"1" Token:token];
//    }
//    else
//    {
        [self toFacebookLogin];
//    }
}

-(void)toFacebookLogin
{
    FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
    NSArray* permissionArray = @[@"public_profile", @"email"];
    [login logInWithPermissions:permissionArray fromViewController:self handler:^(FBSDKLoginManagerLoginResult* result, NSError* error)
    {
        if(error)
        {
            NSString* str = @"";
            NSString* first = [oneSDKBranchUtils getDataFromBundleJson:@"facebookloginfailed"];
            str = [str stringByAppendingFormat:@"%@ : error is %@", first, [error localizedDescription]];
            // 给用户一个提示
            [oneSDKBranchToastUtils show:str duration:2.0f];
            oneSDKBranchLogUtils(@"facebool login failed : %@", [error localizedDescription]);
        }
        else if (result.isCancelled)
        {
            oneSDKBranchLogUtils(@"facebool login canceled");
        }
        else
        {
            NSString* userId = [FBSDKAccessToken currentAccessToken].userID;
            NSString* token = [FBSDKAccessToken currentAccessToken].tokenString;
            NSString* appId = [FBSDKAccessToken currentAccessToken].appID;
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_email" Value:@"1"];
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_userId" Value:userId];
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_fullname" Value:@"1"];
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_token" Value:token];
            [self handleFacebook:@"1" UserId:userId Name:@"1" Token:token];
            oneSDKBranchLogUtils(@"%@, facebook userId is %@, token is %@, appId is %@", mineTAGoneSDKBranchLoginView, userId, token, appId);
        }
    }];
}

-(void)checkFacebookAuthorize
{
    NSString* email = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_facebook_email"];
    NSString* userId = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_facebook_userId"];
    NSString* fullName = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_facebook_fullname"];
    NSString* idToken = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_facebook_token"];
    
    if (email.length > 0 && userId.length > 0 && fullName.length > 0 && idToken.length > 0)
    {
        [self handleFacebook:email UserId:userId Name:fullName Token:idToken];
    }
    else
    {
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_email" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_userId" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_fullname" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_facebook_token" Value:@""];
        [self setViewState:1];
    }
}

-(void)handleFacebook:(NSString*)email UserId:(NSString*)userId Name:(NSString*)name Token:(NSString*)token
{
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:email forKey: @"email"];
    [mineJson setValue:userId forKey: @"id"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:name] forKey: @"name"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:token] forKey: @"token"];
    [always setEmpowerLoginData:email andId:userId andName:[oneSDKBranchUtils base64Encode:name] andToken:[oneSDKBranchUtils base64Encode:token]];
    [self tellToHttpAboutFacebook:mineJson];
}

-(void)tellToHttpAboutFacebook:(NSMutableDictionary*)mineJson
{
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutFacebook newSign_str is %@", mineTAGoneSDKBranchLoginView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutFacebook str is %@", mineTAGoneSDKBranchLoginView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutFacebook newSign is %@", mineTAGoneSDKBranchLoginView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getFacebookLoginFuncName];
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutFacebook newUrl is %@", mineTAGoneSDKBranchLoginView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, tellToHttpAboutFacebook result is %@", mineTAGoneSDKBranchLoginView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        // 自动登录失败
        if (![code isEqual:@"200"])
        {
            [self setViewState:1];
        }
        
        // 通知客户端登录结果
        [always onLoginCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchLoginView, error);
    }];
}

// facebook登出接口
+(void)facebookLogout
{
    // facebook登出接口
    FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
    if (login && [FBSDKAccessToken currentAccessToken] != nil)
    {
        [login logOut];
    }
}

-(void)gotoAppleLogin:(id)sender
{
    [self goAppleLogin];
}

-(void)goAppleLogin
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[[oneSDKBranchPlayerConfig getInstance] getAppleLoginFuncName] isEqualToString:@""])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    if (@available(iOS 13.0, *))
    {
        // 基于用户的Apple ID授权用户, 生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider* appleIDProvider = [ASAuthorizationAppleIDProvider new];
        // 创建新的AppleID授权请求
        ASAuthorizationAppleIDRequest* request = appleIDProvider.createRequest;
        // 在用户授权期间请求的联系信息
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求, 管理授权请求的控制器
        ASAuthorizationController* controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        controller.delegate = self;
        // 设置提供展示上下文的代理, 在这个上下文中系统可以展示授权界面给用户
        controller.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [controller performRequests];
    }
    else
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nosupport"] duration:2.0f];
    }
}

-(void)perfomExistingAccountSetupFlows
{
    if (@available(iOS 13.0, *))
    {
        // 基于用户的Apple ID授权用户, 生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider* appleIDProvider = [ASAuthorizationAppleIDProvider new];
        // 授权请求依赖于用于的AppleID
        ASAuthorizationAppleIDRequest* authAppleIDRequest = [appleIDProvider createRequest];
        // 为了执行钥匙串凭证分享生成请求的一种机制
        ASAuthorizationPasswordRequest* passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];
        
        NSMutableArray <ASAuthorizationRequest*>* mArr = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest)
        {
            [mArr addObject:authAppleIDRequest];
        }
        if (passwordRequest)
        {
            [mArr addObject:passwordRequest];
        }
        // ASAuthorizationRequest:对于不同种类授权请求的基类
        NSArray <ASAuthorizationRequest*>* requests = [mArr copy];
        // ASAuthorizationController是由ASAuthorizationAppleIDProvider创建的授权请求, 管理授权请求的控制器
        ASAuthorizationController* authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供展示上下文的代理, 在这个上下文中系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

// apple登录授权成功地回调
-(void)authorizationController:(ASAuthorizationController*)controller didCompleteWithAuthorization:(ASAuthorization*)authorization API_AVAILABLE(ios(13.0))
{
    oneSDKBranchLogUtils(@"%@, authorizationController %s", mineTAGoneSDKBranchLoginView, __FUNCTION__);
    oneSDKBranchLogUtils(@"%@, authorizationController is %@", mineTAGoneSDKBranchLoginView, controller);
    oneSDKBranchLogUtils(@"%@, authorizationController is %@", mineTAGoneSDKBranchLoginView, authorization);
    oneSDKBranchLogUtils(@"%@, authorization.credential：%@", mineTAGoneSDKBranchLoginView, authorization.credential);
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])
    {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential* appleIDCredential = authorization.credential;
        NSString* user = appleIDCredential.user;
        NSString* givenName = appleIDCredential.fullName.givenName ? appleIDCredential.fullName.givenName : @"1";
        NSString* email = appleIDCredential.email ? appleIDCredential.email : @"1";
        NSString* token = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding];
//        NSString* authorizationCode = [[NSString alloc] initWithData:appleIDCredential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
//        NSString* identityToken = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding]; // access token
        oneSDKBranchLogUtils(@"%@, appleLoginSuccess user is %@", mineTAGoneSDKBranchLoginView, user);
        oneSDKBranchLogUtils(@"%@, appleLoginSuccess givenName is %@", mineTAGoneSDKBranchLoginView, givenName);
        oneSDKBranchLogUtils(@"%@, appleLoginSuccess email is %@", mineTAGoneSDKBranchLoginView, email);
        oneSDKBranchLogUtils(@"%@, appleLoginSuccess token is %@", mineTAGoneSDKBranchLoginView, token);
        [self handleApple:user GivenName:givenName Email:email Token:token];
        
        // 将ID保存到钥匙串
        if (user)
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:user];
        }
        if (token)
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:token];
        }
    }
    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]])  // 只有储存到本地之后, 才会走这个判断(此处暂不做处理)
    {
        NSMutableString* mutableString = [NSMutableString string];
        // 用户登录使用现有的密码凭证
        ASPasswordCredential* passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString* user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString* password = passwordCredential.password;
        [mutableString appendString:user?:@""];
        [mutableString appendString:password?:@""];
        [mutableString appendString:@"\n"];
        oneSDKBranchLogUtils(@"%@, mStr：%@", mineTAGoneSDKBranchLoginView, mutableString);
    }
    else
    {
        oneSDKBranchLogUtils(@"%@, 授权信息均不符", mineTAGoneSDKBranchLoginView);
    }
}

// apple登录授权失败的回调
-(void)authorizationController:(ASAuthorizationController*)controller didCompleteWithError:(NSError*)error  API_AVAILABLE(ios(13.0))
{
    oneSDKBranchLogUtils(@"%@, authorizationController is %s", mineTAGoneSDKBranchLoginView, __FUNCTION__);
    oneSDKBranchLogUtils(@"%@, 错误信息：%@", mineTAGoneSDKBranchLoginView, error);
    NSString* errorMsg = nil;
    switch (error.code)
    {
        case ASAuthorizationErrorCanceled:
            errorMsg = [oneSDKBranchUtils getDataFromBundleJson:@"shouquanchexiao"];
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = [oneSDKBranchUtils getDataFromBundleJson:@"shouquanfailed"];
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = [oneSDKBranchUtils getDataFromBundleJson:@"shouquanxiangyingwuxiao"];
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = [oneSDKBranchUtils getDataFromBundleJson:@"weinengchulishouquanqingqiu"];
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = [oneSDKBranchUtils getDataFromBundleJson:@"weizhishibaiyuanyin"];
            break;
    }
    
    if (errorMsg)
    {
        // 提示一下
        [oneSDKBranchToastUtils show:errorMsg duration:2.0f];
        return;
    }
    if (error.localizedDescription)
    {
        
    }
    oneSDKBranchLogUtils(@"%@, controller requests：%@", mineTAGoneSDKBranchLoginView, controller.authorizationRequests);
}

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController*)controller API_AVAILABLE(ios(13.0))
{
    return self.view.window;
}

-(void)checkAppleAuthorize
{
    if (@available(iOS 13.0, *))
    {
        NSString* userId = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_apple_userId"];
        NSString* token = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_apple_usertoken"];
        
        if (userId.length > 0 && token.length > 0)
        {
            ASAuthorizationAppleIDProvider* provider = [ASAuthorizationAppleIDProvider new];
            [provider getCredentialStateForUserID:userId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError* _Nullable error)
             {
                switch (credentialState)
                {
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    {
                        oneSDKBranchLogUtils(@"has authorized");
                        NSString* givenName = @"1";
                        NSString* email = @"1";
                        [self handleApple:userId GivenName:givenName Email:email Token:token];
                    }
                        break;
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                    {
                        [self setViewState:1];
                        [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:@""];
                        [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:@""];
                    }
                        break;
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                    {
                        [self setViewState:1];
                        [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:@""];
                        [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:@""];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
        else
        {
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:@""];
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:@""];
            [self setViewState:1];
        }
    }
    else
    {
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_userId" Value:@""];
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_apple_usertoken" Value:@""];
        [self setViewState:1];
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noappleautologin"] duration:2.0f];
    }
}

// 如果app在运行中, 我们可以通过添加通知的方法来实时监控用户是否取消了授权
-(void)observeAppleSignInState
{
    if (@available(iOS 13.0, *))
    {
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

// 观察SignInWithApple状态改变
-(void)handleSignInWithAppleStateChanged:(NSNotification*)noti
{
    oneSDKBranchLogUtils(@"%@, handleSignInWithAppleStateChanged is %@", mineTAGoneSDKBranchLoginView, noti.name);
    oneSDKBranchLogUtils(@"%@, handleSignInWithAppleStateChanged is %@", mineTAGoneSDKBranchLoginView, noti.userInfo);
}

-(void)handleApple:(NSString*)user GivenName:(NSString*)givenName Email:(NSString*)email Token:(NSString*)token
{
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:user forKey: @"id"];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:givenName] forKey: @"name"];
    [mineJson setValue:email forKey: @"email"];
    [always setEmpowerLoginData:email andId:user andName:[oneSDKBranchUtils base64Encode:givenName] andToken:[oneSDKBranchUtils base64Encode:token]];
    
    // 储存token
    [[oneSDKBranchPlayerConfig getInstance] setAppleLoginToken:token];
    [mineJson setValue:[oneSDKBranchUtils base64Encode:token] forKey: @"token"];
    [self tellToHttpAboutApple:mineJson];
}

-(void)tellToHttpAboutApple:(NSMutableDictionary*)mineJson
{
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutApple newSign_str is %@", mineTAGoneSDKBranchLoginView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutApple newSign is %@", mineTAGoneSDKBranchLoginView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getAppleLoginFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, tellToHttpAboutApple newUrl is %@", mineTAGoneSDKBranchLoginView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, tellToHttpAboutApple result is %@", mineTAGoneSDKBranchLoginView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        // 自动登录失败
        if (![code isEqual:@"200"])
        {
            [self setViewState:1];
        }
        
        // 通知客户端登录结果
        [always onLoginCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchLoginView, error);
    }];
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

// 获取本类信息
+(oneSDKBranchLoginView*)getApp
{
    return apponeSDKBranchLoginView;
}

// 删除自身
+(void)removeSelf
{
    if (_displayLinkLoginView != NULL)
    {
        [_displayLinkLoginView invalidate];
        _displayLinkLoginView = NULL;
    }
    apponeSDKBranchLoginView = NULL;
}

// 点击屏幕空白处什么都不做(屏蔽触摸)
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

@end
