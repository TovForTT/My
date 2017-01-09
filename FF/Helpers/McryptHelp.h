//
//  McryptHelp.h
//
//  Created by Tov_ on 2016/10/13.
//  Copyright © 2016年 com.ticket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface McryptHelp : NSObject
+ (NSString*)descode:(NSString*)encryptText;
@end
