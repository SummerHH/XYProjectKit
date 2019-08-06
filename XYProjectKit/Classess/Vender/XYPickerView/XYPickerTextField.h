//
//  XYPickerTextField.h
//  XYPIckerView
//
//  Created by xiyedev on 2017/9/14.
//  Copyright © 2017年 YeJiong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XYTapAcitonBlock)(void);
typedef void(^XYEndEditBlock)(NSString *text);

@interface XYPickerTextField : UITextField

/** textField 的点击回调 */
@property (nonatomic, copy) XYTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) XYEndEditBlock endEditBlock;

@end
