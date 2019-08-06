//
//  XYLaunchAdManager.h
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/10.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYLaunchAdManager : NSObject

+ (instancetype)sharedInstance;

- (void)loadLaunchImageAd;

@end

NS_ASSUME_NONNULL_END
