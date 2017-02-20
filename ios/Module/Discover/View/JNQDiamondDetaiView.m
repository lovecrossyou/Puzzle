//
//  JNQDiamondDetaiView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQDiamondDetaiView.h"
#import "UIImageView+WebCache.h"

@implementation JNQDiamondDetaiView

@end


@implementation JNQDiamondDetaiHeaderView {
    UIImageView *_imgView;
    UILabel *_soloPrice;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, -0.5, SCREENWidth+1, 174.5)];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        backView.layer.borderWidth = 0.5;
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 135, 135)];
        [self addSubview:_imgView];
        _imgView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _imgView.layer.borderWidth = 0.5;
        
        UILabel *attenPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+15, 60, 45, 20)];
        [self addSubview:attenPrice];
        attenPrice.text = @"价格";
        attenPrice.textColor = HBColor(51, 51, 51);
        attenPrice.font = PZFont(15);
        
        UILabel *attenCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+15, CGRectGetMaxY(attenPrice.frame)+30, 45, 20)];
        [self addSubview:attenCount];
        attenCount.text = @"数量";
        attenCount.textColor = HBColor(51, 51, 51);
        attenCount.font = PZFont(15);
        
        _soloPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(attenPrice.frame), 60, 110, 20)];
        [self addSubview:_soloPrice];
        _soloPrice.textColor = BasicRedColor;
        WEAKSELF
        _countOperateView = [[JNQCountOperateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(attenCount.frame), CGRectGetMaxY(attenPrice.frame)+25, SCREENWidth-24-135-45-15, 30)];
        [self addSubview:_countOperateView];
        _countOperateView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _countOperateView.layer.borderWidth = 0.7;
        _countOperateView.layer.cornerRadius = 3;
        _countOperateView.count = 10;
        _countOperateView.countBlock = ^(NSInteger count) {
            if (weakSelf.countBlock) {
                weakSelf.countBlock(count);
            }
        };
    }
    return self;
}

- (void)setDiamondModel:(JNQDiamondModel *)diamondModel {
    _diamondModel = diamondModel;
    _soloPrice.text = [NSString stringWithFormat:@"￥ %.2f", (float)diamondModel.price/100];
}

@end
