;//
//  PZTabController.m
//  Puzzle
//
//  Created by 朱理哲 on 16/7/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZTabController.h"
#import "HomeController.h"
#import "JNQDiscoverController.h"
#import "RRFMeController.h"
#import "PZNavController.h"
#import "PZParamTool.h"
#import "RRFCommentController.h"
#import "PZBarContainerController.h"
#import "NotificateMsgUtil.h"
#import <JMessage/JMessage.h>
#import "HomeTool.h"
#import "XTChatUtil.h"
#import "PZCache.h"
@interface PZTabController ()<UITabBarControllerDelegate>

@end

@implementation PZTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO ;
    HomeController* home = [[HomeController alloc]init];
    [self setupChildViewController:home title:@"喜腾" imageName:@"tab_xiteng_s" selectedImageName:@"tab_xiteng"];
    BOOL appOpen = [PZCache sharedInstance].versionRelease ;

    UIViewController* comment = nil ;
    if (appOpen) {
        PZBarContainerController* bar = [[PZBarContainerController alloc]init];
        NSArray *titles = @[@"新闻",@"论吧"];
        bar.titles = titles;
        bar.showOnNavigationBar = YES;
        bar.menuViewStyle = WMMenuViewStyleFlood;
        bar.itemsWidths = @[@(54),@(54)]; // 这里可以设置不同的宽度
        bar.progressWidth = 64.0f ;
        bar.progressColor = [UIColor whiteColor];
        bar.progressViewIsNaughty = YES ;
        bar.menuHeight = 32.0f ;
        bar.titleColorSelected = [UIColor colorWithHexString:@"4964ef"];
        bar.titleColorNormal = [UIColor whiteColor];
        
        bar.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        comment = bar ;
    }
    else{
        comment = [[RRFCommentController alloc]init];
    }
    [self setupChildViewController:comment title:@"沙龙" imageName:@"tab_shalong_s" selectedImageName:@"tab_shalong"];
    JNQDiscoverController* discover = [[JNQDiscoverController alloc]init];
    [self setupChildViewController:discover title:@"发现" imageName:@"tab_faxian_s" selectedImageName:@"tab_faxian"];
    RRFMeController* me = [[RRFMeController alloc]init];
    [self setupChildViewController:me title:@"我" imageName:@"tab_me_s" selectedImageName:@"tab_me"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeNum:) name:RefreshFriendCircleNoticeView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyClearCircle) name:NotifyClearCircle object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDiscoverBadgeValue) name:RefreshBadgeValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMeBadgeValue) name:RefreshMeBadgeValue object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyChat) name:NotifyChat object:nil];
}

-(void)notifyChat{
    WEAKSELF
    [XTChatUtil getConversationBadge:^(NSNumber* unreadCount) {
        if (unreadCount == nil) {
            [[[weakSelf.tabBar items] objectAtIndex:2] setBadgeValue:nil];
        }
        else{
            NSString* currentNum = [NSString stringWithFormat:@"%@",unreadCount];
            [[[weakSelf.tabBar items] objectAtIndex:2] setBadgeValue:currentNum];
        }
    }];
}

-(void)refreshMeBadgeValue{
    WEAKSELF
    [self updateMeMsgCompleteBlock:^(id json) {
        int unread_count = [json intValue];
        [weakSelf refreshMeBadgeValue:unread_count];
    }];
//    [self notifyChat];
}

-(void)updateMeMsgCompleteBlock:(PZRequestSuccess)complete{
    //    查询未读消息条数
    [HomeTool pushMsgUnReadCountWithSuccessBlock:^(id json) {
        int unread_count = [json[@"unread_count"] intValue];
        complete(@(unread_count));
    } fail:^(id json) {
        
    }];
}


-(void)notifyClearCircle{
    [[[self.tabBar items] objectAtIndex:2] setBadgeValue:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0 ;
    [JPUSHService resetBadge];
}

-(void)updateBadgeNum:(NSNotification*)notificate{
    NSString* currentNum = [[[self.tabBar items] objectAtIndex:2] badgeValue];
    currentNum = [NSString stringWithFormat:@"%d",[currentNum intValue]+1];
    [[[self.tabBar items] objectAtIndex:2] setBadgeValue:currentNum];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyCircle object:nil];
}

-(void)setupChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childController.title = title;
    // 设置图标
    UITabBarItem* item = childController.tabBarItem ;
    item.image = [UIImage imageNamed:imageName];
    //文字颜色
    //设置文字颜色
    UIColor *colorSelect= [UIColor colorWithHexString:@"4964ef"];
    //未选中颜色
    UIColor *color= [UIColor colorWithHexString:@"aaaaaa"];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  color, NSForegroundColorAttributeName,
                                  nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  colorSelect, NSForegroundColorAttributeName,
                                  nil] forState:UIControlStateSelected];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    PZNavController *nav = [[PZNavController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
    nav.title = title;
}

-(void)refreshMeBadgeValue:(int)unread_count{
    NSString* unread_countString = unread_count ? [NSString stringWithFormat:@"%d",unread_count] : nil ;
    [[[self.tabBar items] objectAtIndex:3] setBadgeValue:unread_countString];
}

-(void)refreshChatBadgeValue{
    [self notifyChat];
}

-(void)refreshBadgeValue{
    [self refreshMeBadgeValue];
    [self refreshChatBadgeValue];
}


#pragma mark -  更新发现 提示数字
-(void)refreshDiscoverBadgeValue{
    NSUInteger count = [NotificateMsgUtil unReadMsgCount];
    if (count < 1) {
        [[[self.tabBar items] objectAtIndex:1] setBadgeValue:nil];
        return;
    }
    NSString* badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)count];
    [[[self.tabBar items] objectAtIndex:1] setBadgeValue:badgeValue];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshDiscoverBadgeValue];
}


@end
