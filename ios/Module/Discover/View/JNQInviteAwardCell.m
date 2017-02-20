//
//  JNQInviteAwardCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQInviteAwardCell.h"
#import "InviteBonusesModel.h"
#import "UIImageView+WebCache.h"

@interface JNQInviteAwardCell () {
    UIImageView *_headImg;
    UILabel *_name;
    UILabel *_inviteCount;
}

@end

@implementation JNQInviteAwardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 3.0f;
        
        _name = [[UILabel alloc] init];
        [self.contentView addSubview:_name];
        _name.textColor = HBColor(51, 51, 51);
        _name.font = PZFont(15);
        [_name sizeToFit];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImg.mas_right).offset(12);
            make.top.mas_equalTo(_headImg.mas_top);
        }];
        
        _inviteCount = [[UILabel alloc] init];
        [self.contentView addSubview:_inviteCount];
        _inviteCount.textColor = HBColor(153, 153, 153);
        _inviteCount.font = PZFont(13);
        [_inviteCount sizeToFit];
        [_inviteCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImg.mas_right).offset(12);
            make.bottom.mas_equalTo(_headImg.mas_bottom);
        }];
        
        _awardLabel = [[UIButton alloc] init];
        [self.contentView addSubview:_awardLabel];
        [_awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
//            make.height.mas_equalTo(self);
        }];
        _awardLabel.titleLabel.font = PZFont(13);
        [_awardLabel setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        [_awardLabel setTitleColor:BasicRedColor forState:UIControlStateNormal];
        _awardLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *line = [[UIView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

-(void)setModel:(InviteBonuses *)model{
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.model.acceptUserIconUrl] placeholderImage:DefaultImage];
    _name.text = model.model.acceptUserName ;
    _inviteCount.text = [NSString stringWithFormat:@"邀请%d人",model.model.acceptUserInviteAmout];
    [_awardLabel setTitle:[NSString stringWithFormat:@" %d", model.bonusesXtb] forState:UIControlStateNormal];
}


-(void)setBaseModel:(InviteBaseModel *)baseModel{
    [_headImg sd_setImageWithURL:[NSURL URLWithString:baseModel.acceptUserIconUrl] placeholderImage:DefaultImage];
    _name.text = baseModel.acceptUserName ;
    _inviteCount.text = [NSString stringWithFormat:@"邀请%d人",baseModel.acceptUserInviteAmout];
    
}

@end
