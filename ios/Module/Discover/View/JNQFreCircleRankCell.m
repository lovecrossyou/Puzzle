//
//  JNQFreCircleRankCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFreCircleRankCell.h"
#import "UIImageView+WebCache.h"

@interface JNQFreCircleRankCell () {
    UIImageView *_headImg;
    UILabel *_nameLabel;
    UIButton *_incomeLabel;
    UILabel *_hitPercentLabel;
    UIButton *_genderTag;
    UIButton *_vBtn;
}

@end

@implementation JNQFreCircleRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 64)];
        [self.contentView addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 4;
        
        _topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 4)];
        [self.contentView addSubview:_topBackView];
        _topBackView.backgroundColor = [UIColor whiteColor];
        
        _botBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREENWidth, 4)];
        [self.contentView addSubview:_botBackView];
        _botBackView.backgroundColor = [UIColor whiteColor];
        
        //排名
        _rankLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 64)];
        [self.contentView addSubview:_rankLabel];
        _rankLabel.titleLabel.numberOfLines = 2 ;
        _rankLabel.titleLabel.textAlignment = NSTextAlignmentCenter ;
        [_rankLabel setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _rankLabel.titleLabel.font = PZFont(14);
        
        //头像
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(36+6, 12, 40, 40)];
        [self.contentView addSubview:_headImg];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 4.0f;
        
        //性别
        _genderTag = [[UIButton alloc] init];
        [self.contentView addSubview:_genderTag];
        [_genderTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(_headImg).offset(5);
            make.size.mas_equalTo(15);
        }];
        [_genderTag setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
        [_genderTag setImage:[UIImage imageNamed:@"man"] forState:UIControlStateSelected];
        
        //名字
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(_headImg.mas_right).offset(15);
        }];
        _nameLabel.font = PZFont(15);
        _nameLabel.textColor = HBColor(51, 51, 51);
        
        //加V
        _vBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_vBtn];
        [_vBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_nameLabel);
            make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
        }];
        [_vBtn setImage:[UIImage imageNamed:@"icon_v"] forState:UIControlStateNormal];
        
        //收益
        _incomeLabel = [[UIButton alloc] init];
        [self.contentView addSubview:_incomeLabel];
        [_incomeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-12);
            make.top.mas_equalTo(self).offset(15);
            make.width.mas_equalTo(SCREENWidth/2-12);
            make.height.mas_equalTo(34);
        }];
        _incomeLabel.userInteractionEnabled = NO;
        [_incomeLabel setTitleColor:BasicRedColor forState:UIControlStateNormal];
        _incomeLabel.titleLabel.font = PZFont(15);
        _incomeLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        //命中率
        _hitPercentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_hitPercentLabel];
        [_hitPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.width.mas_equalTo(_incomeLabel);
            make.top.mas_equalTo(self).offset(33);
            make.height.mas_equalTo(15);
        }];
        _hitPercentLabel.textColor = HBColor(153, 153, 153);
        _hitPercentLabel.font = PZFont(13);
        _hitPercentLabel.textAlignment = NSTextAlignmentRight;
        
        UIView *line = [[UIView alloc] init];//WithFrame:CGRectMake(0, 63.5, SCREENWidth, 0.5)];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(63.5);
        }];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setRankType:(FriendRankType)rankType {
    _rankType = rankType;
    _hitPercentLabel.hidden = rankType == FriendRankTypeIncome ? YES : NO;
    NSInteger height = rankType == FriendRankTypeIncome ? 34 : 18;
    [_incomeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)setSelfRankModel:(JNQSelfRankModel *)selfRankModel {
    _selfRankModel = selfRankModel;
    [_incomeLabel setTitle:@"" forState:UIControlStateNormal];

    NSString *iconUrl = _rankType == FriendRankTypeIncome ? selfRankModel.iconUrl : selfRankModel.userIconUrl;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = [selfRankModel.userName isEqualToString:@""] || !selfRankModel.userName ? @"" : selfRankModel.userName;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:PZFont(13), NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [_nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 64)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    CGFloat width = rect.size.width+10>=SCREENWidth/2-70 ? SCREENWidth/2-70 : rect.size.width+10;
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    
    _genderTag.selected = [selfRankModel.sex isEqualToString:@"男"] ? YES : NO;
    _vBtn.hidden = [selfRankModel.userStatue isEqualToString:@"already_review"] ? NO : YES;
    _hitPercentLabel.text = [NSString stringWithFormat:@"投注%ld  命中%ld",(long)selfRankModel.addGuessAmount ,(long)selfRankModel.hitAmount];
    UIImage *img = _rankType == FriendRankTypeIncome ? [UIImage imageNamed:@"icon_big"] : nil;
    [_incomeLabel setImage:img forState:UIControlStateNormal];
    if (_rankType == FriendRankTypeIncome) {
        [_incomeLabel setTitle:[NSString stringWithFormat:@" %ld", (long)_selfRankModel.bonusXtbAmount] forState:UIControlStateNormal];
    } else {
        NSString *str = [_selfRankModel.hitRate isEqualToString:@""] || !_selfRankModel.hitRate ? @"0%" : _selfRankModel.hitRate;
        [_incomeLabel setTitle:str forState:UIControlStateNormal];
    }
}

@end
