//
//  EChatFooter.m
//  Puzzle
//
//  Created by huipay on 2016/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "EChatFooter.h"
#import "UIButton+EdgeInsets.h"
@implementation EChatFooter

-(instancetype)init{
    if (self = [super init]) {
        
        WEAKSELF
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIButton* leftBet = [UIButton new];
        [leftBet setTitle:@"猜涨投注" forState:UIControlStateNormal];
        [leftBet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftBet.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        leftBet.layer.masksToBounds = YES ;
        leftBet.layer.cornerRadius = 22.5;
        [leftBet setBackgroundColor:StockRed];
        [self addSubview:leftBet];
        [leftBet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(45);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [[leftBet rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.itemClick([NSNumber numberWithBool:YES]);
        }];
        
        UIButton* rightBet = [UIButton new];
        [rightBet setTitle:@"猜跌投注" forState:UIControlStateNormal];
        [rightBet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBet.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        rightBet.layer.masksToBounds = YES ;
        rightBet.layer.cornerRadius = 22.5;
        [rightBet setBackgroundColor:StockGreen];
        [self addSubview:rightBet];
        [rightBet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(leftBet.mas_right).offset(25);
            make.width.mas_equalTo(leftBet.mas_width);
            make.height.mas_equalTo(45);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [[rightBet rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.itemClick([NSNumber numberWithBool:NO]);
        }];
    }
    return self ;
}

@end
