//
//  JNQShoppingCartView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQShoppingCartView.h"

@implementation JNQShoppingCartView

@end

@implementation JNQShoppingCartBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, 60, 50)];
        [self addSubview:_allBtn];
        [_allBtn setImage:[UIImage imageNamed:@"btn_choose_d"] forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateSelected];
        [_allBtn setTitle:@" 全选  " forState:UIControlStateNormal];
        [_allBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _allBtn.titleLabel.font = PZFont(15);
        _allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/3*2, 0, SCREENWidth/3, 50)];
        [self addSubview:_payBtn];
        _payBtn.backgroundColor = BasicGoldColor;
        [_payBtn setTitle:@"去结算（0）" forState:UIControlStateNormal];
        [_payBtn setTitle:@"删除" forState:UIControlStateSelected];
        _payBtn.titleLabel.font = PZFont(17);
        
        UILabel *atten = [[UILabel alloc] init];
        [self addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(72);
        }];
        atten.font = PZFont(15);
        atten.textColor = HBColor(51, 51, 51);
        atten.text = @"合计： ";
        
        _allPrice = [[UIButton alloc] init];
        [self addSubview:_allPrice];
        [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(atten.mas_right);
        }];
        [_allPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_allPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _allPrice.titleLabel.font = PZFont(15);
        _allPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

- (void)updateAllSelectState:(BOOL)state totalPrice:(NSInteger)totalPrice totalCount:(NSInteger)totalCount {
    _allBtn.selected = state;
    [_allPrice setTitle:[NSString stringWithFormat:@"%.2f", (float)totalPrice/100] forState:UIControlStateNormal];
    [_payBtn setTitle:[NSString stringWithFormat:@"去结算(%ld)", totalCount] forState:UIControlStateNormal];
    [_payBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", totalCount] forState:UIControlStateSelected];
}

@end


@implementation JNQShoppingCartSectionHeaderView {
    UIButton *_shopBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 15, SCREENWidth+1, 45)];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        backView.layer.borderWidth = 0.5;
        
        _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.5, 0, 40, 45)];
        [backView addSubview:_allBtn];
        [_allBtn setImage:[UIImage imageNamed:@"btn_choose_d"] forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateSelected];
        [[_allBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.btnBlock) {
                self.btnBlock(_allBtn);
            }
        }];
        
        _shopBtn = [[UIButton alloc] init];
        [backView addSubview:_shopBtn];
        [_shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(backView);
            make.left.mas_equalTo(_allBtn.mas_right).offset(8);
        }];
        [_shopBtn setImage:[UIImage imageNamed:@"icon_mall"] forState:UIControlStateNormal];
        [_shopBtn setTitle:@"兑换礼品" forState:UIControlStateNormal];
        [_shopBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _shopBtn.titleLabel.font = PZFont(15);
        _shopBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return self;
}

@end






