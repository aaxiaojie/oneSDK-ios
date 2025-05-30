//
//  oneSDKBranchUtils.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchUtils.h"
#import <AdSupport/ASIdentifierManager.h>
#import "./oneSDKBranchToastUtils.h"
#import "./../playerConfig/oneSDKBranchPlayerConfig.h"
#import "./oneSDKBranchRSAUtils.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation oneSDKBranchUtils

static NSString* serviceName = @"com.sdk.oneSDK";
static float showToastTime = 2.0f;

// SHA256加密
+(NSString*)getSHA256:(NSString*)str
{
    if (!str.length)
    {
        return @"";
    }
    return [oneSDKBranchEncryptionUtils getSHA256tr:str];
}

// base64加密
+(NSString*)base64Encode:(NSString*)str
{
    if (!str.length)
    {
        return @"";
    }
    return [oneSDKBranchBase64Utils encode:str];
}

// base64解密
+(NSString*)base64Decode:(NSString*)str
{
    if (!str.length)
    {
        return @"";
    }
    return [oneSDKBranchBase64Utils decode:str];
}

// urlEncode加密
+(NSString*)urlEncode:(NSString*)str
{
    if (!str.length)
    {
        return @"";
    }
    
    NSString* charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet* allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString* encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

// urlDecode解密
+(NSString*)urlDecode:(NSString*)str
{
    if (!str.length)
    {
        return @"";
    }
    return [str stringByRemovingPercentEncoding];
}

// 获取时间戳
+(long long)getTime
{
    double currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    long long iTime = (long long)currentTime;
    return iTime;
}

// 获取info.plist中的数据
+(NSString*)getInfoData:(NSString*)str
{
    if (!str.length)
    {
        return @"";
    }
    /*
    NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
    NSArray* urlTypes = dict[@"CFBundleURLTypes"];
    NSString* urlSchemes = nil;
    for (NSDictionary* scheme in urlTypes)
    {
        NSString* schemeKey = scheme[@"CFBundleURLName"];
        if ([schemeKey isEqualToString:str])
        {
            urlSchemes = scheme[@"CFBundleURLSchemes"][0];
            break;
        }
    }
    return urlSchemes;
     */
    
    NSString* urlSchemes = [[NSBundle mainBundle].infoDictionary objectForKey:str];
    return urlSchemes;
}

// 获取plist中Schemes数组
+(NSArray*)getSchemesArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    // 获取应用的Info.plist字典
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 获取CFBundleURLTypes数组
    NSArray* urlTypes = infoDictionary[@"CFBundleURLTypes"];
    
    for (int i = 0; i < urlTypes.count; i++)
    {
        [array addObject:urlTypes[i]];
        array[i] = [[NSMutableArray alloc] init];
        
        // 获取URLSchemes数组
        NSArray* schemes = urlTypes[i][@"CFBundleURLSchemes"];
        
        for (int j = 0; j < schemes.count; j++)
        {
            [array[i] addObject:schemes[j]];
        }
    }
    return array;
}

// 是否连接网络
+(BOOL)isConnectNetwork
{
    BOOL bEnabled = FALSE;
    NSString* url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    CFRelease(ref);
    if (bEnabled)
    {
        // kSCNetworkReachabilityFlagsReachable：能够连接网络
        // kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
        // kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }
    return bEnabled;
}

// 是否连接WIFI
+(BOOL)isWif
{
    BOOL ret = YES;
    struct ifaddrs* first_ifaddr, *current_ifaddr;
    NSMutableArray* activeInterfaceNames = [[NSMutableArray alloc] init];
    getifaddrs(&first_ifaddr);
    current_ifaddr = first_ifaddr;
    while(current_ifaddr != NULL)
    {
        if(current_ifaddr->ifa_addr->sa_family == 0x02)
        {
            [activeInterfaceNames addObject:[NSString stringWithFormat:@"%s", current_ifaddr->ifa_name]];
        }
        current_ifaddr = current_ifaddr->ifa_next;
    }
    ret = [activeInterfaceNames containsObject:@"en0"] || [activeInterfaceNames containsObject:@"en1"];
    return ret;
}

// 获取屏幕高度
+(int)getScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

// 获取屏幕宽度
+(int)getScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

// 获取SDK号
+(NSString*)getSDK
{
    return [UIDevice currentDevice].systemVersion;
}

// 获取手机型号
+(NSString*)getModel
{
    return [UIDevice currentDevice].model;
}

// 获取系统版本
+(NSString*)getRelease
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

// 手机剩余内存
+(long)getAvailMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return (vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count);
}

// 手机总内存
+(long long)getTotalMemory
{
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1)
    {
        totalMemory = -1;
    }
    return totalMemory;
}

// 获取手机内部空间总大小
+(long)getTotalInternalSize
{
    
    NSDictionary* fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber* maxber = [fattributes objectForKey:NSFileSystemSize];
    return [maxber longValue];
}

// 获取手机内部可用空间大小
+(long)getAvailableInternalSize
{
    NSDictionary* fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber* freeber = [fattributes objectForKey:NSFileSystemFreeSize];
    return [freeber longValue];
}

// 获取SDK卡总空间大小
+(long)getTotalSDSize
{
    return 0;
}

// 获取SD卡剩余空间
+(long)getAvailableSDSize
{
    return 0;
}

// 获取手机mac地址
+(NSString*)getMac
{
    int mgmtInfoBase[6];
    char* msgBuffer = NULL;
    size_t length;
    unsigned char macAddress[6];
    struct if_msghdr* interfaceMsgStruct;
    struct sockaddr_dl* socketStruct;
    NSString* errorFlag = NULL;
   
    mgmtInfoBase[0] = CTL_NET;
    mgmtInfoBase[1] = AF_ROUTE;
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;
    mgmtInfoBase[4] = NET_RT_IFLIST;
   
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
    {
        errorFlag = @"if_nametoindex failure";
    }
    else
    {
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        {
            errorFlag = @"sysctl mgmtInfoBase failure";
        }
        else
        {
            if ((msgBuffer = malloc(length)) == NULL)
            {
                errorFlag = @"buffer allocation failure";
            }
            else
            {
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                {
                    errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
    }
   
    if (errorFlag != NULL)
    {
        oneSDKBranchLogUtils(@"Error: %@", errorFlag);
        return errorFlag;
    }
   
    interfaceMsgStruct = (struct if_msghdr*)msgBuffer;
    socketStruct = (struct sockaddr_dl*)(interfaceMsgStruct + 1);
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    NSString* macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
    free(msgBuffer);
    return macAddressString;
}

// 获取bid
+(NSString*)getBid
{
    return [[NSBundle mainBundle]bundleIdentifier];
}

// 验证邮箱
+(BOOL)isEmail:(NSString*)str
{
    if (!str.length)
    {
        return NO;
    }
    NSString* emailRegex = @"^(([a-zA-Z0-9_-]+)|([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)))@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

// 验证手机号
+(BOOL)isMobilePhone:(NSString*)str
{
    BOOL bRet = NO;
    if (!str.length || str.length != 11)
    {
        return bRet;
    }
    
    // 手机号码
    NSString* MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    // 中国移动
    NSString* CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    // 中国联通
    NSString* CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    // 中国电信
    NSString* CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    NSPredicate* regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate* regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate* regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate* regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:str] == YES) || ([regextestcm evaluateWithObject:str] == YES) || ([regextestct evaluateWithObject:str] == YES) || ([regextestcu evaluateWithObject:str] == YES))
    {
        bRet = YES;
    }
    
    return bRet;
}

// 复制文本
// 需要导入UIKit.framework并导入头文件#import <UIKit/UIKit.h>
+(void)copyText:(NSString*)str
{
    if (!str.length)
    {
        return;
    }
    // 应用内单独使用时
    NSString* strBuildID = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleIdentifier"];
    UIPasteboard* myPasteboard = [UIPasteboard pasteboardWithName:strBuildID create:YES];
    myPasteboard.string = str;
}

// 粘贴文本
+(NSString*)pasteText
{
    NSString* strBuildID = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleIdentifier"];
    UIPasteboard* myPasteboard = [UIPasteboard pasteboardWithName:strBuildID create:NO];
    return myPasteboard.string ? myPasteboard.string : @"";
}

// 永久储存数据(将数据永久储存在本地, 用户执行卸载操作, 数据仍然存在, 但是用户如果执行清除数据或者刷机操作, 数据就会被删除)
+(void)permanentSave:(NSString*)key Value:(NSString*)value
{
    if ([oneSDKKeychain setPassword:value forService:serviceName account:key])
    {
        oneSDKBranchLogUtils(@"success!");
    }
}

// 查询数据
+(NSString*)permanentLoad:(NSString*)key
{
    NSString* str = [oneSDKKeychain passwordForService:serviceName account:key];
    if (!str)
    {
        str = @"";
    }
    return str;
}

// 清理所有数据
+(void)permanentClearAll
{
    // 定义要清除的Keychain项类型数组
    NSArray* classes = @[
        (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecClassInternetPassword,
        (__bridge id)kSecClassCertificate,
        (__bridge id)kSecClassKey,
        (__bridge id)kSecClassIdentity
    ];
        
    // 遍历所有类型并删除对应项
    for (id classType in classes) {
        NSDictionary* query = @{
            (__bridge id)kSecClass:classType,
            (__bridge id)kSecMatchLimit:(__bridge id)kSecMatchLimitAll,
            (__bridge id)kSecReturnData:(__bridge id)kCFBooleanFalse
        };
        
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
        if (status != errSecSuccess && status != errSecItemNotFound) {
            oneSDKBranchLogUtils(@"清除Keychain数据失败，类型: %@，错误码: %d", classType, (int)status);
        }
    }
}

// 验证账号
+(BOOL)verificatAccount:(NSString*)account
{
    if (account.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noaccount"] duration:showToastTime];
        return NO;
    }
    else if (account.length > 30)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"longaccount"] duration:showToastTime];
        return NO;
    }
    else if (![oneSDKBranchUtils isEmail:account])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"mustemail"] duration:showToastTime];
        return NO;
    }
    else if (account.length < 6)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"shortaccount"] duration:showToastTime];
        return NO;
    }
    return YES;
}

// 验证密码
+(BOOL)verificatPassword:(NSString *)password
{
    if (password.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nopassword"] duration:showToastTime];
        return NO;
    }
    else if (password.length > 20)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"longpassword"] duration:showToastTime];
        return NO;
    }
    else if (password.length < 6)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"shortpassword"] duration:showToastTime];
        return NO;
    }
    return YES;
}

// 传入的字符串是否是纯数字
+(BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length)
    {
        NSString* string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

// 验证验证码
+(BOOL)verificatCode:(NSString*)code
{
    if (code.length == 0)
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nocode"] duration:showToastTime];
        return NO;
    }
//    else if (code.length != 4)
//    {
//        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nolengthcode"] duration:showToastTime];
//        return NO;
//    }
    else if (![oneSDKBranchUtils validateNumber:code])
    {
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"nonumcode"] duration:showToastTime];
        return NO;
    }
    return YES;
}

//// 从bundle中获取指定文件路径
//+(NSString*)getPathFromBundle:(NSString*)fileName
//{
//    NSString* result = @"";
//    if (fileName.length == 0)
//    {
//        return result;
//    }
//    
//    NSString* emoticon = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
//    result = [emoticon stringByAppendingPathComponent:fileName];
//    return result;
//}

// 从bundle中读取图片
+(UIImage*)getImageFromBundle:(NSString*)imageName
{
    NSString* emoticon = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSString* path = [emoticon stringByAppendingPathComponent:imageName];
    
//    NSString* path = [oneSDKBranchUtils getPathFromBundle:imageName];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

// 从bundle的json文件中读取数据
+(NSString*)getDataFromBundleJson:(NSString*)jsonKey
{
    NSString* emoticon = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSString* path = [emoticon stringByAppendingPathComponent:@"tips.json"];
    
//    NSString* path = [oneSDKBranchUtils getPathFromBundle:@"tips.json"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return [dict objectForKey:jsonKey];
}

// 将json数据排序
+(NSString*)getJsonSort:(NSDictionary*)dict
{
    // 判断字典内容
    if (dict.count == 0)
    {
        oneSDKBranchLogUtils(@"字典为空");
        return NULL;
    }
    
    // 拼接转换结果
    NSString* str = @"";
    // 获取所有的key
    NSArray* keys = [dict allKeys];
    // 排序
    NSComparator sotrBlock = ^(id string1, id string2)
    {
        // 升序
        return [string1 compare:string2];
    };

    // 排序后的数组
    NSArray* sortArray = [keys sortedArrayUsingComparator:sotrBlock];
    
    // 遍历排序后的数组
    for (int i = 0; i < sortArray.count; i++)
    {
        NSString* key = sortArray[i];
        id value = [dict objectForKey:key];
        // 拼接json串的分割符
        str = [str stringByAppendingFormat:@"%@=%@&", key, value];
    }
    
    // 收尾(去掉最后一个&)
    NSString* newStr = [str substringToIndex:[str length] - 1];
    return newStr;
}

// 排序并且SHA256
+(NSString*)sortAndSHA256:(NSDictionary*)json
{
    NSString* result = @"";
    
    if (json.count == 0)
    {
        oneSDKBranchLogUtils(@"sortAndSHA256 json is null");
        return result;
    }
    
    NSString* str = [oneSDKBranchUtils getJsonSort:json];
    NSString* string = [NSString stringWithFormat:@"%@%@%@", [[oneSDKBranchPlayerConfig getInstance] getAppId], str, [[oneSDKBranchPlayerConfig getInstance] getAppKey]];

    result = [oneSDKBranchUtils getSHA256:string];
    return result;
}

// 此方法是遍历json数据中的key和value, 并按照key=value输出
+(NSString*)jsonErgodic:(NSDictionary*)jsonInfo
{
    // 拼接转换结果
    NSString* str = @"";
    for (NSString* key in jsonInfo)
    {
        // 拼接json串的分割符
        str = [str stringByAppendingFormat:@"%@=%@&", key, jsonInfo[key]];
    }
    // 收尾(去掉最后一个&)
    NSString* newStr = [str substringToIndex:[str length] - 1];
    return newStr;
}

// 远程读取json文件
+(void)getJsonFromServer:(NSString*)url
{
    
}

// 获取当前屏幕显示的viewcontroller
+(UIViewController*)getCurrentVC
{
    UIViewController* result = nil;
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray* windows = [[UIApplication sharedApplication] windows];
        for(UIWindow* tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView* frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    return result;
}

// 当前是否是横屏
+(BOOL)isHorizontal
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft)
    {
        // 当前横屏
        return true;
    }
    else
    {
       // 当前竖屏
        return false;
    }
}

// 获取设备id
+(NSString*)getAdvertisingId
{
    NSString* advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return advertisingId;
}

// 打开自带浏览器
+(void)openURL:(NSString*)url
{
    NSURL* str = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:str options:@{} completionHandler:nil];
}

// 判断字典中是否有值
+(id)isContains:(NSMutableDictionary*)dictionary andKey:(NSString*)key
{
    Class objectType = [dictionary class];
    NSString* className = NSStringFromClass(objectType);
    oneSDKBranchLogUtils(@"Object type: %@, objectType is %@", className, dictionary);
    
    if ([className isEqualToString:@"OS_dispatch_data"])
    {
        oneSDKBranchLogUtils(@"报错");
        [oneSDKBranchToastUtils show:[oneSDKBranchUtils getDataFromBundleJson:@"noDictionary"] duration:2.0f];
        return @"";
    }
    
    if ([[dictionary allKeys] containsObject:key])
    {
        return [dictionary objectForKey:key];
    }
    else
    {
        NSString* msg = [key stringByAppendingString:@" is null"];
        [oneSDKBranchToastUtils show:msg duration:2.0f];
        oneSDKBranchLogUtils(@"msg is %@", msg);
        return @"";
    }
}

// 字符串中是否包含指定字符
+(Boolean)isContainStr:(NSString*)str andSpecify:(NSString*)specify
{
    if (str.length == 0)
    {
        return false;
    }
    
    if (specify.length == 0)
    {
        return false;
    }
    
    return [str rangeOfString:specify].location != NSNotFound;
}

// 将字符串以指定字符倒序
+(NSString*)reverseOrder:(NSString*)str andDelimiter:(NSString*)delimiter;
{
    if (str.length == 0)
    {
        return @"";
    }
    
    if (delimiter.length == 0)
    {
        return @"";
    }
    
    NSArray* components = [str componentsSeparatedByString:delimiter];
    NSArray* reversedComponents = [[components reverseObjectEnumerator] allObjects];
    return [reversedComponents componentsJoinedByString:delimiter];
}

// id转字符串, 主要是防止崩溃
+(NSString*)toNSString:(id)obj
{
    NSString* str = [NSString stringWithFormat:@"%@", obj];
    return str;
}

// 从父view移除子view
+(void)removeViewWithTag:(NSInteger)tag fromSuperview:(UIView*)superview
{
    for (UIView* subview in superview.subviews)
    {
        if (subview.tag == tag)
        {
            [subview removeFromSuperview];
            break;
        }
    }
}

// 字符串rsa加密
+(NSString*)encryptByPublicKey:(NSString*)str
{
    if (str.length == 0)
    {
        return @"";
    }
    
    NSString* emoticon = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSString* path = [emoticon stringByAppendingPathComponent:@"ios_pkcs8_rsa_public_key.der"];
    
    oneSDKBranchLogUtils(@"encryptByPublicKey path is %@", path);
    
//    NSString* path = [oneSDKBranchUtils getPathFromBundle:@"ios_pkcs8_rsa_public_key.der"];
    return [oneSDKBranchRSAUtils encryptString:str publicKeyWithContentsOfFile:path];
}

@end
