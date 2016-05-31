//
//  DelegateTest.m
//  JMReactiveCocoaDemo
//
//  Created by jm on 16/5/30.
//  Copyright © 2016年 raozhizhen. All rights reserved.
//

#import "DelegateTest.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *CellIdentifier = @"Cell";

@interface DelegateTest () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property(nonatomic, assign, getter = isSearching) BOOL searching;

@end

@implementation DelegateTest {
    UISearchController *_searchController;
    NSArray *_searchTexts;
    NSArray *_searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchTexts = @[@"San Francisco", @"Grand Rapids", @"Chicago", @"San Jose"];
    _searchResults = @[];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [_searchController.searchBar sizeToFit];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = _searchController.searchBar;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:tableView];
    
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    
    @weakify(self);
    [[self rac_signalForSelector:@selector(updateSearchResultsForSearchController:) fromProtocol:@protocol(UISearchResultsUpdating)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UISearchController *searchController = tuple.first;
        NSString *searchText = searchController.searchBar.text;
        NSMutableArray *results = [NSMutableArray array];
        if (searchText.length > 0) {
            for (NSString *text in self->_searchTexts) {
                if ([[text lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                    [results addObject:text];
                }
            }
        } else {
            results = self->_searchTexts.copy;
        }
        self->_searchResults = results;
        [tableView reloadData];
    }];
    
    RACSignal *willPresentSearching = [[self rac_signalForSelector:@selector(willPresentSearchController:) fromProtocol:@protocol(UISearchControllerDelegate)] mapReplace:@YES];
    RACSignal *willDismissSearching = [[self rac_signalForSelector:@selector(willDismissSearchController:) fromProtocol:@protocol(UISearchControllerDelegate)] mapReplace:@NO];
    
    [[RACSignal merge:@[willPresentSearching, willDismissSearching]] subscribeNext:^(NSNumber *x) {
        _searching = x.boolValue;
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_searching) {
        return _searchResults.count;
    } else {
        return _searchTexts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _searching ? _searchResults[indexPath.row] : _searchTexts[indexPath.row];
    return cell;
}


@end
