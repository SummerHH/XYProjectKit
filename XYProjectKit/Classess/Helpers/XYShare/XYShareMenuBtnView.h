//
//  XYShareMenuBtnView.h
//  LeRongRong
//
//  Created by xiaoye on 2018/10/25.
//  Copyright © 2018 Rong Zheng De. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XYShareMenuBtnViewDelegate <NSObject>

- (void)sendViewButtonClickCallblack:(UIButton *)sender;

@end

/**< BaseSendTextView 界面按钮 */
@interface XYShareMenuBtnView : UIView

@property (nonatomic, strong) UIImageView *btnImageView;/**< image */
@property (nonatomic, strong) UILabel *btnTitleLabel;/**< bottom title */
@property (nonatomic, strong) UIButton *sendViewButton;/**< view button */
@property (nonatomic, weak) id <XYShareMenuBtnViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
