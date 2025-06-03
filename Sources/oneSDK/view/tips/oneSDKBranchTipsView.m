//
//  oneSDKBranchTipsView.m
//  oneSDK
//
//  Created by 天下 on 2022/5/30.
//

#import "./oneSDKBranchTipsView.h"
#import "./../../utils/oneSDKBranchUtils.h"
#import "./../../utils/oneSDKBranchLogUtils.h"
#import "./../../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./../../http/oneSDKBranchHttpManager.h"
#import "./../../oneSDK/oneSDKBranch.h"
#import "./../../utils/oneSDKBranchToastUtils.h"
#import "./../oneSDKBranchBaseActivity.h"
#import "./../../always/always.h"

// mineTAG
NSString* mineTAGoneSDKBranchTipsView;

// 倒计时时间
int countDown;
// 定时器对象
NSTimer* eTimer;
// 删除按钮
UIButton* confirmButton;

@implementation oneSDKBranchTipsView
// app
static oneSDKBranchTipsView* apponeSDKBranchTipsView = NULL;

-(instancetype)initViewWithType:(int)index andValue:(NSString*)value
{
    if (self == [super init])
    {
        _type = index;
        _value = value;
        
        UIWindow* rootWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [rootWindow addSubview:self];
        self.layer.position = self.center;
        self.transform = CGAffineTransformMakeScale(0.90, 0.90);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished){}];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        mineTAGoneSDKBranchTipsView = @"oneSDKBranchTipsView";
        apponeSDKBranchTipsView = self;
        
        // 添加背景
        UIImageView* bg = [[UIImageView alloc] init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 500, 329);
        bg.contentMode = UIViewContentModeCenter;
        bg.layer.position = self.center;
        bg.image = [oneSDKBranchUtils getImageFromBundle:@"info_bg_h"];
        [self addSubview:bg];
        
        // title文本
        UITextView* titleText = [[UITextView alloc] initWithFrame:CGRectMake(bg.frame.size.width * 0.5 - 50, 0, 200, 40) textContainer:nil];
        titleText.userInteractionEnabled = NO;
        titleText.font = [UIFont systemFontOfSize:25];
        [titleText setBackgroundColor:[UIColor clearColor]];
        titleText.textColor = [UIColor blackColor];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = @"Reminder";
        // 创建NSAttributedString
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:titleText.text];
        // 设置加粗属性
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleText.font.pointSize] range:NSMakeRange(0, titleText.text.length)];
        // 应用属性到UITextView
        titleText.attributedText = attributedString;
        [bg addSubview:titleText];
        
        // Confirm按钮
        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(bg.frame.size.width * 0.5 - 105 * 0.5, bg.frame.size.height - 50, 105, 34);
        [confirmButton setBackgroundImage:[oneSDKBranchUtils getImageFromBundle:@"button"] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:12];
        confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bg addSubview:confirmButton];
        
        UILabel* label = [[UILabel alloc] init];
        if (index == 1)  // 游客登录
        {
            label.frame = CGRectMake(bg.frame.size.width * 0.5 - 320 * 0.5, bg.frame.size.height * 0.25, 400, 600);
            label.text = @"In order to keep your account secured\nfrom any losses, it is recommended\nthat you bind your Guest ID";
            label.font = [UIFont systemFontOfSize:25];
        }
        else if (index == 2)  // 删除账号
        {
            label.frame = CGRectMake(bg.frame.size.width * 0.5 - 320 * 0.5, bg.frame.size.height * 0.15, 400, 600);
            label.text = @"Once you begin this process, this\naccount will no longer be\naccessible and the deletion\ncannot be reversed.\n\nImportant: You cannot undo this\naction. Account will be deleted\npermanently.";
            label.font = [UIFont systemFontOfSize:20];
            
            // 设置倒计时时间
            countDown = 15;
            eTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(MyCountDownTimer:) userInfo:nil repeats:YES];
            // 按钮设置为不可点
            [confirmButton setEnabled:NO];
            
            NSString* str = @"";
            NSString* stringInt = [NSString stringWithFormat:@"%d", countDown];
            str = [str stringByAppendingFormat:@"Delete(%@S)", stringInt];
            // 设置显示文本
            [confirmButton setTitle:str forState:UIControlStateNormal];
        }
        else if (index == 3)  // 修改昵称
        {
            label.frame = CGRectMake(bg.frame.size.width * 0.5 - 320 * 0.5, bg.frame.size.height * 0.4, 400, 600);
            label.text = [@"Are you sure you want to change\nthe nickname to " stringByAppendingString:value];
            label.font = [UIFont systemFontOfSize:25];
        }
        [label setBackgroundColor:[UIColor clearColor]];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 10;
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

-(void)confirmButtonClick:(id)sender
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }

    if (_type == 1)  // 游客登录
    {
        [self doGuestLogin];
    }
    else if (_type == 2)  // 删除账号
    {
        [self doDeleteAccount];
    }
    else if (_type == 3)  // 修改昵称
    {
        [self doModifyNickName];
    }
}

// 游客登录
-(void)doGuestLogin
{
    // 如果没有获取到值, 或者没获取到唯一码
    oneSDKBranchLogUtils(@"%@, getGuestFuncName : %@, getMacAddress is %@", mineTAGoneSDKBranchTipsView, [[oneSDKBranchPlayerConfig getInstance] getGuestFuncName], [[oneSDKBranchPlayerConfig getInstance] getMacAddress]);
    
    if ([[oneSDKBranchPlayerConfig getInstance] getGuestFuncName] == nil || [[oneSDKBranchPlayerConfig getInstance] getMacAddress] == nil || [[oneSDKBranchUtils toNSString:[[oneSDKBranchPlayerConfig getInstance] getMacAddress]] isEqualToString:@""])
    {
        // 给用户一个提示
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:0];
    NSString* dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    oneSDKBranchLogUtils(@"%@, doGuestLogin dataStr is %@", mineTAGoneSDKBranchTipsView, dataStr);
    NSString* newSign_str = [oneSDKBranchUtils getJsonSort:mineJson];
    oneSDKBranchLogUtils(@"%@, doGuestLogin newSign_str is %@", mineTAGoneSDKBranchTipsView, newSign_str);
    NSString* str = @"";
    str = [str stringByAppendingFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], newSign_str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];
    oneSDKBranchLogUtils(@"%@, doGuestLogin str is %@", mineTAGoneSDKBranchTipsView, str);
    NSString* newSign = @"";
    newSign = [oneSDKBranchUtils getSHA256:str];
    oneSDKBranchLogUtils(@"%@, doGuestLogin newSign is %@", mineTAGoneSDKBranchTipsView, newSign);
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    // 拼接url
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getGuestFuncName];
    
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doGuestLogin newUrl is %@", mineTAGoneSDKBranchTipsView, newUrl);
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doGuestLogin result is %@", mineTAGoneSDKBranchTipsView, object);
        
        // 通知客户端登录结果
        [always onLoginCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchTipsView, error);
    }];
}

// 删除账号
-(void)doDeleteAccount
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getClearAccountFuncName] == nil)
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getLoginType] forKey: @"loginType"];
    [mineJson setValue:@"1" forKey: @"token"];
    
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:mineJson];
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getClearAccountFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doDeleteAccount newUrl is %@", mineTAGoneSDKBranchTipsView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doDeleteAccount result is %@", mineTAGoneSDKBranchTipsView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        [always onDeleteAccountCallback:object];
    }
    FailBlock: ^(NSError *error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchTipsView, error);
    }];
}

// 修改昵称
-(void)doModifyNickName
{
    // 没有连接网络
    if (![oneSDKBranchUtils isConnectNetwork])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonetwork"] duration:2.0f];
        return;
    }
    
    // 没获取到值
    if ([[oneSDKBranchPlayerConfig getInstance] getModifyNickNameFuncName] == nil)
    {
        // 提示一下用户
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"interfaceNameFailed"] duration:2.0f];
        // 再次请求
        [oneSDKBranchBaseActivity doSDKInterfaceInfo];
        return;
    }
    
    NSMutableDictionary* mineJson = [oneSDKBranchBaseActivity getBaseJson];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getUid] forKey: @"user_id"];
    [mineJson setValue:[oneSDKBranchUtils urlDecode:self.value] forKey: @"nickname"];
    
    NSString* newSign = [oneSDKBranchUtils sortAndSHA256:mineJson];
    [mineJson setValue:newSign forKey: @"SIGN"];
    [mineJson setValue:[[oneSDKBranchPlayerConfig getInstance] getVersion] forKey: @"version"];
    
    // json转NSString*
    NSData* upJsonData = [NSJSONSerialization dataWithJSONObject:mineJson options:0 error:nil];
    NSString* upStr = [[NSString alloc] initWithData:upJsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* upJson = [NSMutableDictionary dictionary];
    [upJson setValue:[oneSDKBranchUtils encryptByPublicKey:upStr] forKey: @"data"];
    
    NSString* url = [[oneSDKBranchPlayerConfig getInstance] getModifyNickNameFuncName];
    NSString* newUrl = @"";
    newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    oneSDKBranchLogUtils(@"%@, doModifyNickName newUrl is %@", mineTAGoneSDKBranchTipsView, newUrl);
    // 发送请求
    [[oneSDKBranchHttpManager getInstance] post:newUrl Params:upJson successBlock: ^(id object, NSURLResponse* response)
    {
        oneSDKBranchLogUtils(@"%@, doModifyNickName result is %@", mineTAGoneSDKBranchTipsView, object);
        
        NSString* msg = [oneSDKBranchUtils isContains:object andKey:@"msg"];
        NSString* code = [oneSDKBranchUtils isContains:object andKey:@"code"];
        if ([code isEqual:@"200"])
        {
            [always closeView];
            NSString* name = [oneSDKBranchUtils isContains:object andKey:@"name"];
            [[oneSDKBranchPlayerConfig getInstance] setName:name];
            [oneSDKBranchUtils permanentSave:@"onesdkbranch_access_nickName" Value:name];
        }
        [oneSDKBranchToastUtils show:msg duration:2.0f];
    }
    FailBlock: ^(NSError* error)
    {
        oneSDKBranchLogUtils(@"%@, 网络请求失败:%@", mineTAGoneSDKBranchTipsView, error);
    }];
}

// 关闭本界面
-(void)closeBtn:(id)sender
{
    apponeSDKBranchTipsView = NULL;
    if (eTimer)
    {
        // 暂停定时器
        [eTimer invalidate];
        eTimer = NULL;
    }
    [self removeFromSuperview];
}

// 获取本类信息
+(oneSDKBranchTipsView*)getApp
{
    return apponeSDKBranchTipsView;
}

// 删除自身
+(void)removeSelf
{
    apponeSDKBranchTipsView = NULL;
}

-(void)MyCountDownTimer:(id)sender
{
    countDown--;
    NSString* str = @"";
    NSString* stringInt = [NSString stringWithFormat:@"%d", countDown];
    str = [str stringByAppendingFormat:@"Delete(%@S)", stringInt];
    [confirmButton setTitle:str forState:UIControlStateNormal];
    if (countDown <= 0)
    {
        [confirmButton setTitle:@"Delete" forState:UIControlStateNormal];
        countDown = 15;
        [confirmButton setEnabled:YES];
        // 暂停定时器
        [eTimer invalidate];
    }
}

@end
