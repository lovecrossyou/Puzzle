//
//  RRFCalendarView.h
//  Puzzle
//
//  Created by huipay on 2016/12/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFCalendarView : UIView
@property(nonatomic,weak)UIButton *sureBtn;
@property(nonatomic,weak)UIPickerView *pickerView;
@property(copy,nonatomic) void(^confirmBlock)();
@property(copy,nonatomic) void(^switchSolarBlock)(NSInteger index);
@end
