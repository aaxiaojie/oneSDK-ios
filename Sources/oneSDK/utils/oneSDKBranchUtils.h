//
//  oneSDKBranchUtils.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <sys/sysctl.h>
#import <net/if_dl.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "./oneSDKBranchEncryptionUtils.h"
#import "./oneSDKBranchBase64Utils.h"
#import "./oneSDKKeychain/oneSDKKeychain.h"
#import "./oneSDKBranchLogUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchUtils : NSObject

// SHA256加密
+(NSString*)getSHA256:(NSString*)str;
// base64加密
+(NSString*)base64Encode:(NSString*)str;
// base64解密
+(NSString*)base64Decode:(NSString*)str;
// urlEncode加密
+(NSString*)urlEncode:(NSString*)str;
// urlDecode解密
+(NSString*)urlDecode:(NSString*)str;
// 获取时间戳
+(long long)getTime;
// 获取info.plist中的数据
+(NSString*)getInfoData:(NSString*)str;
// 获取plist中Schemes数组
+(NSArray*)getSchemesArray;
// 是否连接网络
+(BOOL)isConnectNetwork;
// 是否连接WIFI
+(BOOL)isWif;
// 获取屏幕高度
+(int)getScreenHeight;
// 获取屏幕宽度
+(int)getScreenWidth;
// 获取SDK号
+(NSString*)getSDK;
// 获取手机型号
+(NSString*)getModel;
// 获取系统版本
+(NSString*)getRelease;
// 手机剩余内存
+(long)getAvailMemory;
// 手机总内存
+(long long)getTotalMemory;
// 获取手机内部空间总大小
+(long)getTotalInternalSize;
// 获取手机内部可用空间大小
+(long)getAvailableInternalSize;
// 获取SDK卡总空间大小
+(long)getTotalSDSize;
// 获取SD卡剩余空间
+(long)getAvailableSDSize;
// 获取手机mac地址
+(NSString*)getMac;
// 获取bid
+(NSString*)getBid;
// 验证邮箱
+(BOOL)isEmail:(NSString*)str;
// 验证手机号
+(BOOL)isMobilePhone:(NSString*)str;
// 复制文本
+(void)copyText:(NSString*)str;
// 粘贴文本
+(NSString*)pasteText;
// 永久储存数据(将数据永久储存在本地, 用户执行卸载操作, 数据仍然存在, 但是用户如果执行清除数据或者刷机操作, 数据就会被删除)
+(void)permanentSave:(NSString*)key Value:(NSString*)value;
// 查询数据
+(NSString*)permanentLoad:(NSString*)key;
// 清理所有数据
+(void)permanentClearAll;
// 验证账号
+(BOOL)verificatAccount:(NSString*)account;
// 验证密码
+(BOOL)verificatPassword:(NSString*)password;
// 传入的字符串是否是纯数字
+(BOOL)validateNumber:(NSString*)number;
// 验证验证码
+(BOOL)verificatCode:(NSString*)code;
// 从bundle中获取指定文件路径
//+(NSString*)getPathFromBundle:(NSString*)fileName;
// 从bundle中读取图片
+(UIImage*)getImageFromBundle:(NSString*)imageName;
// 从bundle的json文件中读取数据
+(NSString*)getDataFromBundleJson:(NSString*)jsonKey;
// 将json数据排序
+(NSString*)getJsonSort:(NSDictionary*)dict;
// 排序并且SHA256
+(NSString*)sortAndSHA256:(NSDictionary*)json;
// 此方法是遍历json数据中的key和value, 并按照key=value输出
+(NSString*)jsonErgodic:(NSDictionary*)jsonInfo;
// 远程读取json文件
+(void)getJsonFromServer:(NSString*)url;
// 获取当前屏幕显示的viewcontroller
+(UIViewController*)getCurrentVC;
// 当前是否是横屏
+(BOOL)isHorizontal;
// 获取设备id
+(NSString*)getAdvertisingId;
// 打开自带浏览器
+(void)openURL:(NSString*)url;
// 判断字典中是否有值
+(id)isContains:(NSMutableDictionary*)dictionary andKey:(NSString*)key;
// 字符串中是否包含指定字符
+(Boolean)isContainStr:(NSString*)str andSpecify:(NSString*)specify;
// 将字符串以指定字符倒序
+(NSString*)reverseOrder:(NSString*)str andDelimiter:(NSString*)delimiter;
// id转字符串, 主要是防止崩溃
+(NSString*)toNSString:(id)obj;
// 从父view移除子view
+(void)removeViewWithTag:(NSInteger)tag fromSuperview:(UIView*)superview;
// 字符串rsa加密
+(NSString*)encryptByPublicKey:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
