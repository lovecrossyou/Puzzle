//
//  AppDelegate.h
//  Puzzle
//
//  Created by 朱理哲 on 16/7/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import <CocoaLumberjack/DDLegacyMacros.h>
#import "JChatConstants.h"
#import "PZTabController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,JMessageDelegate>
@property (nonatomic,strong) PZTabController *tabBarCtl;

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic)BOOL isDBMigrating;

- (void)setupMainTabBar;

@end

