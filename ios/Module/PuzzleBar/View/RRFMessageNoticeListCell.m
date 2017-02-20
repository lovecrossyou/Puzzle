//
//  RRFMessageNoticeListCell.m
//  Puzzle
//
//  Created by huibei on 16/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMessageNoticeListCell.h"
#import "RRFMessageNoticeListModel.h"
#import "UIImageView+WebCache.h"

@interface RRFMessageNoticeListCell ()
@property(nonatomic,weak)UIImageView *headView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UIButton *replyBtn;

@property(nonatomic,weak)UIImageView *commentIcon;
@property(nonatomic,weak)UILabel *commentLabel;

@end
@implementation RRFMessageNoticeListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        UIImageView *headView = [[UIImageView alloc]init];
        headView.userInteractionEnabled = NO;
        headView.image = [UIImage imageNamed:@"common_head_default-diagram"];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = 3;
        headView.userInteractionEnabled = YES ;
        self.headView = headView;
        [self.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.top.mas_equalTo(12.5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(10.5);
            make.top.mas_equalTo(headView.mas_top).offset(4);
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(10.5);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        }];
        
        UIButton *replyBtn = [[UIButton alloc]init];
        replyBtn.userInteractionEnabled = NO;
        [replyBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [replyBtn sizeToFit];
        replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.replyBtn = replyBtn;
        [self.contentView addSubview:replyBtn];
        [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(10.5);
            make.top.mas_equalTo(headView.mas_bottom).offset(4);
            make.right.mas_equalTo(-90);
            make.bottom.mas_equalTo(-12.5);
        }];
        
        UIImageView *commentIcon = [[UIImageView alloc]init];
        commentIcon.userInteractionEnabled = NO;
        self.commentIcon = commentIcon;
        [self.contentView addSubview:commentIcon];
        [commentIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    
        UILabel *commentLabel = [[UILabel alloc]init];
        commentLabel.userInteractionEnabled = NO;
        commentLabel.textColor = [UIColor colorWithHexString:@"777777"];
        commentLabel.font = [UIFont systemFontOfSize:13];
        [commentLabel sizeToFit];
        commentLabel.numberOfLines = 4;
        self.commentLabel = commentLabel;
        [self.contentView addSubview:commentLabel];
        [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
    }
    return self;
}
-(void)setModel:(RRFMessageNoticeListModel *)model
{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    self.nameLabel.text = model.userName;
    self.timeLabel.text = model.time;
    [self.replyBtn setTitle:model.responseContent forState:UIControlStateNormal];
    if (model.entityConent.length != 0) {
        self.commentLabel.text = model.entityConent;
        self.commentIcon.hidden = YES;
    }else{
        self.commentIcon.hidden = NO;
        [self.commentIcon sd_setImageWithURL:[NSURL URLWithString:model.respImage]];
    }
    NSString *verifyStr ;
    if (model.type == 21) {
        verifyStr = [NSString stringWithFormat:@"%@请求添加您为好友",model.userName];
        [self.replyBtn setTitle:verifyStr forState:UIControlStateNormal];
    }else if(model.type == 22){
        verifyStr = [NSString stringWithFormat:@"%@已通过您的验证请求",model.userName];
        [self.replyBtn setTitle:verifyStr forState:UIControlStateNormal];
    }
}

@end
