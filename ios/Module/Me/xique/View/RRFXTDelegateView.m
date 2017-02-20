//
//  RRFXTDelegateView.m
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFXTDelegateView.h"
#import "RRFXTDelegateInfoModel.h"
@implementation RRFXTDelegateView



@end

@interface RRFXTDelegateHeaderView ()
@property(nonatomic,weak)UIButton *oneButton;
@property(nonatomic,weak)UIButton *twoButton;
@property(nonatomic,weak)UIButton *threeButton;
@property(nonatomic,weak)UIButton *tempBtn;
@end


@implementation RRFXTDelegateHeaderView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *oneButton = [[UIButton alloc]init];
        oneButton.tag = 0;
        [oneButton addTarget:self action:@selector(xtbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.oneButton = oneButton;
        [self addSubview:oneButton];
        [oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-12);
            make.width.mas_equalTo((SCREENWidth-3)/3);
        }];
        
        
        UIButton *twoButton = [[UIButton alloc]init];
        twoButton.tag = 1;
        [twoButton addTarget:self action:@selector(xtbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.twoButton = twoButton;
        [self addSubview:twoButton];
        [twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-12);
            make.left.mas_equalTo(oneButton.mas_right);
            make.width.mas_equalTo((SCREENWidth-3)/3);
        }];
        
        
        UIButton *threeButton = [[UIButton alloc]init];
        threeButton.tag = 2;
        [threeButton addTarget:self action:@selector(xtbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.threeButton = threeButton;
        [self addSubview:threeButton];
        [threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-12);
            make.left.mas_equalTo(twoButton.mas_right);
            make.width.mas_equalTo((SCREENWidth-3)/3);
            make.right.mas_equalTo(0);
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
        
        for (int i = 0; i < 3; i++) {
            UIView *sep = [[UIView alloc]init];
            sep.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
            sep.frame = CGRectMake(i*SCREENWidth/3, 15, 1, 20);
            [self addSubview:sep];
        }
        [self xtbuttonClick:oneButton];
    }
    return self;
}
-(void)setModel:(RRFXTDelegateInfoModel *)model
{
    NSMutableAttributedString *Anormalstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一级(%@)",model.countOfALevelUser]];
    [Anormalstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, Anormalstr.length)];
    [Anormalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, Anormalstr.length-2)];
    [Anormalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, Anormalstr.length-2)];
    [self.oneButton setAttributedTitle:Anormalstr forState:UIControlStateNormal];
    
    NSMutableAttributedString *Aselstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一级(%@)",model.countOfALevelUser]];
    [Aselstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4964ef"] range:NSMakeRange(0, Aselstr.length)];
    [Aselstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, Aselstr.length-2)];
    [Aselstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, Aselstr.length-2)];
    [self.oneButton setAttributedTitle:Aselstr forState:UIControlStateSelected];
    
    NSMutableAttributedString *Bnormalstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二级(%@)",model.countOfBLevelUser]];
    [Bnormalstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, Bnormalstr.length)];
    [Bnormalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, Bnormalstr.length-2)];
    [Bnormalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, Bnormalstr.length-2)];
    [self.twoButton setAttributedTitle:Bnormalstr forState:UIControlStateNormal];
    
    NSMutableAttributedString *Bselstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二级(%@)",model.countOfBLevelUser]];
    [Bselstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4964ef"] range:NSMakeRange(0, Bselstr.length)];
    [Bselstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, Bselstr.length-2)];
    [Bselstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, Bselstr.length-2)];
    [self.twoButton setAttributedTitle:Bselstr forState:UIControlStateSelected];
    
    NSMutableAttributedString *Cnormalstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"三级(%@)",model.countOfCLevelUser]];
    [Cnormalstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, Cnormalstr.length)];
    [Cnormalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, Cnormalstr.length-2)];
    [Cnormalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, Cnormalstr.length-2)];
    [self.threeButton setAttributedTitle:Cnormalstr forState:UIControlStateNormal];
    
    NSMutableAttributedString *Cselstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"三级(%@)",model.countOfCLevelUser]];
    [Cselstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4964ef"] range:NSMakeRange(0, Cselstr.length)];
    [Cselstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, Cselstr.length-2)];
    [Cselstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, Cselstr.length-2)];
    [self.threeButton setAttributedTitle:Cselstr forState:UIControlStateSelected];
    
    

}
-(void)xtbuttonClick:(UIButton *)button
{
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    }else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;
        
    }else if (self.tempBtn != nil && self.tempBtn != button){
        button.selected = YES;
        self.tempBtn.selected = NO;
        self.tempBtn = button;
    }
    if (self.XTDelegateHeaderBlock) {
        self.XTDelegateHeaderBlock(@(button.tag));
    }
}
@end
@interface RRFXTDelegateFootBarView ()
@property(nonatomic,weak)UILabel *titleLabel;
@end
@implementation RRFXTDelegateFootBarView 
-(instancetype)init
{
    if (self = [super init]) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:11];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}
-(void)setNumber:(NSString *)numberStr
{
    NSMutableAttributedString *number = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"返利钻石的数量:%@颗",numberStr ]];
    [number addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, number.length-9)];
    [number addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(8, number.length-9)];
    self.titleLabel.attributedText = number;
}
@end
