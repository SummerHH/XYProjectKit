//
//  XYCalendarCollectionViewCell.h
//  fula
//
//  Created by 叶炯 on 2018/1/8.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapContentBtnBlock)(UIButton *sender);
@interface XYCalendarCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (nonatomic, copy) tapContentBtnBlock tapContentBtnBlock;

@end
