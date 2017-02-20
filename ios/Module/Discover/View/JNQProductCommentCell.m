//
//  JNQProductCommentCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define maxContentStrHeight 180
#import "JNQProductCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface JNQProductCommentCell () {
    UIImageView *_userImgView;
    UILabel *_userName;
    UILabel *_timeLabel;
    UIView *_gradeBackView;
    UILabel *_textLabel;
    UIView *_imgBackView;
}

@end

@implementation JNQProductCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _userImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImgView];
        [_userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(15);
            make.left.mas_equalTo(self.contentView).offset(10);
            make.width.height.mas_equalTo(24);
        }];
        _userImgView.layer.masksToBounds = YES;
        _userImgView.layer.cornerRadius = 12;
        _userImgView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _userImgView.layer.borderWidth = 0.5;
        
        _userName = [[UILabel alloc] init];
        [self.contentView addSubview:_userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(14);
            make.left.mas_equalTo(_userImgView.mas_right).offset(8);
            make.height.mas_equalTo(16);
        }];
        _userName.font = PZFont(13);
        _userName.textColor = HBColor(51, 51, 51);
        _userName.text = @"******";
        
        _gradeBackView = [[UIView alloc] init];
        [self.contentView addSubview:_gradeBackView];
        [_gradeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userName.mas_bottom).offset(5);
            make.left.mas_equalTo(_userName);
            make.size.mas_equalTo(CGSizeMake(60, 10));
        }];
        for (int i = 0; i<5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12*i, 0, 10, 10)];
            [_gradeBackView addSubview:btn];
            [btn setImage:[UIImage imageNamed:@"star_d"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"star-_s"] forState:UIControlStateSelected];
            btn.tag = i;
        }
        
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(_userImgView);
            make.right.mas_equalTo(self.contentView).offset(-25);
        }];
        _timeLabel.font = PZFont(12);
        _timeLabel.textColor = HBColor(153, 153, 153);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0 ;
        [self.contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_gradeBackView.mas_bottom).offset(15);
            make.left.mas_equalTo(self.contentView).offset(12);
            make.width.mas_equalTo(SCREENWidth-24);
            make.bottom.mas_equalTo(-12);
        }];
        _textLabel.font = PZFont(13);
        _textLabel.textColor = HBColor(153, 153, 153);
        
//        _imgBackView = [[UIImageView alloc] init];
//        [self.contentView addSubview:_imgBackView];
//        [_imgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_textLabel.mas_bottom).offset(10);
//            make.left.mas_equalTo(_textLabel);
//            make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, 50));
//        }];
//        
//        for (int i = 0; i<5; i++) {
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60*i, 0, 50, 50)];
//            [_imgBackView addSubview:button];
//            button.tag = i;
//        }
    }
    return self;
}

- (void)setCommentModel:(JNQProductCommentModel *)commentModel {
    _commentModel = commentModel;
    [_userImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.userIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    if (![commentModel.userName isEqualToString:@""]) {
        _userName.text = commentModel.userName;
        _userName.text = [NSString stringWithFormat:@"%@****", [commentModel.userName substringToIndex:1]];
    }
    
    _timeLabel.text = commentModel.createTime;
    _textLabel.text = commentModel.content;
    
    for (UIButton *btn in _gradeBackView.subviews) {
        if (btn.tag+1 < (commentModel.score+1)/2) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
//    for (UIButton *btn in _imgBackView.subviews) {
//        btn.hidden = btn.tag < commentModel.contentImages.count ? NO : YES;
//        if (!btn.hidden) {
//            [btn sd_setImageWithURL:[NSURL URLWithString:[commentModel.contentImages[btn.tag] objectForKey:@"head_img"]] forState:UIControlStateNormal];
//        }
//    }
}

@end
