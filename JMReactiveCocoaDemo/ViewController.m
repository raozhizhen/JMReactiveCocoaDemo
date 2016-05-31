//
//  ViewController.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/30.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    UITableView *_tableView;
    NSMutableArray *_titles;
    NSMutableArray *_classNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 44;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _titles = @[].mutableCopy;
    _classNames = @[].mutableCopy;
    [self addCell:@"TextField" class:@"TextFieldTestVC"];
    [self addCell:@"TapGesture" class:@"TapGestureTestVC"];
    [self addCell:@"Notification" class:@"NotificationTestVC"];
    [self addCell:@"Timer" class:@"TimerTestVC"];
    [self addCell:@"Delegate" class:@"DelegateTest"];
    [self addCell:@"KVO" class:@"KVOTest"];
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [_titles addObject:title];
    [_classNames addObject:className];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = _classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *VC = class.new;
        VC.title = _titles[indexPath.row];
        VC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:VC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
