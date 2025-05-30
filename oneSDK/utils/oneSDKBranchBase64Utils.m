//
//  oneSDKBase64Utils.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchBase64Utils.h"

@implementation oneSDKBranchBase64Utils

// base64加密
+(NSString*)encode:(NSString*)str;
{
    NSData* data =[str dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64Str = [data base64EncodedStringWithOptions:0];
    return base64Str;
}

// base64解密
+(NSString*)decode:(NSString*)str;
{
    NSData* data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString* dStr  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return dStr;
}

@end
