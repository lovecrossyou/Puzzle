//
//  JNQPerHomepageCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPerHomepageCell.h"

@interface JNQPerHomepageCell () {
    UILabel *_stockTimeLabel;
    UILabel *_stockNameLabel;
    UILabel *_stockNumLabel;
    UILabel *_guessLabel;
    UIButton *_guessBtn;
    UILabel *_resultLabel;
    UIButton *_guessCountLabel;
    UIButton *_guessCountBtn;
    UIButton *_profitCountLabel;
    
    UILabel *_attenLabel;
}

@end

@implementation JNQPerHomepageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(12);
            make.right.bottom.mas_equalTo(self).offset(-12);
        }];
        _backView.backgroundColor = HBColor(245, 245, 245);
        _backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _backView.layer.borderWidth = 0.5;
        _backView.layer.cornerRadius = 4;
        
        _stockTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_stockTimeLabel];
        [_stockTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_backView).offset(22);
            make.top.mas_equalTo(_backView).offset(15);
            make.height.mas_equalTo(16);
        }];
        _stockTimeLabel.font = PZFont(12);
        _stockTimeLabel.textColor = HBColor(153, 153, 153);
        
        _attenLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_attenLabel];
        [_attenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_stockTimeLabel);
            make.right.mas_equalTo(self).offset(-22);
        }];
        _attenLabel.font = PZFont(14);
        _attenLabel.textColor = BasicRedColor;
        _attenLabel.textAlignment = NSTextAlignmentRight;
        _attenLabel.text = @"未收盘";
        //名称
        UILabel *stockNameAtten = [[UILabel alloc] init];
        [_backView addSubview:stockNameAtten];
        [stockNameAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stockTimeLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(_stockTimeLabel);
            make.height.mas_equalTo(27);
        }];
        stockNameAtten.font = PZFont(14);
        stockNameAtten.textColor = HBColor(153, 153, 153);
        stockNameAtten.text = @"名称：";
        
        _stockNameLabel = [[UILabel alloc] init];
        [_backView addSubview:_stockNameLabel];
        [_stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(stockNameAtten);
            make.left.mas_equalTo(stockNameAtten.mas_right);
        }];
        _stockNameLabel.font = PZFont(14);
        _stockNameLabel.textColor = HBColor(51, 51, 51);
        
        //投注
        UILabel *guessAtten = [[UILabel alloc] init];
        [_backView addSubview:guessAtten];
        [guessAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(stockNameAtten.mas_bottom);
            make.left.mas_equalTo(stockNameAtten);
            make.height.mas_equalTo(27);
        }];
        guessAtten.font = PZFont(14);
        guessAtten.textColor = HBColor(153, 153, 153);
        guessAtten.text = @"投注：";
        
        _guessLabel = [[UILabel alloc] init];
        [_backView addSubview:_guessLabel];
        [_guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(guessAtten);
            make.left.mas_equalTo(guessAtten.mas_right);
        }];
        _guessLabel.font = PZFont(14);
        _guessLabel.textColor = HBColor(51, 51, 51);
        
        _guessBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_guessBtn];
        [_guessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_guessLabel);
        }];
        [_guessBtn setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        [[_guessBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.btnBlock) {
                self.btnBlock(_guessBtn);
            }
        }];
        
        //收盘
        UILabel *resultAtten = [[UILabel alloc] init];
        [_backView addSubview:resultAtten];
        [resultAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(guessAtten.mas_bottom);
            make.left.mas_equalTo(guessAtten);
            make.height.mas_equalTo(27);
        }];
        resultAtten.font = PZFont(14);
        resultAtten.textColor = HBColor(153, 153, 153);
        resultAtten.textAlignment = NSTextAlignmentRight;
        resultAtten.text = @"收盘：";
        
        _resultLabel = [[UILabel alloc] init];
        [_backView addSubview:_resultLabel];
        [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(resultAtten);
            make.left.mas_equalTo(resultAtten.mas_right);
        }];
        _resultLabel.font = PZFont(14);
        _resultLabel.textColor = HBColor(51, 51, 51);
        
        //期号
        _stockNumLabel = [[UILabel alloc] init];
        [_backView addSubview:_stockNumLabel];
        [_stockNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stockNameLabel);
            make.right.mas_equalTo(_backView).offset(-22);
            make.height.mas_equalTo(27);
        }];
        _stockNumLabel.font = PZFont(14);
        _stockNumLabel.textColor = HBColor(51, 51, 51);
        _stockNumLabel.textAlignment = NSTextAlignmentRight;
        
        //数额
        _guessCountLabel = [[UIButton alloc] init];
        [_backView addSubview:_guessCountLabel];
        [_guessCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stockNumLabel.mas_bottom);
            make.right.mas_equalTo(_backView).offset(-22);
            make.height.mas_equalTo(27);
        }];
        [_guessCountLabel setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        [_guessCountLabel setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        _guessCountLabel.titleLabel.font = PZFont(14);
        _guessCountLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        UILabel *guessCountAtten = [[UILabel alloc] init];
        [_backView addSubview:guessCountAtten];
        [guessCountAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_guessCountLabel);
            make.right.mas_equalTo(self).offset(-125);
        }];
        guessCountAtten.font = PZFont(14);
        guessCountAtten.textColor = HBColor(153, 153, 153);
        guessCountAtten.textAlignment = NSTextAlignmentRight;
        guessCountAtten.text = @"数额：";
        
        _guessCountBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_guessCountBtn];
        [_guessCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(_guessCountLabel);
        }];
        [_guessCountBtn setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];\
        [[_guessCountBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.btnBlock) {
                self.btnBlock(_guessCountBtn);
            }
        }];
        
        //盈亏
        _profitCountLabel = [[UIButton alloc] init];
        [_backView addSubview:_profitCountLabel];
        [_profitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_guessCountLabel.mas_bottom);
            make.right.height.mas_equalTo(_guessCountLabel);
        }];
        [_profitCountLabel setTitleColor:BasicRedColor forState:UIControlStateNormal];
        
        _profitCountLabel.titleLabel.font = PZFont(14);
        _profitCountLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        UILabel *profitCountAtten = [[UILabel alloc] init];
        [_backView addSubview:profitCountAtten];
        [profitCountAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_guessCountLabel.mas_bottom);
            make.right.mas_equalTo(self).offset(-125);
            make.height.mas_equalTo(27);
        }];
        profitCountAtten.font = PZFont(14);
        profitCountAtten.textColor = HBColor(153, 153, 153);
        profitCountAtten.textAlignment = NSTextAlignmentRight;
        profitCountAtten.text = @"盈亏：";
    }
    return self;
}

- (void)setCircleModel:(JNQFriendCircleModel *)circleModel {
    _circleModel = circleModel;
    _stockTimeLabel.text = circleModel.guessTime;
    _stockNameLabel.text = circleModel.stockName;
    _stockNumLabel.text = [NSString stringWithFormat:@"%ld期", circleModel.stage];
    _backView.backgroundColor = [circleModel.guessGameStatus isEqualToString:@"ongoing"] ? HBColor(216, 239, 255) : [UIColor whiteColor];
    _attenLabel.hidden = [circleModel.guessGameStatus isEqualToString:@"ongoing"] ? NO : YES;
    
    _guessBtn.hidden = [circleModel.guessType isEqualToString:@"会员可见"] ? NO : YES;
    _guessLabel.hidden = !_guessBtn.hidden;
    _guessLabel.text = circleModel.guessType;
    _guessLabel.text = [circleModel.guessType isEqualToString:@"猜涨"] ? [NSString stringWithFormat:@"%@↑", circleModel.guessType] : [NSString stringWithFormat:@"%@↓", circleModel.guessType];
    UIColor *guessColor = [circleModel.guessType isEqualToString:@"猜涨"] ? StockRed : StockGreen;
    NSMutableAttributedString *guessString = [[NSMutableAttributedString alloc] initWithString:_guessLabel.text];
    [guessString addAttribute:NSForegroundColorAttributeName value:guessColor range:NSMakeRange(_guessLabel.text.length-1, 1)];
    _guessLabel.attributedText = guessString;
    
    if ([circleModel.finalResult isEqualToString:@"涨"] || [circleModel.finalResult isEqualToString:@"跌"]) {
        _resultLabel.text = [circleModel.finalResult isEqualToString:@"涨"] ? [NSString stringWithFormat:@"%@↑", circleModel.finalResult] : [NSString stringWithFormat:@"%@↓", circleModel.finalResult];
        UIColor *resultColor = [circleModel.finalResult isEqualToString:@"涨"] ? StockRed : StockGreen;
        NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:_resultLabel.text];
        [resultString addAttribute:NSForegroundColorAttributeName value:resultColor range:NSMakeRange(_resultLabel.text.length-1, 1)];
        _resultLabel.attributedText = resultString;
    } else {
        _resultLabel.text = circleModel.finalResult;
    }
    
    _guessCountBtn.hidden = _guessBtn.hidden;
    _guessCountLabel.hidden = !_guessCountBtn.hidden;
    NSString *guessCountStr = circleModel.guessAmount>10000 ? [NSString stringWithFormat:@" %.1f 万", (float)circleModel.guessAmount/10000] : [NSString stringWithFormat:@" %ld", circleModel.guessAmount];
    [_guessCountLabel setTitle:guessCountStr forState:UIControlStateNormal];
    
    if ([circleModel.guessResultAmount isEqualToString:@"等待开奖"] || [circleModel.guessResultAmount isEqualToString:@"进行中"] || [circleModel.guessResultAmount isEqualToString:@"未开始"]) {
        [_profitCountLabel setTitle:circleModel.guessResultAmount forState:UIControlStateNormal];
        [_profitCountLabel setImage:nil forState:UIControlStateNormal];
        [_profitCountLabel setTitleColor:BasicRedColor forState:UIControlStateNormal];
    } else {
        NSInteger amount = [circleModel.guessResultAmount integerValue];
        NSString *guessResultStr;
        if (amount <= -10000000) {
            guessResultStr = [NSString stringWithFormat:@" %.1f 千万", (float)amount/10000000];
        } else if (amount>-10000000 && amount <= -10000) {
            guessResultStr = [NSString stringWithFormat:@" %.1f 万", (float)amount/10000];
        } else if (amount>=10000 && amount<10000000) {
            guessResultStr = [NSString stringWithFormat:@" +%.1f 万", (float)amount/10000];
        } else if (amount>=10000000) {
            guessResultStr = [NSString stringWithFormat:@" +%.1f 千万", (float)amount/10000000];
        } else {
            guessResultStr = [NSString stringWithFormat:@" %@", circleModel.guessResultAmount];
        }
        [_profitCountLabel setTitle:guessResultStr forState:UIControlStateNormal];
        [_profitCountLabel setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        UIColor *guessColor = [circleModel.guessResultAmount integerValue]>0 ? StockRed : StockGreen;
        [_profitCountLabel setTitleColor:guessColor forState:UIControlStateNormal];
    }
}

@end
