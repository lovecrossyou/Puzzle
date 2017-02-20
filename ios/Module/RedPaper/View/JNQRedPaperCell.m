//
//  JNQRedPaperCell.m
//  Puzzle
//
//  Created by HuHuiPay on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "JNQRedPaperCell.h"
#import "UIImageView+WebCache.h"

@interface JNQRedPaperCell () {
    UIImageView *_headImgV;
    UILabel *_nameL;
    UILabel *_timeL;
    UIButton *_getCountBtn;
    UIButton *_bestBtn;
}

@end

@implementation JNQRedPaperCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _headImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(45);
        }];
        _headImgV.layer.cornerRadius = 2;
        
        _nameL = [[UILabel alloc] init];
        [self.contentView addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgV);
            make.left.mas_equalTo(_headImgV.mas_right).offset(16);
            make.height.mas_equalTo(25);
        }];
        _nameL.font = [UIFont boldSystemFontOfSize:14];
        _nameL.textColor = HBColor(51, 51, 51);
        
        _timeL = [[UILabel alloc] init];
        [self.contentView addSubview:_timeL];
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameL.mas_bottom);
            make.left.mas_equalTo(_nameL);
            make.height.mas_equalTo(20);
        }];
        _timeL.font = PZFont(12.5);
        _timeL.textColor = HBColor(153, 153, 153);
        
        _getCountBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_getCountBtn];
        [_getCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(13);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(44);
        }];
        _getCountBtn.titleLabel.font = PZFont(14);
        [_getCountBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _getCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_getCountBtn setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        
        _bestBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_bestBtn];
        [_bestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(38);
            make.right.mas_equalTo(_getCountBtn);
            make.height.mas_equalTo(20);
        }];
        _bestBtn.titleLabel.font = PZFont(13.5);
        [_bestBtn setTitleColor:BasicGoldColor forState:UIControlStateNormal];
        [_bestBtn setTitle:@" 手气最佳" forState:UIControlStateNormal];
        [_bestBtn setImage:[UIImage imageNamed:@"icon_best"] forState:UIControlStateNormal];
        _bestBtn.hidden = YES;
        
        UIView *line = [[UIView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.width.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = HBColor(245, 245, 245);
    }
    return self;
}

- (void)setIsAverage:(BOOL)isAverage {
    _isAverage = isAverage;
}

- (void)setAcceptM:(AcceptModel *)acceptM {
    _acceptM = acceptM;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:acceptM.acceptIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _nameL.text = acceptM.acceptUserName;
    _timeL.text = acceptM.acceptTime;
    [_getCountBtn setTitle:[NSString stringWithFormat:@"  %ld", acceptM.averageMount] forState:UIControlStateNormal];
    if (!_isAverage) {
        _bestBtn.hidden = [acceptM.isBest isEqualToString:@"noBest"] ? YES : NO;
        CGFloat height = _bestBtn.hidden ? 44 : 25;
        [_getCountBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

@end
