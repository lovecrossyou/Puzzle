
//  Created by on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFLoginController.h"
#import "RRFLoginView.h"
#import "RRFLoginTool.h"
#import "RRFFindPwdController.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "PZMMD5.h"
#import "RRFFindPwdController.h"
#import "Singleton.h"
#import <Realm/Realm.h>
#import "WXApi.h"
#import "UIViewController+ResignFirstResponser.h"
#import "PZHttpTool.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "MBProgressHUD+HBProgresss.h"
#import "TPKeyboardAvoidingTableView.h"
#import "XTChatUtil.h"
#import "RRFMeTool.h"
#import "PZWebController.h"
#import "PZReactUIManager.h"
@interface RRFLoginController()
{
    NSString *_userName;
}
@property(nonatomic,weak)RRFLoginView* loginView;
@property(weak,nonatomic)UIView *firstLoginView ;
@property(weak,nonatomic)TPKeyboardAvoidingTableView* tableView ;
@end
@implementation RRFLoginController

-(void)viewDidLoad{
    [super viewDidLoad];
    WEAKSELF
    TPKeyboardAvoidingTableView* tableView = [[TPKeyboardAvoidingTableView alloc]init];
    self.tableView = tableView ;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.title = @"登录" ;
    RRFLoginView* loginView = [[RRFLoginView alloc]init];
    loginView.loginBlock = ^(int type){
        if (type == 1) {
            // 忘记密码
            RRFFindPwdController* forget = [[RRFFindPwdController alloc]init];
            forget.reset = YES;
            [weakSelf.navigationController pushViewController:forget animated:YES];
        }else if (type == 2){
            //登录
            NSString *userName = weakSelf.loginView.userName;
            userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(userName.length == 0){
                [MBProgressHUD showInfoWithStatus:@"请输入手机号!"];
                return ;
            }
            NSString* pwd = weakSelf.loginView.pwd ;
            if (pwd.length == 0) {
                [MBProgressHUD showInfoWithStatus:@"请输入密码!"];
                return ;
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RRFLoginTool loginWithUserName:userName nickName:nil head_imgUrl:nil pwd:pwd type:@"phonenum" sex:1 successBlock:^(id json) {
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
                    [weakSelf requestUserInfo];
                    [weakSelf enterMain];
                }
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            } fail:^(id json) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];
        }else {
            // 微信快捷登录/注册
            [weakSelf sendAuthRequest];
        }
    };
    loginView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight - 64);
    self.loginView = loginView;
    loginView.protocolBlock = ^(){
        PZWebController *desc = [[PZWebController alloc]init];
        desc.hiddenNav = YES;
        PZAccessInfo *accessInfo = [PZParamTool createAccessInfoNotLogin];
        NSDictionary* param = @{@"accessInfo":[accessInfo yy_modelToJSONObject]};
        [MBProgressHUD show];
        [PZHttpTool postHttpRequestUrl:@"baseInfo/protocolUrl" parameters:param successBlock:^(id json) {
            [MBProgressHUD dismiss];
            desc.pathUrl = json ;
            [self.navigationController pushViewController:desc animated:YES];
        } fail:^(id json) {
        }];
    };
    
    self.tableView.tableHeaderView = self.loginView ;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    //展示第一次下载安装后的显示界面
    id isFirst =  [[NSUserDefaults standardUserDefaults] objectForKey:FirstInstall];
    BOOL isWeChatInstall = [WXApi isWXAppInstalled];
    
    BOOL showFirst = !isFirst&&isWeChatInstall ;
    if (showFirst) {
        [self showFirstLoginView];
        [[NSUserDefaults standardUserDefaults] setObject:FirstInstall forKey:FirstInstall];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setNav];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFirstLoginView) name:@"removeFirstLoginView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:DISMISSLOGIN object:nil];
}

-(void)removeFirstLoginView{
    if (self.firstLoginView) {
        [self.firstLoginView removeFromSuperview];
    }
}

-(void)showFirstLoginView{
    UIView* rootView = [PZReactUIManager createWithPage:@"login" params:nil size:CGSizeZero];
    rootView.frame = self.loginView.bounds ;
    [self.loginView addSubview:rootView];
    self.firstLoginView = rootView ;
    
}


-(void)requestUserInfo{
    if ([PZParamTool hasLogin]) {
        [RRFMeTool requestUserInfoWithSuccess:^(id json) {
            if(json != nil){
                LoginModel* userM = [LoginModel yy_modelWithJSON:json[@"userInfo"]];
                [XTChatUtil loginChatAccount:userM.xtNumber pwd:@"123456" complete:^(id resultObject, NSError *error) {
                    
                }];
            }
        } failBlock:^(id json) {
        }];
    }
}

#pragma mark - dismissSelf
-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = [NSString stringWithFormat:@"%d",arc4random_uniform(100000)] ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


-(void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    leftBtn.frame = CGRectMake(0, 0, 40 ,40);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - 取消登录
-(void)cancelLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 进入首页
-(void)enterMain{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor colorWithHexString:@"4964ef"]];
    navBar.shadowImage = [UIImage createImageWithColor:[UIColor whiteColor]];
    navBar.barStyle = UIStatusBarStyleDefault;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    LoginModel *loginM = [Singleton sharedInstance].loginModel;
    self.loginView.loginM = loginM;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DISMISSLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeFirstLoginView" object:nil];
}
@end
