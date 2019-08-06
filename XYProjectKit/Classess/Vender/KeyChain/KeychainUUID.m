//
//  KeychainUUID.m
//  KeychainUUID
//
//  Created by Qixin on 14/12/18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "KeychainUUID.h"
#import "KeychainHelper.h"
@import AdSupport;

#define kIsStringValid(text) (text && text!=NULL && text.length>0)



@implementation KeychainUUID


+ (void)deleteUUID
{
    [KeychainHelper delete:UUID_STRING];
}

+ (NSString*)UUID
{
    //读取keychain的缓存
    NSString *deviceID = [KeychainUUID getUUIDString];
    if (kIsStringValid(deviceID))
    {
        return deviceID;
    }
    else
    {
        //生成UUID
        deviceID = [KeychainUUID getUUID];
        [KeychainUUID setUUIDString:deviceID];
        if (kIsStringValid(deviceID))
        {
            return deviceID;
        }
    }
    return nil;
}

#pragma mark - Keychain
+ (NSString*)getUUIDString
{
    NSString *idfaStr = [KeychainHelper load:UUID_STRING];
    if (kIsStringValid(idfaStr))
    {
        return idfaStr;
    }
    else
    {
        return nil;
    }
}

+ (BOOL)setUUIDString:(NSString *)secValue
{
    if (kIsStringValid(secValue))
    {
        [KeychainHelper save:UUID_STRING data:secValue];
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UUID
+ (NSString*)getUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuid_string_ref= CFUUIDCreateString(kCFAllocatorDefault, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    if (!kIsStringValid(uuid))
    {
        uuid = @"";
    }
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}


@end
