//
//  NSObject+XYSwizzle.h
//  fula
//
//  Created by cby on 16/9/8.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XYSwizzle)

+ (void)swizzleOriSelector:(SEL)origSelector
                withNewSelector:(SEL)newSelector;

- (void)swizzleOriSelector:(SEL)origSelector
           withNewSelector:(SEL)newSelector;

@end
