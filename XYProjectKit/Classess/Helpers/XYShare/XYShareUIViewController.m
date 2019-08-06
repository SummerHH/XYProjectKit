//
//  XYShareUIViewController.m
//  fula
//
//  Created by cby on 2017/4/24.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYShareUIViewController.h"
#import "XYShareDismissAnimation.h"
#import "XYShareHelp.h"
#import "XYSharePresentAnimation.h"
#import "WKWebView+TYSnapshot.h"
#import "UIScrollView+TYSnapshot.h"
#import "UIImageView+LBBlurredImage.h"

@interface XYShareUIViewController () 

@property (strong, nonatomic) UIImage *fromVCImage;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (assign, nonatomic) CGFloat buttonWidth;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *closeButton;
@property (copy, nonatomic) UMSocialRequestCompletionHandler completion;

@end

@implementation XYShareUIViewController

- (instancetype)initWithFromImage:(UIImage *)fromImage completionHandle:(UMSocialRequestCompletionHandler)completion {

    if (self = [super init]) {
        self.fromVCImage = fromImage;
        [self setCompletion:completion];

    }
    return self;
}

- (instancetype)initWithFromView:(UIView *)snapshotView completionHandle:(UMSocialRequestCompletionHandler)completion {
    self = [super init];
    if(self) {
        [self setFromVcImageByVc:snapshotView];
        [self setCompletion:completion];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"分享";
    self.buttonWidth = 2 * (kScreenWidth - 75) / 9;
    if(self.buttonWidth > 60) {
        self.buttonWidth = 60.0f;
    }
    self.imageView.image = self.shareImage;
    
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = self.fromVCImage;
    [self.bgImageView setImageToBlur:self.fromVCImage blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    self.bgImageView.userInteractionEnabled = YES;
    self.transitioningDelegate = self;
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.imageView];
    [self.bgImageView addSubview:self.scrollView];
    [self.bgImageView addSubview:self.closeButton];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAc)];
    [self.view addGestureRecognizer:tapGr];
    
    [self layoutPageSubviews];
    [self buildButtons];
}

- (void)layoutPageSubviews {
    
    CGFloat imageViewHeight = (kScreenWidth - 160) * kScreenHeight / kScreenWidth;
    CGFloat scrollViewWidth = _buttonWidth * 5 + 90;
    if(scrollViewWidth > kScreenWidth)
        scrollViewWidth = kScreenWidth;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(80);
        make.right.equalTo(self.view).offset(-80);
        make.top.equalTo(self.view).offset(kScreenHeight * 0.14);
        make.height.mas_equalTo(imageViewHeight);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self->_buttonWidth + 16);
        make.width.mas_equalTo(scrollViewWidth);
        make.top.equalTo(self.imageView.mas_bottom).offset(kScreenHeight * 0.04);
        make.centerX.equalTo(self.view);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(self.scrollView.mas_bottom).offset(kScreenHeight * 0.07);
        make.centerX.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)buildButtons {
    NSArray *buttonTitles = @[@"微信", @"微信朋友圈", @"QQ空间", @"QQ",];
    NSArray *buttonImageName = @[@"share_WeiChat", @"share_WeiChatline", @"share_QQZone", @"share_QQ"];
    UIView *lastButton;
    for (int i = 0; i < buttonImageName.count; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = _buttonWidth / 2;
        [self.scrollView addSubview:bgView];
        if(!lastButton) {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(self->_buttonWidth, self->_buttonWidth));
                make.left.equalTo(self.scrollView).offset(15);
                make.centerY.equalTo(self.scrollView);
            }];
        } else {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(self->_buttonWidth, self->_buttonWidth));
                make.left.equalTo(lastButton.mas_right).offset(15);
                make.centerY.equalTo(self.scrollView);
            }];
        }
        
        NSString *title = buttonTitles[i];
        NSString *imageName = buttonImageName[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;

        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        lastButton = bgView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = SYSTEMFONT(11.0f);
        titleLabel.text = title;
    }
    self.scrollView.contentSize = CGSizeMake(_buttonWidth * buttonTitles.count + (buttonTitles.count + 1) * 15, _buttonWidth);
}

- (void)buttonAction:(UIButton *)sender {
    UMSocialPlatformType type;
    switch (sender.tag) {
        case 0:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            type = UMSocialPlatformType_Qzone;
            break;
        case 3:
            type = UMSocialPlatformType_QQ;
            break;
        default:
            type = UMSocialPlatformType_WechatSession;
            break;
    }
    
    [XYShareHelp shareImage:self.shareImage thumbImage:nil currentViewController:self platformType:type completion:^(id result, NSError *error) {
       
        NSLog(@"----%@---%@",result,error);
        if(self.completion) {
            self.completion(result, error);
        }
        if(error) {
            NSString *errorMsg = nil;
            switch (error.code) {
                case UMSocialPlatformErrorType_Cancel:
                    errorMsg = @"分享取消";
                    break;
                case UMSocialPlatformErrorType_ShareFailed:
                    errorMsg = @"分享失败";
                    break;
                case UMSocialPlatformErrorType_AuthorizeFailed:
                    errorMsg = @"授权失败";
                    break;
                case UMSocialPlatformErrorType_NotInstall:
                    errorMsg = @"应用未安装";
                    break;
                default:
                    errorMsg = @"分享失败";
                    break;
            }
            [MBProgressHUD showErrorMessage:errorMsg];
        } else {
            [MBProgressHUD showSuccessMessage:@"分享成功"];
        }
    }];
}

- (void)closeAc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[XYSharePresentAnimation alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[XYShareDismissAnimation alloc] init];
}

# pragma mark - setter and getter
- (UIImageView *)imageView {
    
    if(_imageView) return _imageView;
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(0, 0);
    _imageView.layer.shadowRadius = 15.0f;
    _imageView.layer.shadowOpacity = 0.3f;
    
    return _imageView;
}

- (UIScrollView *)scrollView {
    if(_scrollView) return _scrollView;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    return _scrollView;
}

- (void)setCompletionHandle:(UMSocialRequestCompletionHandler)completion {
    self.completion = completion;
}

- (UIButton *)closeButton {
    if(_closeButton) return _closeButton;
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeAc) forControlEvents:UIControlEventTouchUpInside];
    return _closeButton;
}

- (void)setFromVcImageByVc:(UIView *)snapshotView {
    
    if([snapshotView isKindOfClass:[WKWebView class]]){
        //WKWebView
        WKWebView *wkWebView = (WKWebView *)snapshotView;
        [wkWebView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil) {
                self.fromVCImage = snapShotImage;
            }
        }];
    }else if([snapshotView isKindOfClass:[UIWebView class]]){
        
        //UIWebView
        UIWebView *webView = (UIWebView *)snapshotView;
        
        [webView.scrollView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil) {
                self.fromVCImage = snapShotImage;
            }
        }];
    }else if([snapshotView isKindOfClass:[UIScrollView class]] ||
             [snapshotView isKindOfClass:[UITableView class]] ||
             [snapshotView isKindOfClass:[UICollectionView class]]
             ){
        //ScrollView
        UIScrollView *scrollView = (UIScrollView *)snapshotView;
        
        [scrollView screenSnapshot:^(UIImage *snapShotImage) {
            if (snapShotImage != nil) {
                self.fromVCImage = snapShotImage;
            }
        }];
    }else{

        UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, NO, [[UIScreen mainScreen] scale]);
        
        [snapshotView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *fromVCImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.fromVCImage = fromVCImage;
    }
}

@end
