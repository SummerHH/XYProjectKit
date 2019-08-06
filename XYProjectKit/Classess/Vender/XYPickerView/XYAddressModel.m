//
//  XYAddressModel.m
//  XYPIckerView
//
//  Created by xiyedev on 2017/9/14.
//  Copyright © 2017年 YeJiong. All rights reserved.
//

#import "XYAddressModel.h"

@implementation XYProvinceModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"city": @"cityData",
             @"name" : @"provinceName",
             @"code" : @"provinceCode"
             };
}

+ (NSDictionary *)mj_objectClassInArray {

    return @{
             @"city" : @"XYCityModel"
             };
}

@end

@implementation XYCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"town" : @"areaData",
             @"code" : @"cityCode",
             @"name" : @"cityName"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"town" : @"XYTownModel"
             };
}

@end

@implementation XYTownModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"name": @"areaName",
             @"code": @"areaCode"
             };
}

@end
