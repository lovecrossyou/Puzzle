//
//  JNQXTBExchangeCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQDiamondPayCell.h"
#import "UIImageView+WebCache.h"

@interface JNQDiamondPayCell () {
    UIImageView *_imgView;
    UIButton *_salesBtn;
    UIButton *_hotBtn;
    UILabel *_giveLabel;
}

@end

@implementation JNQDiamondPayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backImgView = [[UIView alloc] init];
        [self.contentView addSubview:backImgView];
        [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        backImgView.backgroundColor = [UIColor whiteColor];
        backImgView.layer.borderWidth = 0.5;
        backImgView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(backImgView);
            make.right.mas_equalTo(backImgView).offset(0.5);
            make.bottom.mas_equalTo(backImgView).offset(-70);
        }];
        
        _salesBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_salesBtn];
        [_salesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.top.mas_equalTo(_imgView);
            make.right.mas_equalTo(_imgView).offset(-8);
        }];
        [_salesBtn setImage:[UIImage imageNamed:@"icon_preferential"] forState:UIControlStateNormal];
        
        _count = [[UILabel alloc] init];
        [self.contentView addSubview:_count];
        [_count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake((SCREENWidth-24)/2, 50));
        }];
        _count.font = [UIFont boldSystemFontOfSize:15];//PZFont(15);
        _count.textAlignment = NSTextAlignmentCenter;
        _count.textColor = HBColor(241, 47, 47);
        
        _price = [[UILabel alloc] init];
        [self.contentView addSubview:_price];
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(8);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(12);
            make.height.mas_equalTo(20);
        }];
        _price.font = PZFont(15);
        _price.textColor = HBColor(241, 47, 47);
        
        _hotBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_hotBtn];
        [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_price);
            make.size.mas_equalTo(CGSizeMake(29, 15));
            make.left.mas_equalTo(_price.mas_right).offset(5);
        }];
        [_hotBtn setImage:[UIImage imageNamed:@"icon_hot"] forState:UIControlStateNormal];
        _hotBtn.hidden = YES;
        
        _giveLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_giveLabel];
        [_giveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_price);
            make.left.mas_equalTo(_price.mas_right).offset(5);
        }];
        _giveLabel.font = PZFont(10);
        _giveLabel.textColor = BasicBlueColor;
        
        _payBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_payBtn];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(80, 20));
            
        }];
        _payBtn.layer.borderWidth = 0.5;
        _payBtn.layer.borderColor = HBColor(241, 47, 47).CGColor;
        _payBtn.layer.cornerRadius = 10;
        [_payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payBtn setTitleColor:HBColor(241, 47, 47) forState:UIControlStateNormal];
        _payBtn.titleLabel.font = PZFont(14);
        [[_payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.diamondPayBlock) {
                self.diamondPayBlock(self);
            }
        }];
    }
    return self;
}

- (void)setDiamondModel:(JNQDiamondModel *)diamondModel {
    _diamondModel = diamondModel;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:diamondModel.picture] placeholderImage:[UIImage imageNamed:@"diamond_default"]];
    _count.text = [NSString stringWithFormat:@"%d颗钻", diamondModel.diamondCount];
    _price.text = [NSString stringWithFormat:@"￥%.2f", (float)diamondModel.price/100];
    NSMutableAttributedString *diamondPriceString = [[NSMutableAttributedString alloc] initWithString:_price.text];
    [diamondPriceString addAttribute:NSFontAttributeName value:PZFont(11) range:[_price.text rangeOfString:@"￥"]];
    _price.attributedText = diamondPriceString;
    _giveLabel.text = diamondModel.giveDiamondCount ? [NSString stringWithFormat:@"赠送%d颗钻", diamondModel.giveDiamondCount] : @"";
    _hotBtn.hidden = [diamondModel.tagName isEqualToString:@"热卖"] ? NO : YES;
    _salesBtn.hidden = [diamondModel.tagName isEqualToString:@"特惠"] ? NO : YES;
}

@end
