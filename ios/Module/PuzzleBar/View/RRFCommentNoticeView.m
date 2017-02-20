//
//  RRFCommentNoticeView.m
//  Puzzle
//
//  Created by huibei on 16/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCommentNoticeView.h"
#import "UIImageView+WebCache.h"

@interface RRFCommentNoticeView ()
@property(nonatomic,weak)UIImageView *headView;
@property(nonatomic,weak) UILabel *messageLabel;
@end
@implementation RRFCommentNoticeView
-(instancetype)init
{
    if(self = [super init]){
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UIView *bgView = [[UIView alloc]init];
        bgView.userInteractionEnabled = NO;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 3;
        bgView.backgroundColor = [UIColor colorWithHexString:@"393939"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(175, 40));
        }];
        
        
        UIImageView *headView = [[UIImageView alloc]init];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = 3;
        headView.image = [UIImage imageNamed:@"common_head_default-diagram"];
        self.headView = headView;
        [bgView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(28, 28));
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.text = @"1条新消息";
        messageLabel.font = [UIFont systemFontOfSize:13];
        messageLabel.textColor = [UIColor whiteColor];
        [messageLabel sizeToFit];
        self.messageLabel = messageLabel;
        [bgView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        [bgView addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10.5);
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}
-(void)settingHeadView:(NSString *)headStr countStr:(NSString *)count
{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    self.messageLabel.text = count;
}
@end
