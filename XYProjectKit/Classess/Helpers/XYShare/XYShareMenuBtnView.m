//
//  XYShareMenuBtnView.m
//  LeRongRong
//
//  Created by xiaoye on 2018/10/25.
//  Copyright © 2018 Rong Zheng De. All rights reserved.
//

#import "XYShareMenuBtnView.h"

@implementation XYShareMenuBtnView

- (instancetype)initWithFrame:(CGRect)frame {
   
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.clipsToBounds = NO;
    [self addSubview:self.btnImageView];
    [self addSubview:self.btnTitleLabel];
    [self addSubview:self.sendViewButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.btnImageView.mas_width);
    }];
    
    [self.btnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnImageView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.sendViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark ******  lazy  *******

- (void)sendViewButtonClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendViewButtonClickCallblack:)]) {
        
        [self.delegate sendViewButtonClickCallblack:sender];
    }
}

- (UIImageView *)btnImageView {

    if (!_btnImageView) {
        _btnImageView = [[UIImageView alloc] init];
    }
    return _btnImageView;
}

- (UILabel *)btnTitleLabel {
    if (!_btnTitleLabel) {
        _btnTitleLabel = [[UILabel alloc] init];
        _btnTitleLabel.textColor = [UIColor whiteColor];
        _btnTitleLabel.textAlignment = NSTextAlignmentCenter;
        _btnTitleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _btnTitleLabel;
}

- (UIButton *)sendViewButton {
    if (!_sendViewButton) {
        _sendViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendViewButton addTarget:self action:@selector(sendViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sendViewButton;
}

@end
