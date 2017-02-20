//
//  RRFModifyPwdController.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFModifyPwdController.h"
#import "RRFSettingView.h"
#import "RRFMeTool.h"

@interface RRFModifyPwdController ()

@property(nonatomic,weak)RRFModifyPwdView *modifyPwdView;
@end

@implementation RRFModifyPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingUIVC];
}

- (void)settingUIVC {
    WEAKSELF
    RRFModifyPwdView *modifyPwdView = [[RRFModifyPwdView alloc]init];
    modifyPwdView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64);
    self.modifyPwdView = modifyPwdView;
    [self.tableView setTableFooterView:modifyPwdView];
    modifyPwdView.updatePwdBlock = ^(){
        NSString *oldPassword = weakSelf.modifyPwdView.oldPwdStr;
        NSString *firshPwd = weakSelf.modifyPwdView.firshPwdStr;
        NSString *secondPwd = weakSelf.modifyPwdView.secondPwdStr;
        if (![firshPwd isEqualToString:secondPwd]) {
            [MBProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
            return ;
        }
        [RRFMeTool updatePwdWithOldPassword:oldPassword NewPassword:firshPwd Success:^(id json) {
            [MBProgressHUD showInfoWithStatus:@"修改成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        } failBlock:^(id json) {
            
        }];
    };
}



@end
