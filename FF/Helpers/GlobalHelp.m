//
//  McryptHelp.h
//
//  Created by Tov_ on 2016/10/13.
//  Copyright © 2016年 com.ticket. All rights reserved.
//

#import "GlobalHelp.h"

@implementation GlobalHelp
+(NSString *)getLanguage{
    NSArray *local = [NSLocale preferredLanguages];
    NSString *localLanguage = local[0];
    NSString *lang;
    if ([localLanguage containsString:@"Hans"] || [localLanguage containsString:@"zh-CN"]) {
        lang = @"zh_CN";
    } else if ([localLanguage containsString:@"Hant"] || [localLanguage containsString:@"zh-TW"]) {
        lang = @"zh_TW";
    } else if ([localLanguage containsString:@"ja"] || [localLanguage containsString:@"ja-JP"]) {
        lang = @"ja_JP";
    } else {
        lang = @"en_US";
    }
    return lang;
}


+(NSString *)getDateNowUTC{
    NSDate *date= [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
+(NSString *)getDateNowUTC:(NSString *)format{
    NSDate *date= [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


+(NSString *)getDateNow{
    NSDate *date= [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
+(NSString *)getDateNow:(NSString *)format{
    NSDate *date= [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)convertDateWith:(NSString *)dateStr {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *getDate = [formatter dateFromString:dateStr];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval timeInterval = [timeZone secondsFromGMTForDate:getDate];
    NSDate *reDate = [getDate dateByAddingTimeInterval:timeInterval];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:reDate];
}

@end
