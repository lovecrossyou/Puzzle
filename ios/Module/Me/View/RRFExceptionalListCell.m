//
//  RRFExceptionalListCell.m
//  Puzzle
//
//  Created by huibei on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFExceptionalListCell.h"
#import "UIButton+WebCache.h"
#import "RRFPraiseListModel.h"
#import "UIButton+EdgeInsets.h"

@interface RRFExceptionalListCell ()
{
    UIButton *_headerIcon;
    UILabel *_nameLabel;
    UILabel *_numLabel;
    UIImageView *_numIcon;
}
@end
@implementation RRFExceptionalListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _headerIcon = [[UIButton alloc]init];
        [_headerIcon setImage:[UIImage imageNamed:@"common_head_default-diagram"] forState:UIControlStateNormal];
        [_headerIcon sizeToFit];
        _headerIcon.layer.cornerRadius = 5;
        _headerIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerIcon];
        [_headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.mas_equalTo(-12);
        }];
        
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_nameLabel sizeToFit];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerIcon.mas_right).offset(8);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _numIcon = [[UIImageView alloc]init];
        _numIcon.image = [UIImage imageNamed:@"assets_icon_xiteng-coins_small"];
        [_numIcon sizeToFit];
        [self addSubview:_numIcon];
        [_numIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        
        _numLabel = [[UILabel alloc]init];
        _numLabel.textColor = StockRed;
        _numLabel.font = [UIFont systemFontOfSize:15];
        [_numLabel sizeToFit];
        [self.contentView addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_numIcon.mas_left).offset(-2);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}
-(void)setModel:(RRFPraiseListModel *)model{
    [_headerIcon sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = model.userName;
    NSString *numStr;
    if (model.diamondAmount == 0) {
        numStr = @"";
    }else{
        numStr = [NSString stringWithFormat:@"%ld",(long)model.diamondAmount];
    }
    _numLabel.text = numStr;
}
-(void)setType:(CommentCellClickType)type
{
    if (type == 1) {
        _numIcon.hidden = YES;
    }else{
        _numIcon.hidden = NO;
    }
}
@end
