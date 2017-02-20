//
//  PZBaseTableViewController.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"

@interface PZBaseTableViewController ()

@end

@implementation PZBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.view.backgroundColor = HBColor(245, 245, 245);
    self.tableView = [[TPKeyboardAvoidingTableView alloc]init];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.estimatedRowHeight = 120.0f; 
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
}

@end
