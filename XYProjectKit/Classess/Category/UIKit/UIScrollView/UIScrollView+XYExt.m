//
//  UIScrollView+XYExt.m
//  fula
//
//  Created by cby on 2017/3/20.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "UIScrollView+XYExt.h"

@implementation UIScrollView (XYExt)

- (UIImage *)getAllImageFromScrollView
{
    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, [[UIScreen mainScreen] scale]);
    CGPoint savedContentOffset = self.contentOffset;
    CGRect savedFrame = self.frame;
    self.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self.contentOffset = savedContentOffset;
    self.frame = savedFrame;
    UIGraphicsEndImageContext();
    return image;
}

@end
