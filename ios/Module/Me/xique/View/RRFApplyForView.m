//
//  RRFApplyForView.m
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFApplyForView.h"
#import "Singleton.h"
#import "RRFPhoneListModel.h"
@interface RRFApplyForView ()
@property(nonatomic,weak)UIButton *applyForBtn;

@property(nonatomic,weak)UIButton *phoneBtn;


@end
@implementation RRFApplyForView
-(instancetype)init{
    if (self = [super init]) {
        
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"xitengplan_lg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UIButton *phoneBtn = [[UIButton alloc]init];
        phoneBtn.tag = 1;
        [phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        phoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [phoneBtn setTitle:[NSString stringWithFormat:@"什么是喜鹊计划?"] forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [phoneBtn sizeToFit];
        self.phoneBtn = phoneBtn;
        [self addSubview:phoneBtn];
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-20);
        }];
        
        UIButton *applyForBtn = [[UIButton alloc]init];
        applyForBtn.tag = 0;
        [applyForBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [applyForBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        [applyForBtn setTitleColor:[UIColor colorWithHexString:@"fff100"] forState:UIControlStateNormal];
        [applyForBtn setBackgroundImage:[UIImage imageNamed:@"xique_btn_shenqing"] forState:UIControlStateNormal];
        applyForBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [applyForBtn sizeToFit];
        self.applyForBtn = applyForBtn;
        [self addSubview:applyForBtn];
        [applyForBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(phoneBtn.mas_top).offset(-30);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/2, 44));
        }];
    }
    return self;
}
-(void)btnClick:(UIButton *)sender
{
    if (self.applyForBlock) {
        self.applyForBlock(@(sender.tag));
    }
}

@end
