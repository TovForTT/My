//
//  QRView.h
//  TTT
//
//  Created by Tov_ on 16/5/12.
//  Copyright © 2016年 Tov_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRView;

@protocol QRViewDelegate <NSObject>

- (void)qrView:(QRView *)view ScanResult:(NSString *)result;

@end


@interface QRView : UIView

@property (nonatomic, assign) id<QRViewDelegate> delegate;

@property (nonatomic, assign) CGRect scanViewFrame;


- (void)startScan;

- (void)stopScan;

@end
