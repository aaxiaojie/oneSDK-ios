//
//  oneSDKBranchPlayerConfig.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchPlayerConfig.h"

@implementation oneSDKBranchPlayerConfig

static oneSDKBranchPlayerConfig* player = nil;

+(instancetype)getInstance
{
    if (player == nil)
    {
        player = [[oneSDKBranchPlayerConfig alloc] init];
    }
    return player;
}

// 姓名
-(void)setName:(NSString*)name
{
    _pName = name;
}

-(NSString*)getName
{
    return _pName;
}

// uid
-(void)setUid:(NSString*)uid
{
    _pUid = uid;
}

-(NSString*)getUid
{
    return _pUid;
}

// token
-(void)setToken:(NSString*)token
{
    _pToken = token;
}

-(NSString*)getToken
{
    return _pToken;
}

// 玩家账号
-(void)setAccount:(NSString*)account
{
    _account = account;
}

-(NSString*)getAccount;
{
    return _account;
}

// 登录时间
-(void)setLoginTime:(NSString*)loginTime
{
    _loginTime = loginTime;
}

-(NSString*)getLoginTime
{
    return _loginTime;
}

// 过期时间戳
-(void)setOverdueTime:(NSString*)overdueTime
{
    _overdueTime = overdueTime;
}

-(NSString*)getOverdueTime
{
    return _overdueTime;
}

// 是否开启自动登录功能
-(void)setIsAutoLogin:(BOOL)isAutoLogin
{
    _isAutoLogin = isAutoLogin;
}

-(BOOL)getIsAutoLogin
{
    return _isAutoLogin;
}

// 玩家登录方式
-(void)setLoginType:(NSString*)loginType
{
    _loginType = loginType;
}

-(NSString*)getLoginType
{
    return _loginType;
}

// 唯一码
-(void)setMacAddress:(NSString*)macAddress
{
    _macAddress = macAddress;
}

-(NSString*)getMacAddress
{
    return _macAddress;
}

// 域名
-(void)setDomain:(NSString*)domain
{
    _domain = domain;
}

-(NSString*)getDomain
{
    return _domain;
}

// 注册时间
-(void)setRegisterTime:(NSString*)registerTime
{
    _registerTime = registerTime;
}

-(NSString*)getRegisterTime
{
    return _registerTime;
}

// 登录接口
-(void)setLoginFuncName:(NSString*)loginFuncName
{
    _loginFuncName = loginFuncName;
}

-(NSString*)getLoginFuncName
{
    return _loginFuncName;
}

// 注册接口
-(void)setRegisterFuncName:(NSString*)registerFuncName
{
    _registerFuncName = registerFuncName;
}

-(NSString*)getRegisterFuncName
{
    return _registerFuncName;
}

// 游客登录接口
-(void)setGuestFuncName:(NSString*)guestFuncName
{
    _guestFuncName = guestFuncName;
}

-(NSString*)getGuestFuncName
{
    return _guestFuncName;
}

// apple登录接口
-(void)setAppleLoginFuncName:(NSString*)appleLoginFuncName
{
    _appleLoginFuncName = appleLoginFuncName;
}

-(NSString*)getAppleLoginFuncName
{
    return _appleLoginFuncName;
}

// facebook登录接口
-(void)setFacebookLoginFuncName:(NSString*)facebookLoginFuncName
{
    _facebookLoginFuncName = facebookLoginFuncName;
}

-(NSString*)getFacebookLoginFuncName
{
    return _facebookLoginFuncName;
}

// google登录接口
-(void)setGoogleLoginFuncName:(NSString*)googleLoginFuncName
{
    _googleLoginFuncName = googleLoginFuncName;
}

-(NSString*)getGoogleLoginFuncName
{
    return _googleLoginFuncName;
}

// 忘记密码接口
-(void)setForgetPasswordFuncName:(NSString*)forgetPasswordFuncName
{
    _forgetPasswordFuncName = forgetPasswordFuncName;
}

-(NSString*)getForgetPasswordFuncName
{
    return _forgetPasswordFuncName;
}

// 修改密码接口
-(void)setModifyPasswordFuncName:(NSString*)modifyPasswordFuncName
{
    _modifyPasswordFuncName = modifyPasswordFuncName;
}

-(NSString*)getModifyPasswordFuncName
{
    return _modifyPasswordFuncName;
}

// 绑定接口
-(void)setBindFuncName:(NSString*)bindFuncName
{
    _bindFuncName = bindFuncName;
}

-(NSString*)getBindFuncName
{
    return _bindFuncName;
}

// 强制绑定邮箱接口
-(void)setForceBindFuncName:(NSString*)forceBindFuncName
{
    _forceBindFuncName = forceBindFuncName;
}

-(NSString*)getForceBindFuncName
{
    return _forceBindFuncName;
}

// 忘记密码接口(提交)
-(void)setSubmitForgetPasswordFuncName:(NSString*)submitForgetPasswordFuncName
{
    _submitForgetPasswordFuncName = submitForgetPasswordFuncName;
}

-(NSString*)getSubmitForgetPasswordFuncName
{
    return _submitForgetPasswordFuncName;
}

// 修改密码接口(提交)
-(void)setSubmitModifyPasswordFuncName:(NSString*)submitModifyPasswordFuncName
{
    _submitModifyPasswordFuncName = submitModifyPasswordFuncName;
}

-(NSString*)getSubmitModifyPasswordFuncName
{
    return _submitModifyPasswordFuncName;
}

// 绑定接口(提交)
-(void)setSubmitBindFuncName:(NSString*)submitBindFuncName
{
    _submitBindFuncName = submitBindFuncName;
}

-(NSString*)getSubmitBindFuncName
{
    return _submitBindFuncName;
}

// 强制绑定邮箱接口(提交)
-(void)setSubmitForceBindEmailFuncName:(NSString*)submitForceBindEmailFuncName
{
    _submitForceBindEmailFuncName = submitForceBindEmailFuncName;
}

-(NSString*)getSubmitForceBindEmailFuncName
{
    return _submitForceBindEmailFuncName;
}

// 登出接口
-(void)setLogoutFuncName:(NSString*)logoutFuncName
{
    _logoutFuncName = logoutFuncName;
}

-(NSString*)getLogoutFuncName
{
    return _logoutFuncName;
}

// 实名认证接口
-(void)setRealNameFuncName:(NSString*)realNameFuncName
{
    _realNameFuncName = realNameFuncName;
}

-(NSString*)getRealNameFuncName
{
    return _realNameFuncName;
}

// 下单接口
-(void)setPOrderFuncName:(NSString*)pOrderFuncName
{
    _pOrderFuncName = pOrderFuncName;
}

-(NSString*)getPOrderFuncName
{
    return _pOrderFuncName;
}

// 支付回调接口
-(void)setPayCallbackFuncName:(NSString*)payCallbackFuncName
{
    _payCallbackFuncName = payCallbackFuncName;
}

-(NSString*)getPayCallbackFuncName
{
    return _payCallbackFuncName;
}

// 上报日志接口
-(void)setUpdateUserLogsFuncName:(NSString*)updateUserLogsFuncName
{
    _updateUserLogsFuncName = updateUserLogsFuncName;
}

-(NSString*)getUpdateUserLogsFuncName
{
    return _updateUserLogsFuncName;
}

// 游戏内上报日志接口
-(void)setUpdateGameInfoFuncName:(NSString*)updateGameInfoFuncName
{
    _updateGameInfoFuncName = updateGameInfoFuncName;
}

-(NSString*)getUpdateGameInfoFuncName
{
    return _updateGameInfoFuncName;
}

// 获取唯一码接口
-(void)setMd5CodeFuncName:(NSString*)md5CodeFuncName
{
    _md5CodeFuncName = md5CodeFuncName;
}

-(NSString*)getMd5CodeFuncName
{
    return _md5CodeFuncName;
}

// 获取删除账号接口
-(void)setClearAccountFuncName:(NSString*)clearAccountFuncName
{
    _clearAccountFuncName = clearAccountFuncName;
}

-(NSString*)getClearAccountFuncName
{
    return _clearAccountFuncName;
}

// 获取自动登录接口
-(void)setAutologinFuncName:(NSString*)autologinFuncName
{
    _autologinFuncName = autologinFuncName;
}

-(NSString*)getAutologinFuncName
{
    return _autologinFuncName;
}

// 获取修改昵称接口
-(void)setModifyNickNameFuncName:(NSString*)modifyNickNameFuncName
{
    _modifyNickNameFuncName = modifyNickNameFuncName;
}

-(NSString*)getModifyNickNameFuncName
{
    return _modifyNickNameFuncName;
}

// 校验用户是否已经强制绑定接口
-(void)setCheckPlayerForceBindStateFuncName:(NSString*)checkPlayerForceBindStateFuncName
{
    _checkPlayerForceBindStateFuncName = checkPlayerForceBindStateFuncName;
}

-(NSString*)getCheckPlayerForceBindStateFuncName
{
    return _checkPlayerForceBindStateFuncName;
}

// 解除强制绑定接口(只针对测试服生效)
-(void)setUnForceBindFuncName:(NSString*)unForceBindFuncName
{
    _unForceBindFuncName = unForceBindFuncName;
}

-(NSString*)getUnForceBindFuncName
{
    return _unForceBindFuncName;
}

// 获取兑换码
-(void)setGoodsCode:(NSString*)goodsCode
{
    _goodsCode = goodsCode;
}

-(NSString*)getGoodsCode
{
    return _goodsCode;
}

// 获取兑换物品
-(void)setGoods:(NSString*)goods
{
    _goods = goods;
}

-(NSString*)getGoods
{
    return _goods;
}

// 获取物品领取状态(0不显示、1未领取、2已领取)
-(void)sestGoodsStatus:(NSString*)goodsStatus
{
    _goodsStatus = goodsStatus;
}

-(NSString*)getGoodsStatus
{
    return _goodsStatus;
}

// 获取登录验证信息
-(void)setEmpowerLoginData:(NSString*)empowerLoginData
{
    _empowerLoginData = empowerLoginData;
}

-(NSString*)getEmpowerLoginData
{
    return _empowerLoginData;
}

// id登录按钮打开状态
-(void)setGuestBtnIsCanShow:(BOOL)guestBtnIsCanShow
{
    _guestBtnIsCanShow = guestBtnIsCanShow;
}

-(BOOL)getGuestBtnIsCanShow
{
    return _guestBtnIsCanShow;
}

// facebook登录按钮打开状态
-(void)setFbBtnIsCanShow:(BOOL)fbBtnIsCanShow
{
    _fbBtnIsCanShow = fbBtnIsCanShow;
}

-(BOOL)getFbBtnIsCanShow
{
    return _fbBtnIsCanShow;
}

// google登录按钮打开状态
-(void)setGoogleBtnIsCanShow:(BOOL)googleBtnIsCanShow
{
    _googleBtnIsCanShow = googleBtnIsCanShow;
}

-(BOOL)getGoogleBtnIsCanShow
{
    return _googleBtnIsCanShow;
}

// apple登录按钮打开状态
-(void)setAppleBtnIsCanShow:(BOOL)appleBtnIsCanShow
{
    _appleBtnIsCanShow = appleBtnIsCanShow;
}

-(BOOL)getAppleBtnIsCanShow
{
    return _appleBtnIsCanShow;
}

// 悬浮窗强制绑定按钮打开状态
-(void)setForceBindBtnIsCanShow:(NSString*)forceBindBtnIsCanShow
{
    _forceBindBtnIsCanShow = forceBindBtnIsCanShow;
}

-(NSString*)getForceBindBtnIsCanShow
{
    return _forceBindBtnIsCanShow;
}

// appid
-(void)setAppId:(NSString*)appId
{
    _appId = appId;
}

-(NSString*)getAppId
{
    return _appId;
}

// appkey
-(void)setAppKey:(NSString*)appKey
{
    _appKey = appKey;
}

-(NSString*)getAppKey
{
    return _appKey;
}

// channel_id
-(void)setChannelId:(NSString*)channelId
{
    _channelId = channelId;
}

-(NSString*)getChannelId
{
    return _channelId;
}

// platform_id
-(void)setPlatformId:(NSString*)platformId
{
    _platformId = platformId;
}

-(NSString*)getPlatformId
{
    return _platformId;
}

// appleLoginToken
-(void)setAppleLoginToken:(NSString*)appleLoginToken
{
    _appleLoginToken = appleLoginToken;
}

-(NSString*)getAppleLoginToken
{
    return _appleLoginToken;
}

// adjustToken
-(void)setAdjustToken:(NSString*)adjustToken
{
    _adjustToken = adjustToken;
}

-(NSString*)getAdjustToken
{
    return _adjustToken;
}

// googleID
-(void)setGoogleID:(NSString*)googleID
{
    _googleID = googleID;
}

-(NSString*)getGoogleID
{
    return _googleID;
}

// 是否显示悬浮窗内的清除缓存按钮
-(void)setIsShowClearBtn:(BOOL)isShowClearBtn
{
    _isShowClearBtn = isShowClearBtn;
}

-(BOOL)getIsShowClearBtn
{
    return _isShowClearBtn;
}

// 用户是否在info.plist中配置了所有的值
-(void)setIsAllAllocationInInfoPlist:(BOOL)isAllAllocationInInfoPlist
{
    _isAllAllocationInInfoPlist = isAllAllocationInInfoPlist;
}

-(BOOL)getIsAllAllocationInInfoPlist
{
    return _isAllAllocationInInfoPlist;
}

// 设置版本
-(void)setVersion:(NSString*)version
{
    _version = version;
}

-(NSString*)getVersion
{
    return _version;
}

// 设置环境
-(void)setProducteState:(NSString*)producteState
{
    _producteState = producteState;
}

-(NSString*)getProducteState
{
    return _producteState;
}

@end
