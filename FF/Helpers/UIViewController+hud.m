//
//  UIViewController+hud.m
//
//  Created by Tov_ on 16/12/16.
//  Copyright © 2016年 com.ticket. All rights reserved.
//

#import "UIViewController+hud.h"
#import <MBProgressHUD.h>


@implementation UIViewController (hud)

- (void)showHud:(NSString *)message {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHud)];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud addGestureRecognizer:tap];
    hud.tag = 668;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    if (message.length <= 20) {
        hud.labelText = message;
    }else {
        hud.detailsLabelText = message;
    }
    [hud show:YES];
    if (message.length > 20) {
        [hud hide:YES afterDelay:5.0];
    } else {
        [hud hide:YES afterDelay:3.0];
    }
    
}

- (void)hideHud {
    MBProgressHUD *hud = [self.view viewWithTag:668];
    [hud hide:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showHudAgainShow:(NSString *)message
{
    WEAKSELF;
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHud)];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud addGestureRecognizer:tap];
    hud.tag = 668;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    if (message.length <= 20) {
        hud.labelText = message;
    }else {
        hud.detailsLabelText = message;
    }
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.view) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        }
    });
    

}


@end
