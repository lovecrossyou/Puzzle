//
//  JNQProductCommentViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQProductCommentViewController.h"
#import "JNQProductCommentCell.h"
#import "JNQHttpTool.h"
#import "MJRefresh.h"

@interface JNQProductCommentViewController () {
    NSMutableArray *_dataArray;
    NSInteger _pageNo;
}

@end

@implementation JNQProductCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSMutableArray array];
    [self loadData];
}

- (void)buildUI {
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
}

- (void)loadData {
    NSDictionary *param = @{
                            @"size"     : @(10),
                            @"pageNo"   : @(_pageNo),
                            @"productId": @(_productId)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"product/comment/list" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSLog(@"223333333");
        NSArray *data = json[@"content"];
        for (NSDictionary *dict in data) {
            JNQProductCommentModel *model = [JNQProductCommentModel yy_modelWithJSON:dict];
            [_dataArray addObject:model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        _pageNo++;
        self.tableView.mj_footer.hidden = [json[@"last"] boolValue];
    } failureBlock:^(id json) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQProductCommentCell"];
    if (!cell) {
        cell = [[JNQProductCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQProductCommentCell"];
    }
    JNQProductCommentModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.commentModel = model;
    return cell;
}

@end
