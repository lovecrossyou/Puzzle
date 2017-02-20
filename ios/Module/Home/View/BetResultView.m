//
//  BetResultView.m
//  Puzzle
//
//  Created by huibei on 16/10/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BetResultView.h"
#import "StockDetailModel.h"
#import "PZBetCurrency.h"

@interface BetResultView ()
@property(nonatomic,weak)UIImageView *bgView;
@property(nonatomic,weak)UIButton *closeBtn;
@property(nonatomic,weak)UILabel *resultLabel;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *termLabel;
@property(nonatomic,weak)UIButton *betLabel;
@property(nonatomic,weak) UILabel *priceTitleLabel;
@property(nonatomic,weak)UIButton *totlalPriceLabel;
@property(nonatomic,weak)UILabel *timeTitleLabel;
@property(nonatomic,weak)UILabel *timeMonthLabel;
@property(nonatomic,weak)UILabel *timeDayLabel;

@end
@implementation BetResultView
-(instancetype)initWithModel:(GameModel *)model type:(int)guessType amount:(NSString *)amount
{
    if (self = [super init]) {
        UIImageView *bgView = [[UIImageView alloc]init];
        self.bgView = bgView;
        bgView.image = [UIImage imageNamed:@"betsuccess_lg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UIButton *closeBtn = [[UIButton alloc]init];
        self.closeBtn = closeBtn;
        [closeBtn setImage:[UIImage imageNamed:@"btn_close_x"] forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.top.mas_equalTo(0);
        }];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.closeClick) {
                self.closeClick();
            }
        }];
        
        UILabel *resultLabel = [[UILabel alloc]init];
        self.resultLabel = resultLabel;
        resultLabel.text = @"投注成功!";
        resultLabel.textColor = [UIColor whiteColor];
        resultLabel.font = [UIFont boldSystemFontOfSize:18];
        [resultLabel sizeToFit];
        [self addSubview:resultLabel];
        [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(34);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        self.nameLabel = nameLabel;
        nameLabel.text = [NSString stringWithFormat:@"%@",model.stockGameName];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = [UIFont systemFontOfSize:14];
        [nameLabel sizeToFit];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(resultLabel.mas_bottom).offset(27.5);
            make.width.mas_equalTo((SCREENWidth-70)/3);
            make.left.mas_equalTo(0);
        }];
        
        UILabel *termLabel = [[UILabel alloc]init];
        self.termLabel= termLabel;
        termLabel.text = [NSString stringWithFormat:@"%d期",model.stage];
        termLabel.textColor = [UIColor whiteColor];
        termLabel.font = [UIFont systemFontOfSize:14];
        termLabel.textAlignment = NSTextAlignmentCenter;
        [termLabel sizeToFit];
        [self addSubview:termLabel];
        [termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_top);
            make.left.mas_equalTo(nameLabel.mas_right).offset(0);
            make.width.mas_equalTo((SCREENWidth-70)/3);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
        }];
        
        NSString *betStr = guessType== 0?@"看涨":@"看跌";
        UIColor *betColor = guessType == 0?StockRed:StockGreen;
        NSString *imageStr = guessType == 0?@"icon_arrow_red":@"icon_arrow_green";
        UIButton *betLabel = [[UIButton alloc]init];
        [betLabel setTitle:betStr forState:UIControlStateNormal];
        [betLabel setTitleColor:betColor forState:UIControlStateNormal];
        [betLabel setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        betLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        betLabel.imageEdgeInsets = UIEdgeInsetsMake(2,26,2,_betLabel.titleLabel.bounds.size.width);
        betLabel.titleEdgeInsets = UIEdgeInsetsMake(0, -betLabel.titleLabel.bounds.size.width-16, 0, 0);
        [betLabel sizeToFit];
        betLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:betLabel];
        [betLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.left.mas_equalTo(termLabel.mas_right).offset(8);
            make.top.mas_equalTo(nameLabel.mas_top);
            make.width.mas_equalTo((SCREENWidth-70)/3);

        }];
        
        UILabel *priceTitleLabel = [[UILabel alloc]init];
        self.priceTitleLabel = priceTitleLabel;
        priceTitleLabel.text = @"金额";
        priceTitleLabel.textAlignment = NSTextAlignmentRight;
        priceTitleLabel.textColor = [UIColor whiteColor];
        priceTitleLabel.font = [UIFont systemFontOfSize:13];
        [priceTitleLabel sizeToFit];
        [self addSubview:priceTitleLabel];
        [priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(12.5);
            make.width.mas_equalTo((SCREENWidth-70)/3);
            make.left.mas_equalTo(0);
        }];
        
        NSString* amountString = [NSString stringWithFormat:@"%@",amount];
        UIButton *totlalPriceLabel = [[UIButton alloc]init];
        self.totlalPriceLabel = totlalPriceLabel;
        [totlalPriceLabel setTitle:amountString forState:UIControlStateNormal];
        totlalPriceLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [totlalPriceLabel setImage:[UIImage imageNamed:@"icon_maddle"] forState:UIControlStateNormal];
        [totlalPriceLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        totlalPriceLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [totlalPriceLabel sizeToFit];
        totlalPriceLabel.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        [self addSubview:totlalPriceLabel];
        [totlalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceTitleLabel.mas_right).offset(0);
            make.centerY.mas_equalTo(priceTitleLabel.mas_centerY);
            make.width.mas_equalTo((SCREENWidth-70)/3);
            make.top.mas_equalTo(priceTitleLabel.mas_top);
        }];
        
        UILabel *timeTitleLabel = [[UILabel alloc]init];
        self.timeTitleLabel = timeTitleLabel;
        timeTitleLabel.text = @"开奖时间";
        timeTitleLabel.textAlignment = NSTextAlignmentRight;
        timeTitleLabel.textColor = [UIColor whiteColor];
        timeTitleLabel.font = [UIFont systemFontOfSize:14];
        [timeTitleLabel sizeToFit];
        [self addSubview:timeTitleLabel];
        [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceTitleLabel.mas_bottom).offset(12.5);
            make.width.mas_equalTo((SCREENWidth-70)/3);
            make.left.mas_equalTo(0);
        }];
        
        NSString *month = model.comesTime;
        if (month.length > 6) {
            NSString *monthStr = [month substringFromIndex:5];
            month = [monthStr substringToIndex:monthStr.length-9];
        }
        UILabel *timeMonthLabel = [[UILabel alloc]init];
        self.timeMonthLabel = timeMonthLabel;
        timeMonthLabel.text = month;
        timeMonthLabel.textColor = [UIColor whiteColor];
        timeMonthLabel.font = [UIFont systemFontOfSize:14];
        timeMonthLabel.textAlignment = NSTextAlignmentCenter;
        [timeMonthLabel sizeToFit];
        [self addSubview:timeMonthLabel];
        [timeMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeTitleLabel.mas_right).offset(0);
            make.top.mas_equalTo(timeTitleLabel.mas_top);
            make.centerY.mas_equalTo(timeTitleLabel.mas_centerY);
            make.width.mas_equalTo((SCREENWidth-70)/3);
        }];
        
        NSString *day = model.comesTime;
        if (day.length > 6) {
            NSString *dayStr = [model.comesTime substringFromIndex:11];
            day = [dayStr substringToIndex:dayStr.length-3];
        }
        UILabel *timeDayLabel = [[UILabel alloc]init];
        self.timeDayLabel = timeDayLabel;
        timeDayLabel.text = day;
        timeDayLabel.textColor = [UIColor whiteColor];
        timeDayLabel.font = [UIFont systemFontOfSize:14];
        timeDayLabel.textAlignment = NSTextAlignmentLeft;
        [timeDayLabel sizeToFit];
        [self addSubview:timeDayLabel];
        [timeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeMonthLabel.mas_right).offset(0);
            make.top.mas_equalTo(timeTitleLabel.mas_top);
            make.centerY.mas_equalTo(timeTitleLabel.mas_centerY);
            make.width.mas_equalTo((SCREENWidth-70)/3);
        }];
    }
    return self;
}


@end
