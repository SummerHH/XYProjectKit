//
//  NSObject+XYSwizzle.m
//  fula
//
//  Created by cby on 16/9/8.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "NSObject+XYSwizzle.h"

@implementation NSObject (XYSwizzle)

+ (void)swizzleOriSelector:(SEL)origSelector
               withNewSelector:(SEL)newSelector {

    Class class = [self class];
    Method origMethod = class_getInstanceMethod(class, origSelector);
    Method newMethod = nil;
    // 类方法就获取类方法，如果是实例方法获取实例方法
    if (!origMethod) {
        origMethod = class_getClassMethod(class, origSelector);
        if (!origMethod) {
            return;
        }
        newMethod = class_getClassMethod(class, newSelector);
        if (!newMethod) {
            return;
        }
    }else{
        newMethod = class_getInstanceMethod(class, newSelector);
        if (!newMethod) {
            return;
        }
    }
    //自身已经有了就添加,不成功，直接交换即可
    if(class_addMethod(class, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){

        class_replaceMethod(class, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{

        method_exchangeImplementations(origMethod, newMethod);
    }
}

- (void)swizzleOriSelector:(SEL)origSelector withNewSelector:(SEL)newSelector {

    Class cls = [self class];
    [cls swizzleOriSelector:origSelector withNewSelector:newSelector];
}
@end
