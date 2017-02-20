//
//  CommentsHeadView.m
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderCommentsHeadView.h"
#import "PZTextView.h"
#import "RRFStar.h"

@interface RRFOrderCommentsHeadView ()
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UIView *lineView;

@end

@implementation RRFOrderCommentsHeadView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
        }];
        
        PZTextView *contentV = [[PZTextView alloc]initWithPlaceHolder:@"评价一下这件宝贝吧"];
        self.contentV = contentV;
        [bgView addSubview:contentV];
        [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(100);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.lineView = lineView;
        [bgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(contentV.mas_bottom).offset(12);
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"总体";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(lineView.mas_bottom).offset(12);
            make.height.mas_equalTo(44);
            make.bottom.mas_equalTo(bgView.mas_bottom);
        }];
        
        RRFStar *star = [[RRFStar alloc]init];
        star.isSelect = YES;
        star.max_star = 10;
        star.empty_color = [UIColor colorWithHexString:@"999999"];
        star.full_color = [UIColor colorWithHexString:@"4964ef"];
        star.font_size = 28;
        self.star = star;
        [bgView addSubview:star];
        [star mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(6);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 36));
        }];
        
        
//        UILabel *scoreLabel = [[UILabel alloc]init];
//        scoreLabel.textColor = [UIColor redColor];
//        scoreLabel.font = [UIFont systemFontOfSize:14];
//        [scoreLabel sizeToFit];
//        self.scoreLabel = scoreLabel;
//        [bgView addSubview:scoreLabel];
//        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(star.mas_right).offset(6);
//            make.centerY.mas_equalTo(star.mas_centerY);
//        }];
    
       
        UIButton *submitBtn = [[UIButton alloc]init];
        submitBtn.tag = 0;
        submitBtn.backgroundColor = [UIColor colorWithHexString:@"4964ef"];
        [submitBtn setTitle:@"发表评论" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.cornerRadius = 5;
        [submitBtn sizeToFit];
        self.submitBtn = submitBtn;
        [self addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(bgView.mas_bottom).offset(35);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            
        }];

        
      
    
       
        
    }
    return self;
}


@end
