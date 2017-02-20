//
//  CommonTableViewCell.m
//  PrivateTeaStall
//
//  Created by 朱理哲 on 16/6/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface CommonTableViewCell () {
    UIView *_topLine;
}

@end

@implementation CommonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = self.contentView.backgroundColor ;
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        //分割线
        _topLine = [[UIView alloc] init];
        [self.contentView addSubview:_topLine];
        _topLine.backgroundColor = HBColor(211, 211, 211);
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.35);
            make.width.mas_equalTo(SCREENWidth);
            make.left.top.mas_equalTo(0);
        }];
        
        _sepLine = [[UIView alloc]init];
//        _sepLine.backgroundColor = HBColor(231, 231, 231);
        [self.contentView addSubview:_sepLine];
        [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.35);
            make.width.mas_equalTo(SCREENWidth);
            make.left.mas_equalTo(weakSelf.textLabel.mas_left);
            make.bottom.mas_equalTo(weakSelf);
        }];
    }
    return self ;
}



- (void)setBottomLineSetFlush:(BOOL)bottomLineSetFlush {
    WEAKSELF
    _bottomLineSetFlush = bottomLineSetFlush;
    if (bottomLineSetFlush) {
        [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_sepHeight);
            make.width.mas_equalTo(SCREENWidth);
            make.left.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf);
        }];
    } else {
        [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_sepHeight);
            make.width.mas_equalTo(SCREENWidth);
            make.left.mas_equalTo(weakSelf.textLabel.mas_left);
            make.bottom.mas_equalTo(weakSelf);
        }];
    }
}

- (void)setSepHeight:(CGFloat)sepHeight {
    _sepHeight = sepHeight;
    [_sepLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sepHeight);
    }];
}

- (void)setTopLineShow:(BOOL)topLineShow {
    if (topLineShow) {
        _topLine.hidden = NO;
    } else {
        _topLine.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
