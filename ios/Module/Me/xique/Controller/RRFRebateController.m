//
//  RRFRebateController.m
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRebateController.h"
#import "RRFRebateView.h"
#import "RRFRebateCell.h"
#import "RRFMeTool.h"
#import "RRFRebateDetailInfoModel.h"
#import "RRFRebateModel.h"

@interface RRFRebateController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)RRFRebateView *headView;
@property(nonatomic,strong)NSMutableArray *allMonthData;
@property(nonatomic,assign)int pageNo;
@end

@implementation RRFRebateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self requestData];
    [self requestMonthInfo];
}
-(NSMutableArray *)allMonthData
{
    if (_allMonthData == nil) {
        _allMonthData = [[NSMutableArray alloc]init];
    }
    return _allMonthData;
}
-(void)requestData
{
    [RRFMeTool requestDelegateRebateInfoMsgWithSuccess:^(id json) {
        RRFRebateDetailInfoModel *model = [RRFRebateDetailInfoModel yy_modelWithJSON:json];
        [self settingHeaderViewWithModel:model];
    } failBlock:^(id json) {
        
    }];
}
-(void)requestMonthInfo
{
    [RRFMeTool requestrebateMonthMsgWithPageNo:self.pageNo Size:10 Success:^(id json) {
        
        NSArray *dicArray = json[@"content"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in dicArray) {
            RRFRebateMonthModel *model = [RRFRebateMonthModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        self.allMonthData = temp;
        [self.tableView reloadData];
    } failBlock:^(id json) {
        
    }];
}
-(void)settingHeaderViewWithModel:(RRFRebateDetailInfoModel *)model
{
    RRFRebateView *headView = [[RRFRebateView alloc]init];
    headView.model = model;
    headView.frame = CGRectMake(0, 0, SCREENWidth, 260);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allMonthData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RRFRebateMonthModel *monthM = self.allMonthData[section];
    if(monthM.isOpen){
        return monthM.dayList.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFRebateMonthModel *monthM = self.allMonthData[indexPath.section];
    RRFRebateDayModel *dayM = monthM.dayList[indexPath.row];
    RRFRebateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFRebateController"];
    if (cell == nil) {
        cell = [[RRFRebateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFRebateController"];
    }
    cell.dayM = dayM;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RRFRebateMonthModel *monthM = self.allMonthData[section];
    RRFRebateSectionHeaderView *headerView = [[RRFRebateSectionHeaderView alloc]init];
    [[headerView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (monthM.isRequest == NO) {
            [RRFMeTool requestRebateDetailByMonthWithYear:monthM.year Month:monthM.month PageNo:0 Size:50 Success:^(id json) {
                NSArray *dicArray = json[@"content"];
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in dicArray) {
                    RRFRebateDayModel *model = [RRFRebateDayModel yy_modelWithJSON:dic];
                    [temp addObject:model];
                }
                monthM.isRequest = YES;
                monthM.isOpen = YES;
                monthM.dayList = temp;
                [self.tableView reloadData];

            } failBlock:^(id json) {
                
            }];
        }else{
            BOOL open = monthM.isOpen;
            monthM.isOpen = !open;
            [self.tableView reloadData];
        }

    }];
   
    headerView.model = monthM;
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
@end
