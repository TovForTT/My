//
//  McryptHelp.h
//
//  Created by Tov_ on 2016/10/13.
//  Copyright © 2016年 com.ticket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHelp : NSObject
+(NSString *)getLanguage;
+(NSString *)getDateNowUTC;
+(NSString *)getDateNowUTC:(NSString *)format;
+(NSString *)getDateNow;
+(NSString *)getDateNow:(NSString *)format;
+ (NSString *)convertDateWith:(NSString *)dateStr;
@end
