//
//  XYJsonConversion.h
//  LeRongRong
//
//  Created by Jiong Ye on 2018/9/26.
//  Copyright © 2018年 Rong Zheng De. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYJsonConversion : NSObject

+ (NSString*)jsonWithDictionary:(NSDictionary*)dict;
+ (NSString *)arrayToJSONString:(NSArray *)array;
//JSON字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
