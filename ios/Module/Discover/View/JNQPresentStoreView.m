//
//  JNQPresentStoreView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentStoreView.h"

@implementation JNQPresentStoreView

@end


@implementation JNQPresentStoreTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _recommondBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth/3, 50)];
        [self addSubview:_recommondBtn];
        [_recommondBtn setTitle:@"综合" forState:UIControlStateNormal];
        [_recommondBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        [_recommondBtn setTitleColor:BasicBlueColor forState:UIControlStateSelected];
        [_recommondBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _recommondBtn.titleLabel.font = PZFont(15);
        _recommondBtn.tag = 1;
        _recommondBtn.selected = YES;
        
        _salesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_recommondBtn.frame), 0, SCREENWidth/3, 50)];
        [self addSubview:_salesBtn];
        [_salesBtn setTitle:@"销量" forState:UIControlStateNormal];
        [_salesBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        [_salesBtn setTitleColor:BasicBlueColor forState:UIControlStateSelected];
        _salesBtn.titleLabel.font = PZFont(15);
        _salesBtn.tag = 2;
        [_salesBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_salesBtn.frame), 0, SCREENWidth/3, 50)];
        [self addSubview:_priceBtn];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        [_priceBtn setTitleColor:BasicBlueColor forState:UIControlStateSelected];
        [_priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -SCREENWidth/3.5)];
        _priceBtn.titleLabel.font = PZFont(15);
        _priceBtn.tag = 3;
        [_priceBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = [UIImage imageNamed:@"jnq_btnTriangle_up"];
        _upDownBtnBackView = [[UIView alloc] init];
        [_priceBtn addSubview:_upDownBtnBackView];
        [_upDownBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_priceBtn).offset(-SCREENWidth/12);
            make.top.bottom.mas_equalTo(_priceBtn);
            make.width.mas_equalTo(img.size.width);
        }];
        _upDownBtnBackView.userInteractionEnabled = NO;
        
        _upImgBtn = [[UIButton alloc] init];
        [_upDownBtnBackView addSubview:_upImgBtn];
        [_upImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_upDownBtnBackView.mas_centerY).offset(-2.5);
            make.left.width.mas_equalTo(_upDownBtnBackView);
            make.height.mas_equalTo(img.size.height);
        }];
        [_upImgBtn setBackgroundImage:[UIImage imageNamed:@"jnq_btnTriangle_up"] forState:UIControlStateNormal];
        [_upImgBtn setBackgroundImage:[UIImage imageNamed:@"jnq_icon_up"] forState:UIControlStateSelected];
        _upImgBtn.userInteractionEnabled = NO;
        
        _downImgBtn = [[UIButton alloc] init];
        [_upDownBtnBackView addSubview:_downImgBtn];
        [_downImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_upDownBtnBackView.mas_centerY).offset(2);
            make.left.width.height.mas_equalTo(_upImgBtn);
        }];
        [_downImgBtn setBackgroundImage:[UIImage imageNamed:@"jnq_btnTriangle_done"] forState:UIControlStateNormal];
        [_downImgBtn setBackgroundImage:[UIImage imageNamed:@"jnq_icon_down-"] forState:UIControlStateSelected];
        _downImgBtn.userInteractionEnabled = NO;
        
        for (int i = 0; i<2; i++) {
            UIView *sep = [[UIView alloc] init];
            sep.frame = CGRectMake(SCREENWidth/3*(i+1), 10, 1, 30);
            [self addSubview:sep];
            sep.backgroundColor = HBColor(231, 231, 231);
        }
    }
    return self;
}

- (void)btnsDidClicked:(UIButton *)button {
    if (button.tag == 3) {
        int priceSort = button.selected ? -1 : 1;
        self.topBlock(button, @"", 0, priceSort);
    }
    if (button.tag == 2) {
        self.topBlock(button, @"", -1, 0);
    }
    if (button.tag == 1) {
        self.topBlock(button, @"", 0, 0);
    }
}

@end
