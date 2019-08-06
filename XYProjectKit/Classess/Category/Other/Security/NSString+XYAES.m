//
//  NSString+XYAES.m
//  fula
//
//  Created by xiaoye on 2018/2/24.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "NSString+XYAES.h"
#import "NSData+XYAES.h"
#import "GTMBase64.h"

static NSString *const key = @"xytech1234567";
static NSString *const iv = @"123456789";

@implementation NSString (XYAES)

- (NSString *)AES128Encrypt:(NSString *)key iv:(NSString *)iv {
    if([key isEqual:[NSNull null]] || [iv isEqual:[NSNull null]])
    {
        return @"";
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:key iv:iv];
    NSLog(@"------十六进制*** %@",encryptData);
    NSString *encryptStr = [encryptData hexStringFromData];
    return encryptStr;
}

- (NSString *)AES128Decrypt:(NSString *)key iv:(NSString *)iv {
    if([key isEqual:[NSNull null]] || [iv isEqual:[NSNull null]])
    {
        return @"";
    }
    NSData *data = [NSData dataForHexString:self];
    NSData *decrypt = [data AES128DecryptWithKey:key iv:iv];
    NSString *decryptStr = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
    return decryptStr;
}

- (NSString *)AES128Base64Encrypt:(NSString *)key iv:(NSString *)iv {
    
    if([key isEqual:[NSNull null]] || [iv isEqual:[NSNull null]]) {
        return @"";
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:key iv:iv];
    NSString *encryptStr = [GTMBase64 stringByEncodingData:encryptData];
    
    return encryptStr;
}

- (NSString *)AES128Base64Decrypt:(NSString *)key iv:(NSString *)iv {
    if([key isEqual:[NSNull null]] || [iv isEqual:[NSNull null]]) {
        return @"";
    }
    NSData *data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *decrypt = [data AES128DecryptWithKey:key iv:iv];
    NSString *decryptStr = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
    return decryptStr;
}

- (NSString *)AES128Encrypt {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:key iv:iv];
    NSString *encryptStr = [encryptData hexStringFromData];
    return encryptStr;
}

- (NSString *)AES128Decrypt {
    NSData *data = [NSData dataForHexString:self];
    NSData *decrypt = [data AES128DecryptWithKey:key iv:iv];
    NSString *decryptStr = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
    return decryptStr;
}

@end
