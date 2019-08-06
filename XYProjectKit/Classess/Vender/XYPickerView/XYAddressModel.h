//
//  XYAddressModel.h
//  XYPIckerView
//
//  Created by xiyedev on 2017/9/14.
//  Copyright © 2017年 YeJiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYProvinceModel, XYCityModel, XYTownModel;

@interface XYProvinceModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <XYCityModel *>*city;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger isSpecial;

@end

@interface XYCityModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <XYTownModel *>*town;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *parentCode;

@end


@interface XYTownModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *parentCode;
@property (nonatomic, strong) NSString *provinceCode;

@end
