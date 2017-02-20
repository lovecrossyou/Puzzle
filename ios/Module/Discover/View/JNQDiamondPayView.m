//
//  JNQXTBExchangeView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQDiamondPayView.h"


@implementation JNQDiamondPayView

@end

@implementation JNQDiamondPayHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stockBackView = [[UIView alloc] init];
        [self addSubview:_stockBackView];
        [_stockBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(self).offset(10);
            make.right.bottom.mas_equalTo(self).offset(-10);
        }];
        _stockBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        
        _backBtn = [[HBVerticalBtn alloc] initWithIcon:@"assets_icon_diamon" title:@""];;
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-1);
        }];
        _backBtn.backgroundColor = [UIColor whiteColor];
        [_backBtn setFontSize:14];
        [_backBtn setTextColor:HBColor(51, 51, 51)];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_backBtn.frame), SCREENWidth, 1)];
        [self addSubview:_line];
        _line.backgroundColor = HBColor(245, 245, 245);
    }
    return self;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    [_backBtn setTitle:[NSString stringWithFormat:@"余额：%ld颗钻", count]];
}

- (void)setStockCount:(NSInteger)stockCount {
    _stockCount = stockCount;
    [_backBtn setTitle:[NSString stringWithFormat:@"库存：%ld颗钻", stockCount]];
}

@end
