//
//  RankDetailController.m
//  Puzzle
//
//  Created by huipay on 2016/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RankDetailController.h"
#import "HomeRankCell.h"
#import "HomeTool.h"
#import "HomeRankListModel.h"
#import "RRFPersonalAskBarController.h"
#import "HomeRankModel.h"
@interface RankDetailController ()
@property(strong,nonatomic)NSArray* rankList ;
@end

@implementation RankDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [UIView new];
    //    收益排行
    [HomeTool getRankListWithPageNo:0 pageSize:15 type:@"currentMonth" SuccessBlock:^(id json) {
        [MBProgressHUD dismiss];
        HomeRankListModel* rankListM = [HomeRankListModel yy_modelWithJSON:json];
        weakSelf.rankList = rankListM.content ;
        [weakSelf.tableView reloadData];
    } fail:^(id json) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeRankModel* rankM = self.rankList[indexPath.row];
    HomeRankCell *cell = [[HomeRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeRankCell"];
    cell.model = rankM ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeRankModel* model = self.rankList[indexPath.row] ;
    RRFPersonalAskBarController* person = [[RRFPersonalAskBarController alloc]init];
    person.userId = model.userId;
    person.title = @"沙龙评论";
    [self.navigationController pushViewController:person animated:YES];
    
}


@end
