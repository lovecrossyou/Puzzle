//
//  SettingDefaultView.h
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
typedef void(^ChooseBlock)(UISwitch *switchBtn);
#import <UIKit/UIKit.h>

@interface RRFSettingDefaultView : UIControl
@property(nonatomic,weak)UISwitch *switchView;

@property(strong,nonatomic) RACSignal* signal ;
@property(nonatomic,assign)BOOL isDefault;

@property(nonatomic,copy)ChooseBlock  chooseBlo;
@end
