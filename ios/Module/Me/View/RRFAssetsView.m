//
//  RRFAssetsHeaderView.m
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFAssetsView.h"
#import "RRFAssetButton.h"
#import "LoginModel.h"
#import "PZCache.h"
@interface RRFAssetsHeaderView ()
@property(nonatomic,weak)RRFAssetButton *xiTengB;
@property(nonatomic,weak)RRFAssetLabel *leftBtn;
@property(nonatomic,weak)RRFAssetLabel *rightBtn;
@property(nonatomic,weak)UIView *divider;
@end
@implementation RRFAssetsHeaderView
-(instancetype)initWithModel:(LoginModel*)model
{
    if (self = [super init]) {
        
        RRFAssetButton *xiTengB = [[RRFAssetButton alloc]init];
        xiTengB.iconView.image = [UIImage imageNamed:@"assets_icon_xiteng-coins"];
        NSMutableAttributedString *xiteng = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 喜腾币",model.xtbTotalAmount]];
        [xiteng addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, xiteng.length-3)];
        [xiteng addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, xiteng.length-3)];
        xiTengB.titleLabel.attributedText = xiteng;
        self.xiTengB = xiTengB;
        [self addSubview:xiTengB];
        [xiTengB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.mas_equalTo(0);
            make.height.mas_equalTo(125);
        }];
        
        RRFAssetLabel *leftBtn = [[RRFAssetLabel alloc]init];
        leftBtn.titleLabel.numberOfLines = 2;
        leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        leftBtn.titleLabel.text = [NSString stringWithFormat:@"%@",model.xtbProfitAmount];

        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableAttributedString *leftSubTitleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" 普通币(全场通用)"]];
        [leftSubTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 4)];
        [leftSubTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 4)];
        
        [leftSubTitleStr addAttribute:NSForegroundColorAttributeName value:StockRed range:NSMakeRange(leftSubTitleStr.length-6, 6)];
        [leftSubTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(leftSubTitleStr.length-6, 6)];
        [leftBtn.subTitleLabel setAttributedTitle:leftSubTitleStr forState:UIControlStateNormal];
        [leftBtn setBackgroundColor:[UIColor whiteColor]];
        [leftBtn.subTitleLabel setImage:[UIImage imageNamed:@"assets_icon_xiteng-coins_small"] forState:UIControlStateNormal];
        self.leftBtn = leftBtn;
        [self addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(125);
            make.height.mas_equalTo(75);
        }];
       
        RRFAssetLabel *rightBtn = [[RRFAssetLabel alloc]init];
        rightBtn.titleLabel.numberOfLines = 2;
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        rightBtn.titleLabel.text = [NSString stringWithFormat:@"%@",model.xtbCapitalAmount];
        
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableAttributedString *rightSubTitleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" 彩色币(仅限投注)"]];
        [rightSubTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 4)];
        [rightSubTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 4)];
        [rightSubTitleStr addAttribute:NSForegroundColorAttributeName value:StockRed range:NSMakeRange(rightSubTitleStr.length-6, 6)];
        [rightSubTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(rightSubTitleStr.length-6, 6)];
        [rightBtn.subTitleLabel setAttributedTitle:rightSubTitleStr forState:UIControlStateNormal];
        [rightBtn.subTitleLabel setImage:[UIImage imageNamed:@"assets_colour-coins_small"] forState:UIControlStateNormal];
        [rightBtn setBackgroundColor:[UIColor whiteColor]];
        self.rightBtn = rightBtn;
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(125);
            make.left.mas_equalTo(_leftBtn.mas_right).offset(0);
            make.height.mas_equalTo(75);
            make.width.mas_equalTo(_leftBtn.mas_width);
        }];
        
        UIView *divider = [[UIView alloc]init];
        divider.backgroundColor = [UIColor colorWithHexString:@"f5f5f5f5"];
        [self addSubview:divider];
        [divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.height.mas_equalTo(40);
        }];
        
        BOOL appOpen = [PZCache sharedInstance].versionRelease ;
        leftBtn.hidden = !appOpen;
        rightBtn.hidden = !appOpen;
        divider.hidden = !appOpen;
    }
    return self;
}

@end


@implementation RRFAssetsView

@end
