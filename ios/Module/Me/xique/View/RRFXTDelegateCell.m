//
//  RRFXTDelegateCell.m
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFXTDelegateCell.h"
#import "RRFXTDelegateCellModel.h"
#import "UIButton+WebCache.h"
@interface RRFXTDelegateCell ()
@property(nonatomic,weak)UIButton *iconBtn;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *numberLabel;
@property(nonatomic,weak)UILabel *typeLabel;

@end
@implementation RRFXTDelegateCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *iconBtn = [[UIButton alloc]init];
        [iconBtn setImage:DefaultImage forState:UIControlStateNormal];
        self.iconBtn = iconBtn;
        [self.contentView addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(iconBtn.mas_centerY);
            make.left.mas_equalTo(iconBtn.mas_right).offset(12);
            make.right.mas_lessThanOrEqualTo(-100);
        }];
        
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.textColor = [UIColor colorWithHexString:@"333333"];
        numberLabel.font = [UIFont systemFontOfSize:16];
        [numberLabel sizeToFit];
        self.numberLabel = numberLabel;
        [self.contentView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(iconBtn.mas_centerY);
            make.right.mas_equalTo(-15);
        }];
        
        
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        typeLabel.font = [UIFont systemFontOfSize:12];
        [typeLabel sizeToFit];
        self.typeLabel= typeLabel;
        [self.contentView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(iconBtn.mas_centerY);
            make.right.mas_equalTo(numberLabel.mas_left).offset(-10);
        }];
    }
    return self;
}
-(void)setModel:(RRFXTDelegateCellModel *)model
{
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] forState:UIControlStateNormal placeholderImage:DefaultImage];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%ld)",model.userName,model.inventoryAmount]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, model.userName.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(model.userName.length, (str.length -  model.userName.length))];
    self.nameLabel.attributedText = str;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",model.diamondAmount];
    self.typeLabel.text = model.operationType;
}

@end
