//
//  RRFRecruitView.m
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRecruitView.h"
@interface RRFRecruitView ()
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *subTitleLabel;
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *messageLabel;

@end
@implementation RRFRecruitView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"邀请朋友加入喜鹊计划";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(0);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.text = @"你招募的A级代理商进货钻石你可享受进货返利2%，B级代理商进货钻石你可享受进货返利1%，C级代理商进货钻石你可享受进货返利0.5%，你招募的代理商越多，进货的钻石越多，盈利越多！";
        subTitleLabel.numberOfLines = 0;
        subTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        subTitleLabel.font = [UIFont systemFontOfSize:13];
        [subTitleLabel sizeToFit];
        self.subTitleLabel = subTitleLabel;
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:@"bird"];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(subTitleLabel.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.text = @"给朋友留言:";
        messageLabel.textColor = [UIColor colorWithHexString:@"777777"];
        messageLabel.font = [UIFont systemFontOfSize:13];
        [messageLabel sizeToFit];
        self.messageLabel = messageLabel;
        [self addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_bottom).offset(30);
            make.left.mas_equalTo(12);
        }];
        
        self.messageView = [[PZTextView alloc]initWithPlaceHolder:@"亲,一起加入喜鹊计划吧!成为喜鹊代理商，零风险，高盈利!"];
        [self.messageView sizeToFit];
        [self addSubview:self.messageView];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(messageLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(80);
        }];
        
        self.clickBtn = [[UIButton alloc]init];
        [self.clickBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
        [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.clickBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.clickBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        [self addSubview:self.clickBtn];
        [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.messageView.mas_bottom).offset(30);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
        }];
    }
    
    return self;
}

@end
