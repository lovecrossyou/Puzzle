//
//  JNQPresentStoreColCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentStoreColCell.h"
#import "UIImageView+WebCache.h"

@interface JNQPresentStoreColCell () {
    UIImageView *_comImg;
    UILabel *_comName;
    UIButton *_comPrice;
}

@end

@implementation JNQPresentStoreColCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] init];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        backView.layer.borderWidth = 0.5;
        
        _comImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_comImg];
        [_comImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-70);
        }];
        
        _comName = [[UILabel alloc] init];
        [self.contentView addSubview:_comName];
        [_comName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(12);
            make.right.mas_equalTo(self).offset(-12);
            make.top.mas_equalTo(self.mas_bottom).offset(-70);
            make.bottom.mas_equalTo(self).offset(-25);
        }];
        _comName.textColor = HBColor(51, 51, 51);
        _comName.font = PZFont(16);
        _comName.numberOfLines = 0;
        
        _comPrice = [[UIButton alloc] init];
        [self.contentView addSubview:_comPrice];
        [_comPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(12);
            make.right.mas_equalTo(self).offset(-12);
            make.top.mas_equalTo(self.mas_bottom).offset(-25);
            make.bottom.mas_equalTo(self);
        }];
        [_comPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_comPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _comPrice.titleLabel.font = PZFont(14);
        _comPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *sepLine = [[UIView alloc] init];
        [self.contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-70);
            make.height.mas_equalTo(0.5);
        }];
        sepLine.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setPresentModel:(JNQPresentModel *)presentModel {
    _presentModel = presentModel;
    [_comImg sd_setImageWithURL:[NSURL URLWithString:presentModel.picUrl] placeholderImage:[UIImage imageNamed:@"goods_default-diagram"]];
    _comName.text = presentModel.productName;
    [_comPrice setTitle:[NSString stringWithFormat:@" %ld", presentModel.price/100] forState:UIControlStateNormal];
}

@end
