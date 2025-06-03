//
//  oneSDKBranchForgetView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchForgetView.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../info/oneSDKBranchUserInfoView.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../utils/oneSDKBranchToastUtils.h"

// mineTAG
NSString* mineTAGoneSDKBranchForgetView;

@implementation oneSDKBranchForgetView

// app
static oneSDKBranchForgetView* apponeSDKBranchForgetView = NULL;
// 获取验证码按钮
UIButton* getCode;
static int countDown = 30;
// 是否开启了定时器
static bool isRunHandle = NO;
// 定时器对象
NSTimer* timer;

-(instancetype)initViewWithType:(int)index NEmail:(NSString*)nEmail;
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
        
        // 修改密码还是忘记密码(1忘记, 2修改, 3绑定)
        self.index = index;
        self.nEmail = nEmail;
        mineTAGoneSDKBranchForgetView = @"oneSDKBranchForgetView";
        apponeSDKBranchForgetView = self;
        
        // 添加背景
        UIImageView* bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 364, 329);
        bg.contentMode = UIViewContentModeCenter;
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"forget_bg_h"];
        [self addSubview:bg];
        
        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 90, 0, 200, 40) textContainer:nil];
        titleText.userInteractionEnabled = NO;
        titleText.font = [UIFont systemFontOfSize:25];
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor blackColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"Forget Password";
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
        titleText.attributedText = attributedString;
        [bg addSubview:titleText];
        
        if (self.index == 1)  // 忘记密码
        {
            titleText.text = @"Forget Password";
        }
        else if (self.index == 2)  // 修改密码
        {
            titleText.text = @"Modify";
            titleText.frame = CGRectMake(bg.frame.size.width * 0.5 - 90, 0, 200, 40);
        }
        else if (self.index == 3)  // 绑定
        {
            titleText.text = @"Bind";
            titleText.frame = CGRectMake(bg.frame.size.width * 0.5 - 90, 0, 200, 40);
        }
        [bg addSubview:titleText];
        
        // account
        UITextField* account = [[UITextField alloc]initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 150, titleText.frame.size.height + 20, 300, 35)];
        account.placeholder = @"Enter Email";
        account.keyboardType = UIKeyboardTypeEmailAddress;
        account.borderStyle = UITextBorderStyleRoundedRect;
        account.layer.borderColor = [UIColor lightGrayColor].CGColor;
        account.layer.borderWidth = 1;
        account.layer.cornerRadius = 6;
        account.returnKeyType = UIReturnKeyDone;
        account.delegate = self;
        account.text = nEmail;
        self.account = account;
        if (self.index == 2)  // 修改密码
        {
            account.text = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_access_account"];
        }
        else if (self.index == 3)  // 绑定
        {
            account.text = [oneSDKBranchUtils permanentLoad:@"onesdkbranch_temporary_email"];
        }
        [bg addSubview:account];
        
        // code
        UITextField* code = [[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x, account.frame.origin.y + 60, 180, 35)];
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
        getCode = [UIButton buttonWithType:UIButtonTypeCustom];
        getCode.frame = CGRectMake(code.frame.size.width + code.frame.origin.x + 10, code.frame.origin.y - 4, 105, 40);
        [getCode setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
        [getCode addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [getCode setTitle:@"Get Code" forState:UIControlStateNormal];
        getCode.titleLabel.font = [UIFont systemFontOfSize:18];
        getCode.titleLabel.textAlignment = NSTextAlignmentCenter;
        [getCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bg addSubview:getCode];
        
        // 如果开启了定时器
        if (countDown > 0 && isRunHandle)
        {
            NSString* str = @"";
            NSString* stringInt = [NSString stringWithFormat:@"%d", countDown];
            str = [str stringByAppendingFormat:@"%@S", stringInt];
            [getCode setEnabled:NO];
        }
        
        // password
        UITextField* password = [[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x, getCode.frame.origin.y + 60, 300, 35)];
        password.placeholder = @"Enter Password(6-20 Characters)";
        password.secureTextEntry = YES;
        password.borderStyle = UITextBorderStyleRoundedRect;
        password.layer.borderColor = [UIColor lightGrayColor].CGColor;
        password.layer.borderWidth = 1;
        password.layer.cornerRadius = 6;
        password.returnKeyType = UIReturnKeyDone;
        password.delegate = self;
        self.password = password;
        [bg addSubview:password];
        
        // 确认按钮
        UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(bg.frame.size.width * 0.5 - 285 * 0.5, password.frame.origin.y + 80, 285, 34);
        [confirmButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"login_submit_btn"] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButton:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)getCodeBtn:(id)sender
{
    if (![self selfConfirm])
    {
        return;
    }
    
    // 验证账号
    if (![oneSDKBranchUtils verificatAccount:self.account.text])
    {
        return;
    }
    
    if (self.index == 1 || self.index == 3)
    {
        [oneSDKBranchUtils permanentSave:@"onesdkbranch_temporary_email" Value:self.account.text];
    }
    
    [self doGetVerificationCode:self.account.text];
}

// 账号
-(void)doGetVerificationCode:(NSString*)account
{
    isRunHandle = YES;
    // 开启一个定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(MyCountDownTimer:) userInfo:nil repeats:YES];
    // 按钮设置为不可点
    [getCode setEnabled:NO];
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:account forKey: @"account"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode newSign_str is %@", mineTAGoneSDKBranchForgetView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode str is %@", mineTAGoneSDKBranchForgetView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode newSign is %@", mineTAGoneSDKBranchForgetView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = @"";
    if (self.index == 1)
    {
        url = [[oneSDKBranchPlayerConfig getInstance] getForgetPasswordFuncName];
    }
    else if (self.index == 2)
    {
        url = [[oneSDKBranchPlayerConfig getInstance] getModifyPasswordFuncName];
    }
    else if (self.index == 3)
    {
        url = [[oneSDKBranchPlayerConfig getInstance] getBindFuncName];
    }
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doGetVerificationCode newUrl is %@", mineTAGoneSDKBranchForgetView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doGetVerificationCode result is %@", mineTAGoneSDKBranchForgetView, object);
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        [oneSDKBranchToastUtils show:msg duration:2.0f];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchForgetView, error);
    }];
}

-(void)confirmButton:(id)sender
{
    if (![self selfConfirm])
    {
        return;
    }
    
    // 验证账号
    if (![oneSDKBranchUtils verificatAccount:self.account.text])
    {
        return;
    }
    
    // 验证码
    if (![oneSDKBranchUtils verificatCode:self.code.text])
    {
        return;
    }
    
    // 验证密码
    if (![oneSDKBranchUtils verificatPassword:self.password.text])
    {
        return;
    }
    
    [self doOkForget:self.account.text Code:self.code.text Password:self.password.text];
}

-(void)doOkForget:(NSString*)account Code:(NSString*)verificationCode Password:(NSString*)passwordText
{
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:account forKey: @"account"];
    [mineJson setValue:passwordText forKey: @"password"];
    [mineJson setValue:verificationCode forKey: @"code"];
    
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, doOkForget newSign_str is %@", mineTAGoneSDKBranchForgetView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@, doOkForget str is %@", mineTAGoneSDKBranchForgetView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, doOkForget newSign is %@", mineTAGoneSDKBranchForgetView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = @"";
    if (self.index == 1)
    {
        url = [[oneSDKBranchPlayerConfig getInstance] getSubmitForgetPasswordFuncName];
    }
    else if (self.index == 2)
    {
        url = [[oneSDKBranchPlayerConfig getInstance] getSubmitModifyPasswordFuncName];
    }
    else if (self.index == 3)
    {
        url = [[oneSDKBranchPlayerConfig getInstance] getSubmitBindFuncName];
    }
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doOkForget newUrl is %@", mineTAGoneSDKBranchForgetView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doOkForget result is %@", mineTAGoneSDKBranchForgetView, object);
        
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];

        if ([[oneSDKBranchUtils toNSString:code] isEqualToString:@"200"])
        {
            NSString* account = [oneSDKBranchUtils isContains:object andKey:@"account"];
            
            if (self.index == 1)
            {
                [oneSDKBranchUtils permanentSave:@"onesdkbranch_temporary_email" Value:@""];
            }
            else if (self.index == 3)
            {
                [[oneSDKBranchPlayerConfig getInstance] setLoginType:@"2"];
                [oneSDKBranchUtils permanentSave:@"onesdkbranch_temporary_email" Value:@""];
                [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_token" Value:@""];
                [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_account" Value:[[oneSDKBranchPlayerConfig getInstance] getAccount]];
            }
            
            isRunHandle = NO;
            countDown = 30;
            
            // 赋值个人邮箱号
            [[oneSDKBranchPlayerConfig getInstance] setAccount:account];
            
            // 暂停定时器
            [timer invalidate];
            
            // 关闭本界面
            [self removeFromSuperview];
            // 如果个人信息界面存在, 则关闭
            if ([oneSDKBranchUserInfoView getApp] != NULL)
            {
                [[oneSDKBranchUserInfoView getApp] removeFromSuperview];
                [oneSDKBranchUserInfoView removeSelf];
            }
            
            apponeSDKBranchForgetView = NULL;
        }
        [oneSDKBranchToastUtils show:msg duration:2.0f];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchForgetView, error);
    }];
}

// 关闭本界面
-(void)closeBtn:(id)sender
{
    apponeSDKBranchForgetView = NULL;
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
    [self.code resignFirstResponder];
    [self.password resignFirstResponder];
}

-(BOOL)selfConfirm
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return NO;
    }
    
    // 如果是修改密码
    if (self.index == 2)
    {
        // 如果账号不匹配
        if ([[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getLoginFuncName]] isEqualToString:self.account.text])
        {
            // 提示一下用户
            [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noagreementaccount"] duration:2.0f];
            return NO;
        }
    }
    
    // 如果没有获取到值, 或者没获取到唯一码
    if ([[oneSDKBranchPlayerConfig getInstance] getForgetPasswordFuncName]  == nil || [[oneSDKBranchPlayerConfig getInstance] getModifyPasswordFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getBindFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getSubmitForgetPasswordFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getSubmitModifyPasswordFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getSubmitBindFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getMacAddress] == nil || [[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getMacAddress]] isEqualToString:@""])
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return NO;
    }
    
    return YES;
}

// 获取本类信息
+(oneSDKBranchForgetView*)getApp
{
    return apponeSDKBranchForgetView;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchForgetView = NULL;
}

-(void)MyCountDownTimer:(id)sender
{
    countDown--;
    NSString* str = @"";
    NSString* stringInt = [NSString stringWithFormat:@"%d", countDown];
    str = [str stringByAppendingFormat:@"%@S", stringInt];
    [getCode setTitle:str forState:UIControlStateNormal];
    if (countDown <= 0)
    {
        isRunHandle = NO;
        [getCode setTitle:@"Get Code" forState:UIControlStateNormal];
        countDown = 30;
        [getCode setEnabled:YES];
        // 暂停定时器
        [timer invalidate];
    }
}

@end
