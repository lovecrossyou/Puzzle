//
//  RRFModifyNameController.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFModifyNameController.h"
#import "RRFModifyNameView.h"
#import "RRFMeTool.h"
#import "XTChatUtil.h"
@interface RRFModifyNameController ()
{
    RRFModifyNameView *_headView;
}
@end

@implementation RRFModifyNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    _headView = [[RRFModifyNameView alloc]init];
    _headView.nameText.text = self.name;
    _headView.placeholder = self.placeholder;
    _headView.frame = CGRectMake(0, 0, SCREENWidth, 90);
    self.tableView.tableHeaderView = _headView;
}
-(void)settingNav
{
    UIButton *titleBtn = [[UIButton alloc]init];
    [titleBtn setTitle:@"保存" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleBtn sizeToFit];
    [titleBtn addTarget:self action:@selector(saveName) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:titleBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)saveName
{
    NSString *name = _headView.nameText.text;
    if (name.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请输入名字"];
        return;
    }
    [RRFMeTool modifyNameWith:name Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"修改成功"];
        //同步到喜信
        [XTChatUtil updateNickName:name];
        [self.navigationController popViewControllerAnimated:YES];
    } failBlock:^(id json) {
        
    }];
    
}
@end
