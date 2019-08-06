//
//  NSError+XYCommon.h
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/9.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//domain
FOUNDATION_EXPORT NSString *const NSCommonErrorDomain;

@interface NSError (XYCommon)

+(NSError*)errorCode:(NSCommonErrorCode)code;

+(NSError*)errorCode:(NSCommonErrorCode)code userInfo:(nullable NSDictionary*)userInfo;

@end

NS_ASSUME_NONNULL_END
