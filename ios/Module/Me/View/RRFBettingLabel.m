//
//  RRFBettingLabel.m
//  Puzzle
//
//  Created by huibei on 16/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBettingLabel.h"
@interface RRFBettingLabel ()
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UIImageView *iconView;

@end
@implementation RRFBettingLabel

-(instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES ;
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        self.iconView = iconView;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(5, 14));
        }];
        
        UIButton *subTitleLabel = [[UIButton alloc]init];
        [subTitleLabel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        subTitleLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [subTitleLabel sizeToFit];
        self.subTitleLabel = subTitleLabel;
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(iconView.mas_left).offset(-10);
        }];
    }
    return self;
}

-(void)setIconStr:(NSString *)iconStr
{
    self.iconView.image = [UIImage imageNamed:iconStr];
}
-(void)subTitleRight:(BOOL)right
{
    if (right == YES) {
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
    }
}

@end
