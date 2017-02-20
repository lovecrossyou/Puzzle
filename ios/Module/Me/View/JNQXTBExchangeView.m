//
//  JNQXTBExchangeView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQXTBExchangeView.h"

@implementation JNQXTBExchangeView

@end

@implementation JNQXTBExchangeHeaderView {
    JNQAcctDescribtionView *_attenView;
    UILabel *_xtbCountLabel;
    UILabel *_diamondPriceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        
        _attenView = [[JNQAcctDescribtionView alloc] init];//WithFrame:CGRectMake(15, CGRectGetMaxY(_btnsBackView.frame)+20, 100, 20)];
        [self addSubview:_attenView];
        [_attenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 40));
        }];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-1, 40, SCREENWidth+2, 225)];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
        [backView addSubview:des];
        des.textColor = HBColor(51, 51, 51);
        des.text = @"选择套餐：";
        des.font = PZFont(14);
        
        _btnsBackView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(des.frame)+10, SCREENWidth-10, 148)];
        [backView addSubview:_btnsBackView];
        CGFloat width = (SCREENWidth-50)/3;
        for (int i = 0; i<6; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10*(i%3+1)+i%3*width, i/3*18+i/3*65, width, 65)];
            [_btnsBackView addSubview:btn];
            [btn setTitleColor:BasicBlueColor forState:UIControlStateNormal];
            [btn setTitleColor:BasicRedColor forState:UIControlStateSelected];
            btn.titleLabel.font = PZFont(14);
            btn.titleLabel.numberOfLines = 2;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter ;
            btn.tag = i;
            btn.layer.borderColor = BasicBlueColor.CGColor;
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 2;
            if (i ==1) {
                btn.selected = YES;
                btn.layer.borderColor = BasicRedColor.CGColor;
            }
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (self.block) {
                    self.block(btn);
                }
            }];
        }
        
        _diamondPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame)+12, SCREENWidth-30, 20)];
        [self addSubview:_diamondPriceLabel];
        _diamondPriceLabel.textColor = BasicRedColor;
        _diamondPriceLabel.textAlignment = NSTextAlignmentRight;
        _diamondPriceLabel.font = PZFont(16);
        
        _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_diamondPriceLabel.frame)+40, SCREENWidth-40, 40)];
        [self addSubview:_payBtn];
        _payBtn.backgroundColor = [UIColor colorWithHexString:@"4964ef"];
        _payBtn.layer.cornerRadius = 4;
        [_payBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _diamondCount = diamondCount;
    _attenView.diamondCount = diamondCount;
}

- (void)setXtbCount:(NSInteger)xtbCount {
    _xtbCount = xtbCount;
    _xtbCountLabel.text = [NSString stringWithFormat:@"兑换数额：%ld XT币", (long)xtbCount];
}

- (void)setDiamondPrice:(NSInteger)diamondPrice {
    _diamondPrice = diamondPrice;
    _diamondPriceLabel.text = [NSString stringWithFormat:@"应付钻石：%ld颗", (long)diamondPrice];
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:_diamondPriceLabel.text];
    [priceString addAttribute:NSForegroundColorAttributeName value:HBColor(51, 51, 51) range:NSMakeRange(0, 5)];
    _diamondPriceLabel.attributedText = priceString;
}

@end



@implementation JNQAcctDescribtionView {
    UILabel *_atten;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        _atten = [[UILabel alloc] init];
        [self addSubview:_atten];
        [_atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.mas_equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 30));
        }];
        _atten.font = PZFont(13);
        _atten.textColor = HBColor(51, 51, 51);
        _atten.text = @"钻石余额：0 颗  (钻石兑换喜腾币为1:12)";
    }
    return self;
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _diamondCount = diamondCount;
    _atten.text = [NSString stringWithFormat:@"钻石余额：%ld 颗  (钻石兑换喜腾币为1:12)", (long)diamondCount];
    NSMutableAttributedString *diamondCountString = [[NSMutableAttributedString alloc] initWithString:_atten.text];
    [diamondCountString addAttribute:NSFontAttributeName value:PZFont(12) range:[_atten.text rangeOfString:@"(钻石兑换喜腾币为1:12)"]];
    [diamondCountString addAttribute:NSForegroundColorAttributeName value:HBColor(153, 153, 153) range:[_atten.text rangeOfString:@"(钻石兑换喜腾币为1:12)"]];
    [diamondCountString addAttribute:NSFontAttributeName value:PZFont(17) range:[_atten.text rangeOfString:[NSString stringWithFormat:@"%ld", (long)diamondCount]]];
    [diamondCountString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[_atten.text rangeOfString:[NSString stringWithFormat:@"%ld", (long)diamondCount]]];
    _atten.attributedText = diamondCountString;
}

@end
