//
//  XYJsonConversion.m
//  LeRongRong
//
//  Created by Jiong Ye on 2018/9/26.
//  Copyright © 2018年 Rong Zheng De. All rights reserved.
//

#import "XYJsonConversion.h"

@interface XYJsonConversion () {
    
    NSMutableString * _jsonString;     //存放json字符串
}

@end

@implementation XYJsonConversion

- (instancetype)init {
    self = [super init];
    if(self){
        _jsonString  = [NSMutableString new];
        [_jsonString appendString:@"{"];
    }
    return self;
}

+ (NSString*)jsonWithDictionary:(NSDictionary*)dict {
    XYJsonConversion  * json = [XYJsonConversion new];
    return [NSString stringWithFormat:@"%@}",[json handleDictEngine:dict]];
}

- (NSString*)handleDictEngine:(id)object {
    if([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary  * dict = object;
        NSInteger       count = dict.count;
        NSArray       * keyArr = [dict allKeys];
        for (NSInteger i = 0; i < count; i++) {
            id subObject = dict[keyArr[i]];
            if([subObject isKindOfClass:[NSDictionary class]]) {
                [_jsonString appendFormat:@"\"%@\":{",keyArr[i]];
                [self handleDictEngine:subObject];
                [_jsonString appendString:@"}"];
                if(i < count - 1) {
                    [_jsonString appendString:@","];
                }
            }else if ([subObject isKindOfClass:[NSArray class]]) {
                [_jsonString appendFormat:@"\"%@\":[",keyArr[i]];
                [self handleDictEngine:subObject];
                [_jsonString appendString:@"]"];
                if(i < count - 1) {
                    [_jsonString appendString:@","];
                }
            }else if([subObject isKindOfClass:[NSString class]]) {
                [_jsonString appendFormat:@"\"%@\":\"%@\"",keyArr[i],subObject];
                if(i < count - 1) {
                    [_jsonString appendString:@","];
                }
            }else if([subObject isKindOfClass:[NSNumber class]]) {
                [_jsonString appendFormat:@"\"%@\":%@",keyArr[i],subObject];
                if(i < count - 1) {
                    [_jsonString appendString:@","];
                }
            }
        }
    }else if([object isKindOfClass:[NSArray class]]) {
        NSArray  * dictArr = object;
        NSInteger  count = dictArr.count;
        for (NSInteger i = 0; i < count; i++) {
            [_jsonString appendString:@"{"];
            [self handleDictEngine:dictArr[i]];
            [_jsonString appendString:@"}"];
            if(i < count - 1) {
                [_jsonString appendString:@","];
            }
        }
    }
    return _jsonString;
}

- (void)checkIsAddComma:(id)object {
    if(![object isKindOfClass:[NSArray class]] &&
       ![object isKindOfClass:[NSDictionary class]]) {
        [_jsonString appendString:@","];
    }
}

+ (NSString *)arrayToJSONString:(NSArray *)array {
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonResult;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
