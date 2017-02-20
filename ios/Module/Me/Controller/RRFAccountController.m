//
//  RRFAccountController.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFAccountController.h"
#import "PZCommonCellModel.h"
#import "RRFModifyPwdController.h"
#import "LoginModel.h"
#import "PZParamTool.h"
@interface RRFAccountController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_allData;
}
@end

@implementation RRFAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self settingTableView];
}
-(void)settingTableView
{
    LoginModel *user = [PZParamTool currentUser];
    NSString *phone = user.phone_num;
    if (phone.length == 0) {
        phone = user.phoneNumber;
    }
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"" title:@"用户名" subTitle:phone accessoryType:UITableViewCellAccessoryNone descVc:nil];
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"" title:@"喜腾密码" subTitle:@"******" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFModifyPwdController class]];
       _allData = @[@[mode1],@[mode2]];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sec = _allData[section];
    return sec.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFAccountController"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RRFAccountController"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = PZFont(15);
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.detailTextLabel.font = PZFont(13);
    }
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = model.accessoryType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    UIViewController *desc = [[model.descVc alloc]init];
    desc.title = model.title;
    [self.navigationController pushViewController:desc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
@end
