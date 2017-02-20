//
//  RRFPlanView.m
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFXQPlanView.h"
#import "RRFAssetButton.h"
#import "RRFXTPlanModel.h"
@implementation RRFXQPlanView



@end
@interface RRFPlanHeaderView ()
@property(nonatomic,weak)RRFAssetButton *myUser ;
@property(nonatomic,weak)RRFAssetButton *rebate ;

@end
@implementation RRFPlanHeaderView
-(instancetype)initWithBackgroundColor:(UIColor *)backgroundColor TextColor:(UIColor *)textColor
{
    if (self = [super init]) {
        
        RRFAssetButton *myUser = [[RRFAssetButton alloc]init];
        myUser.backgroundColor = backgroundColor;
        myUser.iconView.image = [UIImage imageNamed:@"xique_icon_user"];
        myUser.titleLabel.font = [UIFont systemFontOfSize:15];
        myUser.titleLabel.textColor = textColor ;
        myUser.titleLabel.numberOfLines = 2;
        self.myUser = myUser;
        [self addSubview:myUser];
        [myUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/2);
        }];
        [[myUser rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.planHeaderBlock) {
                self.planHeaderBlock(@(0));
            }
        }];
        
        RRFAssetButton *rebate = [[RRFAssetButton alloc]init];
        rebate.backgroundColor = backgroundColor;
        rebate.iconView.image = [UIImage imageNamed:@"xique_icon_rebate"];
        rebate.titleLabel.font = [UIFont systemFontOfSize:15];
        rebate.titleLabel.textColor = textColor ;
        rebate.titleLabel.numberOfLines = 2;
        self.rebate = rebate;
        [self addSubview:rebate];
        [rebate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/2);
            make.left.mas_equalTo(myUser.mas_right);
        }];
        [[rebate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.planHeaderBlock) {
                self.planHeaderBlock(@(1));
            }
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"b8b9ba"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(1, 88));
        }];
        
    }
    return self;
}

-(void)setModel:(RRFXTPlanModel *)model
{
    
    NSMutableAttributedString *inviterStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld\n我的客户(人)",model.inviterAmount]];
    [inviterStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, inviterStr.length-7)];
    [inviterStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(inviterStr.length-7, 4)];
    [inviterStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(inviterStr.length-3, 3)];
    self.myUser.titleLabel.attributedText = inviterStr;
    
    
    NSMutableAttributedString *rebateStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f\n我的返利(元)",model.myRebateAmount]];
    [rebateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, rebateStr.length-7)];
    [rebateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(rebateStr.length-7, 4)];
    [rebateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(rebateStr.length-3, 3)];
    self.rebate.titleLabel.attributedText = rebateStr;

}

@end

@implementation RRFPlanFooterBarView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UIButton *footBar = [[UIButton alloc]init];
        footBar.userInteractionEnabled = NO;
        [footBar setTitle:@"喜鹊助手" forState:UIControlStateNormal];
        [footBar setImage:[UIImage imageNamed:@"xique_icon_help"] forState:UIControlStateNormal];
        [footBar setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        footBar.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:footBar];
        [footBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 44));
            make.center.mas_equalTo(self.center);
        }];
        
    }
    return self;
}


@end
