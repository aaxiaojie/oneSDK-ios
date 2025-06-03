//
//  oneSDKBranchPlayerConfig.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchPlayerConfig : NSObject

+(instancetype)getInstance;

// 生成get、set方法
// 玩家昵称
@property(nonatomic, retain)NSString* pName;
// 玩家id
@property(nonatomic, retain)NSString* pUid;
// token
@property(nonatomic, retain)NSString* pToken;
// 玩家账号
@property(nonatomic, retain)NSString* account;
// 登录时间
@property(nonatomic, retain)NSString* loginTime;
// 过期时间戳
@property(nonatomic, retain)NSString* overdueTime;
// 是否开启自动登录功能(默认开启)
@property(nonatomic, assign)BOOL isAutoLogin;
// 玩家登录方式(1:游客, 2:账号密码, 3:google, 4:facebook, 5:apple, 6:huawei, 7:鸿蒙)
@property(nonatomic, retain)NSString* loginType;
// 唯一码
@property(nonatomic, retain)NSString* macAddress;
// 域名
@property(nonatomic, retain)NSString* domain;
// 注册时间
@property(nonatomic, retain)NSString* registerTime;
// 登录接口
@property(nonatomic, retain)NSString* loginFuncName;
// 注册接口
@property(nonatomic, retain)NSString* registerFuncName;
// 游客登录接口
@property(nonatomic, retain)NSString* guestFuncName;
// apple登录接口
@property(nonatomic, retain)NSString* appleLoginFuncName;
// facebook登录接口
@property(nonatomic, retain)NSString* facebookLoginFuncName;
// google登录接口
@property(nonatomic, retain)NSString* googleLoginFuncName;
// 忘记密码接口
@property(nonatomic, retain)NSString* forgetPasswordFuncName;
// 修改密码接口
@property(nonatomic, retain)NSString* modifyPasswordFuncName;
// 绑定接口
@property(nonatomic, retain)NSString* bindFuncName;
// 强制绑定邮箱接口
@property(nonatomic, retain)NSString* forceBindFuncName;
// 忘记密码接口(提交)
@property(nonatomic, retain)NSString* submitForgetPasswordFuncName;
// 修改密码接口(提交)
@property(nonatomic, retain)NSString* submitModifyPasswordFuncName;
// 绑定接口(提交)
@property(nonatomic, retain)NSString* submitBindFuncName;
// 强制绑定邮箱接口(提交)
@property(nonatomic, retain)NSString* submitForceBindEmailFuncName;
// 登出接口
@property(nonatomic, retain)NSString* logoutFuncName;
// 实名认证接口
@property(nonatomic, retain)NSString* realNameFuncName;
// 下单接口
@property(nonatomic, retain)NSString* pOrderFuncName;
// 支付回调接口
@property(nonatomic, retain)NSString* payCallbackFuncName;
// 上报日志接口
@property(nonatomic, retain)NSString* updateUserLogsFuncName;
// 游戏内上报日志接口
@property(nonatomic, retain)NSString* updateGameInfoFuncName;
// 获取唯一码接口
@property(nonatomic, retain)NSString* md5CodeFuncName;
// 获取删除账号接口
@property(nonatomic, retain)NSString* clearAccountFuncName;
// 自动登录接口
@property(nonatomic, retain)NSString* autologinFuncName;
// 修改昵称接口
@property(nonatomic, retain)NSString* modifyNickNameFuncName;
// 校验用户是否已经强制绑定
@property(nonatomic, retain)NSString* checkPlayerForceBindStateFuncName;
// 解除强制绑定(只针对测试服生效)
@property(nonatomic, retain)NSString* unForceBindFuncName;
// 兑换码
@property(nonatomic, retain)NSString* goodsCode;
// 兑换物品
@property(nonatomic, retain)NSString* goods;
// 物品领取状态(0不显示、1未领取、2已领取)
@property(nonatomic, retain)NSString* goodsStatus;
// 登录验证信息
@property(nonatomic, retain)NSString* empowerLoginData;
// 游客登录按钮打开状态
@property(nonatomic, assign)BOOL guestBtnIsCanShow;
// facebook登录按钮打开状态
@property(nonatomic, assign)BOOL fbBtnIsCanShow;
// google登录按钮打开状态
@property(nonatomic, assign)BOOL googleBtnIsCanShow;
// apple登录按钮打开状态
@property(nonatomic, assign)BOOL appleBtnIsCanShow;
// 悬浮窗强制绑定按钮打开状态("1"显示, "0"隐藏)
@property(nonatomic, retain)NSString* forceBindBtnIsCanShow;
// appid
@property(nonatomic, retain)NSString* appId;
// appkey
@property(nonatomic, retain)NSString* appKey;
// channel_id
@property(nonatomic, retain)NSString* channelId;
// platform_id
@property(nonatomic, retain)NSString* platformId;
// appleLoginToken
@property(nonatomic, retain)NSString* appleLoginToken;
// adjustToken
@property(nonatomic, retain)NSString* adjustToken;
// googleID
@property(nonatomic, retain)NSString* googleID;
// 是否显示悬浮窗内的清除缓存按钮
@property(nonatomic, assign)BOOL isShowClearBtn;
// 用户是否在info.plist中配置了所有的值
@property(nonatomic, assign)BOOL isAllAllocationInInfoPlist;
// 版本
@property(nonatomic, retain)NSString* version;
// 1测试环境, 2发布环境
@property(nonatomic, retain)NSString* producteState;

// 姓名
-(void)setName:(NSString*)name;
-(NSString*)getName;

// uid
-(void)setUid:(NSString*)uid;
-(NSString*)getUid;

// token
-(void)setToken:(NSString*)token;
-(NSString*)getToken;

// 玩家账号
-(void)setAccount:(NSString*)account;
-(NSString*)getAccount;

// 登录时间
-(void)setLoginTime:(NSString*)loginTime;
-(NSString*)getLoginTime;

// 过期时间戳
-(void)setOverdueTime:(NSString*)overdueTime;
-(NSString*)getOverdueTime;

// 是否开启自动登录功能
-(void)setIsAutoLogin:(BOOL)isAutoLogin;
-(BOOL)getIsAutoLogin;

// 玩家登录方式
-(void)setLoginType:(NSString*)loginType;
-(NSString*)getLoginType;

// 唯一码
-(void)setMacAddress:(NSString*)macAddress;
-(NSString*)getMacAddress;

// 域名
-(void)setDomain:(NSString*)domain;
-(NSString*)getDomain;

// 注册时间
-(void)setRegisterTime:(NSString*)registerTime;
-(NSString*)getRegisterTime;

// 登录接口
-(void)setLoginFuncName:(NSString*)loginFuncName;
-(NSString*)getLoginFuncName;

// 注册接口
-(void)setRegisterFuncName:(NSString*)registerFuncName;
-(NSString*)getRegisterFuncName;

// 游客登录接口
-(void)setGuestFuncName:(NSString*)guestFuncName;
-(NSString*)getGuestFuncName;

// apple登录接口
-(void)setAppleLoginFuncName:(NSString*)appleLoginFuncName;
-(NSString*)getAppleLoginFuncName;

// facebook登录接口
-(void)setFacebookLoginFuncName:(NSString*)facebookLoginFuncName;
-(NSString*)getFacebookLoginFuncName;

// google登录接口
-(void)setGoogleLoginFuncName:(NSString*)googleLoginFuncName;
-(NSString*)getGoogleLoginFuncName;

// 忘记密码接口
-(void)setForgetPasswordFuncName:(NSString*)forgetPasswordFuncName;
-(NSString*)getForgetPasswordFuncName;

// 修改密码接口
-(void)setModifyPasswordFuncName:(NSString*)modifyPasswordFuncName;
-(NSString*)getModifyPasswordFuncName;

// 绑定接口
-(void)setBindFuncName:(NSString*)bindFuncName;
-(NSString*)getBindFuncName;

// 强制绑定邮箱接口
-(void)setForceBindFuncName:(NSString*)forceBindFuncName;
-(NSString*)getForceBindFuncName;

// 忘记密码接口(提交)
-(void)setSubmitForgetPasswordFuncName:(NSString*)submitForgetPasswordFuncName;
-(NSString*)getSubmitForgetPasswordFuncName;

// 修改密码接口(提交)
-(void)setSubmitModifyPasswordFuncName:(NSString*)submitModifyPasswordFuncName;
-(NSString*)getSubmitModifyPasswordFuncName;

// 绑定接口(提交)
-(void)setSubmitBindFuncName:(NSString*)submitBindFuncName;
-(NSString*)getSubmitBindFuncName;

// 强制绑定邮箱接口(提交)
-(void)setSubmitForceBindEmailFuncName:(NSString*)submitForceBindEmailFuncName;
-(NSString*)getSubmitForceBindEmailFuncName;

// 登出接口
-(void)setLogoutFuncName:(NSString*)logoutFuncName;
-(NSString*)getLogoutFuncName;

// 实名认证接口
-(void)setRealNameFuncName:(NSString*)realNameFuncName;
-(NSString*)getRealNameFuncName;

// 下单接口
-(void)setPOrderFuncName:(NSString*)pOrderFuncName;
-(NSString*)getPOrderFuncName;

// 支付回调接口
-(void)setPayCallbackFuncName:(NSString*)payCallbackFuncName;
-(NSString*)getPayCallbackFuncName;

// 上报日志接口
-(void)setUpdateUserLogsFuncName:(NSString*)updateUserLogsFuncName;
-(NSString*)getUpdateUserLogsFuncName;

// 游戏内上报日志接口
-(void)setUpdateGameInfoFuncName:(NSString*)updateGameInfoFuncName;
-(NSString*)getUpdateGameInfoFuncName;

// 获取唯一码接口
-(void)setMd5CodeFuncName:(NSString*)md5CodeFuncName;
-(NSString*)getMd5CodeFuncName;

// 获取删除账号接口
-(void)setClearAccountFuncName:(NSString*)clearAccountFuncName;
-(NSString*)getClearAccountFuncName;

// 获取自动登录接口
-(void)setAutologinFuncName:(NSString*)autologinFuncName;
-(NSString*)getAutologinFuncName;

// 获取修改昵称接口
-(void)setModifyNickNameFuncName:(NSString*)modifyNickNameFuncName;
-(NSString*)getModifyNickNameFuncName;

// 校验用户是否已经强制绑定接口
-(void)setCheckPlayerForceBindStateFuncName:(NSString*)checkPlayerForceBindStateFuncName;
-(NSString*)getCheckPlayerForceBindStateFuncName;

// 解除强制绑定接口(只针对测试服生效)
-(void)setUnForceBindFuncName:(NSString*)unForceBindFuncName;
-(NSString*)getUnForceBindFuncName;

// 获取兑换码
-(void)setGoodsCode:(NSString*)goodsCode;
-(NSString*)getGoodsCode;

// 获取兑换物品
-(void)setGoods:(NSString*)goods;
-(NSString*)getGoods;

// 获取物品领取状态(0不显示、1未领取、2已领取)
-(void)sestGoodsStatus:(NSString*)goodsStatus;
-(NSString*)getGoodsStatus;

// 获取登录验证信息
-(void)setEmpowerLoginData:(NSString*)empowerLoginData;
-(NSString*)getEmpowerLoginData;

// 获取游客登录按钮打开状态
-(void)setGuestBtnIsCanShow:(BOOL)guestBtnIsCanShow;
-(BOOL)getGuestBtnIsCanShow;

// facebook登录按钮打开状态
-(void)setFbBtnIsCanShow:(BOOL)fbBtnIsCanShow;
-(BOOL)getFbBtnIsCanShow;

// google登录按钮打开状态
-(void)setGoogleBtnIsCanShow:(BOOL)googleBtnIsCanShow;
-(BOOL)getGoogleBtnIsCanShow;

// apple登录按钮打开状态
-(void)setAppleBtnIsCanShow:(BOOL)appleBtnIsCanShow;
-(BOOL)getAppleBtnIsCanShow;

// 悬浮窗强制绑定按钮打开状态
-(void)setForceBindBtnIsCanShow:(NSString*)forceBindBtnIsCanShow;
-(NSString*)getForceBindBtnIsCanShow;

// appid
-(void)setAppId:(NSString*)appId;
-(NSString*)getAppId;

// appkey
-(void)setAppKey:(NSString*)appKey;
-(NSString*)getAppKey;

// channel_id
-(void)setChannelId:(NSString*)channelId;
-(NSString*)getChannelId;

// platform_id
-(void)setPlatformId:(NSString*)platformId;
-(NSString*)getPlatformId;

// appleLoginToken
-(void)setAppleLoginToken:(NSString*)appleLoginToken;
-(NSString*)getAppleLoginToken;

// adjustToken
-(void)setAdjustToken:(NSString*)adjustToken;
-(NSString*)getAdjustToken;

// googleID
-(void)setGoogleID:(NSString*)googleID;
-(NSString*)getGoogleID;

// 是否显示悬浮窗内的清除缓存按钮
-(void)setIsShowClearBtn:(BOOL)isShowClearBtn;
-(BOOL)getIsShowClearBtn;

// 用户是否在info.plist中配置了所有的值
-(void)setIsAllAllocationInInfoPlist:(BOOL)isAllAllocationInInfoPlist;
-(BOOL)getIsAllAllocationInInfoPlist;

// 设置版本
-(void)setVersion:(NSString*)version;
-(NSString*)getVersion;

// 设置环境
-(void)setProducteState:(NSString*)producteState;
-(NSString*)getProducteState;

@end

NS_ASSUME_NONNULL_END
