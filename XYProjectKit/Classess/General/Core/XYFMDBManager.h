//
//  XYFMDBManager.h
//  LeRongRong
//
//  Created by xiaoye on 2018/11/30.
//  Copyright © 2018 Rong Zheng De. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>


NS_ASSUME_NONNULL_BEGIN

@interface XYFMDBManager : NSObject

+ (XYFMDBManager *)sharedInstance;

/// 创建表
- (void)createTable:(NSString*)tableName withSQL:(NSString *)sql;

- (NSArray *)selectWithSQL:(NSString *)sql;
- (int)selectCountWithSQL:(NSString *)sql;
- (void)updateWithSQL:(NSString *)sql;

@end

NS_ASSUME_NONNULL_END



