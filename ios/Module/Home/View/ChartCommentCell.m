//
//  ChartCommentCell.m
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ChartCommentCell.h"
#import "RRFCommentsCellModel.h"
#import "UIImageView+WebCache.h"
@implementation ChartCommentCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(RRFCommentsCellModel*)m{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        serIconUrl": null,
        //"userName": "15210963519",
        //"content": "这是个好的啊",
        //"contentImages": null,
        //"userId": 30,
        //"praiseAmount": 0,
        //"responseAmount": 0,
        
        
        //icon  name  time  amount
        UIImageView* icon = [[UIImageView alloc]init];
        icon.layer.cornerRadius = 12 ;
        [icon sd_setImageWithURL:[NSURL URLWithString:m.userIconUrl] placeholderImage:DefaultImage];
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        UILabel* titleLabel = [[UILabel alloc]init];
        [titleLabel sizeToFit];
        titleLabel.textColor = [UIColor blueColor];
        titleLabel.text = m.userName ;
        titleLabel.font = PZFont(14);
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(8);
            make.centerY.mas_equalTo(icon.mas_centerX);
        }];
        
        //刚刚
        UILabel* timeLabel = [[UILabel alloc]init];
        [timeLabel sizeToFit];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.text = @"刚刚" ;
        timeLabel.font = PZFont(12);
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(icon.mas_centerX);
        }];
        
        // 明天上证指数是涨是跌 啊。。卧槽
        UILabel* contentLabel = [[UILabel alloc]init];
        [contentLabel sizeToFit];
        contentLabel.numberOfLines = 0 ;
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.text = m.content ;
        contentLabel.font = PZFont(12);
        [self.contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(icon.mas_right);
            make.top.mas_equalTo(icon.mas_bottom);
        }];
        //uiimageList
        UIView* imageList = [[UIView alloc]init];
        [self.contentView addSubview:imageList];
        [imageList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom);
            make.left.mas_equalTo(icon.mas_right);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(0);
        }];
        
        //打赏  点赞  评论
        UIButton* commentBtn = [UIButton new];
        commentBtn.titleLabel.font = PZFont(12);
        [commentBtn sizeToFit];
        [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"icon_comment_d"] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"icon_comment_s"] forState:UIControlStateSelected];
        [self.contentView addSubview:commentBtn];
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageList.mas_bottom).offset(12);
            make.right.mas_equalTo(-24);
            make.height.mas_equalTo(24);
            make.bottom.mas_equalTo(-12);
        }];
        WEAKSELF
        [[commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.toolBarBlock(@(3));
        }];
        
        UIButton* optInBtn = [UIButton new];
        optInBtn.titleLabel.font = PZFont(12);
        [optInBtn sizeToFit];
        [optInBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [optInBtn setImage:[UIImage imageNamed:@"icon_likes_d"] forState:UIControlStateNormal];
        [optInBtn setImage:[UIImage imageNamed:@"icon_likes_s"] forState:UIControlStateSelected];
        [self.contentView addSubview:optInBtn];
        [optInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(commentBtn.mas_left).offset(-24);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(commentBtn.mas_centerY);
        }];
        [[optInBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.toolBarBlock(@(2));
        }];
        
        UIButton* payBtn = [UIButton new];
        payBtn.titleLabel.font = PZFont(12);
        [payBtn sizeToFit];
        [payBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [payBtn setImage:[UIImage imageNamed:@"icon_reward_d"] forState:UIControlStateNormal];
        [payBtn setImage:[UIImage imageNamed:@"icon_reward_s"] forState:UIControlStateSelected];
        [self.contentView addSubview:payBtn];
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(optInBtn.mas_left).offset(-24);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(commentBtn.mas_centerY);
        }];
        [[payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.toolBarBlock(@(1));
        }];
    }
    return self ;
}


-(void)setModel:(RRFCommentsCellModel *)model{
    
}
@end
