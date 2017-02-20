//
//  RRFCommentDetailCell.m
//  Puzzle
//
//  Created by huibei on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCommentDetailCell.h"
#import "RRFCommentContentListModel.h"
#import "RRFRespToRespListModel.h"
#import "PZParamTool.h"
#import "UIButton+WebCache.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "RRFResplyToResplyCell.h"
#import "InsetsLabel.h"
#import "ReplyInnerCell.h"
#import "NSString+TimeConvert.h"
@interface RRFCommentDetailCell ()
@property(nonatomic,weak)UIButton *headerIcon;
@property(nonatomic,weak)UIButton *sexBtn;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UIButton *textContentLabel;
@property(nonatomic,weak)UIButton *agreeBtn;
@property(nonatomic,weak)UIButton *commentsBtn;
@property(nonatomic,weak)UIButton *deletedBtn;
@property(nonatomic,weak)UIImageView *replyListView;
@property(nonatomic,strong)NSArray *replyList;
@property(nonatomic,weak)NSString  *isPraise;

@end
@implementation RRFCommentDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        UIButton *headerIcon = [[UIButton alloc]init];
        [headerIcon sizeToFit];
        headerIcon.layer.masksToBounds = YES;
        headerIcon.layer.cornerRadius = 3;
        self.headerIcon = headerIcon ;
        [self.contentView addSubview:headerIcon];
        [headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12.5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [[headerIcon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.detailCellBlock) {
                self.detailCellBlock(@(2));
            }
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerIcon.mas_top).offset(2);
            make.left.mas_equalTo(headerIcon.mas_right).offset(10);
            make.right.mas_equalTo(-12);
        }];
        
        UIButton *sexBtn = [[UIButton alloc]init];
        sexBtn.userInteractionEnabled = NO;
        self.sexBtn = sexBtn;
        [self.contentView addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"777777"];
        timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(2);
            make.left.mas_equalTo(headerIcon.mas_right).offset(10);
        }];
        
        UIButton *agreeBtn = [[UIButton alloc]init];
        [agreeBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"icon_likes_d"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"icon_likes_s"] forState:UIControlStateSelected];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [agreeBtn sizeToFit];
        self.agreeBtn = agreeBtn;
        [self.contentView addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headerIcon.mas_centerY);
            make.right.mas_equalTo(-30);
            make.width.mas_greaterThanOrEqualTo(40);
        }];
        
        UIButton *textContentLabel = [[UIButton alloc]init];
        textContentLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [textContentLabel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        textContentLabel.titleLabel.numberOfLines = 0;
        textContentLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        self.textContentLabel = textContentLabel;
        [textContentLabel sizeToFit];
        [self.contentView addSubview:textContentLabel];
        [textContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headerIcon.mas_right).offset(10);
            make.top.mas_equalTo(headerIcon.mas_bottom).offset(8);
            make.right.mas_equalTo(-12);
        }];
        
        UIImageView *replyListView = [[UIImageView alloc]init];
        replyListView.userInteractionEnabled = YES ;
        replyListView.image = [UIImage imageNamed:@"reply_bg"];
        self.replyListView = replyListView;
        [self.contentView addSubview:replyListView];
        [replyListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(textContentLabel.mas_left);
            make.right.mas_equalTo(textContentLabel.mas_right);
            make.top.mas_equalTo(textContentLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-32);
        }];

        
        UIButton *commentsBtn = [[UIButton alloc]init];
        commentsBtn.tag = 0;
        [commentsBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [commentsBtn setImage:[UIImage imageNamed:@"icon_comment_d"] forState:UIControlStateNormal];
        [commentsBtn setImage:[UIImage imageNamed:@"icon_comment_s"] forState:UIControlStateSelected];        commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [commentsBtn sizeToFit];
        self.commentsBtn = commentsBtn;
        [self.contentView addSubview:commentsBtn];
        [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-8);
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(replyListView.mas_bottom).offset(10);
            make.width.mas_greaterThanOrEqualTo(40);
        }];
        [[commentsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.detailCellBlock) {
                self.detailCellBlock(@(0));
            }
        }];
        
       
        
        UIButton *deletedBtn = [[UIButton alloc]init];
        deletedBtn.tag = 1;
        [deletedBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deletedBtn setTitleColor:[UIColor colorWithHexString:@"2b5490"] forState:UIControlStateNormal];
        deletedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [deletedBtn sizeToFit];
        deletedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.deletedBtn = deletedBtn;
        [self.contentView addSubview:deletedBtn];
        [deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(replyListView.mas_bottom).offset(10);
            make.left.mas_equalTo(headerIcon.mas_right).offset(10);
            make.width.mas_greaterThanOrEqualTo(40);
            make.bottom.mas_equalTo(-8);
        }];
        [[deletedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.detailCellBlock) {
                self.detailCellBlock(@(1));
            }
        }];
        
    }
    return self;
}
-(void)setContentListM:(RRFCommentContentListModel *)contentListM{
    _contentListM = contentListM;
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:contentListM.respCommentUserIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    NSString *sexStr = [contentListM.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    self.isPraise = contentListM.isPraise;
    self.deletedBtn.hidden = [contentListM.isSelfResponse isEqualToString:@"self"]?NO:YES;
    self.nameLabel.text = contentListM.respCommentUserName;
    self.timeLabel.text = contentListM.time ;
    [self.textContentLabel setTitle:contentListM.respCommentContent forState:UIControlStateNormal];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
     CGRect rect = [contentListM.respCommentContent boundingRectWithSize:CGSizeMake(SCREENWidth-12-12-30-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    [self.textContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(rect));
    }];
    [self.replyListView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSInteger count = contentListM.respToRespList.count ;
    if (count > 0) {
        self.replyList = contentListM.respToRespList;
        UIView* lastView ;
        for (int i = 0; i < count; i++) {
            RRFRespToRespListModel *respM = contentListM.respToRespList[i];
            NSString* noStr = [NSString stringWithFormat:@"%d",i + 1];
            NSString* contentStr = respM.respTorespContent ;
            NSString* nameStr = respM.respTorespUserName ;
            ReplyInnerCell* innerCell = [[ReplyInnerCell alloc]initWithIndex:noStr name:nameStr content:contentStr];
            [self.replyListView addSubview:innerCell];
            if (lastView != nil) {
                [innerCell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(2);
                    make.left.right.mas_equalTo(0);
                }];
            }
            else{
                [innerCell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(5);
                }];
            }
            if (i == count - 1) {
               [innerCell mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.bottom.mas_equalTo(0);
               }];
               [self.replyListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-32);
               }];
            }
            lastView = innerCell ;
        }
        [self.commentsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.replyListView.mas_bottom).offset(6);
            make.bottom.mas_equalTo(-6);
        }];
    }
    else{
        [self.replyListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(-32);
        }];
        [self.commentsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.replyListView.mas_bottom).offset(6);
            make.bottom.mas_equalTo(-12);
        }];
        
    }
    
    self.agreeBtn.selected = [contentListM.isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
    NSString *str = [NSString stringWithFormat:@"  %ld",(long)self.contentListM.respCommentPraiseAmount];
    if (self.contentListM.respCommentPraiseAmount <= 0) {
        str = @" 点赞" ;
    }
    [self.agreeBtn setTitle:str forState:UIControlStateNormal];
    [self layoutIfNeeded];
}

-(void)agreeBtnClick:(UIButton*)sender
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    NSMutableDictionary *prame = [[NSMutableDictionary alloc]init];
    [prame setObject:@(self.contentListM.responseId) forKey:@"responseId"];
    [PZParamTool agreedToWithUrl:@"addResponsePraise" param:prame Success:^(id json) {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [sender.imageView.layer addAnimation:k forKey:@"SHOW"];
        
        if ([self.isPraise isEqualToString:@"alreadyPraise"]) {
            self.isPraise = @"aise";
            NSString *str = [NSString stringWithFormat:@"  %ld",(long)self.contentListM.respCommentPraiseAmount];
            if (self.contentListM.respCommentPraiseAmount <= 0) {
                str = @" 点赞" ;
            }
            [self.agreeBtn setTitle:str forState:UIControlStateNormal];
            self.agreeBtn.selected = NO;
        }else{
            self.isPraise = @"alreadyPraise";
            NSString *str = [NSString stringWithFormat:@"  %ld",self.contentListM.respCommentPraiseAmount + 1];
            [self.agreeBtn setTitle:str forState:UIControlStateNormal];
            self.agreeBtn.selected =YES;
        }
    } failBlock:^(id json) {
        
    }];

}


@end
