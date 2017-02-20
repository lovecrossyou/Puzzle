//
//  JNQAwardListCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAwardListCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

static NSString *awardRank[3] = {
    @"冠军奖品：",
    @"亚军奖品：",
    @"季军奖品：",
};


@interface JNQAwardListCell () {
    UIView *_backView;
    UIView *_listTopV;
    UIImageView *_imgView;
    UIButton *_rankBtn;            //获奖名单-排名图片
    UIButton *_headImgBtn;         //获奖名单-用户头像
    UILabel *_nameLabel;           //获奖名单-用户头像
    UILabel *_awardNameLabel;
    UILabel *_awardRankLabel;
    UILabel *_awardProNameLabel;
    UIButton *_awardIncomeBtn;
}

@end

@implementation JNQAwardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(12);
            make.right.mas_equalTo(self).offset(-12);
            make.height.mas_equalTo(220);
        }];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 4;
        
        _listTopV = [[UIView alloc] init];
        [_backView addSubview:_listTopV];
        [_listTopV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(_backView);
            make.height.mas_equalTo(80);
        }];
        _listTopV.backgroundColor = [UIColor clearColor];
        
        UIView *line0 = [[UIView alloc] init];
        [_listTopV addSubview:line0];
        [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_listTopV);
            make.height.mas_equalTo(0.5);
        }];
        line0.backgroundColor = HBColor(231, 231, 231);
        
        //图片
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit ;
        [_backView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_listTopV.mas_bottom);
            make.left.right.mas_equalTo(_backView);
            make.height.mas_equalTo(165);
        }];
        
        
        //获奖名单-（冠军奖品etc）
        _awardRankLabel = [[UILabel alloc] init];
        [_listTopV addSubview:_awardRankLabel];
        [_awardRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_listTopV);
            make.left.mas_equalTo(_listTopV).offset(12);
//            make.height.mas_equalTo(18);
        }];
        _awardRankLabel.font = PZFont(15);
        _awardRankLabel.textColor = BasicRedColor;
        
        //获奖名单-奖品名称
        _awardProNameLabel = [[UILabel alloc] init];
        [_listTopV addSubview:_awardProNameLabel];
        [_awardProNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_listTopV);
            make.left.mas_equalTo(_awardRankLabel.mas_right);
        }];
        _awardProNameLabel.font = PZFont(13);
        _awardProNameLabel.textColor = HBColor(51, 51, 51);
        
        //获奖名单-排名图片
        _rankBtn = [[UIButton alloc] init];
        [_backView addSubview:_rankBtn];
        [_rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.bottom.mas_equalTo(_backView);
            make.left.mas_equalTo(_backView).offset(10);
            make.width.mas_equalTo(18);
        }];
        [_rankBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _rankBtn.titleLabel.font = PZFont(15);
        
        //获奖名单-用户头像
        _headImgBtn = [[UIButton alloc] init];
        [_backView addSubview:_headImgBtn];
        [_headImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_bottom).offset(12.5);
            make.left.mas_equalTo(_rankBtn.mas_right).offset(10);
            make.width.height.mas_equalTo(30);
        }];
        _headImgBtn.layer.masksToBounds = YES;
        _headImgBtn.layer.cornerRadius = 3;
        
        //获奖名单-用户名称
        _nameLabel = [[UILabel alloc] init];
        [_backView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.bottom.mas_equalTo(_backView);
            make.left.mas_equalTo(_headImgBtn.mas_right).offset(10);
        }];
        _nameLabel.textColor = HBColor(51, 51, 51);
        _nameLabel.font = PZFont(15);
        
        _awardIncomeBtn = [[UIButton alloc] init];
        [_backView addSubview:_awardIncomeBtn];
        [_awardIncomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_nameLabel);
            make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
        }];
        [_awardIncomeBtn setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        [_awardIncomeBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _awardIncomeBtn.titleLabel.font = PZFont(14);
        
        //奖品-奖品名称
        _awardNameLabel = [[UILabel alloc] init];
        [_backView addSubview:_awardNameLabel];
        [_awardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.bottom.mas_equalTo(_backView);
            make.left.mas_equalTo(_backView).offset(15);
            make.right.mas_equalTo(_backView).offset(-15);
        }];
        _awardNameLabel.font = PZFont(15);
        _awardNameLabel.textColor = HBColor(51, 51, 51);
        
        _bottomBtn = [[UIButton alloc] init];
        [_backView addSubview:_bottomBtn];
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.left.width.bottom.mas_equalTo(_backView);
        }];
        _bottomBtn.backgroundColor = [UIColor clearColor];
        [[_bottomBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.btnBlock) {
                self.btnBlock();
            }
        }];
        
        UIView *line = [[UIView alloc] init];
        [_backView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_backView);
            make.top.mas_equalTo(_imgView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

-(void)setAwardModel:(JNQAwardModel *)awardModel {
    _awardModel = awardModel;
}

- (void)setRankType:(RankType)rankType {
    _rankType = rankType;
    CGFloat backHeight;
    CGFloat listVHeight;
    if (_rankType <=3 || _rankType == 7) {//获奖名单
        backHeight = 260;
        listVHeight = 40;
        _awardNameLabel.hidden = YES;
        _awardIncomeBtn.hidden = NO;
        _nameLabel.text = [NSString stringWithFormat:@"%@", _awardModel.userName];
        [_awardIncomeBtn setTitle:[NSString stringWithFormat:@" %ld", _awardModel.profit] forState:UIControlStateNormal];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_awardModel.pic] placeholderImage:[UIImage imageNamed:@"product-details_img_default"]];
        [_headImgBtn sd_setImageWithURL:[NSURL URLWithString:_awardModel.userIcon] forState:UIControlStateNormal];
        
        UIImage *img = _awardModel.rank <= 3 ? [UIImage imageNamed:rankImgArr[_awardModel.rank-1]] : nil;
        NSString *title = _awardModel.rank <= 3 ? @"" : [NSString stringWithFormat:@"%d", _awardModel.rank];
        [_rankBtn setImage:img forState:UIControlStateNormal];
        [_rankBtn setTitle:title forState:UIControlStateNormal];
        
        _awardRankLabel.text = [NSString stringWithFormat:@"%@", _awardModel.rankStr];
        _awardProNameLabel.text = _awardModel.awardName;
    } else {//奖品
        backHeight = 220;
        listVHeight = 0;
        _rankBtn.hidden = YES;
        _headImgBtn.hidden = YES;
        _nameLabel.hidden = YES;
        _awardIncomeBtn.hidden = YES;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_awardModel.presentModel.picUrl] placeholderImage:[UIImage imageNamed:@"product-details_img_default"]];
        _awardNameLabel.text = [NSString stringWithFormat:@"%@：%@" , _awardModel.rankStr,_awardModel.name];
        NSMutableAttributedString *awardNameString = [[NSMutableAttributedString alloc] initWithString:_awardNameLabel.text];
        [awardNameString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[_awardNameLabel.text rangeOfString:[NSString stringWithFormat:@"%@：", _awardModel.rankStr]]];
        _awardNameLabel.attributedText = awardNameString;
    }
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(backHeight);
    }];
    [_listTopV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(listVHeight);
    }];
}


@end
