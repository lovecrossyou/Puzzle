//
//  JNQConfirmOrderCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQConfirmOrderCell.h"
#import "UIImageView+WebCache.h"

@interface JNQConfirmOrderCell () {
    UIImageView *_comImg;
    UILabel *_comName;
    UIButton *_comPrice;
    UILabel *_comCount;
}

@end

@implementation JNQConfirmOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _comImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 65, 65)];
        [self.contentView addSubview:_comImg];
        _comImg.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _comImg.layer.borderWidth = 0.5;
        
        _comName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_comImg.frame)+10, 15, SCREENWidth-97, 20)];
        [self.contentView addSubview:_comName];
        _comName.textColor = HBColor(51, 51, 51);
        _comName.font = PZFont(16);
        
        _comPrice = [[UIButton alloc] init];
        [self.contentView addSubview:_comPrice];
        [_comPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comName.mas_bottom).offset(15);
            make.left.mas_equalTo(_comName);
            make.height.mas_equalTo(18);
        }];
        [_comPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_comPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _comPrice.titleLabel.font = PZFont(14);
        _comPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _comCount = [[UILabel alloc] init];
        [self.contentView addSubview:_comCount];
        [_comCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comName.mas_bottom).offset(15);
            make.left.mas_equalTo(_comPrice.mas_right);
            make.height.mas_equalTo(18);
        }];
        _comCount.textColor = HBColor(153, 153, 153);
        _comCount.font = PZFont(13);
        
        UIView *sepe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 0.5)];
        [self.contentView addSubview:sepe];
        sepe.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setPresentProductModel:(JNQPresentProductModel *)presentProductModel {
    _presentProductModel = presentProductModel;
    [_comImg sd_setImageWithURL:[NSURL URLWithString:presentProductModel.smallPicture] placeholderImage:[UIImage imageNamed:@"order_image_small"]];
    _comName.text = presentProductModel.productName;
    [_comPrice setTitle:[NSString stringWithFormat:@" %.0f", (float)presentProductModel.price/100] forState:UIControlStateNormal];
    _comCount.text = [NSString stringWithFormat:@"  x%ld", presentProductModel.count];
}

@end
