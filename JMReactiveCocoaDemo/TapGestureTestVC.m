//
//  TapGestureTestVC.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/30.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "TapGestureTestVC.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation TapGestureTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请点击任意位置";
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    
    [[[tap rac_gestureSignal] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(UITapGestureRecognizer *tap) {
        CGPoint point = [tap locationInView:self.view];
        label.text = [NSString stringWithFormat:@"你点击了：（%.1f, %.1f）", point.x, point.y];
    }];
    
}

@end
