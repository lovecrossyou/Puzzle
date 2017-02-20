//
//  RecentBetController.m
//  Puzzle
//
//  Created by huibei on 17/2/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RecentBetController.h"
#import <React/RCTRootView.h>
#import "HomeTool.h"
#import "JustNowWithStockModel.h"
#import "JNQPersonalHomepageViewController.h"
#import "PZParamTool.h"
#import "RRFDetailInfoController.h"
//#import <CodePush/CodePush.h>
#import <React/RCTBundleURLProvider.h>
#import "PZReactUIManager.h"
@interface RecentBetController ()

@end

@implementation RecentBetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    [self registeNotifications];
}

-(void)registeNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserProfileEvent:) name:@"goUserProfileEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserHomePageEvent:) name:@"goUserHomePageEvent" object:nil];
}


-(void)goUserProfileEvent:(NSNotification*)noti{
    id userId = noti.object ;
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
    desc.title = @"详细资料";
    desc.userId = [userId integerValue];
    desc.verityInfo = NO;
    desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)goUserHomePageEvent:(NSNotification*)noti{
    id userId = noti.object ;
    JNQPersonalHomepageViewController *perHomepageVC = [[JNQPersonalHomepageViewController alloc] init];
    perHomepageVC.title = @"个人投注";
    perHomepageVC.rankingType = @"currentWeek";
    perHomepageVC.otherUserId = [userId integerValue];
    [self.navigationController pushViewController:perHomepageVC animated:YES];
}


-(void)setupView{
    UIView* rootView = [PZReactUIManager createWithPage:@"home" params:nil size:CGSizeZero];
    self.view = rootView ;
}

@end
