//
//  UIViewController+HttpResponse.h
//
//  Created by Tov_ on 14-6-19.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (HttpResponse)

- (void)showHttpRequestParseFail;

- (void)showHttpRequestNoServerFail;

- (void)showHttpRequestNoData;

-(void)showMessage:(NSString *)message;

-(void)showMessage:(NSString *)message withDetail:(NSString *)detailMessage;

-(void)showMessageByAlertView:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle;
@end
