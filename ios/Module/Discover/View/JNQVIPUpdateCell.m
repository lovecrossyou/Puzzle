//
//  JNQVIPUpdateCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQVIPUpdateCell.h"

@interface JNQVIPUpdateCell () {
    
    UILabel *_levelLabel;
    UILabel *_levelTime;
    UILabel *_levelGift;
    UILabel *_levelIncome;
    UILabel *_levelPrice;
    UIButton *_payBtn;
}

@end

@implementation JNQVIPUpdateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _levelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 110)];
        [self.contentView addSubview:_levelBtn];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_levelBtn.frame), 20, 100, 20)];
        [self.contentView addSubview:_levelLabel];
        _levelLabel.font = PZFont(16);
        _levelLabel.textColor = HBColor(51, 51, 51);
        
        _levelTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_levelBtn.frame), CGRectGetMaxY(_levelLabel.frame)+10, SCREENWidth/2, 18)];
        [self.contentView addSubview:_levelTime];
        _levelTime.font = PZFont(12);
        _levelTime.textColor = HBColor(153, 153, 153);
//        _levelTime.text = @"会员期限1个月";
        
        _levelIncome = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_levelBtn.frame), CGRectGetMaxY(_levelTime.frame), SCREENWidth/2, 18)];
        [self.contentView addSubview:_levelIncome];
        _levelIncome.font = PZFont(12);
        _levelIncome.textColor = HBColor(153, 153, 153);
        _levelIncome.text = @"赠送880XT币";
        
        _levelPrice = [[UILabel alloc] init];//WithFrame:CGRectMake(SCREENWidth/2-50, 20, 100, 20)];
        [self.contentView addSubview:_levelPrice];
        [_levelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(20);
            make.centerX.mas_equalTo(self).offset(15);
            make.height.mas_equalTo(20);
        }];
        _levelPrice.font = PZFont(16);
        _levelPrice.textColor = HBColor(241, 47, 47);
        _levelPrice.textAlignment = NSTextAlignmentCenter;
        
        _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth-77, 34, 65, 22)];
        [self.contentView addSubview:_payBtn];
        _payBtn.layer.borderColor = HBColor(241, 47, 47).CGColor;
        _payBtn.layer.borderWidth = 1;
        [_payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payBtn setTitleColor:HBColor(241, 47, 47) forState:UIControlStateNormal];
        _payBtn.titleLabel.font = PZFont(14);
        [[_payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.vipUpdateBlock) {
                self.vipUpdateBlock(self);
            }
        }];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREENWidth, 1)];
        [self.contentView addSubview:line];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setVipModel:(JNQVIPModel *)vipModel {
    _vipModel = vipModel;
    _levelLabel.text = vipModel.identityName;
    _levelPrice.text = [NSString stringWithFormat:@"%.0f颗钻", (float)vipModel.price/100];
    _levelTime.text = [NSString stringWithFormat:@"会员期限%d个月", vipModel.expires];
    _levelIncome.text = [NSString stringWithFormat:@"赠送%ld喜腾币", (long)vipModel.giveXtb];
    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:_levelIncome.text];
    [priceString addAttribute:NSForegroundColorAttributeName value:HBColor(247, 41, 41) range:NSMakeRange(2, _levelIncome.text.length-5)];
    _levelIncome.attributedText = priceString;
}

@end
