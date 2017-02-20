//
//  RRFFreeBuyOrderHeaderView.m
//  Puzzle
//
//  Created by huipay on 2017/1/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderHeaderView.h"
@interface RRFFreeBuyOrderHeaderView ()
@property(nonatomic,weak)UIButton *tempBtn;
@property(nonatomic,weak)UIView *rollView;
@end
@implementation RRFFreeBuyOrderHeaderView
-(instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIButton *allBtn = [[UIButton alloc]init];
        allBtn.tag = 0;
        [allBtn setTitle:@"全部订单" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateSelected];
        allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [allBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:allBtn];
        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 44));
        }];
        
        UIButton * announcBtn = [[UIButton alloc]init];
        announcBtn.tag = 1;
        [announcBtn setTitle:@"待揭晓" forState:UIControlStateNormal];
        [announcBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [announcBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateSelected];
        announcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [announcBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:announcBtn];
        [announcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(allBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 44));
        }];

        UIButton *receiveBtn = [[UIButton alloc]init];
        receiveBtn.tag = 2;
        [receiveBtn setTitle:@"待领奖" forState:UIControlStateNormal];
        [receiveBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [receiveBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateSelected];
        receiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [receiveBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:receiveBtn];
        [receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(announcBtn.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 44));
        }];
        
        UIButton *remarkBtn = [[UIButton alloc]init];
        remarkBtn.tag = 3;
        [remarkBtn setTitle:@"待晒单" forState:UIControlStateNormal];
        [remarkBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [remarkBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateSelected];
        remarkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [remarkBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:remarkBtn];
        [remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(receiveBtn.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 44));
            make.right.mas_equalTo(0);
        }];
        
        UIView *rollView =[[UIView alloc]init];
        rollView.frame = CGRectMake(0, 44, SCREENWidth/4, 2);
        rollView.backgroundColor = [UIColor colorWithHexString:@"4964ef"];
        self.rollView = rollView;
        [self addSubview:rollView];
        
        [self buttonClick:allBtn];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.top.mas_equalTo(rollView.mas_bottom);
        }];

    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    self.rollView.frame = CGRectMake(SCREENWidth/4 * button.tag, 45, SCREENWidth/4, 2);
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    }else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;

    }else if (self.tempBtn != nil && self.tempBtn != button){
        button.selected = YES;
        self.tempBtn.selected = NO;
        self.tempBtn = button;
    }
    
    if (self.buyOrderHeaderBlock) {
        self.buyOrderHeaderBlock(@(button.tag));
    }
}

@end
