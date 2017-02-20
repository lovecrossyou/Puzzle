//
//  RRFNoLoginMyInfoView.m
//  Puzzle
//
//  Created by huibei on 16/10/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFNoLoginMyInfoView.h"
@interface RRFNoLoginMyInfoView ()

@end
@implementation RRFNoLoginMyInfoView

-(instancetype)init
{
    if (self = [super init]) {
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"betting-record_bg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UIImageView *headView = [[UIImageView alloc]init];
        headView.layer.cornerRadius = 5;
        headView.layer.masksToBounds = YES;
        headView.layer.borderWidth = 2.0f;
        headView.layer.borderColor = [UIColor whiteColor].CGColor;
        headView.image = [UIImage imageNamed:@"common_head_default-diagram"];
        [self addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"点击登录";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView.mas_bottom).offset(8);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return self;
}

@end
