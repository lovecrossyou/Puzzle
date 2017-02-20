
//
//  AvatarHeadView.m
//  Puzzle
//
//  Created by huipay on 2016/9/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "AvatarHeadView.h"

@implementation AvatarHeadView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorR:243 colorG:243 colorB:243];
        UIImageView* bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"lg"];
        bgView.contentMode = UIViewContentModeScaleAspectFill ;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, -44, 0));
        }];
        
        
        UILabel* centerLabel = [[UILabel alloc]init];
        centerLabel.text = @"关注 200 | 评论 999 | 回答 1000" ;
        centerLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:centerLabel];
        [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.left.right.mas_equalTo(0);
        }];
        
        
        UIButton* followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [followBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [followBtn setBackgroundColor:[UIColor redColor]];
        [self addSubview:followBtn];
        [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(centerLabel.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(60, 28));
        }];
        
        
        UIView* bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(followBtn.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        
        UIImageView* avatar = [[UIImageView alloc]init];
        avatar.layer.masksToBounds = YES ;
        avatar.layer.cornerRadius = 22;
        avatar.image = [UIImage imageNamed:@"lg"];
        [bottomView addSubview:avatar];
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(-12);
        }];
        
        UILabel* nameLabel = [[UILabel alloc]init];
        [nameLabel sizeToFit];
        nameLabel.font = PZFont(13.0f);
        nameLabel.text = @"周杰伦" ;
        [bottomView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(avatar.mas_centerY).offset(6);
            make.left.mas_equalTo(avatar.mas_right).offset(12);
        }];
        
        UILabel* descLabel = [[UILabel alloc]init];
        descLabel.font = PZFont(12.0f);
        descLabel.numberOfLines = 2 ;
        descLabel.text = @"选项卡参照顶部视图，利用自动布局，可以让一个控件随着参照控件的改变而改变，以后就能做到移动头部视图，选项卡跟着移动了" ;
        [bottomView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatar.mas_right).offset(12);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(-12);
        }];
    }
    return self ;
}

@end
