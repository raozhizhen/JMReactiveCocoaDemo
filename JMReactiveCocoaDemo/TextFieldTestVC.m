//
//  TextFieldTestVC.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/30.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "TextFieldTestVC.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation TextFieldTestVC

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
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
    }];
    
    [textField.rac_textSignal subscribeNext:^(NSString *x) {
        label.text = x;
    }];

    [[[textField rac_signalForControlEvents:UIControlEventEditingDidBegin] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        label.text = @"开始输入";
    }];
    
    [[[textField rac_signalForControlEvents:UIControlEventEditingDidEnd] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        label.text = @"结束输入";
    }];
}

@end
