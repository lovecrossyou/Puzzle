//
//  RRFRecordView.m
//  Puzzle
//
//  Created by huibei on 16/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRecordView.h"
#import "RRFBillBtn.h"
#import "RRFBettingStatisticalModel.h"
@interface RRFRecordView ()
// 投注金额
@property(nonatomic,weak)RRFBillBtn *totalPriceBtn;
// 投注盈利
@property(nonatomic,weak)RRFBillBtn *profiteBtn;
// 收益率
@property(nonatomic,weak)RRFBillBtn *profiteRateBtn;

@property(nonatomic,weak)UIImageView *profiteIconView;

// 投注次数
@property(nonatomic,weak)RRFBillBtn *totalCountBtn;
// 猜中次数
@property(nonatomic,weak)RRFBillBtn *hitCountBtn;
// 命中率
@property(nonatomic,weak)RRFBillBtn *hitRateBtn;

@property(nonatomic,weak)UIImageView *hitIconView;

@end
@implementation RRFRecordView
-(instancetype)initWithModel:(RRFBettingStatisticalModel *)model
{
    if (self = [super init]) {
        UIImageView *bgView =[[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"betting-record_bg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UIImageView *profiteIconView = [[UIImageView alloc]init];
        profiteIconView.backgroundColor = [UIColor clearColor];
        profiteIconView.image = [UIImage imageNamed:@"icon_yield"];
        profiteIconView.layer.masksToBounds = YES;
        profiteIconView.layer.cornerRadius = 15;
        self.profiteIconView = profiteIconView;
        [self addSubview:profiteIconView];
        [profiteIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(18);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];

        
        RRFBillBtn *totalPriceBtn = [[RRFBillBtn alloc]init];
        [totalPriceBtn.subTitleBtn setImage:[UIImage imageNamed:@"icon_money"] forState:UIControlStateNormal];
        totalPriceBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffe300"];
        NSMutableAttributedString *totalPriceStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld 喜腾币",(long)model.cumulativeBetAmount]];
        [totalPriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(totalPriceStr.length - 3, 3)];
        [totalPriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, totalPriceStr.length - 3)];
        totalPriceBtn.titleLabel.attributedText = totalPriceStr;
        self.totalPriceBtn = totalPriceBtn;
        [self addSubview:totalPriceBtn];
        [totalPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(profiteIconView.mas_bottom).offset(4);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/3);
            make.height.mas_equalTo(50);
        }];
        
        RRFBillBtn *profiteBtn = [[RRFBillBtn alloc]init];
        [profiteBtn.subTitleBtn setImage:[UIImage imageNamed:@"icon_profit"] forState:UIControlStateNormal];
        profiteBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffe300"];
        NSMutableAttributedString *profiteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld 喜腾币",(long)model.addProfit]];
        [profiteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(profiteStr.length - 3, 3)];
        [profiteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, profiteStr.length - 3)];
        profiteBtn.titleLabel.attributedText = profiteStr;
        self.profiteBtn = profiteBtn;
        [self addSubview:profiteBtn];
        [profiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalPriceBtn.mas_top);
            make.left.mas_equalTo(totalPriceBtn.mas_right).offset(0);
            make.width.mas_equalTo(SCREENWidth/3);
            make.height.mas_equalTo(50);
        }];
        
        
        RRFBillBtn *profiteRateBtn = [[RRFBillBtn alloc]init];
        [profiteRateBtn.subTitleBtn setTitle:@"收益率" forState:UIControlStateNormal];
        [profiteRateBtn.subTitleBtn setTitleColor:[UIColor colorWithHexString:@"ffe300"] forState:UIControlStateNormal];
        profiteRateBtn.subTitleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        profiteRateBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffe300"];
        profiteRateBtn.titleLabel.text = model.yields;
        profiteRateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.profiteRateBtn = profiteRateBtn;
        [self addSubview:profiteRateBtn];
        [profiteRateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalPriceBtn.mas_top);
            make.left.mas_equalTo(profiteBtn.mas_right).offset(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(SCREENWidth/3);
            make.right.mas_equalTo(0);
        }];
        
        UIImageView *sepView = [[UIImageView alloc]init];
        sepView.image = [UIImage imageNamed:@"line"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(110);
            make.height.mas_equalTo(1);
        }];
        
        
        UIImageView *hitIconView = [[UIImageView alloc]init];
        hitIconView.backgroundColor = [UIColor clearColor];
        hitIconView.image = [UIImage imageNamed:@"icon_hit_rate"];
        hitIconView.layer.masksToBounds = YES;
        hitIconView.layer.cornerRadius = 15;
        self.hitIconView = hitIconView;
        [self addSubview:hitIconView];
        [hitIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(sepView.mas_bottom).offset(18);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        
        RRFBillBtn *totalCountBtn = [[RRFBillBtn alloc]init];
        [totalCountBtn.subTitleBtn setTitle:@"投注次数" forState:UIControlStateNormal];
        [totalCountBtn.subTitleBtn setTitleColor:[UIColor colorWithHexString:@"ffe300"] forState:UIControlStateNormal];
        totalCountBtn.subTitleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        totalCountBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffe300"];
        totalCountBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",model.addGuessAmount];
        totalCountBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.totalCountBtn = totalCountBtn;
        [self addSubview:totalCountBtn];
        [totalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hitIconView.mas_bottom).offset(4);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/3);
            make.height.mas_equalTo(50);
        }];
        
        RRFBillBtn *hitCountBtn = [[RRFBillBtn alloc]init];
        [hitCountBtn.subTitleBtn setTitle:@"猜中次数" forState:UIControlStateNormal];
        [hitCountBtn.subTitleBtn setTitleColor:[UIColor colorWithHexString:@"ffe300"] forState:UIControlStateNormal];
        hitCountBtn.subTitleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        hitCountBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffe300"];
        hitCountBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",model.hitAmount];
        hitCountBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.hitCountBtn = hitCountBtn;
        [self addSubview:hitCountBtn];
        [hitCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalCountBtn.mas_top);
            make.left.mas_equalTo(totalCountBtn.mas_right).offset(0);
            make.width.mas_equalTo(SCREENWidth/3);
            make.height.mas_equalTo(50);
        }];
        
        RRFBillBtn *hitRateBtn = [[RRFBillBtn alloc]init];
        [hitRateBtn.subTitleBtn setTitle:@"猜中率" forState:UIControlStateNormal];
        [hitRateBtn.subTitleBtn setTitleColor:[UIColor colorWithHexString:@"ffe300"] forState:UIControlStateNormal];
        hitRateBtn.subTitleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        hitRateBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffe300"];
        hitRateBtn.titleLabel.text = model.hitRate;
        hitRateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.hitRateBtn = hitRateBtn;
        [self addSubview:hitRateBtn];
        [hitRateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalCountBtn.mas_top);
            make.left.mas_equalTo(hitCountBtn.mas_right).offset(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(SCREENWidth/3);
            make.right.mas_equalTo(0);
        }];
        
    }
    return self;
}


@end
