
//
//  GuessPageHeadView.m
//  Puzzle
//
//  Created by huipay on 2016/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "GuessPageHeadView.h"
#import "PZTitleInputView.h"
#import "GameModel.h"
#import "GameModel.h"
#import "RRFMeTool.h"
#import "LoginModel.h"
#import "PZDateUtil.h"
//#import "PZVerticalButton.h"
#import "StockDetailModel.h"
#import "UIButton+EdgeInsets.h"
#import "PZBetCurrency.h"
#import "AFFNumericKeyboard.h"
#import "UICountingLabel.h"

#import "HomeTool.h"
#define kColumn 3
#define kPadding 12



@interface DefaultAmountPanel : UIView
@property(copy,nonatomic)ItemClickParamBlock itemClick ;
@property(weak,nonatomic)UIButton* selBtn ;
@end


@implementation DefaultAmountPanel
-(instancetype)init{
    if (self = [super init]) {
        WEAKSELF
        NSArray* amounts = @[@"100",@"1000",@"10000"];
        CGFloat itemWidth = (SCREENWidth - kPadding*(kColumn+1))/kColumn ;
        CGFloat itemHeight = 64 ;
        for (int i = 0; i<amounts.count; i++) {
            CGFloat x = i%kColumn*itemWidth +(i%kColumn + 1)*kPadding ;
            CGFloat y = i/kColumn*itemHeight +kPadding*(i/kColumn) + kPadding ;
            CGRect frame = CGRectMake(x, y, itemWidth, itemHeight) ;
            NSInteger amount = [amounts[i] integerValue];
            UIButton* itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.layer.masksToBounds = YES ;
            itemBtn.layer.cornerRadius = 5 ;
            itemBtn.titleLabel.font  = PZFont(16.0f);
            [itemBtn setBackgroundImage:[UIImage imageNamed:@"btn_choose_bet"] forState:UIControlStateSelected];
            [itemBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"777777"]] forState:UIControlStateNormal];
            [itemBtn setTitle:amounts[i] forState:UIControlStateNormal];
            itemBtn.tag = amount ;
            [[itemBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UIButton* x) {
                weakSelf.selBtn.selected = NO ;
                x.selected = YES ;
                [weakSelf itemClick:x];
                weakSelf.selBtn = x ;
            }];
            itemBtn.frame = frame ;
            [itemBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageBottom imageTitlespace:4 imageWidth:itemWidth];
            [self addSubview:itemBtn];
        }
    }
    return self;
}


-(void)itemClick:(UIButton*)sender{
    NSArray* views = self.subviews ;
    [views enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO ;
    }];
    sender.selected = YES ;
    self.itemClick(@(sender.tag));
}



-(UIColor*)normalColor{
    return  [UIColor colorR:0 colorG:139 colorB:246] ;
}

-(UIColor*)selectedColor{
    return [UIColor redColor];
}

@end



@interface GuessPageHeadView()<AFFNumericKeyboardDelegate>

@property(assign,nonatomic)int guessType ;
@property(assign,nonatomic)int stockId ;
@property(strong,nonatomic)LoginModel* userInfo ;

@property(strong,nonatomic) NSTimer* timer1 ;
@property(weak,nonatomic) UILabel* endDateView ;

@property(strong,nonatomic)GameModel* gameModel ;
@property(strong,nonatomic)StockDetailModel* stockDetailModel ;


@property(weak,nonatomic)UIActivityIndicatorView* indicator ;

@property(weak,nonatomic)UITextField* inputField ;

@property(weak,nonatomic) UICountingLabel* oddsUpLabel ;
@property(weak,nonatomic) UICountingLabel* oddsDownUpLabel ;


@end


@implementation GuessPageHeadView

-(instancetype)initWithIndexM:(GameModel*)gameM stockDetailM:(StockDetailModel*)stockDetail type:(int)guessType{
    if (self = [super init]) {
        self.gameModel = gameM ;
        self.stockDetailModel = stockDetail ;
        //self.backgroundColor = HBColor(20, 22, 28);

        UIImageView* bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"cai3-light"];
        bgView.contentMode = UIViewContentModeScaleAspectFill ;
        bgView.userInteractionEnabled = NO ;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        
        UIView* topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor clearColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(240+2, 60));
        }];
        
        UILabel* stockNameAndTypeLabel = [[UILabel alloc]init];
        stockNameAndTypeLabel.textColor = [UIColor whiteColor];
        stockNameAndTypeLabel.textAlignment = NSTextAlignmentCenter ;
        [topView addSubview:stockNameAndTypeLabel];
        [stockNameAndTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.left.right.mas_equalTo(0);
            make.width.mas_equalTo(120);
        }];
        NSString* guessTypeString = guessType==0 ? @"猜涨" : @"猜跌" ;
        UIColor* guessColor = guessType==0 ? StockRed : StockGreen;
        NSString* stockName = gameM.stockGameName ;
        NSString* stockNumber = [NSString stringWithFormat:@"%d 期",gameM.stage];
        NSString* fullString = [NSString stringWithFormat:@"%@    %@    %@",stockName,stockNumber,guessTypeString];
        
        NSMutableAttributedString* attrFullString = [[NSMutableAttributedString alloc]initWithString:fullString];
        
        
        NSRange range = NSMakeRange(fullString.length - 2, 2);
        [attrFullString addAttributes:@{NSForegroundColorAttributeName:guessColor} range:range];
        [stockNameAndTypeLabel setAttributedText:attrFullString];
        WEAKSELF
        self.stockId =  gameM.stockGameId;
        
        // 金额   请选择输入数额  xt币 touzhu_money_input input_bet_iocn
        UITextField* inputView = [[UITextField alloc]init];
        inputView.background = [UIImage imageNamed:@"touzhu_money_input"];
        inputView.font = PZFont(16) ;
        inputView.textColor = [UIColor whiteColor];
        inputView.textAlignment = NSTextAlignmentCenter ;
        AFFNumericKeyboard *keyboard = [[AFFNumericKeyboard alloc]
                                        initWithFrame:CGRectMake(0, 200, SCREENWidth, 216)];
        inputView.inputView = keyboard;
        keyboard.delegate = self;
        inputView.tintColor = [UIColor colorWithHexString:@"ffb527"];
        NSMutableAttributedString* placeHolder = [[NSMutableAttributedString alloc]initWithString:@"请输入/选择数额"];
        range = NSMakeRange(0, placeHolder.length);
        [placeHolder addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffb527"]} range:range];
        inputView.attributedPlaceholder = placeHolder ;
        self.inputField = inputView ;
        [self addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(160);
            make.top.mas_equalTo(topView.mas_bottom).offset(20);
        }];
        
        
        UILabel* titleInput = [[UILabel alloc]init];
        titleInput.text = @"数额:" ;
        titleInput.font = PZFont(15.0f);
        titleInput.textColor = [UIColor whiteColor];
        [titleInput sizeToFit];
        [self addSubview:titleInput];
        [titleInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(inputView.mas_left).offset(-8);
            make.centerY.mas_equalTo(inputView.mas_centerY);
        }];
        
        UILabel* unitInput = [[UILabel alloc]init];
        unitInput.text = @"喜腾币" ;
        unitInput.font = PZFont(12.0f);
        unitInput.textColor = [UIColor whiteColor];
        [unitInput sizeToFit];
        [self addSubview:unitInput];
        [unitInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(inputView.mas_right).offset(8);
            make.centerY.mas_equalTo(inputView.mas_centerY);
        }];
        
        
        //100 200 500 100 2000 5000
        DefaultAmountPanel* defaultAmountPanel = [[DefaultAmountPanel alloc]init];
        defaultAmountPanel.itemClick = ^(NSNumber* amount){
            [inputView resignFirstResponder];
            inputView.text = [NSString stringWithFormat:@"%@",amount];
        };
        [self addSubview:defaultAmountPanel];
        [defaultAmountPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(inputView.mas_bottom).offset(20+12);
            make.height.mas_equalTo(70+ 12);
            make.left.right.mas_equalTo(0);
        }];
        
        UILabel* remainLabel = [[UILabel alloc]init];
        remainLabel.textColor = [UIColor whiteColor];
        remainLabel.text = @"余额：";
        [self addSubview:remainLabel];
        [remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(32.0f);
            make.top.mas_equalTo(defaultAmountPanel.mas_bottom).offset(28-12-12);
        }];
        
        
        UIButton* remainBtn = [UIButton new];
        [remainBtn setImage:[UIImage imageNamed:@"icon_maddle"] forState:UIControlStateNormal];
        remainBtn.titleLabel.textColor = [UIColor whiteColor];
        remainBtn.titleLabel.font = PZFont(13.0f);
        [remainBtn sizeToFit];
        [self addSubview:remainBtn];
        [remainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(remainLabel.mas_right);
            make.height.mas_equalTo(32.0f);
            make.centerY.mas_equalTo(remainLabel.mas_centerY);
        }];
        [remainBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:4 imageWidth:12];
        
        //wo de yu e
        UIButton* betAllMoney = [UIButton new];
        [betAllMoney setTitle:@"全部投注" forState:UIControlStateNormal];
        [betAllMoney setTitleColor:[UIColor colorWithHexString:@"ffb527"] forState:UIControlStateNormal];
        betAllMoney.titleLabel.font = PZFont(13.0);
        [self addSubview:betAllMoney];
        [betAllMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(remainBtn.mas_right).offset(6);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(44.0f);
            make.centerY.mas_equalTo(remainBtn.mas_centerY);
        }];
        
        //wo de yu e
        UIButton* getXTCurrency = [UIButton new];
        [getXTCurrency setTitle:@"获取喜腾币" forState:UIControlStateNormal];
        [getXTCurrency setTitleColor:[UIColor colorWithHexString:@"ffb527"] forState:UIControlStateNormal];
        getXTCurrency.titleLabel.font = PZFont(13.0);
        [self addSubview:getXTCurrency];
        [getXTCurrency mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(44.0f);
            make.centerY.mas_equalTo(remainBtn.mas_centerY);
        }];
        [[getXTCurrency rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [inputView resignFirstResponder];
            weakSelf.bugXTBlock();
        }];
        
        UIButton* btnCommit = [UIButton new];
        [btnCommit setBackgroundImage:[UIImage imageNamed:@"bet_button"] forState:UIControlStateNormal];
        btnCommit.imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [self addSubview:btnCommit];
        [btnCommit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80.0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(45);
            if (IPHONE4) {
                make.bottom.mas_equalTo(-30.0f);
            }else{
                make.top.mas_equalTo((SCREENHeight - 64)*0.65);
            }
        }];
        
        
        [[btnCommit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSString* betAmount = inputView.text ;
            if (betAmount.length == 0) {
                [MBProgressHUD showInfoWithStatus:@"请输入投注金额！"];
                return ;
            }
            [inputView resignFirstResponder];
            weakSelf.guessGameBlock(betAmount);
        }];
        [RRFMeTool requestAccountXTBWithSuccess:^(id json) {
            [MBProgressHUD dismiss];
            LoginModel* userM = [LoginModel yy_modelWithJSON:json];
            weakSelf.userInfo = userM ;
            NSString *attrStr = [NSString stringWithFormat:@"%@",userM.xtbTotalAmount];
            [remainBtn setTitle:attrStr forState:UIControlStateNormal];
            [[betAllMoney rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                inputView.text = [NSString stringWithFormat:@"%@",userM.xtbTotalAmount];
                [weakSelf keyboardDown];
            }];
        } failBlock:^(id json) {
            
        }];
        
        
        UIView* bottomView = [[UIView alloc]init];
        [bottomView sizeToFit];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(0);
        }];
        
        //当前参考
        UILabel* descInfo = [[UILabel alloc]init];
        descInfo.text = @"【当前参考】猜涨赔率: " ;
        descInfo.font = PZFont(12.0f);
        descInfo.textAlignment = NSTextAlignmentCenter ;
        descInfo.textColor = [UIColor lightGrayColor];
        [descInfo sizeToFit];
        [bottomView addSubview:descInfo];
        [descInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-12*2);
        }];
        
        UICountingLabel* oddsUpLabel = [[UICountingLabel alloc]init];
        [oddsUpLabel sizeToFit];
        oddsUpLabel.font = PZFont(12.0f);
        oddsUpLabel.textAlignment = NSTextAlignmentCenter ;
//        oddsUpLabel.textColor = StockRed;
        oddsUpLabel.textColor = [UIColor lightGrayColor];

        oddsUpLabel.text = @"0.5" ;
        oddsUpLabel.format = @" %.2f";

        [bottomView addSubview:oddsUpLabel];
        [oddsUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(descInfo.mas_right);
            make.bottom.mas_equalTo(-12*2);
        }];
        self.oddsUpLabel = oddsUpLabel ;
        
        UILabel* descMidInfo = [[UILabel alloc]init];
        descMidInfo.text = @"猜跌赔率: " ;
        descMidInfo.font = PZFont(12.0f);
        descMidInfo.textAlignment = NSTextAlignmentCenter ;
        descMidInfo.textColor = [UIColor lightGrayColor];
        [descMidInfo sizeToFit];
        [bottomView addSubview:descMidInfo];
        [descMidInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oddsUpLabel.mas_right);
            make.bottom.mas_equalTo(-12*2);
        }];
        
        UICountingLabel* oddsDownUpLabel = [[UICountingLabel alloc]init];
        [oddsDownUpLabel sizeToFit];
        oddsDownUpLabel.font = PZFont(12.0f);
        oddsDownUpLabel.textAlignment = NSTextAlignmentCenter ;
//        oddsDownUpLabel.textColor = StockGreen;
        oddsDownUpLabel.textColor = [UIColor lightGrayColor];

        oddsDownUpLabel.text = @"0.5" ;
        oddsDownUpLabel.format = @" %.2f";
        [bottomView addSubview:oddsDownUpLabel];
        [oddsDownUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(descMidInfo.mas_right);
            make.bottom.mas_equalTo(-12*2);
            make.right.mas_equalTo(-6);
        }];
        self.oddsDownUpLabel = oddsDownUpLabel ;
        [self requestOdds];
    }
    return self ;
}

#pragma mark  - 查询赔率
-(void)requestOdds{
    WEAKSELF
    int stockId = self.gameModel.stockGameId ;
    [HomeTool getStockOddsWithStockId:stockId successBlock:^(id json) {
        NSString* upOdds = json[@"upOdds"] ;
        NSString* downOdds = json[@"downOdds"] ;
        if ([upOdds isNull]) {
            upOdds = @"0.5" ;
        }
        if ([downOdds isNull]) {
            downOdds = @"0.5" ;
        }
        [weakSelf.oddsUpLabel countFrom:0.5 to:[upOdds floatValue] withDuration:0.2];
        [weakSelf.oddsDownUpLabel countFrom:0.5 to:[downOdds floatValue] withDuration:0.2];
    } fail:^(id json) {
        
    }];
}

-(void)changeKeyboardType
{
    [self.inputField resignFirstResponder];
}

-(void)numberKeyboardBackspace
{
    if (self.inputField.text.length != 0)
    {
        self.inputField.text = [self.inputField.text substringToIndex:self.inputField.text.length -1];
    }
}

-(void)numberKeyboardInput:(NSInteger)number
{
    self.inputField.text = [self.inputField.text stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)number]];
}



-(void)keyboardUp{
    [self.inputField becomeFirstResponder];
}

-(void)keyboardDown{
    [self.inputField resignFirstResponder];
}

@end
