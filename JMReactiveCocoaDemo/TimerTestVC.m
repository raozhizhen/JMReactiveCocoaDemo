//
//  TimerTestVC.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/30.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "TimerTestVC.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation TimerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    UIImageView *dialImageView = [[UIImageView alloc] init];
    dialImageView.image = [UIImage imageNamed:@"dial_image"];
    [self.view addSubview:dialImageView];
    
    [dialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.size.mas_equalTo(CGSizeMake(256, 256));
        make.centerX.equalTo(self.view);
    }];

    UIImageView *hourHandImageView = [[UIImageView alloc] init];
    hourHandImageView.image = [UIImage imageNamed:@"hour_hand"];
    hourHandImageView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:hourHandImageView];
    
    [hourHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(dialImageView);
        make.size.mas_equalTo(CGSizeMake(20, 106));
    }];
    
    UIImageView *minuteHandImageView = [[UIImageView alloc] init];
    minuteHandImageView.image = [UIImage imageNamed:@"minute_hand"];
    minuteHandImageView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:minuteHandImageView];
    
    [minuteHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(dialImageView);
        make.size.mas_equalTo(CGSizeMake(20, 106));
    }];
    
    UIImageView *secondHandImageView = [[UIImageView alloc] init];
    secondHandImageView.image = [UIImage imageNamed:@"second_hand"];
    secondHandImageView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:secondHandImageView];
    
    [secondHandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(dialImageView);
        make.size.mas_equalTo(CGSizeMake(8, 102));
    }];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSDate *date) {
        
        NSDateComponents *components = [calendar components:units fromDate:date];
        CGFloat secsAngle = (components.second / 60.0) * M_PI_2;
        CGFloat minsAngle = (components.minute / 60.0 + components.second / 3600.0) * M_PI_2;
        CGFloat hoursAngle = (components.hour / 12.0 + components.minute / 720.0) * M_PI_2;
        hourHandImageView.transform = CGAffineTransformMakeRotation(hoursAngle);
        minuteHandImageView.transform = CGAffineTransformMakeRotation(minsAngle);
        secondHandImageView.transform = CGAffineTransformMakeRotation(secsAngle);
        
        label.text = [NSString stringWithFormat:@"时间：%d : %d : %d", components.hour, components.minute, components.second];
    }];
}

@end
