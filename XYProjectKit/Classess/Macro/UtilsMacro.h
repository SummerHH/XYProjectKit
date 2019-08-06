//
//  UtilsMacro.h
//  fula
//
//  Created by xiaoye on 2018/2/24.
//  Copyright © 2018年 ixiye company. All rights reserved.
//


/**
 *  本类放一些方便使用的宏定义
 */

//定义是否是刘海屏 default NO
static inline BOOL isIPhoneNotchScreen() {
    if (@available(iOS 11.0, *)) {
        CGFloat iPhoneNotchDirectionSafeAreaInsets = 0;
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
        } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.left;
        } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.right;
        } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.bottom;

        } else {
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
        }
        return iPhoneNotchDirectionSafeAreaInsets > 20;
    } else {
        return NO;
    }
}

// 忽略警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


/******* 归档解档 *******/
#define HDCodingImplementation                              \
- (void)encodeWithCoder:(NSCoder *)aCoder {                 \
unsigned int count = 0;                                     \
Ivar *ivars = class_copyIvarList([self class], &count);     \
for (int i = 0; i < count; i++) {                           \
Ivar ivar = ivars[i];                                       \
const char *name = ivar_getName(ivar);                      \
NSString *key = [NSString stringWithUTF8String:name];       \
id value = [self valueForKey:key];                          \
[aCoder encodeObject:value forKey:key];                     \
}                                                           \
free(ivars);                                                \
}                                                           \
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder {         \
if (self = [super init]) {                                  \
unsigned int count = 0;                                     \
Ivar *ivars = class_copyIvarList([self class], &count);     \
for (int i = 0; i < count; i++) {                           \
Ivar ivar = ivars[i];                                       \
const char *name = ivar_getName(ivar);                      \
NSString *key = [NSString stringWithUTF8String:name];       \
id value = [aDecoder decodeObjectForKey:key];               \
[self setValue:value forKey:key];                           \
}                                                           \
free(ivars);                                                \
}                                                           \
return self;                                                \
}
/******* 归档解档 *******/


