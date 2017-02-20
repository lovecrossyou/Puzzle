//
//  RRFWiningOrderListCell.m
//  Puzzle
//
//  Created by huipay on 2017/1/17.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWiningOrderListCell.h"
#import "RRFWiningOrderModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@interface RRFWiningOrderListCell ()
@property(nonatomic,weak)UIButton *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *winTypeLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *incomeTitleLabel;
@property(nonatomic,weak)UIButton *incomeLabel;
@property(nonatomic,weak)UIImageView *luckIcon;
@property(nonatomic,weak)UIButton *optionBtn;

@end
@implementation RRFWiningOrderListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *iconView = [[UIButton alloc]init];
        iconView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        iconView.layer.borderWidth = 0.5;
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 3;
        iconView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [iconView setImage:DefaultImage forState:UIControlStateNormal];
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(86, 86));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(iconView.mas_top).offset(6);
        }];
        
        UILabel *winTypeLabel = [[UILabel alloc]init];
        winTypeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        winTypeLabel.font = [UIFont systemFontOfSize:12];
        self.winTypeLabel = winTypeLabel;
        [self.contentView addSubview:winTypeLabel];
        [winTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(winTypeLabel.mas_bottom).offset(4);
        }];
        
        UILabel *incomeTitleLabel = [[UILabel alloc]init];
        incomeTitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        incomeTitleLabel.font = [UIFont systemFontOfSize:12];
        self.incomeTitleLabel = incomeTitleLabel;
        [self.contentView addSubview:incomeTitleLabel];
        [incomeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(4);
        }];
        
        UIButton *incomeLabel = [[UIButton alloc]init];
        [incomeLabel setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [incomeLabel setImage:[UIImage imageNamed:@"icon_maddle_black"] forState:UIControlStateNormal];
        incomeLabel.titleLabel.font = [UIFont systemFontOfSize:12];
        self.incomeLabel = incomeLabel;
        [self.contentView addSubview:incomeLabel];
        [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(incomeTitleLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(incomeTitleLabel.mas_centerY);
        }];
        
        
        UIImageView *luckIcon = [[UIImageView alloc]init];
        luckIcon.image = [UIImage imageNamed:@"fortune"];
        self.luckIcon = luckIcon;
        [self.contentView addSubview:luckIcon];
        [luckIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(nameLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self.contentView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(iconView.mas_bottom).offset(12);
        }];
        
        UIButton *optionBtn = [[UIButton alloc]init];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateNormal];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.optionBtn = optionBtn;
        [self.contentView addSubview:optionBtn];
        [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(sep.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(80, 32));
            make.bottom.mas_equalTo(-12);
        }];
        [[optionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.winingOrderListCellBlock) {
                self.winingOrderListCellBlock();
            }
        }];
        
        
    }
    return self;
}
-(void)setModel:(RRFWiningOrderModel *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.awardPicture] forState:UIControlStateNormal placeholderImage:DefaultImage];
    self.nameLabel.text = model.awardName;
    self.winTypeLabel.text = [NSString stringWithFormat:@"获奖类型:%@",model.awardType];
    self.timeLabel.text = [NSString stringWithFormat:@"开奖时间:%@",model.openResultTime];
    NSString *typeStr ;
    if ([model.awardTypeName isEqualToString:@"week"]) {
        typeStr = @"本周收益:";
    }else if([model.awardTypeName isEqualToString:@"month"]){
        typeStr = @"本月收益:";
    }else{
        typeStr = @"本年收益:";
    }
    self.incomeTitleLabel.text = typeStr;
    [self.incomeLabel setTitle:[NSString stringWithFormat:@"%ld",model.profit] forState:UIControlStateNormal];
    NSString *opStr = [model.orderStatus winingOrderListCellOpentionStatus];
    [self.optionBtn setTitle:opStr forState:UIControlStateNormal];
}
@end
