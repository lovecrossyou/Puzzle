//
//  FortuneHeader.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneHeader.h"
#import "UIImageView+WebCache.h"
#import "UIButton+EdgeInsets.h"
#import "LoginModel.h"
@interface FortuneHeader()
{
    UILabel* leftBotLabel ;
    UIImageView* iconView ;
    UILabel* nameLabel ;
}
@end

@implementation FortuneHeader

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor =  [UIColor colorWithHexString:@"4964ef"];
        iconView = [[UIImageView alloc]init];
        iconView.layer.masksToBounds = YES ;
        iconView.layer.cornerRadius = 4 ;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.font = PZFont(12.0);
        nameLabel.textColor = [UIColor whiteColor];
        [nameLabel sizeToFit];
        nameLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconView.mas_bottom).offset(12);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UIView* sepLineTop = [[UIView alloc]init];
        sepLineTop.backgroundColor= [UIColor colorWithHexString:@"969696"];
        [self addSubview:sepLineTop];
        [sepLineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(SCREENWidth*0.8);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UILabel* leftTopLabel = [[UILabel alloc]init];
        leftTopLabel.font = PZFont(11.0);
        leftTopLabel.textColor = [UIColor colorWithHexString:@"c3c3c3"];
        leftTopLabel.textAlignment = NSTextAlignmentCenter ;
        
        NSMutableAttributedString *prizeWinnerStr = [[NSMutableAttributedString alloc]initWithString:@"运程大吉大利会员"];
//        [prizeWinnerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff002a"] range:NSMakeRange(2,4)];
        leftTopLabel.attributedText = prizeWinnerStr ;
        [leftTopLabel sizeToFit];
        [self addSubview:leftTopLabel];
        [leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepLineTop.mas_bottom).offset(8);
            make.left.mas_equalTo(SCREENWidth*0.1+4);
        }];
        leftBotLabel = [[UILabel alloc]init];
        leftBotLabel.font = PZFont(11.0);
        leftBotLabel.textColor = [UIColor colorWithHexString:@"c3c3c3"];
        [leftBotLabel sizeToFit];
        leftBotLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:leftBotLabel];
        [leftBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(leftTopLabel.mas_bottom).offset(4);
            make.centerX.mas_equalTo(leftTopLabel.mas_centerX);
        }];
        
        //line
        UIView* sepLineBot = [[UIView alloc]init];
        sepLineBot.backgroundColor= [UIColor colorWithHexString:@"969696"];
        [self addSubview:sepLineBot];
        [sepLineBot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(sepLineTop.mas_width);
            make.bottom.mas_equalTo(-12);
        }];
        
        UIButton* rightBtn = [UIButton new];
        [rightBtn setTitleColor:[UIColor colorWithHexString:@"c3c3c3"] forState:UIControlStateNormal];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
        rightBtn.titleLabel.font = PZFont(11.0f);
        [rightBtn setTitle:@"运程会员专区" forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftBotLabel.mas_centerY);
            make.right.mas_equalTo(sepLineBot.mas_right).offset(-6);
            make.height.mas_equalTo(32.0f);
        }];
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.MemberCenterBlock) {
                self.MemberCenterBlock();
            }
        }];
        [rightBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:0 imageWidth:9];
    }
    return self ;
}

-(void)configHeader:(LoginModel* )userM{
    [iconView sd_setImageWithURL:[NSURL URLWithString:userM.icon] placeholderImage:DefaultImage];
    nameLabel.text = userM.cnName ;
}

-(void)update:(NSDictionary *)data{
    int remainTimes = [data[@"remainTimes"] intValue];
    leftBotLabel.text = [NSString stringWithFormat:@"剩余%d天",remainTimes] ;
}




@end
