//
//  oneSDKBranchHttpManager.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

#import "./../utils/oneSDKBranchUtils.h"
#import "./../utils/oneSDKBranchLogUtils.h"

NS_ASSUME_NONNULL_BEGIN

// 成功回调类型(object(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)
typedef void(^SuccessBlock)(id object, NSURLResponse* response);
// 失败回调类型(NSError error)
typedef void(^failBlock)(NSError* error);

@interface oneSDKBranchHttpManager : NSObject

// 单例模式
+(instancetype)getInstance;

// get请求(urlString连接地址、成功回调(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)、失败回调)
-(void)get:(NSString*)urlString successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;
// post请求(urlString连接地址、参数(字典类型)、成功回调(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)、失败回调)
-(void)post:(NSString*)urlString Params:(NSMutableDictionary*)params successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;
// post请求(urlString连接地址、参数(字符串类型)、成功回调(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)、失败回调)
-(void)post:(NSString*)urlString NSStringParams:(NSString*)nSStringParams successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;

@end

NS_ASSUME_NONNULL_END
