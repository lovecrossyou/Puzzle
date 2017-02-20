//
//  CommentsController.m
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderCommentsController.h"
#import "RRFOrderCommentsHeadView.h"
#import "RRFStar.h"
#import "PZTextView.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "RRFMeTool.h"
#import "RRFStar.h"
#import "PZTextView.h"
#import "RRFOrderDetailController.h"

@interface RRFOrderCommentsController ()
@property(nonatomic,weak)RRFOrderCommentsHeadView *headView;

@end

@implementation RRFOrderCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    RRFOrderCommentsHeadView *headView = [[RRFOrderCommentsHeadView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
    self.headView = headView;
    [headView.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

//#pragma mark - 提交
-(void)submit
{
    NSInteger score = self.headView.star.show_star;
    NSString *content = [self.headView.contentV getText];

  /*
    [RRFMeTool addCommentWithContent:content OrderId:self.orderId Score:score Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"评价成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.refreBlock) {
            self.refreBlock(YES);
        }
    } failBlock:^(id json) {
        
    }];*/
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
@end
