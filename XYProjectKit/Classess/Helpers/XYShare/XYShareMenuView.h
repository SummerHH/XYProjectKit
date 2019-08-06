//
//  XYShareMenuView.h
//  LeRongRong
//
//  Created by xiaoye on 2018/10/25.
//  Copyright © 2018 Rong Zheng De. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^shareMenuViewCallback)(NSInteger index);

@interface XYShareMenuView : UIView

/** (NSArray<NSDictionary *> *) {"title":"btn title","image":"btn image",...} */
+ (instancetype)alertShareMenuButtonTitleAndImages:(NSArray<NSDictionary *> *)titleAndImages columnNums:(NSInteger)columnNum completion:(shareMenuViewCallback)completion;

@property (nonatomic, assign, readonly) NSInteger columnNum;

@property (nonatomic, assign, readonly) CGFloat animateTime;


- (void)showShareMenuView;

- (void)hideShareMenuView;


@end

NS_ASSUME_NONNULL_END
