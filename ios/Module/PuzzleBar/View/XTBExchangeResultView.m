//
//  XTBExchangeResultView.m
//  Puzzle
//
//  Created by huibei on 16/10/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "XTBExchangeResultView.h"
#import "UIButton+EdgeInsets.h"
@implementation XTBExchangeResultView

-(instancetype)initWithJson:(id)resultJson{
    if (self = [super init]) {
        self.backgroundColor = HBColor(243, 243, 243);
        
        UIView* resultTopView = [[UIView alloc]init];
        resultTopView.backgroundColor = [UIColor whiteColor];
        [self addSubview:resultTopView];
        [resultTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(14.0f);
            make.height.mas_equalTo(120);
        }];
        UIButton* btnResult = [UIButton new];
        [btnResult setTitle:@"兑换成功!" forState:UIControlStateNormal];
        btnResult.titleLabel.font = PZFont(13.0f);
        [btnResult setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        [btnResult setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateNormal];
        [resultTopView addSubview:btnResult];
        [btnResult sizeToFit];
        [btnResult mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(resultTopView.center);
        }];
        
        [btnResult layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:6 imageWidth:44];
        
        UIView* resultBotView = [[UIView alloc]init];
        resultBotView.backgroundColor = [UIColor whiteColor];
        [self addSubview:resultBotView];
        [resultBotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(resultTopView.mas_bottom).offset(12);
            make.height.mas_equalTo(140);
        }];
        
        UILabel* labelNo = [[UILabel alloc]init];
        labelNo.text = [NSString stringWithFormat:@"交易单号：%@",resultJson[@"orderId"]] ;
        [labelNo sizeToFit];
        labelNo.font = PZFont(14.0f);
        labelNo.textColor = [UIColor darkGrayColor];
        [resultBotView addSubview:labelNo];
        [labelNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(12);
        }];
        
        UILabel* labelDiamond = [[UILabel alloc]init];
        labelDiamond.text = [NSString stringWithFormat:@"支付钻石：%@颗",resultJson[@"diamondPrice"]] ;
        [labelDiamond sizeToFit];
        labelDiamond.font = PZFont(14.0f);
        labelDiamond.textColor = [UIColor darkGrayColor];
        [resultBotView addSubview:labelDiamond];
        [labelDiamond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
            make.top.mas_equalTo(labelNo.mas_bottom).offset(15);
            make.left.mas_equalTo(12);
        }];
        
        UILabel* labelTradeTime = [[UILabel alloc]init];
        labelTradeTime.text = [NSString stringWithFormat:@"交易时间：%@",resultJson[@"createTime"]] ;
        [labelTradeTime sizeToFit];
        labelTradeTime.font = PZFont(14.0f);
        labelTradeTime.textColor = [UIColor darkGrayColor];
        [resultBotView addSubview:labelTradeTime];
        [labelTradeTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
            make.top.mas_equalTo(labelDiamond.mas_bottom).offset(15);
            make.left.mas_equalTo(12);
        }];
    
    }
    return self ;
}

@end
