//
//  FBActionSheet.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSharePanel.h"
#import <FSCalendar/FSCalendar.h>
#import "RRFCalendarView.h"
@interface FBActionSheet : UIView
+(void)showPicker:(RRFCalendarView*)view;
+(void)showCalendar:(FSCalendar*)view;
+(void)showView:(FBSharePanel*)view presentedController:(UIViewController *)presentedController;
@end
