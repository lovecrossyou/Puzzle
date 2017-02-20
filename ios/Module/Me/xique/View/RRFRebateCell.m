//
//  RRFRebateCell.m
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRebateCell.h"
#import "RRFRebateModel.h"
#import "UIButton+WebCache.h"

@interface RRFRebateCell ()
@property(nonatomic,weak)UIButton *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *priceLabel;
@property(nonatomic,weak)UILabel *typeLabel;

@end
@implementation RRFRebateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *iconView = [[UIButton alloc]init];
        [iconView setImage:DefaultImage forState:UIControlStateNormal];
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.top.mas_equalTo(iconView.mas_top).offset(4);
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *priceLabel = [[UILabel alloc]init];
        priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
        priceLabel.font = [UIFont systemFontOfSize:16];
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
        }];
        
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        typeLabel.font = [UIFont systemFontOfSize:12];
        self.typeLabel = typeLabel;
        [self.contentView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(timeLabel.mas_centerY);
        }];
    }
    return self;
}
-(void)setDayM:(RRFRebateDayModel *)dayM
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dayM.userIconUrl] forState:UIControlStateNormal placeholderImage:DefaultImage];
    self.nameLabel.text = dayM.userName;
    self.timeLabel.text = dayM.time;
    self.priceLabel.text = [NSString stringWithFormat:@"+%.2f",dayM.rebateAmount];
    self.typeLabel.text =[NSString stringWithFormat:@"购买%ld钻石",dayM.buyDiamondAmount];
}
@end
