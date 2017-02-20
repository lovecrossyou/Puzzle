//
//  EchatHeadFooter.m
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#import "EchatHeadFooter.h"
#import "EChatHeadCell.h"
#import "StockDetailModel.h"
#import "HomeTool.h"
#import "JustNowWithStockListModel.h"
#import "PZDateUtil.h"
#import "PZBetCurrency.h"
#import "UICountingLabel.h"
@interface StageView()
@property(weak,nonatomic)PZBetCurrency* moneyLabel ;
@property(weak,nonatomic)UILabel* titleLabel ;
@property(weak,nonatomic)UILabel* countLabel ;
@property(assign,nonatomic)BOOL isUp ;
@end


@implementation StageView
-(instancetype)initWithModel:(StockDetailModel*)model isUp:(BOOL)isUp{
    if (self = [super init]) {
        self.isUp = isUp ;
        //icon  看涨  percent
        NSString* iconName = isUp? @"flag_green-0" : @"flag_red" ;
        UIImageView* icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(24);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        UIColor* titleColor = [UIColor redColor];
        if (!isUp) {
            titleColor = [UIColor colorR:0 colorG:197 colorB:118];
        }
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = titleColor ;
        [titleLabel sizeToFit];
        NSString* percent = model.guessDownRate ;
        NSString* titleString = [NSString stringWithFormat:@"看涨:%@",percent];
        if (!isUp) {
            titleColor = [UIColor colorR:0 colorG:197 colorB:118];
            titleString = [NSString stringWithFormat:@"看跌:%@",percent];
        }
        titleLabel.text = titleString ;
        titleLabel.font = PZFont(14);
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel ;
        
        
        if (isUp) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(icon.mas_right).offset(8);
                make.centerY.mas_equalTo(icon.mas_centerY);
            }];
        }
        else{
            [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.centerY.mas_equalTo(icon.mas_centerY);
            }];
            [icon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(titleLabel.mas_left).offset(-8);
                make.top.mas_equalTo(24);
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }];
        }
        //green_rank
        NSString* bgName = isUp? @"red_rank" : @"green_rank" ;
        UIImageView* bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bgName]];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(6);
            make.height.mas_equalTo(32);
        }];
        
        
        //
        PZBetCurrency* moneyLabel = [[PZBetCurrency alloc]initWithMidImageTitle:@"合计:" subtitle:@""];
        [moneyLabel sizeToFit];
        moneyLabel.textLabel.textColor = [UIColor whiteColor];
        moneyLabel.subLabel.textColor = [UIColor whiteColor];
        
        moneyLabel.textLabel.font = PZFont(12);
        moneyLabel.subLabel.font = PZFont(12);
        
        [bgView addSubview:moneyLabel];
        if (isUp) {
            [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(bgView.mas_centerX).offset(-12);
                make.centerY.mas_equalTo(bgView.mas_centerY);
                make.height.mas_equalTo(32);
            }];
        }
        else{
            [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(bgView.mas_centerX);
                make.centerY.mas_equalTo(bgView.mas_centerY);
                make.height.mas_equalTo(32);
            }];
        }
        self.moneyLabel = moneyLabel ;
        
        UILabel* countLabel = [[UILabel alloc]init];
        countLabel.font = PZFont(12);
        countLabel.textAlignment = NSTextAlignmentCenter ;
        countLabel.textColor = [UIColor whiteColor];
        [countLabel sizeToFit];
        [bgView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.left.mas_equalTo(moneyLabel.mas_right);
            make.height.mas_equalTo(32);
        }];
        self.countLabel = countLabel ;
        if (isUp) {
            self.countLabel.text = [NSString stringWithFormat:@"%@",model.guessUpXtBAmount];
        }
        else{
            self.countLabel.text = [NSString stringWithFormat:@"%@",model.guessDownXtBAmount];
        }
    }
    return self ;
}


-(instancetype)initWithUp:(BOOL)isUp percent:(NSString*)percent amount:(NSString*)amount{
    if (self = [super init]) {
        self.isUp = isUp ;
        UIImageView* logo = [[UIImageView alloc]init];
        logo.contentMode = UIViewContentModeScaleAspectFit ;
        NSString* imageName =  isUp?@"icon_cow" : @"icon_bear" ;
        logo.image = [UIImage imageNamed:imageName];
        [self addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(39, 32));
        }];
        
        UILabel* countLabel = [[UILabel alloc]init];
        countLabel.font = PZFont(12);
        if (isUp) {
            countLabel.textAlignment = NSTextAlignmentLeft ;
        }
        else{
            countLabel.textAlignment = NSTextAlignmentRight ;
        }
        countLabel.textColor = isUp? StockRed : StockGreen ;
        [countLabel sizeToFit];
        [self addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(logo.mas_centerY);
            make.height.mas_equalTo(20);
            if (isUp) {
                make.left.mas_equalTo(16);
            }
            else{
                make.right.mas_equalTo(-16);
            }
        }];
        self.countLabel = countLabel ;
        
        UIImageView* line = [[UIImageView alloc]init];
        NSString* lineName =  isUp?@"cai2-red-line" : @"cai2-green-line" ;
        line.image = [UIImage imageNamed:lineName];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(2);
            make.top.mas_equalTo(logo.mas_bottom).offset(4);
        }];
        
        NSString* titleStr = isUp ? @"看涨" : @"看跌" ;
        NSString* titleString = [NSString stringWithFormat:@"%@",amount];
        PZBetCurrency* moneyLabel = [[PZBetCurrency alloc]initWithMidImageTitle:titleStr subtitle:titleString];
        [moneyLabel sizeToFit];
        moneyLabel.textLabel.textColor = [UIColor blackColor];
        moneyLabel.subLabel.textColor = [UIColor blackColor];
        moneyLabel.textLabel.font = PZFont(12);
        moneyLabel.subLabel.font = PZFont(12);
        [self addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(12);
            make.width.mas_equalTo(90);
            make.centerX.mas_equalTo(line.mas_centerX);
        }];
    }
    return self ;
}

-(void)setModel:(StockDetailModel *)model{
    NSString* percent = model.guessUpRate ;
    NSString* percentString = @"看涨:";
    NSString* titleString = [NSString stringWithFormat:@"看涨:"];
    if (self.isUp) {
        self.moneyLabel.subLabel.text = @"" ;
        self.countLabel.text = [NSString stringWithFormat:@"%@",model.guessUpRate];
    }
    else{
        percent = model.guessDownRate ;
        titleString = [NSString stringWithFormat:@"看跌:"];
        self.moneyLabel.subLabel.text = @"" ;
        percentString = @"看跌:";
        self.countLabel.text = [NSString stringWithFormat:@"%@",model.guessDownRate];
    }
    self.moneyLabel.textLabel.text = titleString ;
}
@end



@interface EchatHeadFooter()<UITableViewDelegate,UITableViewDataSource>{
    StockDetailModel* _stockDetailModel ;
}
@property(weak,nonatomic)UITableView* activeList  ;
@property(strong,nonatomic)NSArray* stockListJustNow ;
@property(weak,nonatomic)UIButton *betTimeLabel ;
@property(strong,nonatomic) NSTimer* CountdownTimer ;

@property(weak,nonatomic)StageView* stateUp ;
@property(weak,nonatomic)StageView* stateDown ;


@end

@implementation EchatHeadFooter
-(instancetype)initWithModel:(StockDetailModel *)m{
    if (self = [super init]) {
//        WEAKSELF
        _stockDetailModel = m ;
        self.backgroundColor = [UIColor whiteColor];
//        开奖日期 时间
        UILabel* IGKbetLabel = [[UILabel alloc]init];
        IGKbetLabel.textColor = [UIColor redColor];
        IGKbetLabel.font = PZFont(13.0f);
        NSString* IGKbetTimeString = [NSString stringWithFormat:@"%@ %d期 开奖时间：%@",m.stockGameName,m.stage,m.comesTime];
        IGKbetLabel.text = IGKbetTimeString;
        IGKbetLabel.textAlignment = NSTextAlignmentCenter ;
        [IGKbetLabel sizeToFit];
        [self addSubview:IGKbetLabel];
        [IGKbetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(30.0f);
            make.top.mas_equalTo(6);
        }];
        
//        截止日期
        NSString* timetext = [NSString stringWithFormat:@"截止投注：%@",m.gameEndTime] ;
        UIButton *betTimeLabel = [[UIButton alloc]init];
        [betTimeLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [betTimeLabel setImage:[UIImage imageNamed:@"home_icon_time"] forState:UIControlStateNormal];
        betTimeLabel.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [betTimeLabel setTitle:timetext forState:UIControlStateNormal];
        [betTimeLabel sizeToFit];
        [self addSubview:betTimeLabel];
        self.betTimeLabel  = betTimeLabel ;
        [betTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(IGKbetLabel.mas_bottom).offset(2);
            make.height.mas_equalTo(18.0f);
        }];
        
        StageView* stateUp = [[StageView alloc]initWithUp:YES percent:m.guessUpRate amount:m.guessUpXtBAmount];
        [self addSubview:stateUp];
        [stateUp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(72);
            make.left.mas_equalTo(12);
            make.width.mas_equalTo(SCREENWidth*0.4);
            make.bottom.mas_equalTo(-12-16);
        }];
        self.stateUp = stateUp ;
        
        StageView* stateDown = [[StageView alloc]initWithUp:NO percent:m.guessDownRate amount:m.guessDownXtBAmount];
        [self addSubview:stateDown];
        [stateDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(72);
            make.width.mas_equalTo(SCREENWidth*0.4);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12-16);
        }];
        self.stateDown = stateDown ;
        
        UIImageView* vsLabel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PK"]];
        vsLabel.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:vsLabel];
        [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(stateDown.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(32, 18));
        }];

        UIView* bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = HBColor(243, 243, 243);
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDate) userInfo:nil repeats:YES];
    }
    return self ;
}


-(void)updateDate{
    NSString* timeStr = [NSString stringWithFormat:@"截止投注:%@",[PZDateUtil intervalSinceNow:[self getStockEndTime]]] ;
    //    截止日期刷新
    [self.betTimeLabel setTitle:timeStr forState:UIControlStateNormal];
}

-(NSString*)getStockEndTime{
    return _stockDetailModel.gameEndTime ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stockListJustNow.count ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JustNowWithStockModel* m = self.stockListJustNow[indexPath.row];
    EChatHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EChatHeadCell"];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (cell== nil) {
        cell = [[EChatHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EChatHeadCell"];
    }
    cell.model = m ;
    return cell ;
}

-(void)updateModel:(StockDetailModel *)m{
    self.stateUp.model = m ;
    self.stateDown.model = m ;
}


-(void)dealloc{
    [self.CountdownTimer invalidate];
    self.CountdownTimer = nil ;
}


@end
