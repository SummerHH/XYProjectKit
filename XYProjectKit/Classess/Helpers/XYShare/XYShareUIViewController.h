//
//  XYShareUIViewController.h
//  fula
//
//  Created by cby on 2017/4/24.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UShareUI/UShareUI.h>

@interface XYShareUIViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *shareImage;
/**
 * 背景为分享的图片
 */
- (instancetype)initWithFromImage:(UIImage *)fromImage completionHandle:(UMSocialRequestCompletionHandler)completion;
/**
 * 背景为分享的父视图
 */
- (instancetype)initWithFromView:(UIView *)snapshotView completionHandle:(UMSocialRequestCompletionHandler)completion;
/**
 *  设置父视图
 */
- (void)setFromVcImageByVc:(UIView *)snapshotView;
/**
 *  分享图回调
 */
- (void)setCompletionHandle:(UMSocialRequestCompletionHandler)completion;

@end
