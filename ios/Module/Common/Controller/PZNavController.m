//
//  PZNavController.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNavController.h"
#import "UIImage+Image.h"
#import "JCHATConversationListViewController.h"
@interface PZNavController ()

@end

@implementation PZNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self blueTheme];
}

-(void)lightGrayTheme{
     UINavigationBar *navBar = self.navigationBar;
     [navBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"f7f7f8"]] forBarMetrics:UIBarMetricsDefault];
     [navBar setTintColor:[UIColor whiteColor]];
     
     navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
     
     self.navigationBar.barTintColor = [UIColor blackColor];
     self.navigationBar.tintColor = [UIColor darkGrayColor];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

-(void)redTheme{
    UINavigationBar *navBar = self.navigationBar;
    [navBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.7968 green:0.2186 blue:0.204 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor whiteColor]];
    
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};

}

-(void)blueTheme{
    UINavigationBar *navBar = self.navigationBar;
    [navBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"4964ef"]] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor whiteColor]];
    
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (viewController.class == [JCHATConversationListViewController class])
        {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
@end
