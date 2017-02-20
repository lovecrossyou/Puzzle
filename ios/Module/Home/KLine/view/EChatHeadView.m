//
//  EChatHeadView.m
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "EChatHeadView.h"
#import "EChatHead.h"
#import "UIColor+helper.h"
#import "lineView.h"
#import "EchatHeadFooter.h"
#import "StockDetailModel.h"
#import "UIImageView+WebCache.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>

@interface EChatHeadView(){
    lineView *lineview;
    UIImageView* stockGifView ;
    UIButton *btnDay;
    UIButton *btnWeek;
    UIButton *btnMonth;
    UIButton* btnHour ;
    
    StockModel* _stockM ;
    
    
    NSString* _currentStockTypeUrl ;
}

@property(weak,nonatomic)EChatHead* headView  ;
@property(weak,nonatomic)EchatHeadFooter* footer;

@end


@implementation EChatHeadView
-(instancetype)initWithModel:(StockDetailModel*)m{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#111111" withAlpha:1];
        _stockM = m.stockModel ;
        EChatHead* headView = [[EChatHead alloc]initWithStockDetailModel:m];
        [self addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(100);
        }];
        self.headView = headView ;
        
        CGFloat width = (SCREENWidth-2*12) / 4 ;
        UIView* selectPanel = [[UIView alloc]init];
        [self addSubview:selectPanel];
        selectPanel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        selectPanel.layer.borderWidth = 1 ;
        [selectPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(headView.mas_bottom).offset(1);
            make.height.mas_equalTo(32);
        }];
        
        // 分时按钮
        btnHour = [[UIButton alloc] init];
        [btnHour setBackgroundColor:[UIColor grayColor]];
        [btnHour setTitle:@"分时" forState:UIControlStateNormal];
        [btnHour addTarget:self action:@selector(kHourLine) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonAttr:btnHour];
        [selectPanel addSubview:btnHour];
        [btnHour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(1);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        
        // 日k按钮
         btnDay = [[UIButton alloc] init];
        [btnDay setBackgroundColor:[UIColor grayColor]];
        [btnDay setTitle:@"日K" forState:UIControlStateNormal];
        [btnDay addTarget:self action:@selector(kDayLine) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonAttr:btnDay];
        [selectPanel addSubview:btnDay];
        [btnDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnHour.mas_right);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        
        // 周k按钮
        btnWeek = [[UIButton alloc] init];
        [btnWeek setTitle:@"周K" forState:UIControlStateNormal];
        [btnWeek addTarget:self action:@selector(kWeekLine) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonAttr:btnWeek];
        [selectPanel addSubview:btnWeek];
        [btnWeek mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnDay.mas_right);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        
        // 月k按钮
        btnMonth = [[UIButton alloc] init];
        [btnMonth setTitle:@"月K" forState:UIControlStateNormal];
        [btnMonth addTarget:self action:@selector(kMonthLine) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonAttr:btnMonth];
        [selectPanel addSubview:btnMonth];
        [btnMonth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnWeek.mas_right);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        
        // 添加k线图
        /* lineview = [[lineView alloc] init];
        lineview.frame = CGRectMake(0,100 + 30 + 12, SCREENWidth, 252);
        lineview.req_type = @"d";
        lineview.req_freq = @"000001.SS";
        lineview.kLineWidth = 5;
        lineview.kLinePadding = 0.5;
        [self addSubview:lineview];
        [lineview start]; // k线图运行
        [self setButtonAttrWithClick:btnDay];*/
        
        stockGifView = [[UIImageView alloc]init];
        stockGifView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *gesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapHandle:)];
        [stockGifView addGestureRecognizer:gesture];

        stockGifView.frame = CGRectMake(0,100 + 30 + 12, SCREENWidth, 252);
        [stockGifView sd_setImageWithURL:[NSURL URLWithString:_stockM.minImg] placeholderImage:nil];
        [self addSubview:stockGifView];
        
        EchatHeadFooter* footer = [[EchatHeadFooter alloc]initWithModel:m];
        [self addSubview:footer];
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(stockGifView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        self.footer = footer ;
        [self kHourLine];

    }
    return self ;
}

-(void)kHourLine{
    [self setButtonAttrWithClick:btnHour];
    [self setButtonAttr:btnMonth];
    [self setButtonAttr:btnDay];
    [self setButtonAttr:btnWeek];
    lineview.req_type = @"h";
    _currentStockTypeUrl = _stockM.minImg ;
    [self kUpdate];
}

-(void)kDayLine{
    [self setButtonAttrWithClick:btnDay];
    [self setButtonAttr:btnMonth];
    [self setButtonAttr:btnHour];
    [self setButtonAttr:btnWeek];
    lineview.req_type = @"d";
    _currentStockTypeUrl = _stockM.dayImg ;

    [self kUpdate];
}

-(void)kWeekLine{
    [self setButtonAttrWithClick:btnWeek];
    [self setButtonAttr:btnMonth];
    [self setButtonAttr:btnDay];
    [self setButtonAttr:btnHour];
    lineview.req_type = @"w";
    _currentStockTypeUrl = _stockM.weekImg ;

    [self kUpdate];
}

-(void)kMonthLine{
    [self setButtonAttrWithClick:btnMonth];
    [self setButtonAttr:btnWeek];
    [self setButtonAttr:btnDay];
    lineview.req_type = @"m";
    _currentStockTypeUrl = _stockM.monthImg ;

    [self kUpdate];
}

-(void)kBigLine{
    lineview.kLineWidth += 1;
    [self kUpdate];
}

-(void)kSmallLine{
    lineview.kLineWidth -= 1;
    if (lineview.kLineWidth<=1) {
        lineview.kLineWidth = 1;
    }
    [self kUpdate];
}

-(void)kUpdate{
    //[lineview update];
    [stockGifView sd_setImageWithURL:[NSURL URLWithString:_currentStockTypeUrl] placeholderImage:nil options:SDWebImageRefreshCached];
}

-(void)setButtonAttr:(UIButton*)button{
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
-(void)setButtonAttrWithClick:(UIButton*)button{
    button.backgroundColor = [UIColor colorR:41 colorG:41 colorB:49];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


-(void)updateStock:(StockDetailModel *)stockM{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headView updateModel:stockM];
        [self.footer updateModel:stockM];
    });
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    UIImageView* sender = (UIImageView*)tap.view ;
    [HUPhotoBrowser showFromImageView:sender withURLStrings:@[_currentStockTypeUrl] placeholderImage:DefaultImage atIndex:0 dismiss:nil];
}


@end
