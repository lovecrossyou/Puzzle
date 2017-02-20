
//
//  Created by huibei on 16/7/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFResetPwdController.h"
#import "RRFResetPwdView.h"
#import "RRFLoginTool.h"
#import "PZTimerCountView.h"
#import "Singleton.h"
#import "RRFInputPasswordController.h"
#import "UIViewController+ResignFirstResponser.h"
#import "NSData+JsonData.h"

@interface RRFResetPwdController ()
{
    RRFResetPwdView *_pwdView;
}
@end

@implementation RRFResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.view.backgroundColor = [UIColor whiteColor];
    _pwdView = [[RRFResetPwdView alloc]init];
    [_pwdView setPwdViewHidden:self.reset];
    [_pwdView settingPhoneNum:self.userName];
    [_pwdView.btnSendVerifyCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [_pwdView.btnSendVerifyCode  startTimer];
    _pwdView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64);
    [self.tableView setTableFooterView:_pwdView];
    _pwdView.regiseBlock = ^(NSString *checkCode){
        if (checkCode.length != 6) {
            [MBProgressHUD showInfoWithStatus:@"请输入6位验证码!"];
            return ;
        }
//        校验验证码
        NSString* codeType = weakSelf.reset? @"ResetPwd" : @"Register" ;
        [RRFLoginTool verifySMS:weakSelf.userName code:checkCode codeType:codeType successBlock:^(id json) {
            [MBProgressHUD dismiss];
            RRFInputPasswordController *desc = [[RRFInputPasswordController alloc]init];
            desc.coderStr = checkCode;
            desc.userName = weakSelf.userName;
            desc.reset = weakSelf.reset;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        } fail:^(NSError* error) {
            NSData* data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
            NSDictionary* jsonD = [data toJsonData];
            if (jsonD != nil) {
                NSString* message = jsonD[@"message"];
                if (message) {
                    [MBProgressHUD dismiss];
                    [MBProgressHUD showInfoWithStatus:message];
                }
            }
        }];
    };
}

// 获取验证码
-(void)getCode
{
    [RRFLoginTool sendResetPwdSMS:self.userName reset:self.reset successBlock:^(id json) {
        self.realCheckCode = json;
        [MBProgressHUD showInfoWithStatus:@"验证码已发送到手机，请主要查看"];
    } fail:^(id json) {
        
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignAll];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
