//
//  SettingDefaultView.m
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFSettingDefaultView.h"

@interface RRFSettingDefaultView ()
@property(nonatomic,weak)UILabel *titleLabel;

@end
@implementation RRFSettingDefaultView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"设为默认";
        titleLabel.textColor = HBColor(51, 51, 51);
        titleLabel.font = [UIFont systemFontOfSize:13];
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UISwitch *switchView = [[UISwitch alloc]init];
        [switchView sizeToFit];
        self.signal = [switchView rac_signalForControlEvents:UIControlEventValueChanged];
        self.switchView = switchView;
        [self addSubview:switchView];
        [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(6);
        }];
        [switchView addTarget:self action:@selector(chooseIsDefault:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)chooseIsDefault:(UISwitch *)sender
{
    if (self.chooseBlo) {
        self.chooseBlo(sender);
    }
}
@end


