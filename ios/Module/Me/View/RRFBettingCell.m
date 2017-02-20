//
//  RRFBettingCell.m
//  Puzzle
//
//  Created by huibei on 16/10/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBettingCell.h"
#import "RRFBettingLabel.h"
#import "JNQFriendCircleModel.h"

@interface RRFBettingCell ()
@property(nonatomic,weak)UIImageView *bgView;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *statusLabel;
@property(nonatomic,weak)UIButton *priseBtn;


@property(nonatomic,weak)RRFBettingLabel *nameLabel;
@property(nonatomic,weak)UILabel *stageLabel;

@property(nonatomic,weak)RRFBettingLabel *betTypeLabel;
@property(nonatomic,weak)RRFBettingLabel *totalCountLabel;

@property(nonatomic,weak)RRFBettingLabel *resultLabel;
@property(nonatomic,weak)RRFBettingLabel *profitLabel;

@property(weak,nonatomic)UIImageView* fortuneView ;
@end
@implementation RRFBettingCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.userInteractionEnabled = YES;
        bgView.layer.cornerRadius = 3;
        bgView.layer.masksToBounds = YES;
        self.bgView = bgView;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(6);
            make.bottom.mas_equalTo(-6);
            make.right.mas_equalTo(-15);
        }];
        
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(36);
        }];
        
        
        UILabel *statusLabel = [[UILabel alloc]init];
        statusLabel.textColor = [UIColor redColor];
        statusLabel.font = [UIFont systemFontOfSize:14];
        [statusLabel sizeToFit];
        self.statusLabel = statusLabel;
        [self.contentView addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(timeLabel.mas_centerY);
            make.left.mas_equalTo(timeLabel.mas_right).offset(6);
        }];
        
        UIButton *priseBtn = [[UIButton alloc]init];
        [priseBtn setImage:[UIImage imageNamed:@"icon_likes_d"] forState:UIControlStateNormal];
        [priseBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        priseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [priseBtn sizeToFit];
        self.priseBtn = priseBtn;
        [self.contentView addSubview:priseBtn];
        [priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(timeLabel.mas_centerY);
            make.right.mas_equalTo(-36);
        }];
        
        UIImageView* fortuneView = [[UIImageView alloc]init];
        fortuneView.image = [UIImage imageNamed:@"fortune"];
        fortuneView.alpha = 0.2 ;
        [self.contentView addSubview:fortuneView];
        [fortuneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(65,65));
            make.top.mas_equalTo(timeLabel.mas_top).offset(-8);
            make.right.mas_equalTo(-48);
        }];
        self.fortuneView = fortuneView ;
        self.fortuneView.hidden = YES ;
    

        RRFBettingLabel *nameLabel = [[RRFBettingLabel alloc]initWithTitle:@"名 称:"];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(14);
            make.left.mas_equalTo(36);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *stageLabel = [[UILabel alloc]init];
        stageLabel.textColor = [UIColor colorWithHexString:@"333333"];
        stageLabel.font = [UIFont systemFontOfSize:14];
        [stageLabel sizeToFit];
        self.stageLabel = stageLabel;
        [self.contentView addSubview:stageLabel];
        [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(14);
            make.right.mas_equalTo(-36);
        }];
        
        
        RRFBettingLabel *betTypeLabel = [[RRFBettingLabel alloc]initWithTitle:@"投 注:"];
        [betTypeLabel sizeToFit];
        self.betTypeLabel = betTypeLabel;
        [self.contentView addSubview:betTypeLabel];
        [betTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(8);
            make.width.mas_equalTo((SCREENWidth-36-36)/2);
            make.left.mas_equalTo(36);
            make.height.mas_equalTo(20);

        }];
        
        RRFBettingLabel *totalCountLabel = [[RRFBettingLabel alloc]initWithTitle:@"数 额:"];
        [totalCountLabel subTitleRight:YES];
        [totalCountLabel sizeToFit];
        totalCountLabel.subTitleLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.totalCountLabel = totalCountLabel;
        [self.contentView addSubview:totalCountLabel];
        [totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(betTypeLabel.mas_right);
            make.width.mas_equalTo((SCREENWidth-36-36)/2);
            make.right.mas_equalTo(-36);
            make.height.mas_equalTo(20);

        }];
        
        RRFBettingLabel *resultLabel = [[RRFBettingLabel alloc]initWithTitle:@"收 盘:"];
        [resultLabel sizeToFit];
        self.resultLabel = resultLabel;
        [self.contentView addSubview:resultLabel];
        [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(betTypeLabel.mas_bottom).offset(8);
            make.width.mas_equalTo((SCREENWidth-36-36)/2);
            make.left.mas_equalTo(36);
            make.height.mas_equalTo(20);
        }];

        RRFBettingLabel *profitLabel = [[RRFBettingLabel alloc]initWithTitle:@"盈 亏:"];
        [profitLabel sizeToFit];
        [profitLabel subTitleRight:YES];
        profitLabel.subTitleLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.profitLabel = profitLabel;
        [self.contentView addSubview:profitLabel];
        [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(betTypeLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(resultLabel.mas_right);
            make.width.mas_equalTo((SCREENWidth-36-36)/2);
            make.right.mas_equalTo(-36);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}
-(void)setModel:(JNQFriendCircleModel *)model{
    self.timeLabel.text = [NSString stringWithFormat:@"投注时间:%@",model.guessTime];
    if (model.praiseAmount > 0) {
        [self.priseBtn setTitle:[NSString stringWithFormat:@"  %ld",model.praiseAmount] forState:UIControlStateNormal];
    }
    [self.nameLabel.subTitleLabel setTitle: model.stockName forState:UIControlStateNormal];
    [self.betTypeLabel.subTitleLabel setTitle: model.guessType forState:UIControlStateNormal];
    if ([model.guessType isEqualToString:@"猜涨"]) {
        self.betTypeLabel.iconStr = @"icon_arrow_red";
    }else{
        self.betTypeLabel.iconStr = @"icon_arrow_green";
    }
    
    [self.totalCountLabel.subTitleLabel setTitle: [NSString stringWithFormat:@"% ld",model.guessAmount] forState:UIControlStateNormal];
    [self.totalCountLabel.subTitleLabel setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
    [self.resultLabel.subTitleLabel setTitle: model.finalResult forState:UIControlStateNormal];
    if ([model.finalResult isEqualToString:@"涨"]) {
        self.resultLabel.iconStr = @"icon_arrow_red";
    }else if ([model.finalResult isEqualToString:@"跌"]){
        self.resultLabel.iconStr = @"icon_arrow_green";
    }else{
        self.resultLabel.iconStr = @"";
    }
    
    self.stageLabel.text = [NSString stringWithFormat:@"%ld期",model.stage];
    NSString *countStr = model.guessResultAmount;
    if ([countStr isEqualToString:@"进行中"]||[countStr isEqualToString:@"等待开奖"]) {
        self.fortuneView.hidden = YES ;
        self.statusLabel.text = @"未收盘";
        self.bgView.image = [UIImage imageNamed:@"bettingrecord_blue"];
        self.bgView.highlightedImage = [UIImage imageNamed:@"bettingrecord_blue"];

        [self.profitLabel.subTitleLabel setTitle:countStr forState:UIControlStateNormal];
        [self.profitLabel.subTitleLabel setTitleColor:StockRed forState:UIControlStateNormal];
        [self.profitLabel.subTitleLabel setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }else{
        self.statusLabel.text = @"";
        self.bgView.image = [UIImage imageNamed:@"bettingrecord_white"];
        self.bgView.highlightedImage = [UIImage imageNamed:@"bettingrecord_white"];
        UIColor *strColor;
        if ([model.stockResultType isEqualToString:@"wrong"]) {
            strColor = StockGreen;
        }else{
            strColor = StockRed;
        }
        [self.profitLabel.subTitleLabel setTitleColor:strColor forState:UIControlStateNormal];
        [self.profitLabel.subTitleLabel setTitle: [NSString stringWithFormat:@" %@",model.guessResultAmount] forState:UIControlStateNormal];
        [self.profitLabel.subTitleLabel setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        if ([model.guessResultAmount hasPrefix:@"-"]) {
            //亏
            self.fortuneView.hidden = YES ;
        }
        else{
            //赢
            self.fortuneView.hidden = NO ;
        }
        
    }
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    if (editing) {
        self.bgView.alpha = 0 ;
    }
    else{
        self.bgView.alpha = 1 ;
    }
    [super setEditing:editing animated:animated];
}



-(void)setHighlighted:(BOOL)highlighted{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
