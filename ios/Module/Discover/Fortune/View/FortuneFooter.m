//
//  FortuneFooter.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneFooter.h"
#import "UIButton+EdgeInsets.h"
@interface FortuneFooter(){
    UIButton* btnGo ;
}
@end
@implementation FortuneFooter
-(instancetype)init{
    if (self = [super init]) {
        WEAKSELF
        UIImageView* topBg = [[UIImageView alloc]init];
        topBg.image = [UIImage imageNamed:@"measure_pic_s"];
        [self addSubview:topBg];
        [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(108);
        }];
        
        btnGo = [UIButton new];
        btnGo.layer.masksToBounds = YES ;
        btnGo.layer.cornerRadius = 40 ;
        [btnGo setImage:[UIImage imageNamed:@"measure_icon_gossips"] forState:UIControlStateNormal];
        [self addSubview:btnGo];
        [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.top.mas_equalTo(30);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UIButton* goBtn = [[UIButton alloc]init];
        goBtn.titleLabel.font =PZFont(16.0f);
        [goBtn setTitle:@"立即测算" forState:UIControlStateNormal] ;
        [goBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        [goBtn sizeToFit];
        [self addSubview:goBtn];
        [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btnGo.mas_bottom).offset(6);
            make.centerX.mas_equalTo(btnGo.mas_centerX);
        }];
        [[goBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf doComputeFortune];
        }];
        [[btnGo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf doComputeFortune];
        }];
        
        UIImageView* botBg = [[UIImageView alloc]init];
        botBg.contentMode = UIViewContentModeScaleAspectFill ;
        botBg.image = [UIImage imageNamed:@"measure_pic_r"];
        [self insertSubview:botBg belowSubview:btnGo];
        
        CGFloat botHeight = IPHONE4 ? 110 : (IPHONE6 ? 120 : 138);
        [botBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(botHeight);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self ;
}

-(void)doComputeFortune{
    self.computeFortune(self);
}

-(void)stopAnimateRotate{
    [btnGo.layer removeAnimationForKey:@"rotate-layer"];
}


-(void)doAnimateRotate{
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    animation.duration = 1.8; // 持续时间
    animation.repeatCount = MAXFLOAT; // 重复次数
    
    // 设定选装角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI]; // 终止角度
    
    // 添加动画
    [btnGo.layer addAnimation:animation forKey:@"rotate-layer"];
}
@end
