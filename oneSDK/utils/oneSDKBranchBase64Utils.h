//
//  oneSDKBase64Utils.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchBase64Utils : NSObject

// base64加密
+(NSString*)encode:(NSString*)str;

// base64解密
+(NSString*)decode:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
