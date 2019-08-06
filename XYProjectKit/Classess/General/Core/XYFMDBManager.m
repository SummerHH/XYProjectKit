//
//  XYFMDBManager.m
//  LeRongRong
//
//  Created by xiaoye on 2018/11/30.
//  Copyright © 2018 Rong Zheng De. All rights reserved.
//

#import "XYFMDBManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface XYFMDBManager ()
/// 一个FMDatabase对象就代表一个单独的SQLite数据库，用来执行SQL语句，进行增删查改操作。
@property (nonatomic, strong) FMDatabase *dataBase;
/// 保证线程安全可以在多线程中同时读写、执行多个查询或更新
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation XYFMDBManager

+(XYFMDBManager *)sharedInstance {
    
    static XYFMDBManager *dbInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbInstance = [[XYFMDBManager alloc] init];
        dbInstance.semaphore = dispatch_semaphore_create(1);

    });
    return dbInstance;
}

- (instancetype)init {

    if (self = [super init]) {
        
        [self openDatabaseWithUserName:@"LeRongRong"];
    }
    return self;
}

- (void)openDatabaseWithUserName:(NSString*)userName {
    
    if (userName.length == 0) {
        return;
    }
    //Documents:
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //username md5
    const char *cStr = [userName UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString* MD5 =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    //数据库文件夹
    NSString * documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:MD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir) {
            NSLog(@"Create Database Directory Failed.");
        }
        NSLog(@"%@", documentsDirectory);
    }
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",userName]];
    
    NSLog(@"---dbPath--%@----",dbPath);
    
    if (self.dataBase) {
        [self.dataBase close];
        self.dataBase = nil;
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];

    if ([self.dataBase open]) {
        //创建用户表带用户信息表
        NSLog(@"数据库打开成功");
    }
}

/// 创建表
- (void)createTable:(NSString*)tableName withSQL:(NSString *)sql {
    
    BOOL isExist = [self.dataBase tableExists:tableName];
    if (!isExist) {
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            
            BOOL result = [db executeUpdate:sql];
            if (result) {
                NSLog(@"创建表成功");
            }else {
                NSLog(@"创建表失败");
            }
        }];
    }
}

/// 查询
- (NSArray *)selectWithSQL:(NSString *)sql {
    NSMutableArray *array = [NSMutableArray array].mutableCopy;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            [array addObject:dic];
        }
        [rs close];
    }];
    return array;
}

///
- (int)selectCountWithSQL:(NSString *)sql {
    __block int rs = 0;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        rs = [db intForQuery:sql];
    }];
    return rs;
}

/// 更新
- (void)updateWithSQL:(NSString *)sql {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //
        }
        dispatch_semaphore_signal(self.semaphore);
    }];
}

@end
