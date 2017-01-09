//
//  ViewController.m
//  TestMyFavorite
//
//  Created by Tov_ on 16/6/29.
//  Copyright © 2016年 TTT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *mainView;
    UIView *maskView;
    UIView *popView;
    CGRect SaveOpenFrame;
    CGRect SaveCloseFrame;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainView];
    mainView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [mainView addSubview:button];
    button.center = mainView.center;
    button.bounds = CGRectMake(0, 0, 50, 50);
    [button addTarget:self action:@selector(clickOpen) forControlEvents:UIControlEventTouchUpInside];
    
    maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:maskView];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [maskView addGestureRecognizer:tap];
    
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    popView.backgroundColor = [UIColor orangeColor];
    SaveOpenFrame = popView.frame;
    popView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height / 2);
    [self.view addSubview:popView];
    SaveCloseFrame = popView.frame;
    
}

- (void)clickOpen {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / -2000;
        transform = CATransform3DRotate(transform, M_PI / 12, 1, 0, 0);
        transform = CATransform3DScale(transform, 0.98, 0.98, 1);
        transform = CATransform3DTranslate(transform, 0, 0, -100);
        mainView.layer.transform = transform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -2000;
            transform = CATransform3DScale(transform, 0.85, 0.85, 1);
            transform = CATransform3DTranslate(transform, 0, mainView.bounds.size.height * -0.05, 0);
            mainView.layer.transform = transform;
            maskView.alpha = 1;
            popView.frame = SaveOpenFrame;
            
        }];
    }];
    
    
    
}

- (void)clickClose {
    [UIView animateWithDuration:0.3 animations:^{
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / -2000;
        transform = CATransform3DRotate(transform, M_PI / 12, 1, 0, 0);
        transform = CATransform3DScale(transform, 0.98, 0.98, 1);
        transform = CATransform3DTranslate(transform, 0, 0, -100);
        mainView.layer.transform = transform;
        popView.frame = SaveCloseFrame;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            mainView.layer.transform = CATransform3DIdentity;
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
