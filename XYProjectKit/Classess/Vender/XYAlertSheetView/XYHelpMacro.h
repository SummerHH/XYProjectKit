//
//  XYHelpMacro.h
//  XYAlertViewDemo
//
//  Created by 叶炯 on 2017/12/25.
//  Copyright © 2017年 ixiyedev. All rights reserved.
//

#ifndef XYHelpMacro_h
#define XYHelpMacro_h


#ifndef kScreenWidth
#define kScreenWidth            ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kScreenHeight           ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#endif

#define XYFirstWindow [UIApplication sharedApplication].windows.firstObject

#define kScreenMainBounds       [UIScreen mainScreen].bounds

#define weakSelf(weakSelf) __weak typeof(self)weakSelf = self;

#define XYStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define XYArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

#endif /* XYHelpMacro_h */
