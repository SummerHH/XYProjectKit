//
//  XYImagePickerViewController.h
//  fula
//
//  Created by cby on 2016/10/20.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYImagePickerDelegate <NSObject>

- (void)imagePicker:(UIImage *)image;

@end

@interface XYImagePickerViewController : UIViewController

@property (strong, nonatomic) id <XYImagePickerDelegate> delegate;
@end
