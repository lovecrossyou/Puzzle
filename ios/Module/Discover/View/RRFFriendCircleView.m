//
//  RRFFriendCircleSectionHeadView.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFriendCircleView.h"
#import "RRFFriendCircleModel.h"
#import "RRFFriendCircleMeInfoModel.h"
#import "UIImageView+WebCache.h"
#import "RRFCommentNoticeView.h"
@interface RRFPublishView()

@end
@implementation RRFPublishView
-(instancetype)init{
    if (self = [super init]) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"今天";
        titleLabel.textColor  =[UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
        }];
        
        UIButton *iconView = [[UIButton alloc]init];
        iconView.userInteractionEnabled = NO;
        [iconView setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
@end
@interface RRFRankingView()

@end
@implementation RRFRankingView
-(instancetype)init{
    if (self = [super init]) {
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:@"circle-of-friends_icon_ranking-List"];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.top.mas_equalTo(12);
        }];
        
        UILabel *titleLabel =[[ UILabel alloc]init];
        titleLabel.text = @"排行榜";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.centerY.mas_equalTo(iconView.mas_centerY);
        }];
        
        UIImageView *arrowView = [[UIImageView alloc]init];
        arrowView.image = [UIImage imageNamed:@"arrow-right"];
        arrowView.alpha = 0.8;
        [self addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.centerY.mas_equalTo(iconView.mas_centerY);
        }];
        
        UILabel *subTitleLabel =[[ UILabel alloc]init];
        subTitleLabel.text = @"第12名";
        subTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        subTitleLabel.font = [UIFont systemFontOfSize:14];
        self.subTitleLabel = subTitleLabel;
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowView.mas_left).offset(-10);
            make.centerY.mas_equalTo(iconView.mas_centerY);
        }];
        
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(12);
            
        }];

    }
    return self;
}
@end
@interface RRFFriendCircleView ()
@property(nonatomic,weak)UIImageView *bgView;
@property(nonatomic,weak)UIImageView *headIconView;
@property(nonatomic,weak)UIImageView *sexBtn;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UIButton *userStatueIcon;
@property(nonatomic,weak)UILabel *signatureLabel;
@property(nonatomic,weak)UIView *sepView;

@end
@implementation RRFFriendCircleView

-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *bgImageView = [[UIImageView alloc]init];
        bgImageView.image = [UIImage imageNamed:@"circal-of-friends_bg"];
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(255);
        }];
        
        
        UIImageView *headIconView = [[UIImageView alloc]init];
        headIconView.layer.borderColor = [UIColor whiteColor].CGColor;
        headIconView.layer.borderWidth = 2.0f;
        headIconView.layer.masksToBounds = YES;
        headIconView.layer.cornerRadius = 3;
        [headIconView sizeToFit];
        self.headIconView = headIconView;
        [self addSubview:headIconView];
        [headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgImageView.mas_bottom).offset(-40);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        nameLabel.font = [UIFont systemFontOfSize:17];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIconView.mas_right).offset(12.5);
            make.top.mas_equalTo(headIconView.mas_top).offset(15);
        }];
        
        UIImageView *sexBtn = [[UIImageView alloc]init];
        self.sexBtn = sexBtn;
        [self addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        UIButton *userStatueIcon = [[UIButton alloc]init];
        [userStatueIcon sizeToFit];
        self.userStatueIcon = userStatueIcon;
        [self addSubview:userStatueIcon];
        [userStatueIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sexBtn.mas_right).offset(4);
            make.centerY.mas_equalTo(sexBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *signatureLabel = [[UILabel alloc]init];
        signatureLabel.numberOfLines = 1;
        signatureLabel.textColor  = [UIColor colorWithHexString:@"999999"];
        signatureLabel.font = [UIFont systemFontOfSize:11];
        self.signatureLabel = signatureLabel;
        [self addSubview:signatureLabel];
        [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headIconView.mas_right).offset(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(bgImageView.mas_bottom).offset(8);
        }];
        
        RRFCommentNoticeView *noticeView =[[RRFCommentNoticeView alloc]init];
        self.noticeView = noticeView;
        [self addSubview:noticeView];
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headIconView.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(90, 30));
        }];

        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.sepView = sepView;
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(noticeView.mas_bottom).offset(20);
            make.height.mas_equalTo(1);
        }];
        
        RRFRankingView *rankView = [[RRFRankingView alloc]init];
        self.rankView = rankView;
        [self addSubview:rankView];
        [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(sepView.mas_bottom).offset(0);
            make.height.mas_equalTo(56);
        }];
        
        RRFPublishView *sendView = [[RRFPublishView alloc]init];
        sendView.hidden = YES;
        self.sendView = sendView;
        [self addSubview:sendView];
        [sendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(sepView.mas_bottom).offset(0);
            make.height.mas_equalTo(104);
        }];
        
        
        
    }
    return self;
}
-(void)setModel:(RRFFriendCircleMeInfoModel *)model
{
    [self.headIconView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    self.nameLabel.text = model.userName;
    NSString *userStatue = [model.userStatue isEqualToString:@"already_review"]?@"icon_v":@"";
    [self.userStatueIcon setImage:[UIImage imageNamed:userStatue] forState:UIControlStateNormal];
    self.signatureLabel.text = model.selfSign;
    NSString *sexStr = [model.sex isEqualToString:@"女"]?@"woman":@"man";
    self.sexBtn.image = [UIImage imageNamed:sexStr];
    self.rankView.subTitleLabel.text = model.ranking ==0?@"暂无排名":[NSString stringWithFormat:@"第%ld名",model.ranking];
}
-(void)setInfoM:(RRFFriendCircleModel *)infoM
{
    [self.headIconView sd_setImageWithURL:[NSURL URLWithString:infoM.iconUrl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    self.nameLabel.text = infoM.userName;
    NSString *userStatue = [infoM.userStatue isEqualToString:@"already_review"]?@"icon_v":@"";
    [self.userStatueIcon setImage:[UIImage imageNamed:userStatue] forState:UIControlStateNormal];
    self.signatureLabel.text = infoM.selfSign;
    NSString *sexStr = [infoM.sex isEqualToString:@"女"]?@"woman":@"man";
    self.sexBtn.image = [UIImage imageNamed:sexStr];
    self.rankView.subTitleLabel.text = [NSString stringWithFormat:@"第%@名",infoM.ranking];
}
-(void)setType:(RRFFriendCircleType)type
{
    self.rankView.hidden = YES;
    if (type == RRFFriendCircleTypeSelf) {
        self.sendView.hidden = NO;
    }else{
        self.sendView.hidden = YES;
    }
}
-(void)setShowNoticeView:(BOOL)show
{
    self.noticeView.hidden = !show;
    if (show) {
        [self.sepView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.noticeView.mas_bottom).offset(20);
        }];
    }else{
        [self.sepView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headIconView.mas_bottom).offset(12);
        }];
    }
}
@end
