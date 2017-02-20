//
//  JNQFBCompleteView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFBCompleteView.h"
#import "HBVerticalBtn.h"
#import "JNQButton.h"

@implementation JNQFBCompleteView

@end



@interface JNQFBCompleteSuccessView : UIView

@end

@implementation JNQFBCompleteSuccessView {
    HBVerticalBtn *_successBtn;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _successBtn = [[HBVerticalBtn alloc] initWithIcon:@"icon_pay-success" title:@"参与成功"];
        [self addSubview:_successBtn];
        [_successBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(70);
        }];
        [_successBtn setTextColor:BasicBlueColor];
        [_successBtn setFontSize:14.5];
        
        UILabel *attenL = [[UILabel alloc] init];
        [self addSubview:attenL];
        [attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_successBtn.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(25);
        }];
        attenL.font = PZFont(13);
        attenL.textColor = HBColor(153, 153, 153);
        attenL.text = @"请等待揭晓结果...";
    }
    return self;
}

@end

@interface JNQFBCompleteDetailView : UIView

@property (nonatomic, strong) FBProductModel *detaliProductM;
@property (nonatomic, strong) ButtonBlock buttonBlock;

@end

@implementation JNQFBCompleteDetailView {
    UILabel *_orderNoL;
    UILabel *_comNameL;
    UILabel *_stockNoL;
    UILabel *_inCountL;
    UILabel *_inNosL;
    UIButton *_allInNos;
    JNQXTButton *_inPriceBtn;
    UILabel *_createTimeL;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _orderNoL = [[UILabel alloc] init];
        [self addSubview:_orderNoL];
        [_orderNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(8);
            make.left.mas_equalTo(self).offset(12);
            make.height.mas_equalTo(16.5);
        }];
        _orderNoL.font = PZFont(13);
        _orderNoL.textColor = HBColor(153, 153, 153);
        _orderNoL.text = @"订单号：201509220970693";
        
        _comNameL = [[UILabel alloc] init];
        [self addSubview:_comNameL];
        [_comNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_orderNoL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_orderNoL);
        }];
        _comNameL.font = PZFont(13);
        _comNameL.textColor = HBColor(153, 153, 153);
        _comNameL.text = @"商品：Apple苹果iPhone7（A1600）128G 黑色";
        
        _stockNoL = [[UILabel alloc] init];
        [self addSubview:_stockNoL];
        [_stockNoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_comNameL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_comNameL);
        }];
        _stockNoL.font = PZFont(13);
        _stockNoL.textColor = HBColor(153, 153, 153);
        _stockNoL.text = @"期数：20160627001";
        
        _inCountL = [[UILabel alloc] init];
        [self addSubview:_inCountL];
        [_inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_stockNoL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_stockNoL);
        }];
        _inCountL.font = PZFont(13);
        _inCountL.textColor = HBColor(153, 153, 153);
        _inCountL.text = @"参与分数：3";
        
        _inNosL = [[UILabel alloc] init];
        [self addSubview:_inNosL];
        [_inNosL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_stockNoL);
        }];
        _inNosL.font = PZFont(13);
        _inNosL.textColor = HBColor(153, 153, 153);
        _inNosL.text = @"夺宝号码：";
        
        _allInNos = [[UIButton alloc] init];
        [self addSubview:_allInNos];
        [_allInNos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_inNosL);
            make.right.mas_equalTo(self);
            make.width.mas_equalTo(60);
        }];
        _allInNos.backgroundColor = [UIColor whiteColor];
        _allInNos.titleLabel.font = PZFont(12.5);
        [_allInNos setTitleColor:BasicBlueColor forState:UIControlStateNormal];
        [_allInNos setTitle:@"查看全部" forState:UIControlStateNormal];
        _allInNos.hidden = YES;
        [[_allInNos rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.buttonBlock) {
                self.buttonBlock(_allInNos);
            }
        }];
        
        UILabel *inPriceL = [[UILabel alloc] init];
        [self addSubview:inPriceL];
        [inPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inNosL.mas_bottom).offset(8);
            make.left.height.mas_equalTo(_inCountL);
        }];
        inPriceL.font = PZFont(13);
        inPriceL.textColor = HBColor(153, 153, 153);
        inPriceL.text = @"金额：";
        
        _inPriceBtn = [[JNQXTButton alloc] init];
        [self addSubview:_inPriceBtn];
        [_inPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inNosL.mas_bottom).offset(8);
            make.left.mas_equalTo(inPriceL.mas_right);
            make.height.mas_equalTo(inPriceL);
        }];
        _inPriceBtn.titleLabel.font = PZFont(13);
        [_inPriceBtn setTitleColor:HBColor(153, 153, 153) forState:UIControlStateNormal];
        
        _createTimeL = [[UILabel alloc] init];
        [self addSubview:_createTimeL];
        [_createTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inPriceBtn.mas_bottom).offset(8);
            make.left.height.mas_equalTo(inPriceL);
        }];
        _createTimeL.font = PZFont(13);
        _createTimeL.textColor = HBColor(153, 153, 153);
    }
    return self;
}

- (void)setDetaliProductM:(FBProductModel *)detaliProductM {
    _detaliProductM = detaliProductM;
    _orderNoL.text = [NSString stringWithFormat:@"订单号：%ld", detaliProductM.fbOrderId];
    _comNameL.text = [NSString stringWithFormat:@"商品：%@", detaliProductM.productName];
    _stockNoL.text = [NSString stringWithFormat:@"期数：%ld", detaliProductM.stage];
    [_inPriceBtn setTitle:[NSString stringWithFormat:@" %ld", detaliProductM.price] forState:UIControlStateNormal];
    _inCountL.text = [NSString stringWithFormat:@"参与份数：%d", detaliProductM.purchaseGameCount];
    for (FBBidRecordModel *model in detaliProductM.bidRecords) {
        _inNosL.text = [_inNosL.text stringByAppendingString:[NSString stringWithFormat:@"%ld ", model.purchaseCode]];
        NSLog(@"%ld", model.purchaseCode);
    }
    
    NSDictionary *nameAttribute = @{NSFontAttributeName:PZFont(13)};
    CGRect rect = [_inNosL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:nameAttribute context:nil];
    CGFloat inNoWidth = CGRectGetWidth(rect)>SCREENWidth-72 ? SCREENWidth-72 : CGRectGetWidth(rect);
    [_inNosL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(inNoWidth);
    }];
    _allInNos.hidden = CGRectGetWidth(rect)>SCREENWidth-72 ? NO : YES;
    _createTimeL.text = [NSString stringWithFormat:@"时间：%@", detaliProductM.createTime];
}

@end


@implementation JNQFBCompleteHeaderView {
    JNQFBCompleteSuccessView *_successV;
    JNQFBCompleteDetailView *_detailV;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        WEAKSELF
        _successV = [[JNQFBCompleteSuccessView alloc] init];
        [self addSubview:_successV];
        [_successV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(self);
            make.height.mas_equalTo(105);
        }];
        
        _detailV = [[JNQFBCompleteDetailView alloc] init];
        [self addSubview:_detailV];
        [_detailV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_successV.mas_bottom).offset(15);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(179.5);
        }];
        _detailV.buttonBlock = ^(UIButton *button) {
            if (weakSelf.buttonBlock) {
                weakSelf.buttonBlock(button);
            }
        };
    }
    return self;
}

- (void)setProductM:(FBProductModel *)productM {
    _productM = productM;
    _detailV.detaliProductM = productM;
}

@end

@implementation JNQFBCompleteFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _fbContinueBtn = [[UIButton alloc] init];
        [self addSubview:_fbContinueBtn];
        [_fbContinueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-20, 40));
        }];
        _fbContinueBtn.backgroundColor = BasicBlueColor;
        _fbContinueBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_fbContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fbContinueBtn setTitle:@"继续夺宝" forState:UIControlStateNormal];
    }
    return self;
}

@end
