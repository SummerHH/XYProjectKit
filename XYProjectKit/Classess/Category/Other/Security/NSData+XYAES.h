//
//  NSData+XYAES.h
//  fula
//
//  Created by xiaoye on 2018/2/24.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (XYAES)

//加密
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

//解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

// 转换为 16 进制字符串
- (NSString *)hexStringFromData;

// 16 进制转换为 data
+ (NSData*)dataForHexString:(NSString*)hexString;

@end
