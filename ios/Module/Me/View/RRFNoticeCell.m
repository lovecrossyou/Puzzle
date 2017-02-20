//
//  RRFNoticeCell.m
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFNoticeCell.h"
#import "RRFNoticeModel.h"
@interface RRFNoticeCell ()
@property(nonatomic,weak)UILabel* timeLabel;
@property(nonatomic,weak)UIButton* contentTextBtn;

@end

@implementation RRFNoticeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

       
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.font = [UIFont systemFontOfSize:13];
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(10);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:@"icon_new"];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        
        UIButton *contentTextBtn = [[UIButton alloc]init];
        [contentTextBtn sizeToFit];
        contentTextBtn.titleLabel.numberOfLines = 0;
        [contentTextBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        contentTextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        contentTextBtn.layer.masksToBounds = YES;
        contentTextBtn.layer.cornerRadius = 5;
        contentTextBtn.userInteractionEnabled = NO;
        //创建图片
        UIImage *norImage = [UIImage imageNamed:@"notice_bg"];
        // 设置按钮背景图
        [contentTextBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        // 设置按钮内边距
        contentTextBtn.contentEdgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
        contentTextBtn.titleEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        self.contentTextBtn = contentTextBtn;
        [self.contentView addSubview:contentTextBtn];
        [contentTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(6);
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
            make.right.bottom.mas_equalTo(-12);
        }];

    }
    return self;
}
-(void)setModel:(RRFNoticeModel *)model
{
    self.timeLabel.text = model.time;
    NSString* content = model.content ;
    NSString* targetStr = @">>!" ;
    NSRange range = [content rangeOfString:targetStr];
    NSMutableAttributedString* msgStr = [[NSMutableAttributedString alloc]initWithString:content];
    [msgStr addAttributes:@{NSForegroundColorAttributeName:StockRed} range:range];
    [self.contentTextBtn setAttributedTitle:msgStr forState:UIControlStateNormal];
}
@end
