//
//  TakePictureManager.h
//  fula
//
//  Created by cby on 2016/12/16.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TakePictureManager;

typedef NS_ENUM(NSInteger, XYTakePictureManagerErrorType){
    XYTakePictureManagerErrorTypeDefault,
    XYTakePictureManagerErrorTypeMediaTypeError,
    XYTakePictureManagerErrorTypeNoImage, // 返回图片为空
};

// 获取图片的回调
@protocol TakePictureManaagerDelegate <NSObject>

// 成功获取图片
- (void)imagePickerDidPick:(TakePictureManager *)manager
                     image:(UIImage *)image;
// 用户触发取消事件
- (void)imagePickerDidCancel:(TakePictureManager *)manager;
@optional
// 错误回调 一般不需要
// todo 可以和 cancel 回调合并
- (void)imagePickerDidError:(TakePictureManager *)manager
                  errorType:(XYTakePictureManagerErrorType)errorType;

@end

@interface TakePictureManager : NSObject

/**
 媒体类型
 */
@property (assign, nonatomic) UIImagePickerControllerSourceType sourceType;

/**
 回调代理
 */
@property (weak, nonatomic) id <TakePictureManaagerDelegate> delegate;

/**
 根据 sourceType 初始化 manager
 */
- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)sourceType;

/**
 返回需要的获取图片 viewController

 @return viewController
 */
- (UIViewController *)pickerViewController;

@end
