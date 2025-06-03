//
//  oneSDKEncryptionUtils.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchEncryptionUtils : NSObject

+(NSString*)getSHA256tr:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
