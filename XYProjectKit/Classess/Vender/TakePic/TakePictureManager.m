//
//  TakePictureManager.m
//  fula
//
//  Created by cby on 2016/12/16.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "TakePictureManager.h"
#import "XYImagePickerViewController.h"

@interface TakePictureManager () <XYImagePickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@end

@implementation TakePictureManager

- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    self = [self init];
    if(self) {
        self.sourceType = sourceType;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return self;
}

- (UIViewController *)pickerViewController {
    // 9.0 以下出现过 bug， 所以自定义实现拍照vc
    if (kAppSystemVersion <= 9.0 && self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        XYImagePickerViewController *pic = [[XYImagePickerViewController alloc]init];
        pic.delegate = self;
        return pic;
    }
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImagePickerControllerSourceType sourceType;
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法使用摄像头" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [controller addAction:cancelAction];
            
            [[UIViewController currentNavigationController] presentViewController:controller animated:YES completion:nil];
            
            return nil;
        }
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = self.sourceType;
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
    }
    picker.delegate = self;
    return picker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (![mediaType isEqualToString:@"public.image"]) {
        if([self.delegate respondsToSelector:@selector(imagePickerDidError:errorType:)])
        {
            [self.delegate imagePickerDidError:self
                                     errorType:XYTakePictureManagerErrorTypeMediaTypeError];
        }
        return;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(!image || [image isEqual:[NSNull null]])
    {
        if([self.delegate respondsToSelector:@selector(imagePickerDidError:errorType:)])
        {
            [self.delegate imagePickerDidError:self errorType:XYTakePictureManagerErrorTypeNoImage];
        }
        return;
    }
    if([self.delegate respondsToSelector:@selector(imagePickerDidPick:image:)])
    {
        [self.delegate imagePickerDidPick:self image:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   if([self.delegate respondsToSelector:@selector(imagePickerDidCancel:)])
   {
       [self.delegate imagePickerDidCancel:self];
   }
}

#pragma mark ******  XYImagePickerDelegate  *******

- (void)imagePicker:(UIImage *)image {
    if(!image || [image isEqual:[NSNull null]]) {
        if([self.delegate respondsToSelector:@selector(imagePickerDidError:errorType:)]) {
            [self.delegate imagePickerDidError:self errorType:XYTakePictureManagerErrorTypeNoImage];
        }
        return;
    }
    if([self.delegate respondsToSelector:@selector(imagePickerDidPick:image:)]) {
        [self.delegate imagePickerDidPick:self image:image];
    }
}
@end
