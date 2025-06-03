//
//  RSAUtils.h
//  oneSDKDemo
//
//  Created by 天下 on 2024/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchRSAUtils : NSObject

+(NSString*)encryptString:(NSString*)str publicKeyWithContentsOfFile:(NSString*)path;
+(NSString*)decryptString:(NSString*)str privateKeyWithContentsOfFile:(NSString*)path password:(NSString*)password;
+(NSString*)encryptString:(NSString*)str publicKey:(NSString*)pubKey;
+(NSString*)decryptString:(NSString*)str privateKey:(NSString*)privKey;

@end

NS_ASSUME_NONNULL_END
