//
//  XYCardNoFormatter.h
//  fula
//
//  Created by xiyedev on 2017/9/30.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XYCardNoFormatter : NSObject

/**
 *  默认为4，即4个数一组 用空格分隔
 */
@property (assign, nonatomic) NSInteger groupSize;

/**
 *  分隔符 默认为空格
 */
@property (copy, nonatomic) NSString *separator;

- (void)bankNoField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */

- (NSString *)groupedString:(NSString *)string;

@end
