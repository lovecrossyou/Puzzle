//
//  JNQBookFBOrderView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQBookFBOrderView.h"
#import "JNQButton.h"
#import "UIImageView+WebCache.h"

@implementation JNQBookFBOrderView

@end


@interface JNQBookFBOrderComContentView : UIView

@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, assign) NSInteger restCount;

@end

@implementation JNQBookFBOrderComContentView {
    UIImageView *_comImgV;
    UILabel *_comNameL;
    UILabel *_stageNoL;
    UILabel *_stockL;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _comImgV = [[UIImageView alloc] init];
        [self addSubview:_comImgV];
        [_comImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(12);
            make.width.height.mas_equalTo(60);
        }];
        _comImgV.layer.masksToBounds = YES;
        _comImgV.layer.cornerRadius = 3;
        
        _comNameL = [[UILabel alloc] init];
        [self addSubview:_comNameL];
        [_comNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(_comImgV.mas_right).offset(12);
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(-12);
        }];
        _comNameL.font = PZFont(14.5);
        _comNameL.textColor = HBColor(51, 51, 51);
        
        _stageNoL = [[UILabel alloc] init];
        [self addSubview:_stageNoL];
        [_stageNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comNameL.mas_bottom).offset(6);
            make.left.mas_equalTo(_comNameL);
            make.height.mas_equalTo(14);
        }];
        _stageNoL.font = PZFont(13);
        _stageNoL.textColor = HBColor(153, 153, 153);
        
        _stockL = [[UILabel alloc] init];
        [self addSubview:_stockL];
        [_stockL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stageNoL.mas_bottom);
            make.left.height.mas_equalTo(_stageNoL);
        }];
        _stockL.font = PZFont(13);
        _stockL.textColor = HBColor(153, 153, 153);
    }
    return self;
}

- (void)setProductM:(FBProductModel *)productM {
    _productM = productM;
    NSString *str = [productM.picUrl isEqualToString:@""] || !productM.picUrl ? @"http://www.xiteng.com/group1/M00/00/00/Cqr_HFgapFiABTO0AABm97ka_Oo058.png" : productM.picUrl;
    [_comImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    _comNameL.text = [NSString stringWithFormat:@"%@", productM.productName];
    _stageNoL.text = [NSString stringWithFormat:@"期数：%ld", productM.stage];
}

- (void)setRestCount:(NSInteger)restCount {
    _restCount = restCount;
    _stockL.text = [NSString stringWithFormat:@"剩余：%ld", restCount];
}

@end

@implementation JNQBookFBOrderOperateView {
    
    
    UIView *_countBackV;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *inCountL = [[UILabel alloc] init];
        [self addSubview:inCountL];
        [inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(self).offset(18);
            make.height.mas_equalTo(30);
        }];
        inCountL.font = PZFont(14);
        inCountL.textColor = HBColor(153, 153, 153);
        inCountL.text = @"参与份数";
        
        _countOpeV = [[JNQCountOperateView alloc] initWithFrame:CGRectMake(SCREENWidth-20-118, 15, 118, 30)];
        [self addSubview:_countOpeV];
        _countOpeV.layer.borderColor = HBColor(51, 51, 51).CGColor;
        _countOpeV.layer.borderWidth = 0.5;
        _countOpeV.layer.cornerRadius = 2;
        _countOpeV.textColor = BasicRedColor;
        _countOpeV.lineColor = HBColor(51, 51, 51);
        _countOpeV.lineWidth = 0.5;
        WEAKSELF
        _countOpeV.countBlock = ^(NSInteger count) {
            [weakSelf.allInCountBtn setTitle:[NSString stringWithFormat:@" %ld", _productM.priceOfOneBidInXtb * count] forState:UIControlStateSelected];
            if (weakSelf.countBlock) {
                weakSelf.countBlock(count);
            }
        };
        
        _countBackV = [[UIView alloc] initWithFrame:CGRectMake(18, 70, SCREENWidth-36, 25)];
        [self addSubview:_countBackV];
        
        CGFloat bWidth = (SCREENWidth-36-40)/5;
        for (int i = 0; i<5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(bWidth+10), 0, bWidth, 25)];
            [_countBackV addSubview:btn];
            btn.titleLabel.font = PZFont(13);
            [btn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(countBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = HBColor(51, 51, 51).CGColor;
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 2;
            btn.tag = i;
        }
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_countBackV.mas_bottom).offset(15);
            make.left.mas_equalTo(_countBackV);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-36, 0.5));
        }];
        line.backgroundColor = HBColor(231, 231, 231);
        
        _allInCountBtn = [[JNQXTButton alloc] init];
        [self addSubview:_allInCountBtn];
        [_allInCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.right.mas_equalTo(self).offset(-18);
            make.height.mas_equalTo(35);
        }];
        _allInCountBtn.selected = YES;
        _allInCountBtn.titleLabel.font = PZFont(14);
        
        UILabel *allInCountL = [[UILabel alloc] init];
        [self addSubview:allInCountL];
        [allInCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_allInCountBtn);
            make.right.mas_equalTo(_allInCountBtn.mas_left);
        }];
        allInCountL.font = PZFont(14);
        allInCountL.textColor = BasicRedColor;
        allInCountL.text = @"合计：";
    }
    return self;
}

- (void)setProductM:(FBProductModel *)productM {
    _productM = productM;
    [_allInCountBtn setTitle:[NSString stringWithFormat:@" %ld", productM.priceOfOneBidInXtb] forState:UIControlStateSelected];
}

- (void)setTitleA:(NSArray *)titleA {
    _titleA = titleA;
    for (UIButton *btn in _countBackV.subviews) {
        [btn setTitle:titleA[btn.tag] forState:UIControlStateNormal];
    }
}

- (void)countBtnDidClicked:(UIButton *)button {
    if (button.tag == 4) {
        _countOpeV.count = _restCount;
        [_allInCountBtn setTitle:[NSString stringWithFormat:@" %ld", _restCount * _productM.priceOfOneBidInXtb] forState:UIControlStateNormal];
    } else {
        if (_restCount < [_titleA[button.tag] integerValue]) {
            [MBProgressHUD showInfoWithStatus:@"剩余不足"];
            _countOpeV.count = _restCount;
            [_allInCountBtn setTitle:[NSString stringWithFormat:@" %ld", _restCount * _productM.priceOfOneBidInXtb] forState:UIControlStateNormal];
        } else {
            _countOpeV.count = [_titleA[button.tag] integerValue];
            [_allInCountBtn setTitle:[NSString stringWithFormat:@" %ld", [_titleA[button.tag] integerValue] * _productM.priceOfOneBidInXtb] forState:UIControlStateNormal];
        }
    }
}

- (void)setDelegateVC:(id<UITextFieldDelegate>)delegateVC {
    _countOpeV.numField.delegate = delegateVC;
}

- (void)setRestCount:(NSInteger)restCount {
    _restCount = restCount;
}

@end

@implementation JNQBookFBOrderHeaderView {
    JNQBookFBOrderComContentView *_comContentV;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        WEAKSELF
        _comContentV = [[JNQBookFBOrderComContentView alloc] init];
        [self addSubview:_comContentV];
        [_comContentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(80);
        }];
        
        _operateV = [[JNQBookFBOrderOperateView alloc] init];
        [self addSubview:_operateV];
        [_operateV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comContentV.mas_bottom).offset(10);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(145);
        }];
        _operateV.countBlock = ^(NSInteger count) {
            if (weakSelf.countBlock) {
                weakSelf.countBlock(count);
            }
        };
    }
    return self;
}
- (void)setProductM:(FBProductModel *)productM {
    _productM = productM;
    _comContentV.productM = productM;
    _operateV.productM = productM;
}

- (void)setTitleA:(NSArray *)titleA {
    _titleA = titleA;
    _operateV.titleA = titleA;
}

- (void)setDelegateVC:(id<UITextFieldDelegate>)delegateVC {
    _operateV.delegateVC = delegateVC;
}

- (void)setRestCount:(NSInteger)restCount {
    _restCount = restCount;
    _comContentV.restCount = restCount;
    _operateV.restCount = restCount;
}

@end


@implementation JNQBookFBOrderFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _inBtn = [[UIButton alloc] init];
        [self addSubview:_inBtn];
        [_inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-20, 40));
        }];
        _inBtn.backgroundColor = BasicBlueColor;
        _inBtn.layer.masksToBounds = YES;
        _inBtn.layer.cornerRadius = 3;
        _inBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_inBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inBtn setTitle:@"立即参与" forState:UIControlStateNormal];
    }
    return self;
}


@end
