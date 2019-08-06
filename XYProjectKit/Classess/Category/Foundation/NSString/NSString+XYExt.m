//
//  NSString+XYExt.m
//  fula
//
//  Created by cby on 2016/11/24.
//  Copyright © 2016年 ixiye company. All rights reserved.
//

#import "NSString+XYExt.h"

@implementation NSString (XYExt)

// 1111-1111-1111-1111-111
- (NSString *)bankCardNumStringParse {
    
    if (self.length < 5 || strIsNullOrNoContent(self)) {
        return self;
    }
    return [self baseParseStr:4 replaceStr:@"-" isTail:YES];
}

// 111-1111-1111-1111
- (NSString *)phoneNumberStringParse {
    
    if (strIsNullOrNoContent(self)) {
        return @"";
    }
    return [self baseParseStr:4 replaceStr:@"-" isTail:NO];
}

// 解析字符串  将其处理为 ￥100，000.00
- (NSString *)amountOfMoneyStringParse {
    
    if (self.length < 4) {
        return self;
    }
    NSString *cleanStr = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *interStr = cleanStr;
    NSString *decimalStr = @"";
    if([cleanStr rangeOfString:@"."].location != NSNotFound){
        NSArray *strArray = [cleanStr componentsSeparatedByString:@"."];
        interStr = [strArray firstObject];
        decimalStr = [@"." stringByAppendingString:[strArray lastObject]];
        if (decimalStr.length > 3) {
            decimalStr = [decimalStr substringToIndex:3];
        }
    }
    return [[interStr baseParseStr:3 replaceStr:@"," isTail:NO] stringByAppendingString:decimalStr];
}

// 按照传入的方法处理字符串, 从字符串尾开始截断还是从开头开始
- (NSString *)baseParseStr:(NSUInteger) indexNum replaceStr:(NSString *)reStr isTail:(BOOL)isTail {
    if (self.length < indexNum) {
        return self;
    }
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    NSUInteger remain = mutableString.length % indexNum;
    NSUInteger index = mutableString.length / indexNum;
    if (remain != 0) {
        if(isTail) {
            [mutableString insertString:reStr atIndex:mutableString.length - remain];
        } else {
            [mutableString insertString:reStr atIndex:remain];
        }
    }
    for (NSUInteger i = 1; i < index; i++) {
        if (remain == 0) {
            [mutableString insertString:reStr atIndex:remain + indexNum * i + i - 1];
        } else {
            if(isTail) {
                [mutableString insertString:reStr atIndex:indexNum * i + i - 1];
            } else {
                [mutableString insertString:reStr atIndex:remain + indexNum * i + i];
            }
        }
    }
    return [mutableString copy];
}

+ (NSString *)transferAmount:(NSNumber *)amount {
    if(!amount) return @"";
    float amountYuan = amount.floatValue / 100.0f;
    return [NSString stringWithFormat:@"%.2f", amountYuan];
}

+ (NSString *)transferYuanToFen:(NSString *)str {
    if(!str)
        return nil;
    float amountFloat = [str floatValue] * 100;
    return [NSString stringWithFormat:@"%.0f", amountFloat];
}

- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinYin = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    pinYin = [pinYin stringByReplacingOccurrencesOfString:@" " withString:@""];
    pinYin = [pinYin stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return pinYin;
}

- (NSString *)parseCardNo {
    NSMutableString *retCardNo = [self mutableCopy];
    if (retCardNo.length < 14)
        return self;
    [retCardNo replaceCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
    [retCardNo replaceCharactersInRange:NSMakeRange(8, 4) withString:@"****"];
    [retCardNo insertString:@" " atIndex:4];
    [retCardNo insertString:@" " atIndex:9];
    [retCardNo insertString:@" " atIndex:14];
    if (retCardNo.length - 3 > 16) {
        [retCardNo replaceCharactersInRange:NSMakeRange(15, 4) withString:@"****"];
        [retCardNo insertString:@" " atIndex:19];
    }
    return retCardNo;
}

- (NSString *)parsePhoneNumber {
    NSMutableString *retPhoneNo = [self mutableCopy];
    if (retPhoneNo.length < 11) {
        return self;
    }
    
    [retPhoneNo replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    return retPhoneNo;
}

- (BOOL)isNumText {
    NSString * regex = @"(/^[0-9]*$/)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (isMatch) {
        return YES;
    } else {
        return NO;
    }
}


- (NSString *)URLEncodedString {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

}

//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSString *)totalTime {
    
    NSInteger seconds = [totalTime longLongValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}


+ (NSString *)getRandomStringWithNum:(NSInteger)num {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}


- (NSString *)xy_timestampSwitchTimeFormatter:(NSString *)format {
    
    if (strIsNullOrNoContent(self)) {
        return strCheckNull(self);
    }
    
    NSMutableString *timeString = [self mutableCopy];
    
    /// 年月日时分秒 20181211143512  2018年12月11日14时35分12秒
    if (timeString.length >= 14) {
        NSString *YYYY = [timeString substringToIndex:4];
        NSString *MM = [timeString substringWithRange:NSMakeRange(4,2)];
        NSString *dd = [timeString substringWithRange:NSMakeRange(6, 2)];
        NSString *HH = [timeString substringWithRange:NSMakeRange(8, 2)];
        NSString *mm = [timeString substringWithRange:NSMakeRange(10, 2)];
        NSString *ss = [timeString substringWithRange:NSMakeRange(12, 2)];
        
        NSString *yyyyStr = [format stringByReplacingOccurrencesOfString:@"YYYY" withString:YYYY];
        NSString *MMStr = [yyyyStr stringByReplacingOccurrencesOfString:@"MM" withString:MM];
        NSString *ddStr = [MMStr stringByReplacingOccurrencesOfString:@"dd" withString:dd];
        NSString *HHStr = [ddStr stringByReplacingOccurrencesOfString:@"HH" withString:HH];
        NSString *mmStr = [HHStr stringByReplacingOccurrencesOfString:@"mm" withString:mm];
        NSString *formatString = [mmStr stringByReplacingOccurrencesOfString:@"ss" withString:ss];
        
        return formatString;
        
    }else if (timeString.length == 8) {
        
        /// 年月日 20181211  2018年12月11日
        NSString *YYYY = [timeString substringToIndex:4];
        NSString *MM = [timeString substringWithRange:NSMakeRange(4,2)];
        NSString *dd = [timeString substringWithRange:NSMakeRange(6, 2)];

        /// YYYY-MM-dd
        NSString *formatString = [format substringFromIndex:10];
       
        NSString *yyyyStr = [formatString stringByReplacingOccurrencesOfString:@"YYYY" withString:YYYY];
        NSString *MMStr = [yyyyStr stringByReplacingOccurrencesOfString:@"MM" withString:MM];
        NSString *ddStr = [MMStr stringByReplacingOccurrencesOfString:@"dd" withString:dd];
        
        return ddStr;
        
    } else if (timeString.length == 6) {
        /// 时分秒 143512  14:35:12
        NSString *HH = [timeString substringWithRange:NSMakeRange(0, 2)];
        NSString *mm = [timeString substringWithRange:NSMakeRange(2, 2)];
        NSString *ss = [timeString substringWithRange:NSMakeRange(4, 2)];
        
        /// HH:mm:ss
        NSString *formatString = [format substringWithRange:NSMakeRange(11, 8)];
        
        NSString *HHStr = [formatString stringByReplacingOccurrencesOfString:@"HH" withString:HH];
        NSString *mmStr = [HHStr stringByReplacingOccurrencesOfString:@"mm" withString:mm];
        NSString *ssStr = [mmStr stringByReplacingOccurrencesOfString:@"ss" withString:ss];
        
        return ssStr;
    }
    return timeString;
}
@end
