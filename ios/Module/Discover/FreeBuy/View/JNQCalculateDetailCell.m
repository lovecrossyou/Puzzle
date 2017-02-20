//
//  JNQCalculateDetailCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQCalculateDetailCell.h"

@interface JNQCalculateDetailCell () {
    UILabel *_timeL;
    UILabel *_inNoL;
    UILabel *_userNameL;
}

@end

@implementation JNQCalculateDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeL = [[UILabel alloc] init];
        [self.contentView addSubview:_timeL];
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.height.mas_equalTo(self.contentView.mas_height);
        }];
        _timeL.font = PZFont(12);
        _timeL.textColor = HBColor(102, 102, 102);
        
        _userNameL = [[UILabel alloc] init];
        [self.contentView addSubview:_userNameL];
        [_userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_timeL);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
            make.width.mas_equalTo(62.5);
        }];
        _userNameL.font = _timeL.font;
        _userNameL.textColor = _timeL.textColor;
        
        _inNoL = [[UILabel alloc] init];
        [self.contentView addSubview:_inNoL];
        [_inNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_timeL);
            make.left.mas_equalTo(self.contentView).offset(SCREENWidth/2);
        }];
        _inNoL.font = _timeL.font;
        _inNoL.textColor = HBColor(235, 82, 82);
    }
    return self;
}

- (void)setCalUserM:(JNQCalUserModel *)calUserM {
    _calUserM = calUserM;
    _timeL.text = calUserM.time;
    _userNameL.text = calUserM.userName;
    NSString *time = [calUserM.time substringFromIndex:11];
    if (time.length<12) {
        return;
    }
    _inNoL.text = [NSString stringWithFormat:@"%@%@%@%@", [time substringWithRange:NSMakeRange(0, 2)], [time substringWithRange:NSMakeRange(3, 2)], [time substringWithRange:NSMakeRange(6, 2)], [time substringWithRange:NSMakeRange(9, 3)]];
}

@end
