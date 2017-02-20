//
//  RRFMeView.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMeView.h"
#import "UIImageView+WebCache.h"
#import "LoginModel.h"
@implementation RRFMeView
-(instancetype)initWithUserInfo:(LoginModel*)userInfo
{
    if (self = [super init]) {
        
        UIView *contentView = [[UIView alloc]init];
        contentView.userInteractionEnabled = NO;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        NSString *iconStr = userInfo.icon;
        if (iconStr.length == 0) {
            iconStr = userInfo.headimgurl;
        }
        UIImageView *headIcon = [[UIImageView alloc]init];
        [headIcon sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
        headIcon.contentMode = UIViewContentModeScaleToFill ;
        headIcon.layer.masksToBounds = YES;
        headIcon.layer.cornerRadius = 3;
        [contentView addSubview:headIcon];
        [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        NSString *name = userInfo.cnName;
        if (name.length == 0) {
            name = userInfo.nickname;
        }
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = name;
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIcon.mas_right).offset(8);
            make.right.mas_lessThanOrEqualTo(-70);
            make.top.mas_equalTo(headIcon.mas_top).offset(10);
            
        }];
        NSString *identityTypeStr = @"";
        if ([userInfo.identityType isEqualToString:@"gold_identity"]) {
            identityTypeStr = @"me-_icon_gold_vip";
        }else if ([userInfo.identityType isEqualToString:@"whiteGold_identity"]){
            identityTypeStr = @"me-_icon_platinum_vip";
        }else if ([userInfo.identityType isEqualToString:@"diamond_identity"]){
            identityTypeStr = @"me-_icon_diamonds_vip";
        }
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:identityTypeStr];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 17.5));
        }];
        UIButton* bindingPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bindingPhoneBtn sizeToFit];
        bindingPhoneBtn.titleLabel.font = PZFont(13.0f);
        NSString *noStr = [NSString stringWithFormat:@"喜腾号：%@",userInfo.xtNumber];
        [bindingPhoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [bindingPhoneBtn setTitle:noStr forState:UIControlStateNormal];
        [contentView addSubview:bindingPhoneBtn];
        self.bindingPhoneBtn = bindingPhoneBtn ;
        [bindingPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIcon.mas_right).offset(8);
            make.bottom.mas_equalTo(headIcon.mas_bottom).offset(-10);
        }];
        [[bindingPhoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            
        }];
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.alpha = 0.7;
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        [contentView addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];
        
        UIImageView *codeIcon = [[UIImageView alloc]init];
        codeIcon.image = [UIImage imageNamed:@"qr-code"];
        [contentView addSubview:codeIcon];
        [codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.right.mas_equalTo(arrowIcon.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return self;
}

@end
