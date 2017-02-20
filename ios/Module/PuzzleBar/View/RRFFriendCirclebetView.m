//
//  RRFFriendCirclebetView.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFriendCirclebetView.h"
#import "RRFBettingLabel.h"
#import "PZParamTool.h"

@interface RRFFriendCirclebetView ()

@property(nonatomic,weak)RRFBettingLabel *nameLabel;
@property(nonatomic,weak)UILabel *stageLabel;

// 投注数量
@property(nonatomic,weak)UILabel *guessLabel;
// 收盘
@property(nonatomic,weak)RRFBettingLabel *shoupanLabel;
// 盈亏
@property(nonatomic,weak)UIButton *resultLabel;
// 数额
@property(nonatomic,weak)UIButton *guessTotalLabel;

// 是否是会员
@property(nonatomic,strong)UIButton *guessBtn;
// 是否是会员
@property(nonatomic,strong)UIButton *guessNumBtn;


@property(nonatomic,weak)UILabel *guessNumTitleLable;

@property(nonatomic,weak)UIButton *commentsBtn;
@property(nonatomic,weak)UIButton *agreeBtn;
@property(nonatomic,weak)UIButton *rewardBtn;
@property(nonatomic,strong)NSString *isPraise;

@end
@implementation RRFFriendCirclebetView
-(instancetype)init{
    if (self = [super init]) {
        // 名称
        RRFBettingLabel *nameLabel = [[RRFBettingLabel alloc]initWithTitle:@"名 称:"];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
        }];
        
        // 期数
        UILabel *stageLabel = [[UILabel alloc]init];
        stageLabel.textColor = [UIColor colorWithHexString:@"333333"];
        stageLabel.font = [UIFont systemFontOfSize:14];
        [stageLabel sizeToFit];
        self.stageLabel = stageLabel;
        [self addSubview:stageLabel];
        [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
        }];
        
        // 投注
        UILabel *guessTitleLable = [[UILabel alloc]init];
        guessTitleLable.text = @"投 注:";
        guessTitleLable.textColor =[UIColor colorWithHexString:@"999999"];
        guessTitleLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:guessTitleLable];
        [guessTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
        UILabel *guessLabel = [[UILabel alloc]init];
        guessLabel.textColor =[UIColor colorWithHexString:@"333333"];
        guessLabel.font = [UIFont systemFontOfSize:14];
        self.guessLabel = guessLabel;
        [self addSubview:guessLabel];
        [guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(guessTitleLable.mas_right).offset(6);
            make.centerY.mas_equalTo(guessTitleLable.mas_centerY);
        }];

        UIButton *guessBtn = [[UIButton alloc]init];
        [guessBtn setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        self.guessBtn = guessBtn;
        [self addSubview:guessBtn];
        [guessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(guessTitleLable.mas_right).offset(6);
            make.centerY.mas_equalTo(guessTitleLable.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(68, 30));
        }];
        WEAKSELF
        [[guessBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.betViewCheckBlock) {
                weakSelf.betViewCheckBlock();
            }
        }];
        
        // 数额
        UIButton *guessTotalLabel = [[UIButton alloc]init];
        [guessTotalLabel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [guessTotalLabel setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        guessTotalLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        guessTotalLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        self.guessTotalLabel = guessTotalLabel;
        [guessTotalLabel sizeToFit];
        [self addSubview:guessTotalLabel];
        [guessTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(guessTitleLable.mas_centerY);
        }];
        
        // 数额
        UILabel *guessNumTitleLable = [[UILabel alloc]init];
        guessNumTitleLable.text = @"数 额:";
        guessNumTitleLable.textColor =[UIColor colorWithHexString:@"999999"];
        guessNumTitleLable.font = [UIFont systemFontOfSize:14];
        self.guessNumTitleLable = guessNumTitleLable;
        [self addSubview:guessNumTitleLable];
        [guessNumTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(guessTitleLable.mas_centerY);
            make.right.mas_equalTo(guessTotalLabel.mas_left).offset(-50);
        }];
        
        // 是否是会员
        UIButton *guessNumBtn = [[UIButton alloc]init];
        [guessNumBtn setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        self.guessNumBtn = guessNumBtn;
        [self addSubview:guessNumBtn];
        [guessNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(guessNumTitleLable.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(68, 30));
            make.right.mas_equalTo(0);
        }];
        [[guessNumBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.betViewCheckBlock) {
                weakSelf.betViewCheckBlock();
            }
        }];
        
        // 收盘
        RRFBettingLabel *shoupanLabel = [[RRFBettingLabel alloc]initWithTitle:@"收 盘:"];
        [shoupanLabel subTitleRight:NO];
        [shoupanLabel sizeToFit];
        shoupanLabel.subTitleLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.shoupanLabel = shoupanLabel;
        [self addSubview:shoupanLabel];
        [shoupanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(guessTitleLable.mas_bottom).offset(4);
            make.left.mas_equalTo(-0);
            make.height.mas_equalTo(20);
        }];
        
        // 盈亏数额
        UIButton *resultLabel = [[UIButton alloc]init];
        resultLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [resultLabel setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        [resultLabel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [resultLabel sizeToFit];
        resultLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        self.resultLabel = resultLabel;
        [self addSubview:resultLabel];
        [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(shoupanLabel.mas_centerY);
            make.right.mas_equalTo(0);
        }];
        
        // 盈亏
        UILabel *resultTitleLable = [[UILabel alloc]init];
        resultTitleLable.text = @"盈 亏:";
        resultTitleLable.textColor =[UIColor colorWithHexString:@"999999"];
        resultTitleLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:resultTitleLable];
        [resultTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(shoupanLabel.mas_centerY);
            make.right.mas_equalTo(guessNumTitleLable.mas_right);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}
-(void)setModel:(GuessWithStockModel *)model
{
    [self.nameLabel.subTitleLabel setTitle:model.stockName forState:UIControlStateNormal];
    self.stageLabel.text = [NSString stringWithFormat:@"%ld期",model.stage];
    
    self.guessBtn.hidden = [model.guessType isEqualToString:@"会员可见"] ? NO : YES;
    self.guessLabel.hidden = !self.guessBtn.hidden;
    
    self.guessNumBtn.hidden = [model.guessType isEqualToString:@"会员可见"] ? NO : YES;
    self.guessTotalLabel.hidden = !self.guessNumBtn.hidden;
    if(self.guessTotalLabel.hidden == YES){
        [self.guessNumTitleLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.guessNumBtn.mas_left).offset(-20);
        }];
    }else{
        [self.guessNumTitleLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.guessTotalLabel.mas_left).offset(-50);
        }];
    }
    
    [self.guessTotalLabel setTitle:[NSString stringWithFormat:@"%ld",model.guessAmount] forState:UIControlStateNormal];
    NSString *guessTypeStr = [model.guessType isEqualToString:@"猜涨"] ? [NSString stringWithFormat:@"%@↑", model.guessType] : [NSString stringWithFormat:@"%@↓", model.guessType];
    UIColor *guessColor = [model.guessType isEqualToString:@"猜涨"] ? StockRed : StockGreen;
    NSMutableAttributedString *guessString = [[NSMutableAttributedString alloc] initWithString:guessTypeStr];
    [guessString addAttribute:NSForegroundColorAttributeName value:guessColor range:NSMakeRange(guessTypeStr.length-1, 1)];
    self.guessLabel.attributedText = guessString;
    
   
    
    NSString *resultStr ;
    UIColor *resultColor;
    if ([model.finalResult isEqualToString:@"涨"]) {
        resultStr = @"涨↑";
        resultColor =StockRed;
    }else if ([model.finalResult isEqualToString:@"跌"]){
        resultStr = @"跌↓";
        resultColor = StockGreen;
    }else{
        resultStr = model.finalResult;
        resultColor = [UIColor colorWithHexString:@"666666"];
    }
    if (resultStr==nil) {
        resultStr = @"-";
    }
    NSMutableAttributedString *resultAttritString = [[NSMutableAttributedString alloc] initWithString:resultStr];
    [resultAttritString addAttribute:NSForegroundColorAttributeName value:resultColor range:NSMakeRange(resultStr.length-1, 1)];
     [self.shoupanLabel.subTitleLabel setAttributedTitle:resultAttritString forState:UIControlStateNormal];
    
    NSString *winStr;
    UIColor *winClocr;
    if([model.status isEqualToString:@"complete"]){
        if ([model.stockResultType isEqualToString:@"wrong"]) {
            winStr = [NSString stringWithFormat:@"-%ld",model.guessAmount];
            winClocr = StockGreen;
            [self.resultLabel setImage:[UIImage imageNamed:@"dynamic_money_icon_green"] forState:UIControlStateNormal];
            
        }else if([model.stockResultType isEqualToString:@"right"]){
            winStr = [NSString stringWithFormat:@"+%ld",model.winMount];
            winClocr = StockRed;
            [self.resultLabel setImage:[UIImage imageNamed:@"dynamic_money_icon_red"] forState:UIControlStateNormal];
        }
    }else{
        winStr = @"等待开奖";
        winClocr = StockRed;
        [self.resultLabel setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    }
    NSMutableAttributedString *winAttritString = [[NSMutableAttributedString alloc] initWithString:winStr];
    [winAttritString addAttribute:NSForegroundColorAttributeName value:winClocr range:NSMakeRange(0, winStr.length)];
    [self.resultLabel setAttributedTitle:winAttritString forState:UIControlStateNormal];
}
@end
