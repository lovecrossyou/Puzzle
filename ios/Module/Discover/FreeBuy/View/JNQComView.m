//
//  JNQComView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQComView.h"
#import "SDCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "PZDateUtil.h"
@implementation JNQComView

@end

//商品
@interface JNQComContentView : UIView

@property (nonatomic, strong) FBProductModel *contentProductM;
- (void)updateContentHeight:(CGFloat)contentHeight nameHeight:(CGFloat)nameHeight descriptionHeight:(CGFloat)desHeight;

@end

@implementation JNQComContentView {
    SDCycleScrollView *_bannerColView;
    UIView *_contentBackV;
    UIButton *_stateBtn;
    UILabel *_comNameL;
    UILabel *_comContentL;
    JNQXTButton *_comPriceBtn;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _bannerColView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENWidth) imageURLStringsGroup:nil];
        [self addSubview:_bannerColView];
        _bannerColView.backgroundColor = [UIColor whiteColor];
        _bannerColView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerColView.currentPageDotColor = HBColor(254, 205, 52);
        _bannerColView.pageDotColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _bannerColView.placeholderImage = [UIImage imageNamed:@"product_img_default"];
        _bannerColView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        
        _contentBackV = [[UIView alloc] init];
        [self addSubview:_contentBackV];
        [_contentBackV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bannerColView.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(SCREENWidth);
            make.height.mas_equalTo(170);
        }];
        _contentBackV.backgroundColor = [UIColor whiteColor];
        
        //状态
        _stateBtn = [[UIButton alloc] init];
        [_contentBackV addSubview:_stateBtn];
        [_stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 16));
        }];
        [_stateBtn setImage:[UIImage imageNamed:@"orderdetail_lable_jinxingzhong"] forState:UIControlStateNormal];
        
        //名字
        _comNameL = [[UILabel alloc] init];
        [_contentBackV addSubview:_comNameL];
        [_comNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentBackV).offset(10);
            make.left.mas_equalTo(_stateBtn);
            make.width.mas_equalTo(SCREENWidth-20);
        }];
        _comNameL.font = PZFont(15);
        _comNameL.textColor = HBColor(51, 51, 51);
        _comNameL.numberOfLines = 0;
        
        //描述
        _comContentL = [[UILabel alloc] init];
        [_contentBackV addSubview:_comContentL];
        [_comContentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comNameL.mas_bottom).offset(10);
            make.left.width.mas_equalTo(_comNameL);
        }];
        _comContentL.font = PZFont(12.5);
        _comContentL.textColor = HBColor(153, 153, 153);
        _comContentL.numberOfLines = 0;
        
        UILabel *priceL = [[UILabel alloc] init];
        [_contentBackV addSubview:priceL];
        [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comContentL.mas_bottom).offset(10);
            make.left.mas_equalTo(_comContentL);
            make.height.mas_equalTo(15);
        }];
        priceL.font = PZFont(12.5);
        priceL.textColor = HBColor(153, 153, 153);
        priceL.text = @"每份:";
        
        UILabel *explainLabel = [[UILabel alloc]init];
        explainLabel.text = DeclarationInfo;
        explainLabel.font = PZFont(12.5);
        explainLabel.textColor = StockRed;
        [_contentBackV addSubview:explainLabel];
        [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceL.mas_bottom).offset(10);
            make.left.mas_equalTo(_comContentL);
            make.height.mas_equalTo(15);
            make.right.mas_equalTo(-12);
        }];
        
        _comPriceBtn = [[JNQXTButton alloc] init];
        [_contentBackV addSubview:_comPriceBtn];
        [_comPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comContentL.mas_bottom).offset(10);
            make.left.mas_equalTo(priceL.mas_right);
            make.height.mas_equalTo(15);
        }];
        _comPriceBtn.selected = YES;
        _comPriceBtn.titleLabel.font = PZFont(16.5);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerColView.frame), SCREENWidth, 0.5)];
        [self addSubview:line];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setContentProductM:(FBProductModel *)contentProductM {
    _comNameL.text = [NSString stringWithFormat:@"           %@", contentProductM.productName];
    _comContentL.text = [NSString stringWithFormat:@"%@", contentProductM.purchaseGameDescription];
    [_comPriceBtn setTitle:[NSString stringWithFormat:@" %ld", contentProductM.priceOfOneBidInXtb] forState:UIControlStateSelected];
    if ([contentProductM.purchaseGameStatus isEqualToString:@"bidding"]) {
        [_stateBtn setImage:[UIImage imageNamed:@"orderdetail_lable_jinxingzhong"] forState:UIControlStateNormal];
    } else if ([contentProductM.purchaseGameStatus isEqualToString:@"finish_bid"]) {
        [_stateBtn setImage:[UIImage imageNamed:@"orderdetail_lable_daojishi"] forState:UIControlStateNormal];
    } else if ([contentProductM.purchaseGameStatus isEqualToString:@"have_lottery"]) {
        [_stateBtn setImage:[UIImage imageNamed:@"orderdetail_lable_yijiexiao"] forState:UIControlStateNormal];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in contentProductM.pictures) {
        [array addObject:dict[@"picUrl"]];
    }
    _bannerColView.imageURLStringsGroup = array;
}

- (void)updateContentHeight:(CGFloat)contentHeight nameHeight:(CGFloat)nameHeight descriptionHeight:(CGFloat)desHeight {
    [_contentBackV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    [_comNameL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameHeight);
    }];
    [_comContentL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(desHeight);
    }];
}

@end

@interface JNQLuckUserView : UIView {
    UIButton *_headBtn;
    UILabel *_userNameL;
    UILabel *_areaIpL;
    UILabel *_stageNoL;
    UILabel *_inCountL;
    UILabel *_annouceTimeL;
    UILabel *_luckNoL;
}

@property (nonatomic, strong) JNQFBLukyUserModel *luckUserM;
@property (nonatomic, strong) UIButton *calculateDetailBtn;
@property (nonatomic, assign) NSInteger stage;

@end

@implementation JNQLuckUserView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(249, 242, 240);
        
        _headBtn = [[UIButton alloc] init];
        [self addSubview:_headBtn];
        [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(self).offset(10);
            make.width.height.mas_equalTo(35);
        }];
        _headBtn.layer.masksToBounds = YES;
        _headBtn.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _headBtn.layer.borderWidth = 0.5;
        _headBtn.layer.cornerRadius = 3;
        
        _userNameL = [[UILabel alloc] init];
        [self addSubview:_userNameL];
        [_userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.mas_equalTo(_headBtn.mas_right).offset(10);
            make.height.mas_equalTo(21);
        }];
        _userNameL.font = PZFont(12.5);
        _userNameL.textColor = HBColor(153, 153, 153);
        _userNameL.text = @"获奖用户：";
        
        _areaIpL = [[UILabel alloc] init];
        [self addSubview:_areaIpL];
        [_areaIpL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userNameL.mas_bottom);
            make.left.height.mas_equalTo(_userNameL);
        }];
        _areaIpL.font = PZFont(12.5);
        _areaIpL.textColor = HBColor(153, 153, 153);
        
        _stageNoL = [[UILabel alloc] init];
        [self addSubview:_stageNoL];
        [_stageNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_areaIpL.mas_bottom);
            make.left.height.mas_equalTo(_areaIpL);
        }];
        _stageNoL.font = PZFont(12.5);
        _stageNoL.textColor = HBColor(153, 153, 153);
        _stageNoL.text = @"期数：";
        
        _inCountL = [[UILabel alloc] init];
        [self addSubview:_inCountL];
        [_inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stageNoL.mas_bottom);
            make.left.height.mas_equalTo(_stageNoL);
        }];
        _inCountL.font = PZFont(12.5);
        _inCountL.textColor = HBColor(153, 153, 153);
        _inCountL.text = @"参与份数：";
        
        _annouceTimeL = [[UILabel alloc] init];
        [self addSubview:_annouceTimeL];
        [_annouceTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountL.mas_bottom);
            make.left.height.mas_equalTo(_inCountL);
        }];
        _annouceTimeL.font = PZFont(12.5);
        _annouceTimeL.textColor = HBColor(153, 153, 153);
        _annouceTimeL.text = @"揭晓时间：";
        
        UIImageView *imgV = [[UIImageView alloc] init];
        [self addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 37));
        }];
        [imgV setImage:[UIImage imageNamed:@"orderdetail_yijiexiao_bg"]];
        imgV.contentMode = UIViewContentModeScaleToFill;
        
        _luckNoL = [[UILabel alloc] init];
        [self addSubview:_luckNoL];
        [_luckNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(10);
            make.height.mas_equalTo(34);
        }];
        _luckNoL.font = PZFont(15);
        _luckNoL.textColor = [UIColor whiteColor];
        _luckNoL.text = @"幸运号码：";
        
        _calculateDetailBtn = [[UIButton alloc] init];
        [self addSubview:_calculateDetailBtn];
        [_calculateDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_luckNoL);
            make.right.mas_equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(95, 25));
        }];
        _calculateDetailBtn.backgroundColor = [UIColor whiteColor];
        _calculateDetailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _calculateDetailBtn.layer.borderWidth = 0.5;
        _calculateDetailBtn.layer.cornerRadius = 3;
        _calculateDetailBtn.titleLabel.font = PZFont(14);
        [_calculateDetailBtn setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_calculateDetailBtn setTitle:@"查看计算详情" forState:UIControlStateNormal];
        
        UIImageView *luckL = [[UIImageView alloc] init];
        [self addSubview:luckL];
        [luckL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.right.mas_equalTo(self).offset(-15);
            make.width.height.mas_equalTo(50);
        }];
        [luckL setImage:[UIImage imageNamed:@"fortune"]];
    }
    return self;
}

- (void)setLuckUserM:(JNQFBLukyUserModel *)luckUserM {
    _luckUserM = luckUserM;
    [_headBtn sd_setImageWithURL:[NSURL URLWithString:luckUserM.userIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
    _userNameL.text = [NSString stringWithFormat:@"获奖用户：%@", luckUserM.userName];
    _areaIpL.text = [NSString stringWithFormat:@"(%@IP：%@)", luckUserM.area, luckUserM.ip];
    _inCountL.text = [NSString stringWithFormat:@"参与份数：%ld", luckUserM.bidCount];
    _annouceTimeL.text = [NSString stringWithFormat:@"揭晓时间：%@", luckUserM.winTime];
    _luckNoL.text = [NSString stringWithFormat:@"幸运号码：%ld", luckUserM.luckCode];
}

- (void)setStage:(NSInteger)stage {
    _stage = stage;
    _stageNoL.text = [NSString stringWithFormat:@"期数：%ld", stage];
}

@end

@interface JNQCountDownView : UIView {
    UILabel *_stageL;
    UILabel *_countDownL;
}

@property (nonatomic, assign) NSInteger stage;

@end

@implementation JNQCountDownView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(235, 82, 82);
        
        _stageL = [[UILabel alloc] init];
        [self addSubview:_stageL];
        [_stageL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(5);
            make.left.mas_equalTo(self).offset(15);
            make.height.mas_equalTo(21);
        }];
        _stageL.font = PZFont(13);
        _stageL.textColor = [UIColor whiteColor];
        _stageL.text = @"期数";
        
        _countDownL = [[UILabel alloc] init];
        [self addSubview:_countDownL];
        [_countDownL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stageL.mas_bottom).offset(5);
            make.left.height.mas_equalTo(_stageL);
        }];
        _countDownL.font = PZFont(16);
        _countDownL.textColor = [UIColor whiteColor];
        _countDownL.text = @"揭晓倒计时：";
    }
    return self;
}

- (void)updateCountDownTime:(NSString *)finishTime {
    NSString* remainStr = [PZDateUtil intervalSinceNowMillisecond:finishTime];
    _countDownL.text = [NSString stringWithFormat:@"揭晓倒计时：%@", remainStr];
    NSMutableAttributedString *countDownString = [[NSMutableAttributedString alloc] initWithString:_countDownL.text];
    [countDownString addAttribute:NSFontAttributeName value:PZFont(13) range:[_countDownL.text rangeOfString:@"揭晓倒计时："]];
    _countDownL.attributedText = countDownString;
    if ([remainStr isEqualToString:@"已开奖"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"countDownEnd" object:nil];
        return;
    }
}

- (void)setStage:(NSInteger)stage {
    _stageL.text = [NSString stringWithFormat:@"期数：%ld", stage];
}

@end


//当前参与状态
@interface JNQComFBView : UIView {
    UILabel *_stageNoL;   //期数
    UILabel *_allFBL;     //总需
    UILabel *_stockL;     //剩余
    
    UIView *_isInBV;      //已参与
    UILabel *_inCountL;   //参与份数
    UILabel *_inNos;      //夺宝号码
    UIButton *_allInNos;  //查看全部
    
    UIView *_noInBV;      //未参与
    
}

@property (nonatomic, strong) UIView *topBV;
@property (nonatomic, strong) UIView *proBV;
@property (nonatomic, strong) UIView *progressV;
@property (nonatomic, strong) UIButton *noInAttenBtn;
@property (nonatomic, strong) JNQLuckUserView *luckUserV;
@property (nonatomic, strong) JNQCountDownView *countDownV;
@property (nonatomic, assign) BOOL isIn;
@property (nonatomic, strong) JNQFBStateModel *stateM;
@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, strong) ButtonBlock buttonBlock;

@end


@implementation JNQComFBView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _topBV = [[UIView alloc] init];
        [self addSubview:_topBV];
        [_topBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(self);
            make.height.mas_equalTo(77);
        }];
        
        _proBV = [[UIView alloc] init];
        [_topBV addSubview:_proBV];
        [_proBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _proBV.hidden = YES;
        
        _stageNoL = [[UILabel alloc] init];
        [_proBV addSubview:_stageNoL];
        [_stageNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(10);
            make.height.mas_equalTo(32);
        }];
        _stageNoL.font = PZFont(13.5);
        _stageNoL.textColor = HBColor(153, 153, 153);
        _stageNoL.text = @"期数：201606270001";
        
        UIView *progressBackV = [[UIView alloc] init];
        [_proBV addSubview:progressBackV];
        [progressBackV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stageNoL.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-20, 8));
        }];
        progressBackV.backgroundColor = HBColor(231, 231, 231);
        progressBackV.layer.masksToBounds = YES;
        progressBackV.layer.cornerRadius = 4;
        
        _progressV = [[UIView alloc] init];
        [progressBackV addSubview:_progressV];
        [_progressV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.left.mas_equalTo(progressBackV);
        }];
        _progressV.backgroundColor = BasicRedColor;
        _progressV.layer.masksToBounds = YES;
        _progressV.layer.cornerRadius = 4;
        
        _allFBL = [[UILabel alloc] init];
        [_proBV addSubview:_allFBL];
        [_allFBL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_progressV.mas_bottom);
            make.left.height.mas_equalTo(_stageNoL);
        }];
        _allFBL.font = PZFont(13.5);
        _allFBL.textColor = HBColor(153, 153, 153);
        _allFBL.text = @"总需：5899份";
        
        _stockL = [[UILabel alloc] init];
        [_proBV addSubview:_stockL];
        [_stockL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_allFBL);
            make.right.mas_equalTo(self).offset(-10);
        }];
        _stockL.font = PZFont(13.5);
        _stockL.textColor = HBColor(153, 153, 153);
        _stockL.textAlignment = NSTextAlignmentRight;
        _stockL.text = @"剩余：2950份";
        
        _luckUserV = [[JNQLuckUserView alloc] init];
        [_topBV addSubview:_luckUserV];
        [_luckUserV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_topBV);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 160));
        }];
        _luckUserV.hidden = YES;
        _luckUserV.calculateDetailBtn.tag = 1001;
        [_luckUserV.calculateDetailBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _countDownV = [[JNQCountDownView alloc] init];
        [_topBV addSubview:_countDownV];
        [_countDownV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_topBV);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 57));
        }];
        _countDownV.hidden = YES;
        
        UIView *sepLine = [[UIView alloc] init];
        [self addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topBV.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-20, 0.5));
        }];
        sepLine.backgroundColor = HBColor(231, 231, 231);
        
        _isInBV = [[UIView alloc] init];
        [self addSubview:_isInBV];
        [_isInBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepLine.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(52);
        }];
        _isInBV.backgroundColor = [UIColor whiteColor];
        _isInBV.hidden = YES;
        
        _inCountL = [[UILabel alloc] init];
        [_isInBV addSubview:_inCountL];
        [_inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_isInBV).offset(5);
            make.left.mas_equalTo(_isInBV).offset(10);
            make.height.mas_equalTo(18.5);
        }];
        _inCountL.font = PZFont(12.5);
        _inCountL.textColor = HBColor(153, 153, 153);
        _inCountL.text = @"您参与了：";
        
        _allInNos = [[UIButton alloc] init];
        [_isInBV addSubview:_allInNos];
        [_allInNos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountL.mas_bottom).offset(5);
            make.right.mas_equalTo(_isInBV);
            make.size.mas_equalTo(CGSizeMake(70, 18.5));
        }];
        _allInNos.backgroundColor = [UIColor whiteColor];
        _allInNos.titleLabel.font = PZFont(12.5);
        [_allInNos setTitleColor:BasicBlueColor forState:UIControlStateNormal];
        [_allInNos setTitle:@"查看全部" forState:UIControlStateNormal];
        _allInNos.tag = 1004;
        [_allInNos addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _inNos = [[UILabel alloc] init];
        [_isInBV addSubview:_inNos];
        [_inNos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountL.mas_bottom).offset(5);
            make.left.height.mas_equalTo(_inCountL);
            make.width.mas_equalTo(SCREENWidth-20);
        }];
        _inNos.font = PZFont(12.5);
        _inNos.textColor = HBColor(153, 153, 153);
        _inNos.text = @"夺宝号码：";
        
        _noInBV = [[UIView alloc] init];
        [self addSubview:_noInBV];
        [_noInBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepLine.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(52);
        }];
        _noInBV.backgroundColor = [UIColor whiteColor];
        
        NSString *atten = @"您还没有参加本期夺宝，立即参与！";
        _noInAttenBtn = [[UIButton alloc] init];
        [_noInBV addSubview:_noInAttenBtn];
        [_noInAttenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_noInBV);
            make.center.mas_equalTo(_noInBV);
        }];
        _noInAttenBtn.titleLabel.font = PZFont(12);
        [_noInAttenBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        [_noInAttenBtn setTitle:atten forState:UIControlStateNormal];
        _noInAttenBtn.tag = 1003;
        [_noInAttenBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setProductM:(FBProductModel *)productM {
    _productM = productM;
    _stageNoL.text = [NSString stringWithFormat:@"期数：%ld", productM.stage];
    CGFloat percent = [productM.rateOfProgress floatValue]/100;
    [_progressV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((SCREENWidth-20)*percent);
    }];
    _allFBL.text = [NSString stringWithFormat:@"总需：%ld份", productM.targetPurchaseCount];
    _stockL.text = [NSString stringWithFormat:@"剩余：%.0f份", productM.restPurchaseCount];
}

- (void)setStateM:(JNQFBStateModel *)stateM {
    _stateM = stateM;
    if ([stateM.purchaseGameStatus isEqualToString:@"bidding"]) {
        _proBV.hidden = NO;
        _countDownV.hidden = YES;
        _luckUserV.hidden = YES;
        [_topBV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(77);
        }];
    } else if ([stateM.purchaseGameStatus isEqualToString:@"finish_bid"]) {
        _proBV.hidden = YES;
        _countDownV.hidden = NO;
        _luckUserV.hidden = YES;
        _countDownV.stage = stateM.stage;
        [_topBV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(77);
        }];
    } else if ([stateM.purchaseGameStatus isEqualToString:@"have_lottery"]) {
        _proBV.hidden = YES;
        _countDownV.hidden = YES;
        _luckUserV.hidden = NO;
        _luckUserV.luckUserM = stateM.luckUserInfo;
        _luckUserV.stage = stateM.stage;
        [_topBV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(180);
        }];
    }
    _isInBV.hidden = stateM.bid ? NO : YES;
    _noInBV.hidden = !_isInBV.hidden;
    if (_isInBV.hidden) {
        NSString *title = [stateM.purchaseGameStatus isEqualToString:@"bidding"] ? @"您还没有参加本期夺宝，立即参与！" : @"您没有参与本期夺宝";
        if ([stateM.purchaseGameStatus isEqualToString:@"bidding"]) {
            NSMutableAttributedString *noInString = [[NSMutableAttributedString alloc] initWithString:@"您还没有参加本期夺宝，立即参与！"];
            [noInString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[@"您还没有参加本期夺宝，立即参与！" rangeOfString:@"立即参与"]];
            _noInAttenBtn.titleLabel.attributedText = noInString;
        }
        [_noInAttenBtn setTitle:title forState:UIControlStateNormal];
        _noInAttenBtn.userInteractionEnabled = [stateM.purchaseGameStatus isEqualToString:@"bidding"] ? YES : NO;
    } else {
        _inCountL.text = [NSString stringWithFormat:@"您参与了：%ld份", stateM.bidRecords.count];
        NSMutableAttributedString *inCountString = [[NSMutableAttributedString alloc] initWithString:_inCountL.text];
        [inCountString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[_inCountL.text rangeOfString:[NSString stringWithFormat:@"%ld", stateM.bidRecords.count]]];
        _inCountL.attributedText = inCountString;
        _inNos.text = @"夺宝号码：";
        for (FBBidRecordModel *model in stateM.bidRecords) {
            _inNos.text = [_inNos.text stringByAppendingString:[NSString stringWithFormat:@"%ld ", model.purchaseCode]];
        }
        NSDictionary *nameAttribute = @{NSFontAttributeName:PZFont(12.5)};
        CGRect rect = [_inNos.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:nameAttribute context:nil];
        CGFloat inNoWidth = CGRectGetWidth(rect)>SCREENWidth-70 ? SCREENWidth-70 : CGRectGetWidth(rect);
        [_inNos mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(inNoWidth);
        }];
        _allInNos.hidden = CGRectGetWidth(rect)>SCREENWidth-70 ? NO : YES;
    }
}

- (void)btnsDidClicked:(UIButton *)button {
    if (self.buttonBlock) {
        self.buttonBlock(button);
    }
}

- (void)updateCountDown {
    [_countDownV updateCountDownTime:_stateM.openResultTime];
}

@end

@implementation JNQComHeaderView {
    JNQComContentView *_contentV;
    JNQComFBView *_fbV;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        WEAKSELF
        _contentV = [[JNQComContentView alloc] init];
        _contentV.backgroundColor = [UIColor redColor];
        [self addSubview:_contentV];
        [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(self);
            make.height.mas_equalTo(SCREENWidth+170);
        }];
        
        _fbV = [[JNQComFBView alloc] init];
        [self addSubview:_fbV];
        [_fbV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentV.mas_bottom).offset(10);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(129.5);
        }];
        _fbV.buttonBlock = ^(UIButton *button) {
            if (weakSelf.buttonBlock) {
                weakSelf.buttonBlock(button);
            }
        };
    }
    return self;
}

- (void)setFbProductModel:(FBProductModel *)fbProductModel {
    _fbProductModel = fbProductModel;
    _contentV.contentProductM = _fbProductModel;
    _fbV.productM = _fbProductModel;
}

- (void)setStateM:(JNQFBStateModel *)stateM {
    _stateM = stateM;
    _fbV.stateM = stateM;
    if ([stateM.purchaseGameStatus isEqualToString:@"have_lottery"]) {
        [_fbV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(237.5);
        }];
    } else {
        [_fbV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(134.5);
        }];
    }
}

- (void)updateContentHeight:(CGFloat)contentHeight nameHeight:(CGFloat)nameHeight descriptionHeight:(CGFloat)desHeight {
    [_contentV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREENWidth+contentHeight);
    }];
    [_contentV updateContentHeight:contentHeight nameHeight:(CGFloat)nameHeight descriptionHeight:(CGFloat)desHeight];
}

- (void)updateCountDown {
    [_fbV updateCountDown];
}

@end


@implementation JNQComBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _nowInBtn = [[JNQOperationButton alloc] init];
        [self addSubview:_nowInBtn];
        [_nowInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        [_nowInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
    }
    return self;
}

@end



