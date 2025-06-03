//
//  oneSDKKeychain.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import "./oneSDKKeychain.h"
#import "./oneSDKKeychainQuery.h"

NSString *const koneSDKKeychainErrorDomain = @"com.samsoffes.onesdkKeychain";
NSString *const koneSDKKeychainAccountKey = @"acct";
NSString *const koneSDKKeychainCreatedAtKey = @"cdat";
NSString *const koneSDKKeychainClassKey = @"labl";
NSString *const koneSDKKeychainDescriptionKey = @"desc";
NSString *const koneSDKKeychainLabelKey = @"labl";
NSString *const koneSDKKeychainLastModifiedKey = @"mdat";
NSString *const koneSDKKeychainWhereKey = @"svce";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
    static CFTypeRef oneSDKKeychainAccessibilityType = NULL;
#endif

@implementation oneSDKKeychain

+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordForService:serviceName account:account error:nil];
}


+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    oneSDKKeychainQuery *query = [[oneSDKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    return query.password;
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordDataForService:serviceName account:account error:nil];
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    oneSDKKeychainQuery *query = [[oneSDKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];

    return query.passwordData;
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    return [self deletePasswordForService:serviceName account:account error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    oneSDKKeychainQuery *query = [[oneSDKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    return [query deleteItem:error];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPassword:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    oneSDKKeychainQuery *query = [[oneSDKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.password = password;
    return [query save:error];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPasswordData:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    oneSDKKeychainQuery *query = [[oneSDKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.passwordData = password;
    return [query save:error];
}

+ (nullable NSArray *)allAccounts {
    return [self allAccounts:nil];
}


+ (nullable NSArray *)allAccounts:(NSError *__autoreleasing *)error {
    return [self accountsForService:nil error:error];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName {
    return [self accountsForService:serviceName error:nil];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error {
    oneSDKKeychainQuery *query = [[oneSDKKeychainQuery alloc] init];
    query.service = serviceName;
    return [query fetchAll:error];
}


#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
    return oneSDKKeychainAccessibilityType;
}


+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
    CFRetain(accessibilityType);
    if (oneSDKKeychainAccessibilityType) {
        CFRelease(oneSDKKeychainAccessibilityType);
    }
    oneSDKKeychainAccessibilityType = accessibilityType;
}
#endif

@end
