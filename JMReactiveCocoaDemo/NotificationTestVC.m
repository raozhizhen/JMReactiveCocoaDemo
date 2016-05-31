//
//  NotificationTestVC.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/30.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "NotificationTestVC.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString *const touchButtonNotificition = @"touchButtonNotificition";

@implementation NotificationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请点击按钮发送通知";
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor magentaColor];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:touchButtonNotificition object:nil];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:touchButtonNotificition object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * notification) {
        label.text = @"收到点击 button 的通知";
        NSLog(@"%@", @"收到点击 button 的通知");
    }];
}

@end
