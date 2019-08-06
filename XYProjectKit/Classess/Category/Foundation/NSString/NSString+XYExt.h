//
//  NSString+XYExt.h
//  fula
//
//  Created by cby on 2016/11/24.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline NSString *strCheckNull(NSString *str) {
    if(!str || ![str isKindOfClass:[NSString class]] || [str isEqual:[NSNull null]] || [str isEqualToString:@"<null>"]){
        return @"";
    }
    return str;
}

static inline BOOL strIsNullOrNoContent(NSString *str) {
    if(!str || ![str isKindOfClass:[NSString class]] || [str isEqual:[NSNull null]] || str.length == 0 || [str isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}

static inline BOOL arrayIsNullOrNoContent(NSArray *array) {
    if (array != nil && [array isKindOfClass:[NSArray class]] && ![array isKindOfClass:[NSNull class]] && array.count != 0)  {
        return NO;
    }else {
        return YES;
    }
}

static inline BOOL ObjectIsNil(id object) {

    if ((object == nil) || [object isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    return NO;
}

@interface NSString (XYExt)

// 分转元，并返回字符
+ (NSString *)transferAmount:(NSNumber *)amount;
// 元转分
+ (NSString *)transferYuanToFen:(NSString *)str;

- (NSString *)transformToPinyin;

- (NSString *)amountOfMoneyStringParse;
- (NSString *)phoneNumberStringParse;

- (NSString *)bankCardNumStringParse;
- (NSString *)parseCardNo;
- (NSString *)parsePhoneNumber;
- (BOOL)isNumText;

- (NSString *)URLEncodedString;

/**
 *  时间字符串格式化 20190709164523
 *
 *  @param format @!固定格式 YYYY-MM-dd HH:mm:ss - : 可替换
 *  @return 格式化后时间
 */
- (NSString *)xy_timestampSwitchTimeFormatter:(NSString *)format;

/**
 *  生成字母加数字随机数
 *
 *  @param num 位数
 */

+ (NSString *)getRandomStringWithNum:(NSInteger)num;

//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;


@end
