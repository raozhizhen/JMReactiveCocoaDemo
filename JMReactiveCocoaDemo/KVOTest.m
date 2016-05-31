//
//  KVOTest.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/31.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "KVOTest.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface KVOTest()

@end

@implementation KVOTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    [self.view addSubview:scrollView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 1000);
    [scrollView.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    [RACObserve(scrollView, contentOffset) subscribeNext:^(NSValue *x) {
        CGPoint point = x.CGPointValue;
        label.text = [NSString stringWithFormat:@"countentOffset:(%.1f, %.1f)", point.x, point.y];
    }];
}

@end
