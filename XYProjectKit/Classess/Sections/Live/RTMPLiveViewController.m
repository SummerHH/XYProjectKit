//
//  RTMPLiveViewController.m
//  QiNiuLevel
//
//  Created by xiaoye on 2020/4/14.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "RTMPLiveViewController.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>

@interface RTMPLiveViewController ()

@property (nonatomic, strong) NSURL *streamURL;
@property (nonatomic, strong) PLMediaStreamingSession *streamingSession;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *cameraFlipButton;
@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *watermarkButton;
@property (nonatomic, strong) UIButton *screenshotButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *thumbsButton;


@end

@implementation RTMPLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _getStreamCloudURL];
    [self initialize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-60.0f);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.cameraFlipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.right.mas_equalTo(self.view).offset(-5);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cameraFlipButton.mas_left).offset(-5);
        make.top.mas_equalTo(self.cameraFlipButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.watermarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.beautyButton.mas_left).offset(-5);
        make.top.mas_equalTo(self.beautyButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.screenshotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.watermarkButton.mas_left).offset(-5);
        make.top.mas_equalTo(self.watermarkButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.left.mas_equalTo(5.0f);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-5.0f);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareButton);
        make.top.mas_equalTo(self.shareButton.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];

    [self.thumbsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareButton);
        make.top.mas_equalTo(self.likeButton.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];
}

- (void)initialize {
    
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    self.streamingSession = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
    
    [self.view addSubview:self.streamingSession.previewView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.cameraFlipButton];
    [self.view addSubview:self.beautyButton];
    [self.view addSubview:self.watermarkButton];
    [self.view addSubview:self.screenshotButton];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.thumbsButton];
    
}

- (void)_getStreamCloudURL {
#warning 在这里填写获取推流地址的业务服务器 url
    NSString *streamServer = @"rtmp://pili-publish.zjlrr.cn/lerongrong/app-1586845024782RhfN78ymeN?e=1586848624&token=XkofJYCcxQeXs4u1UDDJlLR78CwaRp0Judf75jqp:NMPKD_3R8Bq54cXr0TKQK41zqB8=";
    
    self.streamURL = [NSURL URLWithString:streamServer];
}

- (void)actionButtonPressed:(UIButton *)sender {
     
    if (!_streamingSession.isStreamingRunning) {
        // 开始推流
        [self.streamingSession startStreamingWithPushURL:self.streamURL feedback:^(PLStreamStartStateFeedback feedback) {
            
            NSString *log = [NSString stringWithFormat:@"session start state %lu",(unsigned long)feedback];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", log);
                sender.enabled = YES;
                if (PLStreamStartStateSuccess == feedback) {
                    [sender setImage:[UIImage imageNamed:@"Live/stop.png"] forState:UIControlStateNormal];
                } else {
                           
                    [[[UIAlertView alloc] initWithTitle:@"错误" message:@"推流失败了，将重新请求有效的URL" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil] show];
                             
                    // 重新获取有效的URL，即更换 token，播放端的地址不会变
                    //[self _generateStreamURLFromServerWithURL:_streamCloudURL];
                }
            });
        }];
    } else {
        NSLog(@"点击了结束推流");
        [_streamingSession stopStreaming];
        [sender setImage:[UIImage imageNamed:@"Live/kaishi.png"] forState:UIControlStateNormal];

    }
}

- (void)pressedChangeCameraButton:(UIButton *)sender {
    
    [_streamingSession toggleCamera];

}

- (void)pressedChangeBeautyButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    /// 是否开启美颜
    [_streamingSession setBeautifyModeOn:sender.selected];
    
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"Live/meiyan_sel.png"] forState:UIControlStateNormal];
    }else {
        [sender setImage:[UIImage imageNamed:@"Live/meiyan.png"] forState:UIControlStateNormal];
    }
}

- (void)changeWatermarkButton:(UIButton *)sender {
    /// 有无水印
    sender.selected = !sender.selected;

    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"Live/addshuiyin.png"] forState:UIControlStateNormal];
    }else {
        [sender setImage:[UIImage imageNamed:@"Live/shuiyinshezhi.png"] forState:UIControlStateNormal];
    }
}

- (void)changeScreenshotButton:(UIButton *)sender {
    
}

/// 返回
- (void)changeBackButton:(UIButton *)sender {
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:[UIImage imageNamed:@"Live/kaishi.png"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)cameraFlipButton {
    if (!_cameraFlipButton) {
        _cameraFlipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraFlipButton setImage:[UIImage imageNamed:@"Live/camera.png"] forState:UIControlStateNormal];
        [_cameraFlipButton addTarget:self action:@selector(pressedChangeCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraFlipButton;;
}

- (UIButton *)beautyButton {
    if (!_beautyButton) {
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyButton setImage:[UIImage imageNamed:@"Live/meiyan.png"] forState:UIControlStateNormal];
        [_beautyButton addTarget:self action:@selector(pressedChangeBeautyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyButton;;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"bblink_ic_nav_back_22x22_.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(changeBackButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)watermarkButton {
    if (!_watermarkButton) {
        _watermarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_watermarkButton setImage:[UIImage imageNamed:@"Live/addshuiyin.png"] forState:UIControlStateNormal];
        [_watermarkButton addTarget:self action:@selector(changeWatermarkButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watermarkButton;
}

- (UIButton *)screenshotButton {
    if (!_screenshotButton) {
        _screenshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenshotButton setImage:[UIImage imageNamed:@"Live/jietu.png"] forState:UIControlStateNormal];
        [_screenshotButton addTarget:self action:@selector(changeScreenshotButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenshotButton;;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"Live/fenxiang.png"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(changeScreenshotButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;;
}

- (UIButton *)thumbsButton {
    if (!_thumbsButton) {
        _thumbsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thumbsButton setImage:[UIImage imageNamed:@"Live/dianzan.png"] forState:UIControlStateNormal];
        [_thumbsButton addTarget:self action:@selector(changeScreenshotButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thumbsButton;;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"Live/shoucang.png"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(changeScreenshotButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;;
}
@end
