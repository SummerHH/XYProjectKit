//
//  XYConstantDataCenter.h
//  fula
//
//  Created by xiaoye on 2018/2/26.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYNetworkingEnum.h"

@interface XYConstantDataCenter : NSObject

+ (instancetype)sharedConstantData;

@property (nonatomic, assign) XYNetworkingStatusType netWorkingStatus;


@end
