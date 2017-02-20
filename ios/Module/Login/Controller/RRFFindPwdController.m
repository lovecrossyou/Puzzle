
//  Created by on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFindPwdController.h"
#import "RRFFindPwdView.h"
#import "RRFLoginTool.h"
#import "PZWebController.h"
#import "RRFResetPwdController.h"
#import "WechatUserInfo.h"
#import "PZParamTool.h"
#import "PZWebController.h"
#import "PZParamTool.h"
#import "PZAccessInfo.h"
#import "PZHttpTool.h"
#import "UIViewController+ResignFirstResponser.h"

@interface RRFFindPwdController ()
{
    RRFFindPwdView* _forgetView;
}
@end

@implementation RRFFindPwdController

- (void)viewDidLoad {
    [super viewDidLoad];

    WEAKSELF
    self.tableView.backgroundColor = [UIColor whiteColor] ;
    _forgetView = [[RRFFindPwdView alloc]initWithWechatUserInfo:weakSelf.wechatInfo Reset:self.reset];
    //发送验证码
    _forgetView.getVerifyCodeBlock = ^(NSString* phoneNum){
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (phoneNum.length != 11) {
            [MBProgressHUD showInfoWithStatus:@"请输入有效的手机号！"];
            return ;
        }
        [RRFLoginTool sendResetPwdSMS:phoneNum  reset:weakSelf.reset successBlock:^(id json) {
            [MBProgressHUD dismiss];
            RRFResetPwdController *desc = [[RRFResetPwdController alloc]init];
            desc.reset = weakSelf.reset;
            desc.realCheckCode = json;
            desc.userName = phoneNum;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        } fail:^(id json) {
            [MBProgressHUD dismiss];
        }];
    };
    _forgetView.goProtocolBlock = ^(){
        [weakSelf goProtocol];
    };
    _forgetView.frame = CGRectMake(0, 64, SCREENWidth, SCREENHeight -64) ;
    [self.view addSubview:_forgetView];
    self.tableView.tableFooterView = _forgetView ;
}
-(void)goProtocol
{
    PZWebController *desc = [[PZWebController alloc]init];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
    NSDictionary* param = @{@"accessInfo":[accessInfo yy_modelToJSONObject]};
    [MBProgressHUD show];
    [PZHttpTool postHttpRequestUrl:@"baseInfo/protocolUrl" parameters:param successBlock:^(id json) {
        [MBProgressHUD dismiss];
        desc.pathUrl = json ;
        [self.navigationController pushViewController:desc animated:YES];
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

    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.shadowImage = [UIImage createImageWithColor:[UIColor whiteColor]];
    [navBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    navBar.barStyle = UIStatusBarStyleDefault;
    [navBar setTintColor:[UIColor colorWithHexString:@"4964ef"]];
    [MBProgressHUD dismiss];
}
@end
