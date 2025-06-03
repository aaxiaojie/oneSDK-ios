//
//  oneSDKBranchHttpManager.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchHttpManager.h"

@implementation oneSDKBranchHttpManager

// 单例模式
+(instancetype)getInstance
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// get请求(urlString连接地址、成功回调(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)、失败回调)
-(void)get:(NSString*)urlString successBlock:(SuccessBlock)success FailBlock:(failBlock)fail
{
    NSMutableString* str = [[NSMutableString alloc] init];
    urlString = [NSString stringWithFormat:@"%@?%@", urlString, str];
    // 截取字符串的方法
    urlString = [urlString substringToIndex:urlString.length - 1];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];

    // 2. 发送网络请求
    // completionHandler:说明网络请求完成
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error)
    {
        // 网络请求成功
        if (data && !error)
        {
            // 查看data是否是JSON数据
            // JSON解析
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            // 如果obj能够解析, 说明就是JSON
            if (!obj)
            {
                obj = data;
            }

            // 成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    success(obj, response);
                }
            });
        }
        else // 失败
        {
            // 失败回调
            if (fail)
            {
                fail(error);
            }
        }
    }] resume];
}

// post请求(urlString连接地址、参数(字典类型)、成功回调(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)、失败回调)
-(void)post:(NSString*)urlString Params:(NSMutableDictionary*)params successBlock:(SuccessBlock)success FailBlock:(failBlock)fail
{
//    NSString* str = [oneSDKBranchUtils jsonErgodic:params];
//    NSData* bodyData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData* bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//    NSData* bodyData = [NSJSONSerialization dataWithJSONObject:str options:NSJSONWritingPrettyPrinted error:nil];
    oneSDKBranchLogUtils(@"postManager url is %@, params is %@", urlString, params);
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];

    // 1. 设置请求方法
    request.HTTPMethod = @"POST";
    // 2. 设置请求体
    request.HTTPBody = bodyData;
    // 3. 发送网络请求
    // completionHandler:说明网络请求完成
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error)
    {
        // 网络请求成功
        if (data && !error)
        {
            // 查看data是否是JSON数据
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            // 如果obj能够解析, 说明就是JSON
            if (!obj)
            {
                obj = data;
            }

            // 成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    success(obj, response);
                }
            });
        }
        else // 失败
        {
            // 失败回调
            if (fail)
            {
                fail(error);
            }
        }
    }] resume];
}

// post请求(urlString连接地址、参数(字符串类型)、成功回调(如果是JSON, 那么直接解析成OC中的数组或者字典; 如果不是JSON, 直接返回NSData)、失败回调)
-(void)post:(NSString*)urlString NSStringParams:(NSString*)nSStringParams successBlock:(SuccessBlock)success FailBlock:(failBlock)fail
{
    NSData* bodyData = [nSStringParams dataUsingEncoding:NSUTF8StringEncoding];
    oneSDKBranchLogUtils(@"postManager url is %@, params is %@", urlString, nSStringParams);
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];

    // 1. 设置请求方法
    request.HTTPMethod = @"POST";
    // 2. 设置请求体
    request.HTTPBody = bodyData;
    // 3. 发送网络请求
    // completionHandler:说明网络请求完成
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error)
    {
        // 网络请求成功
        if (data && !error)
        {
            // 查看data是否是JSON数据
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            // 如果obj能够解析, 说明就是JSON
            if (!obj)
            {
                obj = data;
            }

            // 成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    success(obj, response);
                }
            });
        }
        else // 失败
        {
            // 失败回调
            if (fail)
            {
                fail(error);
            }
        }
    }] resume];
}

@end
