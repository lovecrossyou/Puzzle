//
//  RRFMeInfoHeadView.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMeInfoHeadView.h"
#import "UIImageView+WebCache.h"
@implementation RRFMeInfoHeadView
{
    UIImageView *_iconView;
}
-(instancetype)init
{
    if (self = [super init]) {
        UIView *contentView = [[UIView alloc]init];
        contentView.userInteractionEnabled = NO;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-1);
            make.top.mas_equalTo(15);
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"头像";
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [nameLabel sizeToFit];
        [contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];
        
        _iconView = [[UIImageView alloc]init];
        _iconView.image = DefaultImage;
        [contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.right.mas_equalTo(-30);
        }];
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.alpha = 0.7;
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        [contentView addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];

    }
    return self;
}
-(void)setIconUrl:(NSString *)iconUrl
{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
}

@end
