//
//  XYNewFeatureCollectionViewCell.m
//  fula
//
//  Created by xiyedev on 2017/8/7.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYNewFeatureCollectionViewCell.h"
#import "XYBaseTabBarViewController.h"
#import "XYBaseNavigationViewController.h"

@interface XYNewFeatureCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *startButton;

@property (nonatomic, weak) UIButton *passButton;

@end

@implementation XYNewFeatureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.passButton.hidden = YES;
    }
    return self;
}

// 布局子控件的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    // 开始按钮
    self.startButton.center = CGPointMake(self.width * 0.5, kScreenHeight - 70.0f);
    
    // 跳过按钮
    self.passButton.center = CGPointMake(self.width * 0.87, self.height * 0.08);
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    
    if (indexPath.row == count - 1) {
        // 最后一页,显示分享和开始按钮
        self.startButton.hidden = NO;
        
    }else{
        // 非最后一页，隐藏分享和开始按钮
        self.startButton.hidden = YES;
    }
}

- (void)startButtonClick:(UIButton *)sender {

    //存入版本号
    [USER_DEFAULT setObject:kAppVersion forKey:kCurrentVersionKey];
    [USER_DEFAULT synchronize];
    
    XYBaseTabBarViewController *tabBarController = [[XYBaseTabBarViewController alloc] init];
    tabBarController.tabBar.translucent = NO;

    typedef void (^Animation)(void);
    UIWindow* window = self.window;
    tabBarController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [UIView transitionWithView:window
                      duration:1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        
                        window.rootViewController = [[XYBaseNavigationViewController alloc] initWithRootViewControllerNoWrapping:tabBarController];
                        [UIView setAnimationsEnabled:oldState];
                    } completion:nil];
}

- (UIButton *)startButton {
    if (!_startButton) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.frame = CGRectMake((kScreenWidth - 180)/2, kScreenHeight - 70.0f, 180.0f, 56.0f);
        [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [startBtn setTitleColor:RGBACOLOR(185, 206, 235, 1.0f) forState:UIControlStateNormal];
        startBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
        startBtn.layer.borderWidth = 1.0f;
        startBtn.layer.borderColor = RGBACOLOR(185, 206, 235, 1.0f).CGColor;
        [startBtn setCircle];
        [startBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        _startButton = startBtn;
    }
    return _startButton;
}

- (UIButton *)passButton{

    if (!_passButton) {
        UIButton *passBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        passBtn.frame=CGRectMake(0, 0, 70, 25);
        [passBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [passBtn setBackgroundColor:[UIColor redColor]];
        [passBtn sizeToFit];
        [passBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:passBtn];
        _passButton = passBtn;
    }
    return _passButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView = imageV;
        [self.contentView addSubview:imageV];
    }
    return _imageView;
}


@end
