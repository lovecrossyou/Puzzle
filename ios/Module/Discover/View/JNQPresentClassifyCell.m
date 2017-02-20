//
//  JNQPresentClassifyCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentClassifyCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation JNQPresentClassifyCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imgBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_imgBtn];
        [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(self.contentView.mas_width);
        }];
        _imgBtn.contentMode = UIViewContentModeScaleAspectFit;
        _imgBtn.userInteractionEnabled = NO;
        
        _titleL = [[UILabel alloc] init];
        [self.contentView addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgBtn.mas_bottom);
            make.left.width.bottom.mas_equalTo(self.contentView);
        }];
        _titleL.font = PZFont(14);
        _titleL.textColor = HBColor(51, 51, 51);
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setClassifyM:(JNQPresentClassifyModel *)classifyM {
    _classifyM = classifyM;
    if ([classifyM.picture isEqualToString:@"btn_add-goods"]) {
        [_imgBtn setImage:[UIImage imageNamed:classifyM.picture] forState:UIControlStateNormal];
    } else {
        [_imgBtn sd_setImageWithURL:[NSURL URLWithString:classifyM.picture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
    }
    _titleL.text = classifyM.categoryName;
}


@end
