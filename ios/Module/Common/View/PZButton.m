//
//  PZButton.m
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define Proportion   0.8
#import "PZButton.h"

@implementation PZButton

-(instancetype)init
{
    if (self = [super init]) {
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView = iconView;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
            make.top.mas_equalTo(0);
        }];
        
        UIButton *countBtn = [[UIButton alloc]init];
        countBtn.hidden = YES;
        [countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        countBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [countBtn setBackgroundColor:[UIColor redColor]];
        countBtn.layer.cornerRadius = 8;
        countBtn.layer.masksToBounds = YES;
        [countBtn sizeToFit];
        self.countBtn = countBtn;
        [self addSubview:countBtn];
        [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconView.mas_top).offset(-5);
            make.left.mas_equalTo(self.iconView.mas_centerX).offset(14);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:12];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
-(void)setCount:(int)count
{
    if (count >= 1) {
        self.countBtn.hidden = NO;
        [self.countBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    }else{
        self.countBtn.hidden = YES;
    }
}
@end
