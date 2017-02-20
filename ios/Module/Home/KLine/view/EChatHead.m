//
//  EChatHead.m
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "EChatHead.h"
#import "UIColor+helper.h"
#import "EChatTitle.h"
#import "StockDetailModel.h"

@interface EChatHead()
{
    UILabel* mainIndex ;
    UILabel* mainValue1 ;
    UILabel* mainValue2 ;
    EChatTitle* zuoshou ;
    EChatTitle* top ;
    EChatTitle* chengjiao ;
    EChatTitle* jinkai ;
    EChatTitle* bottom;
    EChatTitle* chengjiaoe ;
}
@end

@implementation EChatHead
//    "stockName": "上证指数",
//    "todayOpend": null,//今日开盘价
//    "yesterDayClosed": null,//昨日收盘价
//    "nowPrice": null,//当前价格
//    "todayMaxPrice": null,//今日最高价格
//    "todayMinPrice": null,//今日最低价格
//    "turnoverStockAmount": "3105.6775",//成交的股票数量
//    "turnoverStockMoney": "3087.8794",//成交的金额
//    "currentPoint": "3091.3287",//当前点数
//    "changeRate": "3090.6488",//涨跌率
//    "chg": "3090.7127"//涨跌幅

-(instancetype)initWithStockDetailModel:(StockDetailModel *)m{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#111111" withAlpha:1];
        mainIndex = [[UILabel alloc]init];
        mainIndex.textColor = [UIColor redColor];
        mainIndex.font = [UIFont boldSystemFontOfSize:24.0f];
        [mainIndex sizeToFit];
        [self addSubview:mainIndex];
        [mainIndex mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16.0f);
            make.left.mas_equalTo(12);
        }];
        
        mainValue1 = [[UILabel alloc]init];
        mainValue1.textColor = StockRed;
        mainValue1.font = PZFont(12.0f);
        [mainValue1 sizeToFit];
        [self addSubview:mainValue1];
        [mainValue1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(mainIndex.mas_centerY);
            make.left.mas_equalTo(mainIndex.mas_right).offset(12);
        }];
        
        mainValue2 = [[UILabel alloc]init];
        mainValue2.textColor = StockRed;
        mainValue2.font = PZFont(12.0f);
        [mainValue2 sizeToFit];
        [self addSubview:mainValue2];
        [mainValue2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(mainValue1.mas_centerY);
            make.left.mas_equalTo(mainValue1.mas_right).offset(12);
        }];
        
        zuoshou = [[EChatTitle alloc]initWithTitle:@"昨收" value:m.stockModel.yesterDayClosed attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
        [zuoshou sizeToFit];
        [self addSubview:zuoshou];
        [zuoshou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(mainValue2.mas_bottom).offset(12);;
        }];
        
        top = [[EChatTitle alloc]initWithTitle:@"最高" value:m.stockModel.todayMaxPrice attr:@{NSForegroundColorAttributeName:StockRed} ];
        [top sizeToFit];
        [self addSubview:top];
        [top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(mainValue2.mas_bottom).offset(12);
        }];
        
        chengjiao = [[EChatTitle alloc]initWithTitle:@"成交量" value:m.stockModel.turnoverStockAmount attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
        [chengjiao sizeToFit];
        [self addSubview:chengjiao];
        [chengjiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(mainValue2.mas_bottom).offset(12);
            make.left.mas_greaterThanOrEqualTo(top.mas_right).offset(0);
        }];
        
        jinkai = [[EChatTitle alloc]initWithTitle:@"今开" value:m.stockModel.todayOpend attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
        [jinkai sizeToFit];
        [self addSubview:jinkai];
        [jinkai mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(zuoshou.mas_bottom).offset(12);;
        }];
        
        bottom = [[EChatTitle alloc]initWithTitle:@"最低" value:m.stockModel.todayMinPrice attr:@{NSForegroundColorAttributeName:StockGreen} ];
        [bottom sizeToFit];
        [self addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(zuoshou.mas_bottom).offset(12);
        }];
        
        chengjiaoe = [[EChatTitle alloc]initWithTitle:@"成交额" value:m.stockModel.turnoverStockMoney  attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
        [chengjiaoe sizeToFit];
        [self addSubview:chengjiaoe];
        [chengjiaoe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(zuoshou.mas_bottom).offset(12);
        }];
        
        [self updateModel:m];
    }
    return self ;
}

-(void)updateModel:(StockDetailModel *)m{
    UIColor* stockColor  ;
    NSString* prefixStr = @"+";
    NSString* subfixStr = @"%" ;
    if ([m.stockModel.chg floatValue] < 0) {
        //down
        stockColor = StockGreen ;
        prefixStr = @"" ;
    }
    else{
        stockColor = StockRed ;
    }
    mainIndex.textColor = stockColor ;
    mainValue1.textColor = stockColor ;
    mainValue2.textColor = stockColor ;
    
    mainIndex.text = m.stockModel.currentPoint ;
    mainValue1.text = [NSString stringWithFormat:@"%@%@",prefixStr,m.stockModel.chg] ;
    mainValue2.text = [NSString stringWithFormat:@"%@%@%@",prefixStr,m.stockModel.changeRate,subfixStr];
    zuoshou = [[EChatTitle alloc]initWithTitle:@"昨收" value:m.stockModel.yesterDayClosed  attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
    top = [[EChatTitle alloc]initWithTitle:@"最高" value:m.stockModel.todayMaxPrice  attr:@{NSForegroundColorAttributeName:StockRed} ];
    chengjiao = [[EChatTitle alloc]initWithTitle:@"成交量" value:m.stockModel.turnoverStockAmount attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
    jinkai = [[EChatTitle alloc]initWithTitle:@"今开" value:m.stockModel.todayOpend  attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];
    bottom = [[EChatTitle alloc]initWithTitle:@"最低" value:m.stockModel.todayMinPrice  attr:@{NSForegroundColorAttributeName:StockGreen} ];
    chengjiaoe = [[EChatTitle alloc]initWithTitle:@"成交额" value:m.stockModel.turnoverStockMoney  attr:@{NSForegroundColorAttributeName:[UIColor whiteColor]} ];

}

@end
