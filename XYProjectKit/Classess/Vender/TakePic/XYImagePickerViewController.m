//
//  XYImagePickerViewController.m
//  自定义相机
//
//  Created by cby on 16/10/9.
//  Copyright (c) 2016年 cby. All rights reserved.
//

#import "XYImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface FocusView : UIView

@end

@implementation FocusView
- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor blackColor] set];
    [path stroke];
}
@end


@interface ShotView : UIView

@end

@implementation ShotView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[UIColor whiteColor] set];
    [path fill];
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5, 5, rect.size.width - 10, rect.size.height - 10)];
    path1.lineWidth = 1.5f;
    [[UIColor blackColor] set];
    [path1 stroke];
}
@end

@interface XYImagePickerViewController ()
{
    UIView *_focusView;
}
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//输出图片
@property (nonatomic ,strong) AVCaptureStillImageOutput *imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;

@property (strong, nonatomic) ShotView *shotView;

@end

//焦距
//static float kCameraScale=1.0;

@implementation XYImagePickerViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self cameraDistrict];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"重拍" forState:UIControlStateSelected];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(backAc:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.shotView = [[ShotView alloc] init];
    self.shotView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.shotView];
    
    [self.shotView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoBtnDidClick)];
    [self.shotView addGestureRecognizer:tapGr];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.hidden = YES;
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = self.view.bounds;
    self.imageView.hidden = YES;
    [self.view addSubview:self.imageView];
}

- (void)comfirm{
    
    if ([self.delegate respondsToSelector:@selector(imagePicker:)]) {
        [self.delegate imagePicker:self.image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backAc:(UIButton *)sender{
//    [self.session stopRunning];
    if (sender.selected) {
        
        sender.selected = NO;
        self.confirmButton.hidden = YES;
        self.shotView.hidden = NO;
        [self.imageView removeFromSuperview];
        [self.session startRunning];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_session startRunning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [_session stopRunning];
}

- (void)cameraDistrict
{
    //    AVCaptureDevicePositionBack  后置摄像头
    //    AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    //     拿到的图像的大小可以自行设定
    //    AVCaptureSessionPreset320x240
    //    AVCaptureSessionPreset352x288
    //    AVCaptureSessionPreset640x480
    //    AVCaptureSessionPreset960x540
    //    AVCaptureSessionPreset1280x720
    //    AVCaptureSessionPreset1920x1080
    //    AVCaptureSessionPreset3840x2160
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    //预览层的生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focus:)];
    [self.view addGestureRecognizer:tap];
    [self.view.layer addSublayer:self.previewLayer];
    //设备取景开始
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        //自动闪光灯，
        if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
            [_device setFlashMode:AVCaptureFlashModeOff];
        }
        //自动白平衡,但是好像一直都进不去
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}
//根据前后置拿到相应的射线头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}
//拍照拿到相应的图片
- (void)photoBtnDidClick{
    AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            NSLog(@"%@", error);
            return ;
        }
        [weakSelf.session stopRunning];
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        weakSelf.image = [UIImage imageWithData:imageData];
        [weakSelf.session stopRunning];
        weakSelf.cancelButton.selected = YES;
        weakSelf.shotView.hidden = YES;
        [weakSelf.view addSubview:weakSelf.imageView];
        
        weakSelf.confirmButton.hidden = NO;
        [weakSelf.view bringSubviewToFront:self.cancelButton];
        [weakSelf.view bringSubviewToFront:self.confirmButton];
    }];
}

- (void)focus:(UITapGestureRecognizer *)gr{
    
    CGPoint point = [gr locationInView:self.view];
    [self focusOnPoint:point];
}

//AVCaptureFlashMode  闪光灯
//AVCaptureFocusMode  对焦
//AVCaptureExposureMode  曝光
//AVCaptureWhiteBalanceMode  白平衡
//闪光灯和白平衡可以在生成相机时候设置
//曝光要根据对焦点的光线状况而决定,所以和对焦一块写
//point为点击的位置
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        //对焦模式和对焦点
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        //曝光模式和曝光点
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView = [[FocusView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _focusView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_focusView];
        //设置对焦动画
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self->_focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self->_focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self->_focusView.hidden = YES;
            }];
        }];
    }
    
}

//对某一点对焦
-(void)focusOnPoint:(CGPoint)point
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.view.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance])
            {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:pointOfInterest];
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [device setExposurePointOfInterest:pointOfInterest];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            _focusView = [[FocusView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            _focusView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_focusView];
            //设置对焦动画
            _focusView.center = point;
            _focusView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self->_focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    self->_focusView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    self->_focusView.hidden = YES;
                }];
            }];

        }
    }
}
@end
