//
//  XYAlertSheetView.h
//  XYAlertViewDemo
//
//  Created by 叶炯 on 2017/12/23.
//  Copyright © 2017年 ixiyedev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYHelpMacro.h"


typedef NS_ENUM(NSInteger, XYAlertSheetViewBackgroundStyle) {
    
    XYAlertViewBackgroundStyleSolid = 0,         // 平面的
    XYAlertViewBackgroundStyleGradient           // 聚光的
};

typedef NS_ENUM(NSInteger, XYSheetViewCancelButtonType) {
    XYAlertViewButtonTypeDefault = 0,
    XYAlertViewButtonTypeDestructive,
    XYAlertViewButtonTypeCancel
};

@class XYAlertSheetView;

typedef void(^XYAlertViewHandler)(XYAlertSheetView *alertSheetView,NSInteger buttonIndex);

@interface XYAlertSheetView : UIView

/** 默认是 XYAlertViewBackgroundStyleSolid */
@property (nonatomic, assign) XYAlertSheetViewBackgroundStyle backgroundStyle;
/** 只针对取消按钮有用*/
@property (nonatomic, assign) XYSheetViewCancelButtonType buttonType;
/** 取消按钮的回调 */
@property (nonatomic, copy) XYAlertViewHandler cancelHandler;
/** 默认点击按钮回调 */
@property (nonatomic, copy) XYAlertViewHandler defulHandler;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  显示弹窗提示
 */
- (void)show;

/**
 *  移除视图
 */
- (void)removeAlertView;

/**
 * 快速创建
 * @param title 标题
 * @param cancelButtonTitle 取消按钮文字
 * @param otherButtonTitles 其他按钮
 * @param otherButtonImages 按钮图片
 * @param block 回调 取消的索引为 0
 * @return 返回XYAlertView对象
 */

+ (XYAlertSheetView *)showAlertViewWithTitle:(NSString *)title
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonImages:(NSArray <NSString *>*)otherButtonImages
                 otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                           handler:(void (^)(XYAlertSheetView *alertView, NSInteger buttonIndex))block;



/**
 * 快速弹窗
 * @param title 标题
 * @param cancelButtonTitle 取消按钮文字
 * @param otherButtonTitles 其他按钮
 * @param block 回调 取消的索引为 0 
 * @return 返回XYAlertView对象
 */

+ (XYAlertSheetView *)showAlertViewWithTitle:(NSString *)title
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                                     handler:(void (^)(XYAlertSheetView *alertView, NSInteger buttonIndex))block;

@end


