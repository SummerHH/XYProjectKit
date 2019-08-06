//
//  NSString+XYAES.h
//  fula
//
//  Created by xiaoye on 2018/2/24.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XYAES)

/////////////////////CBC 模式 data
// AES 加密
- (NSString *)AES128Encrypt:(NSString *)key iv:(NSString *)iv;

// AES 解密
- (NSString *)AES128Decrypt:(NSString *)key iv:(NSString *)iv;

// AES 加密
- (NSString *)AES128Encrypt;

// AES 解密
- (NSString *)AES128Decrypt;

/////////////////////CBC 模式 base64
// AES 加密
- (NSString *)AES128Base64Encrypt:(NSString *)key iv:(NSString *)iv;

// AES 解密
- (NSString *)AES128Base64Decrypt:(NSString *)key iv:(NSString *)iv;


@end
