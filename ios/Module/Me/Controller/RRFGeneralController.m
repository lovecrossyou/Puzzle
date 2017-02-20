//
//  RRFGeneralController.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFGeneralController.h"
#import "RRFSettingController.h"
#import "PZCommonCellModel.h"
#import "RRFAboutController.h"
#import "PZWebController.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "PZHttpTool.h"
@interface RRFGeneralController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_allData;
}
@end

@implementation RRFGeneralController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self settingTableView];
}
-(void)settingTableView
{
    WEAKSELF
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"" title:@"用户协议" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode1.itemClick = ^(){
        PZWebController *desc = [[PZWebController alloc]init];
        PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
        NSDictionary* param = @{@"accessInfo":[accessInfo yy_modelToJSONObject]};
        [MBProgressHUD show];
        [PZHttpTool postHttpRequestUrl:@"baseInfo/protocolUrl" parameters:param successBlock:^(id json) {
            [MBProgressHUD dismiss];
            desc.pathUrl = json ;
            [self.navigationController pushViewController:desc animated:YES];
        } fail:^(id json) {
            [MBProgressHUD dismiss];
        }];
    };
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"" title:@"关于喜腾" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFAboutController class]];
    PZCommonCellModel *mode3 = [PZCommonCellModel cellModelWithIcon:@"" title:@"设置" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFSettingController class]];
    PZCommonCellModel *mode4 = [PZCommonCellModel cellModelWithIcon:@"" title:@"给喜腾点赞" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFAboutController class]];
    mode4.itemClick = ^(){
        [weakSelf goToAppStore];
    };

    
    _allData = @[@[mode1],@[mode2],@[mode4,mode3]];
}

-(void)goToAppStore
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1171289900&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFGeneralController"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFGeneralController"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = model.accessoryType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    if (model.itemClick) {
        model.itemClick();
        return;
    }
    UIViewController *desc = [[model.descVc alloc]init];
    desc.title = model.title;
    [self.navigationController pushViewController:desc animated:YES];
}
@end
