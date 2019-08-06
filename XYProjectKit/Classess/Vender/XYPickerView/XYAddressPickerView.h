//
//  XYAddressPickerView.h
//  XYPIckerView
//
//  Created by xiyedev on 2017/9/14.
//  Copyright © 2017年 YeJiong. All rights reserved.
//

#import "XYBaseView.h"

typedef void(^XYAddressResultBlock)(NSArray *selectAddressArr);

@interface XYAddressPickerView : XYBaseView

/**
 *  显示地址选择器
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@8, @1, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调 回调的内容判断是否存在直筒市的情况
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                 resultBlock:(XYAddressResultBlock)resultBlock;

/**
 *  显示地址选择器
 *  @param isAutoSelectArea         是否展示县 区 列 默认 YES 展示
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@8, @1, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调 回调的内容判断是否存在直筒市的情况
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelectArea:(BOOL)isAutoSelectArea
                                 isAutoSelect:(BOOL)isAutoSelect
                                 resultBlock:(XYAddressResultBlock)resultBlock;

@end
