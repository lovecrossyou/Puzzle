//
//  JNQFrendsCircleCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendsCircleCell.h"
#import "UIImageView+WebCache.h"
@interface JNQFriendsCircleCell () {
    UIImageView *_headImgView;
    UILabel *_nameLabel;
    UILabel *_guessLabel;
    UILabel *_guessTimeLabel;
    UILabel *_stockNameLabel;
    UILabel *_stockNumLabel;
    UILabel *_tradeTimeLabel;
    UILabel *_resultLabel;
}

@end

@implementation JNQFriendsCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self).offset(12.5);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 4;
        _headImgView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _headImgView.layer.borderWidth = 0.5;
        
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(12.5);
            make.left.mas_equalTo(_headImgView.mas_right).offset(12.5);
            make.height.mas_equalTo(20);
        }];
        _nameLabel.font = PZFont(15);
        _nameLabel.textColor = HBColor(43, 84, 144);
        
        _guessTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_guessTimeLabel];
        [_guessTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom);
            make.left.mas_equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/2, 15));
        }];
        _guessTimeLabel.font = PZFont(12.5);
        _guessTimeLabel.textColor = HBColor(153, 153, 153);
        
        _praiseBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_praiseBtn];
        [_praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-30);
            make.size.mas_equalTo(CGSizeMake(80, 35));
        }];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_likes_d"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_likes_s"] forState:UIControlStateSelected];
        [_praiseBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        _praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            _praiseBtn.userInteractionEnabled = NO;
            if (self.cellBlock) {
                self.cellBlock(self);
            }
        }];
        
        UIView *backView = [[UIView alloc] init];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_guessTimeLabel);
            make.top.mas_equalTo(_guessTimeLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-90, 45));
        }];
        
        
        UILabel *stockNameAtten = [[UILabel alloc] init];
        [backView addSubview:stockNameAtten];
        [stockNameAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(backView);
            make.height.mas_equalTo(20);
        }];
        stockNameAtten.font = PZFont(14);
        stockNameAtten.textColor = HBColor(153, 153, 153);
        stockNameAtten.text = @"名称：";
        
        _stockNameLabel = [[UILabel alloc] init];
        [backView addSubview:_stockNameLabel];
        [_stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView);
            make.left.mas_equalTo(stockNameAtten.mas_right);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/2, 20));
        }];
        _stockNameLabel.font = PZFont(14);
        _stockNameLabel.textColor = HBColor(51, 51, 51);
        
        
        UILabel *guessAtten = [[UILabel alloc] init];
        [backView addSubview:guessAtten];
        [guessAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(stockNameAtten.mas_bottom).offset(5);
            make.left.mas_equalTo(stockNameAtten);
            make.height.mas_equalTo(20);
        }];
        guessAtten.font = PZFont(14);
        guessAtten.textColor = HBColor(153, 153, 153);
        guessAtten.text = @"投注：";
        
        _guessLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_guessLabel];
        [_guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(guessAtten);
            make.left.mas_equalTo(guessAtten.mas_right);
            make.height.mas_equalTo(20);
        }];
        _guessLabel.font = PZFont(14);
        _guessLabel.textColor = HBColor(51, 51, 51);
        
        
        _stockNumLabel = [[UILabel alloc] init];
        [backView addSubview:_stockNumLabel];
        [_stockNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/2, 20));
        }];
        _stockNumLabel.font = PZFont(14);
        _stockNumLabel.textColor = HBColor(51, 51, 51);
        _stockNumLabel.textAlignment = NSTextAlignmentRight;
        
        _resultLabel = [[UILabel alloc] init];
        [backView addSubview:_resultLabel];
        [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stockNumLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(backView);
            make.height.mas_equalTo(20);
        }];
        _resultLabel.font = PZFont(14);
        _resultLabel.textColor = HBColor(51, 51, 51);
        _resultLabel.textAlignment = NSTextAlignmentRight;
        
        UILabel *resultAtten = [[UILabel alloc] init];
        [backView addSubview:resultAtten];
        [resultAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_resultLabel);
            make.right.mas_equalTo(_resultLabel.mas_left);
            make.height.mas_equalTo(20);
        }];
        resultAtten.font = PZFont(14);
        resultAtten.textColor = HBColor(153, 153, 153);
        resultAtten.textAlignment = NSTextAlignmentRight;
        resultAtten.text = @"收盘：";
        
        UIView *sepLine = [[UIView alloc] init];
        sepLine.frame = CGRectMake(0, 113.5, SCREENWidth, 0.5);
        [self.contentView addSubview:sepLine];
        sepLine.backgroundColor = HBColor(231, 231, 231);
        
//        _tradeTimeLabel = [[UILabel alloc] init];
//        [backView addSubview:_tradeTimeLabel];
//        [_tradeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(backView).offset(8);
//            make.left.mas_equalTo(_stockNameLabel.mas_right);
//            make.size.mas_equalTo(CGSizeMake((SCREENWidth-55)*7/32, 17));
//        }];
//        _tradeTimeLabel.font = PZFont(15);
//        _tradeTimeLabel.textColor = HBColor(51, 51, 51);
        
//        UILabel *tradeTimeAtten = [[UILabel alloc] init];
//        [backView addSubview:tradeTimeAtten];
//        [tradeTimeAtten mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_tradeTimeLabel.mas_bottom);
//            make.left.mas_equalTo(_tradeTimeLabel);
//            make.size.mas_equalTo(CGSizeMake((SCREENWidth-55)*7/32, 13));
//        }];
//        tradeTimeAtten.font = PZFont(11);
//        tradeTimeAtten.textColor = HBColor(153, 153, 153);
//        tradeTimeAtten.text = @"交易日";
    }
    return self;
}

- (void)setFriendCircleModel:(JNQFriendCircleModel *)friendCircleModel {
    _friendCircleModel = friendCircleModel;
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:friendCircleModel.userIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = friendCircleModel.userName;
    _guessTimeLabel.text = friendCircleModel.guessTime;
    _praiseBtn.selected = [friendCircleModel.isPraise isEqualToString:@"alreadyPraise"] ? YES : NO;
    NSString *praiseAmout = friendCircleModel.praiseAmount ? [NSString stringWithFormat:@"%ld", friendCircleModel.praiseAmount] : @"";
    [_praiseBtn setTitle:praiseAmout forState:UIControlStateNormal];
    
    _stockNameLabel.text = friendCircleModel.stockName;
    _stockNumLabel.text = [NSString stringWithFormat:@"%ld期", friendCircleModel.stage];
    
    _guessLabel.text = [friendCircleModel.guessType isEqualToString:@"猜涨"] ? [NSString stringWithFormat:@"%@↑", friendCircleModel.guessType] : [NSString stringWithFormat:@"%@↓", friendCircleModel.guessType];
    UIColor *guessColor = [friendCircleModel.guessType isEqualToString:@"猜涨"] ? StockRed : StockGreen;
    NSMutableAttributedString *guessString = [[NSMutableAttributedString alloc] initWithString:_guessLabel.text];
    [guessString addAttribute:NSForegroundColorAttributeName value:guessColor range:NSMakeRange(_guessLabel.text.length-1, 1)];
    _guessLabel.attributedText = guessString;
    
    UIColor *resultColor = [UIColor whiteColor];
    if ([friendCircleModel.finalResult isEqualToString:@"涨"]) {
        _resultLabel.text = [NSString stringWithFormat:@"%@↑", friendCircleModel.finalResult];
        resultColor = StockRed;
    } else if ([friendCircleModel.finalResult isEqualToString:@"跌"]) {
        _resultLabel.text = [NSString stringWithFormat:@"%@↓", friendCircleModel.finalResult];
        resultColor = StockGreen;
    } else {
        _resultLabel.text = friendCircleModel.finalResult;
        resultColor = HBColor(51, 51, 51);
    }
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:_resultLabel.text];
    [resultString addAttribute:NSForegroundColorAttributeName value:resultColor range:NSMakeRange(_resultLabel.text.length-1, 1)];
    _resultLabel.attributedText = resultString;
}


@end
