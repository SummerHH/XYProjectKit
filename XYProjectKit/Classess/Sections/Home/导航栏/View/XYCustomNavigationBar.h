//
//  XYCustomNavigationBar.h
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCustomNavigationBar : UIView

@property (nonatomic, copy) void(^onClickLeftButton)(void);
@property (nonatomic, copy) void(^onClickRightButton)(void);

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIColor  *titleLabelColor;
@property (nonatomic, strong) UIFont   *titleLabelFont;
@property (nonatomic, strong) UIColor  *barBackgroundColor;
@property (nonatomic, strong) UIImage  *barBackgroundImage;

- (void)xy_setBottomLineHidden:(BOOL)hidden;
- (void)xy_setBackgroundAlpha:(CGFloat)alpha;
- (void)xy_setTintColor:(UIColor *)color;


- (void)xy_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)xy_setLeftButtonWithImage:(UIImage *)image;
- (void)xy_setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

- (void)xy_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)xy_setRightButtonWithImage:(UIImage *)image;
- (void)xy_setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

@end

NS_ASSUME_NONNULL_END
