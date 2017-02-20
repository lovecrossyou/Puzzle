//
//  FBActionSheet.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBActionSheet.h"
#import "HBShareTool.h"
static FBSharePanel* sharePanel ;
@implementation FBActionSheet
+(void)showPicker:(RRFCalendarView*)view{
    UIWindow* mainWindow = [UIApplication sharedApplication].keyWindow ;
    UIControl* maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor lightGrayColor];
    maskView.alpha = 0.5 ;
    [mainWindow addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [mainWindow addSubview:view];
    CGFloat viewHeight = view.frame.size.height ;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(viewHeight);
        make.bottom.mas_equalTo(0);
    }];
    
    view.confirmBlock = ^(){
        
    };
    
    [[maskView rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIControl* sender) {
        [sender removeFromSuperview];
        [view removeFromSuperview];
    }];
}


+(void)showCalendar:(FSCalendar*)view{
    UIWindow* mainWindow = [UIApplication sharedApplication].keyWindow ;
    UIControl* maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor lightGrayColor];
    maskView.alpha = 0.5 ;
    [mainWindow addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [mainWindow addSubview:view];
    CGFloat viewHeight = view.frame.size.height ;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(viewHeight);
        make.bottom.mas_equalTo(0);
    }];
    
    [[maskView rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIControl* sender) {
        [sender removeFromSuperview];
        [view removeFromSuperview];
    }];
}


+(void)showView:(FBSharePanel*)view presentedController:(UIViewController *)presentedController{
    sharePanel = view ;
    UIWindow* mainWindow = [UIApplication sharedApplication].keyWindow ;
    UIControl* maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor lightGrayColor];
    maskView.alpha = 0.5 ;
    [mainWindow addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [mainWindow addSubview:view];
    CGFloat viewHeight = view.frame.size.height ;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(viewHeight);
        make.bottom.mas_equalTo(0);
    }];
    
    [[maskView rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIControl* sender) {
        [sender removeFromSuperview];
        [view removeFromSuperview];
    }];
    
    view.cancelBlock = ^(){
        [sharePanel removeFromSuperview];
        [maskView removeFromSuperview];
    };
    
    view.itemClickBlock = ^(int type){
        [[HBShareTool sharedInstance] shareInView:presentedController title:nil shareText:nil shareImage:nil url:nil type:nil];
    };
}

@end
