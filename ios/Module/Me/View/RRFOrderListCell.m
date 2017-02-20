//
//  RRFOrderListCell.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderListCell.h"
#import "RRFProductModel.h"
#import "UIImageView+WebCache.h"
@interface RRFOrderListCell ()
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UIButton *priceBtn;
@property(nonatomic,weak)UILabel *numLabel;
@end
@implementation RRFOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *backView = [[UIView alloc]init];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-0.5);
            make.top.mas_equalTo(0.8);
            make.width.mas_equalTo(SCREENWidth + 1);
            make.height.mas_equalTo(95);
            make.bottom.mas_equalTo(0.8);
            make.right.mas_equalTo(0.5);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
       
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [nameLabel sizeToFit];
        nameLabel.numberOfLines = 2;
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(iconView.mas_top).offset(8);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        UIButton *priceBtn = [[UIButton alloc]init];
        [priceBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        priceBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        self.priceBtn = priceBtn;
        [self.contentView addSubview:priceBtn];
        [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(8);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.textColor = [UIColor colorWithHexString:@"333333"];
        numLabel.font = [UIFont systemFontOfSize:12];
        [numLabel sizeToFit];
        self.numLabel = numLabel;
        [self.contentView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceBtn.mas_right).offset(0);
            make.centerY.mas_equalTo(priceBtn.mas_centerY).offset(1);
        }];
        
    }
    return self;
}
-(void)setModel:(RRFProductModel *)model{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    if (model.tradeWay == 5) {
        self.nameLabel.text = @"奖品";
        self.nameLabel.textColor = [UIColor redColor];
        [self.priceBtn setTitle:model.productName forState:UIControlStateNormal];
        [self.priceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.numLabel.text = @"";
    }else {
        self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.nameLabel.text = model.productName;
        [self.priceBtn setTitle:[NSString stringWithFormat:@"%ld",model.xtbPrice] forState:UIControlStateNormal];
        [self.priceBtn setImage:[UIImage imageNamed:@"icon_maddle_black"] forState:UIControlStateNormal];
        self.numLabel.text = [NSString stringWithFormat:@" x %ld",(long)model.count];
    }
}
@end
