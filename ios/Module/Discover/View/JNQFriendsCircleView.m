//
//  JNQFrendsCircleView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendsCircleView.h"
#import "UIImageView+WebCache.h"

@implementation JNQFriendsCircleView

@end

@implementation JNQFriendsCircleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end

@implementation JNQFriendsCircleRankHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 8, frame.size.width+1, 64)];
        [self addSubview:_backView];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _backView.layer.borderWidth = 0.5;
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30.5, 12, 40, 40)];
        [_backView addSubview:_headImgView];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 4.0f;
        _headImgView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _headImgView.layer.borderWidth = 0.5;
        
        _genderTag = [[UIButton alloc] init];
        [self addSubview:_genderTag];
        [_genderTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(_headImgView).offset(5);
            make.size.mas_equalTo(15);
        }];
        [_genderTag setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
        [_genderTag setImage:[UIImage imageNamed:@"man"] forState:UIControlStateSelected];
        
        _nameLabel = [[UILabel alloc] init];
        [_backView addSubview:_nameLabel];
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.top.mas_equalTo(_backView).offset(15);
            make.width.mas_equalTo(SCREENWidth/2-67);
            make.height.mas_equalTo(18);
        }];
        _nameLabel.textColor = HBColor(51, 51, 51);
        _nameLabel.font = PZFont(15);
        
        _rankLabel = [[UILabel alloc] init];
        [_backView addSubview:_rankLabel];
        [_rankLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(_nameLabel);
            make.top.mas_equalTo(_backView).offset(33);
            make.height.mas_equalTo(15);
        }];
        _rankLabel.textColor = HBColor(153, 153, 153);
        _rankLabel.font = PZFont(13);
        
        _incomeLabel = [[UIButton alloc] init];
        [_backView addSubview:_incomeLabel];
        [_incomeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_backView).offset(-12);
            make.top.mas_equalTo(_backView).offset(15);
            make.width.mas_equalTo(SCREENWidth/2-12);
            make.height.mas_equalTo(34);
        }];
        [_incomeLabel setTitleColor:BasicRedColor forState:UIControlStateNormal];
        //        [_incomeLabel setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _incomeLabel.titleLabel.font = PZFont(15);
        _incomeLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _hitPercentLabel = [[UILabel alloc] init];
        [_backView addSubview:_hitPercentLabel];
        [_hitPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.width.mas_equalTo(_incomeLabel);
            make.top.mas_equalTo(_backView).offset(33);
            make.height.mas_equalTo(15);
        }];
        _hitPercentLabel.textColor = HBColor(153, 153, 153);
        _hitPercentLabel.font = PZFont(13);
        _hitPercentLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setSelfRankModel:(JNQSelfRankModel *)selfRankModel {
    _selfRankModel = selfRankModel;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:selfRankModel.iconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = selfRankModel.userName;
    NSString *str = _selfRankModel.ranking ? [NSString stringWithFormat:@"第 %ld 名", (long)_selfRankModel.ranking] : @"暂无排名";
    _rankLabel.text = str;
    [_incomeLabel setTitle:[NSString stringWithFormat:@" %ld", (long)_selfRankModel.bonusXtbAmount] forState:UIControlStateNormal];
    _hitPercentLabel.text = [NSString stringWithFormat:@"投注%ld  命中%ld",(long)selfRankModel.addGuessAmount ,(long)selfRankModel.hitAmount];
    _genderTag.selected = [selfRankModel.sex isEqualToString:@"男"] ? YES : NO;
}

- (void)setRankType:(FriendRankType)rankType {
    _rankType = rankType;
    _hitPercentLabel.hidden = rankType == FriendRankTypeIncome ? YES : NO;
    NSInteger height = rankType == FriendRankTypeIncome ? 34 : 18;
    [_incomeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    UIImage *img = rankType == FriendRankTypeIncome ? [UIImage imageNamed:@"icon_big"] : nil;
    [_incomeLabel setImage:img forState:UIControlStateNormal];
    if (rankType == FriendRankTypeIncome) {
        [_incomeLabel setTitle:[NSString stringWithFormat:@" %ld", (long)_selfRankModel.bonusXtbAmount] forState:UIControlStateNormal];
    } else {
        NSString *str = [_selfRankModel.hitRate isEqualToString:@""] || !_selfRankModel.hitRate ? @"0%" : _selfRankModel.hitRate;
        [_incomeLabel setTitle:str forState:UIControlStateNormal];
    }
}

- (void)setRank:(RankType)rank {
    _rank = rank;
    NSString *str = _selfRankModel.ranking ? [NSString stringWithFormat:@"第 %ld 名", (long)_selfRankModel.ranking] : @"暂无排名";
    
    _rankLabel.text = str;
}

@end



@implementation JNQFriendsCircleSectionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, SCREENWidth+1, 40)];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        backView.layer.borderWidth = 0.5;
        
        UILabel *atten = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 0, SCREENWidth-24, 40)];
        [backView addSubview:atten];
        atten.font = PZFont(16);
        atten.textColor = HBColor(51, 51, 51);
        atten.text = @"朋友猜吧";
    }
    return self;
}

@end


@implementation JNQFriendsCircleRankFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _loadMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 35)];
        [self addSubview:_loadMoreBtn];
        _loadMoreBtn.backgroundColor = [UIColor whiteColor];
        [_loadMoreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_loadMoreBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _loadMoreBtn.titleLabel.font = PZFont(14);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_loadMoreBtn.frame), SCREENWidth, 0.5)];
        [self addSubview:line];
        line.backgroundColor = HBColor(231, 231, 231);
        
        UIView *seperate = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), SCREENWidth, 14)];
        [self addSubview:seperate];
        seperate.backgroundColor = HBColor(245, 245, 245);
    }
    return self;
}

@end

