//
//  JNQConfirmFBOrderView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQConfirmFBOrderView.h"

@implementation JNQConfirmFBOrderView

@end


@implementation JNQConfirmFBOrderHeaderView {
    UILabel *_comNameL;
    UILabel *_stageNoL;
    JNQXTButton *_inCountBtn;
    JNQXTButton *_allInPriceBtn;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        UIView *backV = [[UIView alloc] init];
        [self addSubview:backV];
        [backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(150);
        }];
        backV.backgroundColor = [UIColor whiteColor];
        
        _comNameL = [[UILabel alloc] init];
        [backV addSubview:_comNameL];
        [_comNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(backV).offset(12);
            make.height.mas_equalTo(20);
        }];
        _comNameL.font = PZFont(15);
        _comNameL.textColor = HBColor(51, 51, 51);
        _comNameL.text = @"Apple苹果iPhone7（A1600）128G 黑色";
        
        _stageNoL = [[UILabel alloc] init];
        [backV addSubview:_stageNoL];
        [_stageNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comNameL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_comNameL);
        }];
        _stageNoL.font = PZFont(14);
        _stageNoL.textColor = HBColor(153, 153, 153);
        _stageNoL.text = @"期数：20160607001";
        
        UILabel *inCountL = [[UILabel alloc] init];
        [backV addSubview:inCountL];
        [inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stageNoL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_stageNoL);
        }];
        inCountL.font = PZFont(14);
        inCountL.textColor = HBColor(153, 153, 153);
        inCountL.text = @"参与：";
        
        _inCountBtn = [[JNQXTButton alloc] init];
        [backV addSubview:_inCountBtn];
        [_inCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(inCountL);
            make.left.mas_equalTo(inCountL.mas_right);
        }];
        _inCountBtn.selected = YES;
        _inCountBtn.titleLabel.font = PZFont(14);
        [_inCountBtn setTitle:@"20 x 3" forState:UIControlStateNormal];
        
        UIView *line = [[UIView alloc] init];
        [backV addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountBtn.mas_bottom).offset(12);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, 0.5));
        }];
        line.backgroundColor = HBColor(231, 231, 231);
        
        _allInPriceBtn = [[JNQXTButton alloc] init];
        [backV addSubview:_allInPriceBtn];
        [_allInPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.right.mas_equalTo(self).offset(-12);
            make.height.mas_equalTo(50);
        }];
        _allInPriceBtn.selected = YES;
        _allInPriceBtn.titleLabel.font = PZFont(14);
        [_allInPriceBtn setTitle:@"60" forState:UIControlStateNormal];
        
        UILabel *allInPriceL = [[UILabel alloc] init];
        [backV addSubview:allInPriceL];
        [allInPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_allInPriceBtn);
            make.right.mas_equalTo(_allInPriceBtn.mas_left);
        }];
        allInPriceL.font = PZFont(14);
        allInPriceL.textColor = HBColor(153, 153, 153);
        allInPriceL.text = @"实付：";
    }
    return self;
}

- (void)setProductM:(FBProductModel *)productM {
    _productM = productM;
    _comNameL.text = productM.productName;
    _stageNoL.text = [NSString stringWithFormat:@"期数：%ld", productM.stage];
}

- (void)setInCount:(NSInteger)inCount {
    _inCount = inCount;
    [_inCountBtn setTitle:[NSString stringWithFormat:@" %ld x %ld", _productM.priceOfOneBidInXtb, inCount] forState:UIControlStateSelected];
    [_allInPriceBtn setTitle:[NSString stringWithFormat:@" %ld", _productM.priceOfOneBidInXtb*inCount] forState:UIControlStateSelected];
}

@end


@implementation JNQConfirmFBOrderFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _inBtn = [[JNQOperationButton alloc] init];
        [self addSubview:_inBtn];
        [_inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-10, 40));
        }];
        [_inBtn setTitle:@"确认参与" forState:UIControlStateNormal];
    }
    return self;
}

@end
