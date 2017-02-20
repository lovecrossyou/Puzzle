//
//  XTBExchangeResultController.m
//  Puzzle
//
//  Created by huibei on 16/10/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "XTBExchangeResultController.h"
#import "XTBExchangeResultView.h"
@interface XTBExchangeResultController ()

@end

@implementation XTBExchangeResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(243, 243, 243);
    XTBExchangeResultView* tableHeader = [[XTBExchangeResultView alloc]initWithJson:self.resultJson];
    tableHeader.frame = CGRectMake(0, 0, SCREENWidth, 14.0f+ 120.0f + 12 + 140);
    self.tableView.tableHeaderView = tableHeader ;
    self.tableView.tableFooterView = [UIView new];
    
    //nav right
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = rightItem ;
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem ;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
