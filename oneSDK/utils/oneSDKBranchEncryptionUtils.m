//
//  oneSDKEncryptionUtils.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKBranchEncryptionUtils.h"

@implementation oneSDKBranchEncryptionUtils

+(NSString*)getSHA256tr:(NSString*)str
{
    const char* cStr = [str UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString* ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x", result[i]];
    }
    ret = (NSMutableString*)[ret uppercaseString];
    
    NSString* newStr = ret.lowercaseString;
    return newStr;
}

@end
