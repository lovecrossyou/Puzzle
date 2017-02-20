//
//  RRFChooseSexController.m
//  Puzzle
//
//  Created by huibei on 16/9/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFChooseSexController.h"
#import "PZCommonCellModel.h"
#import "RRFMeTool.h"
@interface RRFChooseSexController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *allData;
@end

@implementation RRFChooseSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self settingTableView];
}
-(void)settingTableView
{
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"me_icon_assets" title:@"男" subTitle:@"" accessoryType:UITableViewCellAccessoryNone descVc:nil];
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"me_icon_assets" title:@"女" subTitle:@"" accessoryType:UITableViewCellAccessoryNone descVc:nil];
    self.allData = @[mode1,mode2];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PZCommonCellModel *model = self.allData[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFChooseSexController"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFChooseSexController"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = model.title;
    cell.accessoryType = model.accessoryType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PZCommonCellModel *model = self.allData[indexPath.row];
    int sex = [model.title isEqualToString:@"男"]?1:2;
    [RRFMeTool modifySexWithSex:sex Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failBlock:^(id json) {
        
    }];
}
@end
