//
//  RRFInputPasswordController.m
//  Puzzle
//
//  Created by huibei on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFInputPasswordController.h"
#import "RRFInputPwdView.h"
#import "RRFLoginTool.h"
#import "Singleton.h"
#import "LoginModel.h"
#import "RRFLoginTool.h"
#import "PZParamTool.h"
#import "WechatUserInfo.h"
#import "HBLoadingView.h"
#import "UIViewController+ResignFirstResponser.h"

@interface RRFInputPasswordController ()
{
    RRFInputPwdView *_pwdView;
}
@end

@implementation RRFInputPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    WEAKSELF
    _pwdView = [[RRFInputPwdView alloc]initWithRegiste:self.reset];
    _pwdView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64);
    [self.tableView setTableFooterView:_pwdView];
    _pwdView.regiseBlock = ^(NSString *pwd){
        if (pwd.length <6) {
            [MBProgressHUD showInfoWithStatus:@"密码长度不得低于6位！"];
            return ;
        }
        [MBProgressHUD show];
        if (weakSelf.reset) {
            // 找回密码
            [RRFLoginTool resetWithUserName:weakSelf.userName pwd:pwd checkCode:weakSelf.coderStr reset:weakSelf.reset successBlock:^(id json) {
                [MBProgressHUD dismiss];
                LoginModel *model = [[LoginModel alloc]init];
                model.phone_num = weakSelf.userName;
                [Singleton sharedInstance].loginModel = model;
                [MBProgressHUD showInfoWithStatus:@"重置成功!"];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } fail:^(id json) {
                [MBProgressHUD dismiss];
            }];
        }else{
            // 绑定手机号
            CFUUIDRef udid = CFUUIDCreate(NULL);
            NSString *md5Key = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
            WechatUserInfo* wechatInfo = [Singleton sharedInstance].wechatInfo ;
            [RRFLoginTool bindPhone:wechatInfo phone:weakSelf.userName pwd:pwd checkCode:weakSelf.coderStr md5Key:md5Key successBlock:^(id json) {
                [MBProgressHUD dismiss];
                int sexNum = [wechatInfo.sex intValue] ;
                [weakSelf autoLoginloginWithUserName:weakSelf.userName pwd:pwd sex:sexNum successBlock:^(id json) {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeForFirstRegister" object:nil];
                    }];
                }];
            } fail:^(id json) {
                [MBProgressHUD dismiss];
                [MBProgressHUD showInfoWithStatus:@"注册失败!"];
            }];
        }
    };
}


#pragma mark-  绑定成功后自动登录
-(void)autoLoginloginWithUserName:userName pwd:(NSString*)pwd sex:(int)sex successBlock:(PZRequestSuccess)completeBlock{
    [RRFLoginTool loginWithUserName:userName nickName:nil head_imgUrl:nil pwd:pwd type:@"phonenum" sex:sex successBlock:^(id json) {
        //保存用户信息
        if (json != nil) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            LoginModel* loginM = [LoginModel yy_modelWithJSON:json];
            loginM.phone_num = userName ;
            loginM.login = @(YES) ;
            [realm addObject:loginM];
            [realm commitWriteTransaction];
            [PZParamTool getAccountInfo];
            completeBlock(json);
        }
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
