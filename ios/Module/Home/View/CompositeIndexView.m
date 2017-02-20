//
//  CompositeIndexView.m
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CompositeIndexView.h"
#import "GameModel.h"
#import "PZVerticalButton.h"

@interface StockLabel : UIView
@property(weak,nonatomic)UILabel* indexValue ;
@property(weak,nonatomic)UIImageView* flagView ;
@property(weak,nonatomic)UILabel* rateValue ;

@end


@implementation StockLabel : UIView
-(instancetype)initWith:(StockModel*)stock{
    if (self = [super init]) {
        self.userInteractionEnabled = NO ;
        UILabel* indexValue = [[UILabel alloc]init];
        indexValue.text = stock.currentPoint ;
        indexValue.font = PZFont(18.0f);
        [indexValue sizeToFit];
        [self addSubview:indexValue];
        [indexValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(12);
        }];
        self.indexValue = indexValue ;
        
        UIImageView* flagView = [[UIImageView alloc]init];
        flagView.userInteractionEnabled = NO ;
        //↑  ↓
        [flagView sizeToFit];
        flagView.image = [UIImage imageNamed:@"icon_arrow_up-"];
        [self addSubview:flagView];
        [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(indexValue.mas_right).offset(2);
        }];
        self.flagView = flagView ;
        
        UILabel* rateValue = [[UILabel alloc]init];
        rateValue.userInteractionEnabled = NO ;
        rateValue.font = PZFont(16.0f);
        [rateValue sizeToFit];
        [self addSubview:rateValue];
        [rateValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(flagView.mas_right).offset(16);
            make.right.mas_equalTo(-12);
        }];
        self.rateValue = rateValue ;
        if ([stock.chg floatValue] > 0) {
            indexValue.textColor = StockRed;
            rateValue.textColor = StockRed;
            flagView.image = [UIImage imageNamed:@"icon_arrow_up-"] ;
            rateValue.text = [NSString stringWithFormat:@"+%@   +%@%%",stock.chg,stock.changeRate] ;
        }
        else{
            indexValue.textColor = StockGreen;
            flagView.image = [UIImage imageNamed:@"icon_arrow_down"] ;
            rateValue.textColor = indexValue.textColor;
            rateValue.text = [NSString stringWithFormat:@"%@   %@%%",stock.chg,stock.changeRate] ;
        }
    }
    return self ;
}

-(void)updateStockData:(StockModel *)stock{
    self.indexValue.text = stock.currentPoint ;
    if ([stock.chg floatValue] > 0) {
        self.indexValue.textColor = StockRed;
        self.rateValue.textColor = StockRed;
        self.flagView.image = [UIImage imageNamed:@"icon_arrow_up-"] ;

        self.rateValue.text = [NSString stringWithFormat:@"+%@   +%@%%",stock.chg,stock.changeRate] ;
    }
    else{
        self.indexValue.textColor = StockGreen;
        self.flagView.image = [UIImage imageNamed:@"icon_arrow_down"] ;
        self.rateValue.textColor = StockGreen;
        self.rateValue.text = [NSString stringWithFormat:@"%@   %@%%",stock.chg,stock.changeRate] ;
    }
}

@end


@interface CompositeIndexView()
{
    CGFloat iconWidthCow   ;
    CGFloat iconHeightCow  ;
    
    CGFloat iconWidthBear ;
    CGFloat iconHeightBear  ;
    
    CGFloat width ;
    
    CAEmitterLayer * _fireEmitter;//发射器对象

}
@property(weak,nonatomic)UILabel* titleStrView ;
@property(weak,nonatomic)StockLabel* indexView ;


@property(weak,nonatomic) UIImageView* leftView ;
@property(weak,nonatomic) UIImageView* rightView ;

@end


@implementation CompositeIndexView
//"stockGameId": 1,  //id
//"stockGameName": "上证综指",//游戏名称
//"guessUpXtBAmount": 0,//猜涨的 喜腾币数量
//"guessDownXtBAmount": 0,//猜跌的喜腾币的数量
//"status": 2,//状态  1未开始 2进行中 3 等待开奖 4 已完成
//"tradeDay": "2016-08-23"//交易日

-(instancetype)initWithStock:(GameModel *)stockM{
    if (self = [super init]) {
        iconWidthCow  = 65 ;
        iconHeightCow  = 53 ;
        
        iconWidthBear = 39 ;
        iconHeightBear  = 58 ;
        
        width = (SCREENWidth - 12*2)/2 ;
        self.backgroundColor = [UIColor clearColor];
        
        UIView* bgView = [[UIView alloc]init];
        bgView.userInteractionEnabled = NO ;
        bgView.backgroundColor = [UIColor colorWithHexString:@"1c242a"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UILabel* titleStrView = [[UILabel alloc]init];
        titleStrView.text = stockM.stockGameName ;
        titleStrView.textColor = [UIColor whiteColor];
        titleStrView.font = [UIFont boldSystemFontOfSize:18.0f];
        titleStrView.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:titleStrView];
        [titleStrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGSizeMake(120, 30));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(20-8);
        }];
        self.titleStrView = titleStrView ;
        
        UIImageView* arrow = [[UIImageView alloc]init];
        arrow.image = [UIImage imageNamed:@"sanjiaoxiaojiantou"];
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleStrView.mas_right).offset(6);
            make.centerY.mas_equalTo(titleStrView.mas_centerY);
            make.height.mas_equalTo(CGSizeMake(6, 10));
        }];

        
        StockLabel* indexView = [[StockLabel alloc]initWith:stockM.stockModel];
        [self addSubview:indexView];
        [indexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleStrView.mas_bottom).offset(12);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(22.0f);
        }];
        self.indexView = indexView ;
        
        
        UIImageView* PK = [[UIImageView alloc]init];
        PK.image = [UIImage imageNamed:@"PK"];
        [self addSubview:PK];
        [PK mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(27, 16));
        }];
        
        CGFloat btnWidth = 118 ;
        CGFloat padding = 12 ;
        CGFloat leftOffset = ((SCREENWidth-2*padding)/2 - btnWidth)/2 ;
        UIButton* leftBet = [UIButton new];
        leftBet.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [leftBet setTitle:@"猜涨投注" forState:UIControlStateNormal];
        [leftBet setBackgroundImage:[UIImage imageNamed:@"cai1-button-bg"] forState:UIControlStateNormal];
        leftBet.contentMode = UIViewContentModeScaleAspectFit ;
        [leftBet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:leftBet];
        [leftBet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftOffset);
            make.height.mas_equalTo(34);
            make.width.mas_equalTo(118);
            make.bottom.mas_equalTo(-17);
        }];
        self.leftBetGo = leftBet ;

        
        UIButton* rightBet = [UIButton new];
        rightBet.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [rightBet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBet setTitle:@"猜跌投注" forState:UIControlStateNormal];
        [rightBet setBackgroundImage:[UIImage imageNamed:@"cai1-button-bg"] forState:UIControlStateNormal];
        rightBet.contentMode = UIViewContentModeScaleAspectFit ;
        [self addSubview:rightBet];
        [rightBet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-leftOffset);
            make.width.mas_equalTo(leftBet.mas_width);
            make.height.mas_equalTo(34);
            make.bottom.mas_equalTo(-17);
        }];
        self.rightBetGo = rightBet ;
        
//      indexBottom  left
        NSString* guessUpAmount = [NSString stringWithFormat:@"%@ ",stockM.guessUpXtBAmount];
        VerticalTextButton* indexBottomLeft = [[VerticalTextButton alloc]initWithHorizonTitle:@"" subTitle:guessUpAmount];
        [indexBottomLeft sizeToFit];
        [indexBottomLeft setBackViewColor:[UIColor clearColor]];
        [self addSubview:indexBottomLeft];
        [indexBottomLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(leftBet.mas_centerX).offset(6);
            make.bottom.mas_equalTo(leftBet.mas_top).offset(-17);
        }];
        UIImageView* flagLeft = [[UIImageView alloc]init];
        flagLeft.image = [UIImage imageNamed:@"Home-red-flag"];
        [self addSubview:flagLeft];
        [flagLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(indexBottomLeft.mas_left).offset(-4);;
            make.centerY.mas_equalTo(indexBottomLeft.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 14));
        }];
        
//
//        //indexBottom  right
        NSString* guessDownAmount = [NSString stringWithFormat:@"%@ ",stockM.guessDownXtBAmount];
        VerticalTextButton* indexBottomRight = [[VerticalTextButton alloc]initWithHorizonTitle:@"" subTitle:guessDownAmount];
        [indexBottomRight sizeToFit];
        [indexBottomRight setBackViewColor:[UIColor clearColor]];
        [self addSubview:indexBottomRight];
        [indexBottomRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(rightBet.mas_top).offset(-17);
            make.centerX.mas_equalTo(rightBet.mas_centerX).offset(6);;
        }];
        UIImageView* flagRight = [[UIImageView alloc]init];
        flagRight.image = [UIImage imageNamed:@"Home-green-flag"];
        [self addSubview:flagRight];
        [flagRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(indexBottomRight.mas_left).offset(-4);
            make.centerY.mas_equalTo(indexBottomRight.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 14));
        }];

        
//        left  right
        UIImageView* leftView = [[UIImageView alloc]init];
        leftView.image = [UIImage imageNamed:@"icon_cow"];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(iconWidthCow, iconHeightCow));
            make.bottom.mas_equalTo(leftBet.mas_top).offset(-42);
            make.left.mas_equalTo((width-iconWidthCow)/2);
        }];
        self.leftView = leftView ;
//
        UIImageView* rightView = [[UIImageView alloc]init];
        rightView.image = [UIImage imageNamed:@"icon_bear"];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(iconWidthBear, iconHeightBear));
            make.right.mas_equalTo(-(width-iconWidthBear)/2);
            make.bottom.mas_equalTo(leftBet.mas_top).offset(-42);
        }];
        self.rightView = rightView ;
//

    }
    return self ;
}

//-(void)setIsEmitting:(BOOL)isEmitting
//{
//    //turn on/off the emitting of particles
//    [_fireEmitter setValue:[NSNumber numberWithInt:isEmitting?30:0] forKeyPath:@"emitterCells.smoke.birthRate"];
//}
//


-(void)updateStockData:(GameModel *)stockModel{
    [self.indexView updateStockData:stockModel.stockModel];
}

@end
