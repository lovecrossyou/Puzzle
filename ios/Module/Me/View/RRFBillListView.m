//
//  RRFBillListView.m
//  Puzzle
//
//  Created by huibei on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBillListView.h"
#import "RRFBillBtn.h"
#import "LoginModel.h"
@interface RRFBillListView()
@property(nonatomic,weak)RRFBillBtn *xtbBillBtn;
@property(nonatomic,weak)RRFBillBtn *zuanBillBtn;
@property(nonatomic,weak)UIView *rollingView;
@property(nonatomic,weak)RRFBillBtn *tempBtn;

@end
@implementation RRFBillListView

-(instancetype)init
{
    if (self = [super init]) {
        
        RRFBillBtn *xtbBillBtn  = [[RRFBillBtn alloc]init];
        xtbBillBtn.titleLabel.text = @"喜腾币";
        xtbBillBtn.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        xtbBillBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [xtbBillBtn.subTitleBtn setImage:[UIImage imageNamed:@"icon_yue"] forState:UIControlStateNormal];
        xtbBillBtn.tag = 0;
        [xtbBillBtn.subTitleBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        xtbBillBtn.subTitleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [xtbBillBtn  sizeToFit];
        self.xtbBillBtn = xtbBillBtn;
        [self addSubview:xtbBillBtn ];
        [xtbBillBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(0);
        }];
        
//        RRFBillBtn *zuanBillBtn  =  [[RRFBillBtn alloc]init];;
//        zuanBillBtn.titleLabel.text = @"钻石";
//        zuanBillBtn.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
//        zuanBillBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        zuanBillBtn.tag = 1;
//        [zuanBillBtn.subTitleBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//        zuanBillBtn.subTitleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [zuanBillBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        zuanBillBtn.backgroundColor = [UIColor whiteColor];
//        [zuanBillBtn  sizeToFit];
//        self.zuanBillBtn = zuanBillBtn;
//        [self addSubview:zuanBillBtn ];
//        [zuanBillBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(-1);
//            make.height.mas_equalTo(45);
//            make.left.mas_equalTo(xtbBillBtn.mas_right).offset(1);
//            make.width.mas_equalTo(xtbBillBtn.mas_width);
//            make.top.mas_equalTo(0);
//        }];
//        
//        UIView *divider = [[UIView alloc]init];
//        divider.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
//        [self addSubview:divider];
//        [divider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(1);
//            make.left.mas_equalTo(xtbBillBtn.mas_right).offset(0);
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.height.mas_equalTo(30);
//        }];
//        
//        UIView *rollingView = [[UIView alloc]init];
//        rollingView.backgroundColor = [UIColor colorWithHexString:@"4964ef"];
//        rollingView.frame = CGRectMake(0, 58, SCREENWidth/2, 2);
//        self.rollingView = rollingView;
//        [self addSubview:rollingView];
//        [self btnClick:self.xtbBillBtn];
    }
    return self;
}

//-(void)btnClick:(RRFBillBtn *)button
//{
//    _rollingView.frame = CGRectMake(SCREENWidth/2 *button.tag, 58, SCREENWidth/2, 2);
//    if (self.tempBtn == nil) {
//        button.selected = YES;
//        self.tempBtn = button;
//    }else if (self.tempBtn != nil && self.tempBtn == button){
//        button.selected = YES;
//        
//    }else if (self.tempBtn != nil && self.tempBtn != button){
//        button.selected = YES;
//        self.tempBtn.selected = NO;
//        self.tempBtn = button;
//    }
//    if (self.billListBlock) {
//        self.billListBlock(@(button.tag));
//    }
//}
-(void)setUserM:(LoginModel *)userM
{
    NSNumber *xtbTotalAmount = @(0);
    if (userM != nil) {
        xtbTotalAmount = userM.xtbTotalAmount;
    }
    
    NSMutableAttributedString *xiteng = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",xtbTotalAmount]];
    [xiteng addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, xiteng.length)];
    [self.xtbBillBtn.subTitleBtn setAttributedTitle:xiteng forState:UIControlStateNormal];
    
//    NSMutableAttributedString *zuan = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"余额: %@颗",diamondAmount]];
//    [zuan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
//    [zuan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(zuan.length - 1, 1)];
//    [self.zuanBillBtn.subTitleBtn setAttributedTitle:zuan forState:UIControlStateNormal];

}
@end
