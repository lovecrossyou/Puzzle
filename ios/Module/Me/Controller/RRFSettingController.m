//
//  RRFSettingController.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFSettingController.h"
#import "PZCommonCellModel.h"
#import "RRFSettingView.h"
#import "RRFAccountController.h"
#import "RRFCacheManager.h"
@interface RRFSettingController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_allData;
    
    RRFSettingFootView *_editView;
}
@end

@implementation RRFSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self settingTableView];
    [self settingFootView];
}
-(void)settingFootView
{
    _editView = [[RRFSettingFootView alloc]init];
    _editView.frame = CGRectMake(0, 0, SCREENWidth, 65);
    [self.tableView setTableFooterView:_editView];
}
-(void)settingTableView
{
    WEAKSELF
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"" title:@"帐号管理" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFAccountController class]];
//    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"" title:@"给喜腾点赞" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    
    PZCommonCellModel *mode3 = [PZCommonCellModel cellModelWithIcon:@"" title:@"意见反馈" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode3.itemClick = ^(){
        [weakSelf feedback];
    };
    PZCommonCellModel *mode4 = [PZCommonCellModel cellModelWithIcon:@"" title:@"清除缓存" subTitle:[[RRFCacheManager sharedCacheManger] getFileSize] accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    _allData = @[@[mode1,mode3],@[mode4]];
}


#pragma mark - 意见反馈
-(void)feedback{
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFSettingController"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFSettingController"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = model.accessoryType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    if (model.itemClick) {
        model.itemClick();
        return;
    }
    if ([model.title isEqualToString:@"清除缓存"]) {
        if ([model.subTitle isEqualToString:@"0.00 MB"]) {
            [MBProgressHUD showInfoWithStatus:@"没有缓存文件!"];
            return;
        }else{
            BOOL isClear = [[RRFCacheManager sharedCacheManger] clearCache];
            if (isClear) {
                [MBProgressHUD showInfoWithStatus:@"清理成功!"];
                model.subTitle = @"0.00 MB";
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showInfoWithStatus:@"清理失败!"];
            }
        }
        return;
    }
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
