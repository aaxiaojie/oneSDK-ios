//
//  RSAUtils.m
//  oneSDKDemo
//
//  Created by 天下 on 2024/8/14.
//

#import "./oneSDKBranchRSAUtils.h"

@implementation oneSDKBranchRSAUtils

static NSString* base64_encode_data(NSData* data)
{
    data = [data base64EncodedDataWithOptions:0];
    NSString* ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData* base64_decode(NSString* str)
{
    NSData* data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

// 加密
+(NSString*)encryptString:(NSString*)str publicKeyWithContentsOfFile:(NSString*)path
{
    if (!str || !path)
    {
        return NULL;
    }
    return [self encryptString:str publicKeyRef:[self getPublicKeyRefWithContentsOfFile:path]];
}

// 获取公钥
+(SecKeyRef)getPublicKeyRefWithContentsOfFile:(NSString*)filePath
{
    NSData* certData = [NSData dataWithContentsOfFile:filePath];
    if (!certData)
    {
        return NULL;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL)
    {
        policy = SecPolicyCreateBasicX509();
        if (policy)
        {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr)
            {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr)
                {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}

+(NSString*)encryptString:(NSString*)str publicKeyRef:(SecKeyRef)publicKeyRef
{
    if(![str dataUsingEncoding:NSUTF8StringEncoding])
    {
        return NULL;
    }
    if(!publicKeyRef)
    {
        return NULL;
    }
    
    NSData* data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:publicKeyRef];
    NSString* ret = base64_encode_data(data);
    return ret;
}
 
// 解密
+(NSString*)decryptString:(NSString*)str privateKeyWithContentsOfFile:(NSString*)path password:(NSString*)password
{
    if (!str || !path)
    {
        return NULL;
    }
    
    if (!password)
    {
        password = @"";
    }
    return [self decryptString:str privateKeyRef:[self getPrivateKeyRefWithContentsOfFile:path password:password]];
}

// 获取私钥
+(SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString*)filePath password:(NSString*)password
{
    NSData* p12Data = [NSData dataWithContentsOfFile:filePath];
    if (!p12Data)
    {
        return NULL;
    }
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0)
    {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr)
        {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}

+(NSString*)decryptString:(NSString*)str privateKeyRef:(SecKeyRef)privKeyRef
{
    NSData* data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!privKeyRef)
    {
        return NULL;
    }
    data = [self decryptData:data withKeyRef:privKeyRef];
    NSString* ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

// 使用公钥字符串加密
+(NSString*)encryptString:(NSString*)str publicKey:(NSString*)pubKey
{
    NSData* data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString* ret = base64_encode_data(data);
    return ret;
}

+(NSData*)encryptData:(NSData*)data publicKey:(NSString*)pubKey
{
    if(!data || !pubKey)
    {
        return NULL;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef)
    {
        return NULL;
    }
    return [self encryptData:data withKeyRef:keyRef];
}

+(SecKeyRef)addPublicKey:(NSString*)key
{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    
    if(spos.location != NSNotFound && epos.location != NSNotFound)
    {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    NSData* data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data)
    {
        return NULL;
    }

    NSString* tag = @"RSAUtil_PubKey";
    NSData* d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    NSMutableDictionary* publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);

    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id) kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnPersistentRef];

    CFTypeRef persistKey = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != NULL)
    {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem))
    {
        return NULL;
    }

    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    SecKeyRef keyRef = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef*)&keyRef);
    if(status != noErr)
    {
        return NULL;
    }
    return keyRef;
}

+(NSData*)stripPublicKeyHeader:(NSData*)d_key
{
    if (d_key == NULL)
    {
        return NULL;
    }

    unsigned long len = [d_key length];
    if (!len)
    {
        return NULL;
    }

    unsigned char* c_key = (unsigned char*)[d_key bytes];
    unsigned int  idx     = 0;

    if (c_key[idx++] != 0x30)
    {
        return NULL;
    }

    if (c_key[idx] > 0x80)
    {
        idx += c_key[idx] - 0x80 + 1;
    }
    else
    {
        idx++;
    }

    static unsigned char seqiod[] = { 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15))
    {
        return NULL;
    }

    idx += 15;

    if (c_key[idx++] != 0x03)
    {
        return NULL;
    }

    if (c_key[idx] > 0x80)
    {
        idx += c_key[idx] - 0x80 + 1;
    }
    else
    {
        idx++;
    }

    if (c_key[idx++] != '\0')
    {
        return NULL;
    }

    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+(NSData*)encryptData:(NSData*)data withKeyRef:(SecKeyRef)keyRef
{
    const uint8_t* srcbuf = (const uint8_t*)[data bytes];
    size_t srclen = (size_t)data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef)* sizeof(uint8_t);
    void* outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;

    NSMutableData* ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size)
    {
        size_t data_len = srclen - idx;
        if(data_len > src_block_size)
        {
            data_len = src_block_size;
        }

        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef, kSecPaddingPKCS1, srcbuf + idx, data_len, outbuf, &outlen);
        if (status != 0)
        {
            ret = NULL;
            break;
        }
        else
        {
            [ret appendBytes:outbuf length:outlen];
        }
    }

    free(outbuf);
    CFRelease(keyRef);
    return ret;
}
 
// 使用私钥字符串解密
+(NSString*)decryptString:(NSString*)str privateKey:(NSString*)privKey
{
    if (!str)
    {
        return NULL;
    }
    NSData* data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data privateKey:privKey];
    NSString* ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+(NSData*)decryptData:(NSData*)data privateKey:(NSString*)privKey
{
    if(!data || !privKey)
    {
        return NULL;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef)
    {
        return NULL;
    }
    return [self decryptData:data withKeyRef:keyRef];
}

+(SecKeyRef)addPrivateKey:(NSString*)key
{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound)
    {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    NSData* data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data)
    {
        return NULL;
    }

    NSString* tag = @"RSAUtil_PrivKey";
    NSData* d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    NSMutableDictionary* privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);

    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id) kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnPersistentRef];

    CFTypeRef persistKey = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != NULL)
    {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) 
    {
        return NULL;
    }

    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    SecKeyRef keyRef = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef*)&keyRef);
    if(status != noErr)
    {
        return NULL;
    }
    return keyRef;
}

+(NSData*)stripPrivateKeyHeader:(NSData*)d_key
{
    if (d_key == NULL)
    {
        return NULL;
    }

    unsigned long len = [d_key length];
    if (!len)
    {
        return NULL;
    }

    unsigned char* c_key = (unsigned char*)[d_key bytes];
    unsigned int idx = 22;

    if (0x04 != c_key[idx++])
    {
        return NULL;
    }

    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det)
    {
        c_len = c_len & 0x7f;
    }
    else
    {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len)
        {
            return NULL;
        }
        unsigned int accum = 0;
        unsigned char* ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount)
        {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }

    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+(NSData*)decryptData:(NSData*)data withKeyRef:(SecKeyRef) keyRef
{
    const uint8_t* srcbuf = (const uint8_t*)[data bytes];
    size_t srclen = (size_t)data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8* outbuf = malloc(block_size);
    size_t src_block_size = block_size;

    NSMutableData* ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size)
    {
        size_t data_len = srclen - idx;
        if(data_len > src_block_size)
        {
            data_len = src_block_size;
        }

        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef, kSecPaddingNone, srcbuf + idx, data_len, outbuf, &outlen);
        if (status != 0)
        {
            ret = NULL;
            break;
        }
        else
        {
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for (int i = 0; i < outlen; i++)
            {
                if ( outbuf[i] == 0 )
                {
                    if (idxFirstZero < 0)
                    {
                        idxFirstZero = i;
                    }
                    else
                    {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            [ret appendBytes:&outbuf[idxFirstZero + 1] length:idxNextZero-idxFirstZero - 1];
        }
    }

    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

@end
