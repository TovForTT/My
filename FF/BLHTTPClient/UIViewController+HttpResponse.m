//
//  UIViewController+HttpResponse.m
//
//  Created by Tov_ on 14-6-19.
//
//

#import "UIViewController+HttpResponse.h"
#import "define.h"
#import "MBProgressHUD.h"

@implementation UIViewController (HttpResponse)

- (void)showHttpRequestParseFail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = K_HUD_FAIL_PARSE;
    [hud hide:YES afterDelay:K_HUD_HIDE_DUTATION];
}

- (void)showHttpRequestNoServerFail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = K_HUD_NO_SERVER;
    [hud hide:YES afterDelay:K_HUD_HIDE_DUTATION];
}

- (void)showHttpRequestNoData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = K_HUD_NO_DATA;
    [hud hide:YES afterDelay:K_HUD_HIDE_DUTATION];
}

-(void)showMessage:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud hide:YES afterDelay:K_HUD_HIDE_DUTATION];
}
-(void)showMessage:(NSString *)message withDetail:(NSString *)detailMessage{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.detailsLabelText = detailMessage;
    [hud hide:YES afterDelay:K_HUD_HIDE_DUTATION];
}
-(void)showMessageByAlertView:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    [alertView show];
}
@end
