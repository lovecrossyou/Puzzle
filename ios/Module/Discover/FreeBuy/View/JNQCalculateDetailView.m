//
//  JNQCalculateDetailView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQCalculateDetailView.h"

@interface JNQCalculateDetailDesView : UIView

@end

@implementation JNQCalculateDetailDesView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(235, 82, 82);
        
        UILabel *attenL = [[UILabel alloc] init];
        [self addSubview:attenL];
        [attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(8);
            make.height.mas_equalTo(25);
        }];
        attenL.font = PZFont(15);
        attenL.textColor = [UIColor whiteColor];
        attenL.text = @"计算公式：";
        
        UILabel *desL = [[UILabel alloc] init];
        [self addSubview:desL];
        [desL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.left.height.mas_equalTo(attenL);
        }];
        desL.font = PZFont(13);
        desL.textColor = [UIColor whiteColor];
        desL.text = @"[(数值A+数值B)÷商品所需次数]取余数+10000001";
    }
    return self;
}

@end

@implementation JNQCalculateDetailHeaderView {
    UILabel *_aValueL;
    UIButton *_detailBtn;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        JNQCalculateDetailDesView *desV = [[JNQCalculateDetailDesView alloc] init];
        [self addSubview:desV];
        [desV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 50));
        }];
        desV.layer.cornerRadius = 3;
        
        UIView *detailBV = [[UIView alloc] init];
        [self addSubview:detailBV];
        [detailBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(desV.mas_bottom).offset(15);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 73));
        }];
        detailBV.backgroundColor = [UIColor whiteColor];
        detailBV.layer.borderColor = HBColor(231, 231, 231).CGColor;
        detailBV.layer.borderWidth = 0.5;
        
        UILabel *detailDesL = [[UILabel alloc] init];
        [detailBV addSubview:detailDesL];
        [detailDesL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(detailBV).offset(10);
            make.left.mas_equalTo(detailBV).offset(15.5);
            make.width.mas_equalTo(SCREENWidth-30);
            make.height.mas_equalTo(33);
        }];
        detailDesL.font = PZFont(13);
        detailDesL.textColor = HBColor(102, 102, 102);
        detailDesL.numberOfLines = 0;
        detailDesL.text = @"数值A=该商品最后一个夺宝号码分配完毕时间点前，0元夺宝平台最后50个参与时间相加求和";
        
        _aValueL = [[UILabel alloc] init];
        [detailBV addSubview:_aValueL];
        [_aValueL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(detailDesL.mas_bottom);
            make.left.mas_equalTo(detailDesL);
            make.height.mas_equalTo(30);
        }];
        _aValueL.font = detailDesL.font;
        _aValueL.textColor = HBColor(235, 82, 82);
        
        _detailBtn = [[UIButton alloc] init];
        [detailBV addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_aValueL);
            make.right.mas_equalTo(detailBV).offset(-15);
        }];
        _detailBtn.titleLabel.font = detailDesL.font;
        [_detailBtn setTitleColor:BasicBlueColor forState:UIControlStateNormal];
        [_detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [[_detailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.buttonBlock) {
                self.buttonBlock(_detailBtn);
            }
        }];
    }
    return self;
}

- (void)setAValue:(NSInteger)aValue {
    _aValueL.text = [NSString stringWithFormat:@"数值A=%ld", aValue];
    NSMutableAttributedString *aValueString = [[NSMutableAttributedString alloc] initWithString:_aValueL.text];
    [aValueString addAttribute:NSForegroundColorAttributeName value:HBColor(102, 102, 102) range:[_aValueL.text rangeOfString:@"数值A="]];
    _aValueL.attributedText = aValueString;
}

@end

@implementation JNQCalculateDetailFooterView {
    UILabel *_bValueL;
    UILabel *_luckCodeL;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        UIView *bValueBV = [[UIView alloc] init];
        [self addSubview:bValueBV];
        [bValueBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 58));
        }];
        bValueBV.backgroundColor = [UIColor whiteColor];
        bValueBV.layer.borderColor = HBColor(231, 231, 231).CGColor;
        bValueBV.layer.borderWidth = 0.5;
        
        
        UILabel *attenL = [[UILabel alloc] init];
        [bValueBV addSubview:attenL];
        [attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bValueBV);
            make.left.mas_equalTo(bValueBV).offset(15.5);
            make.height.mas_equalTo(29);
        }];
        attenL.font = PZFont(13);
        attenL.textColor = HBColor(102, 102, 102);
        attenL.text = @"数值B=截止该商品交易上一个上证交易日收盘指数";
        
        _bValueL = [[UILabel alloc] init];
        [bValueBV addSubview:_bValueL];
        [_bValueL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(attenL.mas_bottom);
            make.left.height.mas_equalTo(attenL);
        }];
        _bValueL.font = attenL.font;
        _bValueL.textColor = attenL.textColor;
        
        UIView *luckCodeBV = [[UIView alloc] init];
        [self addSubview:luckCodeBV];
        [luckCodeBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bValueBV.mas_bottom).offset(10);
            make.centerX.width.mas_equalTo(bValueBV);
            make.height.mas_equalTo(60);
        }];
        luckCodeBV.backgroundColor = [UIColor whiteColor];
        
        UILabel *luckCodeAttenL = [[UILabel alloc] init];
        [luckCodeBV addSubview:luckCodeAttenL];
        [luckCodeAttenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(luckCodeBV);
            make.left.mas_equalTo(luckCodeBV).offset(15.5);
            make.height.mas_equalTo(30);
        }];
        luckCodeAttenL.font = PZFont(13);
        luckCodeAttenL.textColor = HBColor(102, 102, 102);
        luckCodeAttenL.text = @"计算结果";
        
        _luckCodeL = [[UILabel alloc] init];
        [luckCodeBV addSubview:_luckCodeL];
        [_luckCodeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(luckCodeAttenL.mas_bottom);
            make.centerX.mas_equalTo(luckCodeBV);
            make.height.mas_equalTo(30);
        }];
        _luckCodeL.font = PZFont(14);
        _luckCodeL.textColor = HBColor(102, 102, 102);
        _luckCodeL.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setBValue:(NSInteger)bValue tradeTime:(NSString *)tradeTime {
    _bValueL.text = [NSString stringWithFormat:@"数值B=%ld (交易日：%@)", bValue, tradeTime];
    NSMutableAttributedString *bValueString = [[NSMutableAttributedString alloc] initWithString:_bValueL.text];
    [bValueString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[_bValueL.text rangeOfString:[NSString stringWithFormat:@"%ld", bValue]]];
    _bValueL.attributedText = bValueString;
}

- (void)setBidStatus:(NSString *)bidStatus luckCode:(NSInteger)luckCode {
    NSString *luckStr = [bidStatus isEqualToString:@"have_lottery"] ? [NSString stringWithFormat:@"%ld", luckCode] : @"等待揭晓...";
    UIColor *color = [bidStatus isEqualToString:@"have_lottery"] ? BasicRedColor : BasicGoldColor;
    _luckCodeL.text = [NSString stringWithFormat:@"幸运号码：%@", luckStr];
    NSMutableAttributedString *luckString = [[NSMutableAttributedString alloc] initWithString:_luckCodeL.text];
    [luckString addAttribute:NSForegroundColorAttributeName value:color range:[_luckCodeL.text rangeOfString:luckStr]];
    _luckCodeL.attributedText = luckString;
    
}

@end

@implementation JNQCalculateDetailView

@end
