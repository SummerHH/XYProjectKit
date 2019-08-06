//
//  KeychainIDFA.h
//  KeychainIDFA
//
//  Created by Qixin on 14/12/18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置你idfa的Keychain标示,该标示相当于key,而你的IDFA是value
#define UUID_STRING @"com.ixiye.fula.UUID"

@interface KeychainUUID : NSObject

//获取UUID
+ (NSString*)UUID;

//删除keychain的IDFA(一般不需要)
+ (void)deleteUUID;

@end
