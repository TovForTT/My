//
//  UIView+hud.m
//  Created by Tov_ on 16/12/23.
//  Copyright © 2016年 com.ticket. All rights reserved.
//

#import "UIView+hud.h"
#import <MBProgressHUD.h>

@implementation UIView (hud)

- (void)showHud:(NSString *)message {
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHud)];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [hud addGestureRecognizer:tap];
    hud.tag = 668;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [self addSubview:hud];
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
    MBProgressHUD *hud = [self viewWithTag:668];
    [hud hide:YES];
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

@end
