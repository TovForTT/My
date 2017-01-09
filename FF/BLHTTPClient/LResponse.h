//
//  LResponse.h
//
//  Created by Tov_ on 2016/3/9.
//
//

#import <Foundation/Foundation.h>

@interface LResponse : NSObject
@property(strong, nonatomic) NSDictionary *header;
@property(strong, nonatomic) NSNumber *status;
@property(strong, nonatomic) NSString *messsage;
@property(strong, nonatomic) NSDictionary *body;
@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSError *error;
@end
