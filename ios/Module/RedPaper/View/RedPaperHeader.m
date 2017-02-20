//
//  RedPaperHeader.m
//  Puzzle
//
//  Created by huibei on 17/1/11.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RedPaperHeader.h"
#import "UIButton+EdgeInsets.h"
#import "RedPaperInputCell.h"

@interface RedPaperHeader()
{
    CGFloat _amount ;
    CGFloat _amountNormal ;
    CGFloat _amountFortune ;
    NSInteger _count;
    NSString* _bonusType ;
    UITextField *_descField;
    
    BOOL _normalRedPaper ;
}
@end

@implementation RedPaperHeader
-(instancetype)initWithSingle:(BOOL)single count:(NSInteger)count{
    if (self = [super init]) {
        if (single) {
            [self creatSingle];
        }
        else{
            [self createMutil:count];
        }
    }
    return self ;
}

-(void)creatSingle{
    WEAKSELF
    //总金额
    RedPaperInputCell* cellAmount = [[RedPaperInputCell alloc]initWithTitle:@"金额" unitStr:@"喜腾币" placeHolder:@"填写金额"];
    [self addSubview:cellAmount];
    [cellAmount mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(50);
    }];

    //恭喜发财 大吉大利
    UIImageView* bgDescView = [[UIImageView alloc]init];
    bgDescView.backgroundColor = [UIColor whiteColor];
    bgDescView.userInteractionEnabled = YES ;
    bgDescView.layer.masksToBounds = YES ;
    bgDescView.layer.cornerRadius = 4 ;
    [self addSubview:bgDescView];
    [bgDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellAmount.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(60);
    }];
    UITextField* descField = [[UITextField alloc]init];
    descField.placeholder = @"恭喜发财，大吉大利" ;
    descField.font  = PZFont(13);
    [bgDescView addSubview:descField];
    [descField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgDescView.mas_centerY);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    _descField = descField;
    
    
    UIButton* btnAmount = [UIButton new];
    [btnAmount setTitle:@"0.00" forState:UIControlStateNormal];
    [btnAmount setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
    btnAmount.titleLabel.font= PZFont(36.0f);
    [btnAmount setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnAmount sizeToFit];
    [self addSubview:btnAmount];
    [btnAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgDescView.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [btnAmount layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:4 imageWidth:18];
    [cellAmount.textSignal subscribeNext:^(NSString* valueStr) {
        CGFloat amount = [valueStr floatValue];
        _amount = amount ;
        [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",amount] forState:UIControlStateNormal];
    }];
    UIButton* btnConfirm = [UIButton new];
    btnConfirm.layer.masksToBounds = YES ;
    btnConfirm.layer.cornerRadius = 6 ;
    [btnConfirm setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.7968 green:0.2186 blue:0.204 alpha:1.0]] forState:UIControlStateNormal];
    btnConfirm.titleLabel.font= PZFont(14.0f);
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:btnConfirm];
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnAmount.mas_bottom).offset(10);
        make.height.mas_equalTo(36);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [[btnConfirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //验证  红包个数
        NSString* descInfo = descField.text ;
        if (descInfo == nil || descInfo.length == 0) {
            descInfo = @"恭喜发财，大吉大利！" ;
        }
        if (_amount<0.01) {
            [MBProgressHUD showInfoWithStatus:@"请输入红包总金额"];
            return ;
        }
        if (weakSelf.sendRedPaperBlock) {
            weakSelf.sendRedPaperBlock(1,_amount,_amount,@"average",descInfo,@"single");
        }
    }];
}



-(void)createMutil:(NSInteger)count{
    _normalRedPaper = NO ;
    _bonusType = @"random";
    WEAKSELF
    //红包个数
    RedPaperInputCell* cellCount = [[RedPaperInputCell alloc]initWithTitle:@"红包个数" unitStr:@"个" placeHolder:@"填写个数"];
    [self addSubview:cellCount];
    [cellCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UILabel* descCount = [[UILabel alloc]init];
    if (count >0) {
        descCount.text = [NSString stringWithFormat:@"本群共%ld人",(long)count] ;
    }
    descCount.font = PZFont(12.0f);
    descCount.textColor = [UIColor darkGrayColor];
    [self addSubview:descCount];
    [descCount sizeToFit];
    [descCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellCount.mas_bottom);
        make.left.mas_equalTo(15);
    }];
    
    
    UIScrollView* scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO ;
    scrollView.scrollEnabled = NO ;
    scrollView.contentSize = CGSizeMake(SCREENWidth*2, 50);
    scrollView.pagingEnabled = YES ;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellCount.mas_bottom).offset(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    //总金额
    RedPaperInputCell* cellFortuneAmount = [[RedPaperInputCell alloc]initWithTitle:@"金额" unitStr:@"喜腾币" placeHolder:@"填写金额"];
    [scrollView addSubview:cellFortuneAmount];
    [cellFortuneAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREENWidth);
    }];

    RedPaperInputCell* cellNormalAmount = [[RedPaperInputCell alloc]initWithTitle:@"单个金额" unitStr:@"喜腾币" placeHolder:@"填写金额"];
    [scrollView addSubview:cellNormalAmount];
    [cellNormalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(SCREENWidth);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREENWidth);
    }];
    
    UILabel* descType = [[UILabel alloc]init];
    descType.text = @"当前为拼手气红包" ;
    descType.font = PZFont(12.0f);
    descType.textColor = [UIColor darkGrayColor];
    [self addSubview:descType];
    [descType sizeToFit];
    [descType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView.mas_bottom).offset(4);
        make.left.mas_equalTo(15);
    }];
    
    UIButton* btnToggle = [UIButton new];
    btnToggle.titleLabel.font = PZFont(12);
    [btnToggle setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnToggle setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btnToggle setTitle:@"改为普通红包" forState:UIControlStateNormal];
    [btnToggle setTitle:@"改为拼手气红包" forState:UIControlStateSelected];
    [self addSubview:btnToggle];
    [btnToggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descType.mas_right).offset(6);
        make.centerY.mas_equalTo(descType.mas_centerY);
    }];
    
    //恭喜发财 大吉大利
    UIImageView* bgDescView = [[UIImageView alloc]init];
    bgDescView.backgroundColor = [UIColor whiteColor];
    bgDescView.userInteractionEnabled = YES ;
    bgDescView.layer.masksToBounds = YES ;
    bgDescView.layer.cornerRadius = 4 ;
    [self addSubview:bgDescView];
    [bgDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(60);
    }];
    UITextField* descField = [[UITextField alloc]init];
    descField.placeholder = @"恭喜发财，大吉大利" ;
    descField.font  = PZFont(13);
    [bgDescView addSubview:descField];
    [descField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgDescView.mas_centerY);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    

    UIButton* btnAmount = [UIButton new];
    [btnAmount setTitle:@"0.00" forState:UIControlStateNormal];
    [btnAmount setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
    btnAmount.titleLabel.font= PZFont(36.0f);
    [btnAmount setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnAmount sizeToFit];
    [self addSubview:btnAmount];
    [btnAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgDescView.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [btnAmount layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:4 imageWidth:18];
    
    UIButton* btnConfirm = [UIButton new];
    btnConfirm.layer.masksToBounds = YES ;
    btnConfirm.layer.cornerRadius = 6 ;
    [btnConfirm setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.7968 green:0.2186 blue:0.204 alpha:1.0]] forState:UIControlStateNormal];
    btnConfirm.titleLabel.font= PZFont(14.0f);
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:btnConfirm];
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnAmount.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    _descField = descField;
    

    [[btnToggle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
        sender.selected = !sender.selected ;
        if (sender.selected) {
            scrollView.contentOffset = CGPointMake(SCREENWidth, 0);
            _bonusType = @"average";
            descType.text = @"当前为普通红包" ;
            _normalRedPaper = YES ;
            [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",_amountNormal*_count] forState:UIControlStateNormal];
        }
        else{
            scrollView.contentOffset = CGPointMake(0, 0);
            _bonusType = @"random";
            descType.text = @"当前为拼手气红包" ;
            _normalRedPaper = NO;
            [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",_amountFortune] forState:UIControlStateNormal];
        }
    }];
    
    [[btnConfirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _amount = _normalRedPaper ? _amountNormal : _amountFortune ;
        //验证  红包个数
        NSString* descInfo = descField.text ;
        if (descInfo == nil || descInfo.length==0) {
            descInfo = descField.placeholder ;
        }
        if (_count<0.01) {
            [MBProgressHUD showInfoWithStatus:@"请输入红包个数"];
            return ;
        }
        if (_amount<0.01) {
            [MBProgressHUD showInfoWithStatus:@"请输入红包总金额"];
            return ;
        }
        if ([_bonusType isEqualToString:@"random"]) {
            if (_amount < _count) {
                [MBProgressHUD showInfoWithStatus:@"人均不足1喜腾币，你在逗我吗"];
                return;
            }
        }
        if (weakSelf.sendRedPaperBlock) {
            weakSelf.sendRedPaperBlock(_count,_amount,_amount,_bonusType,descInfo,@"group");
        }
    }];
    
    //获取数据
    [cellCount.textSignal subscribeNext:^(NSString* valueStr) {
        CGFloat count = [valueStr floatValue];
        _count = count ;
        if (_normalRedPaper) {
            [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",_amount*_count] forState:UIControlStateNormal];
        }
    }];
    
    [cellNormalAmount.textSignal subscribeNext:^(NSString* valueStr) {
        CGFloat amount = [valueStr floatValue];
        _amountNormal = amount ;
        if (_normalRedPaper) {
            [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",amount*_count] forState:UIControlStateNormal];
        }
        else{
            [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",amount] forState:UIControlStateNormal];
        }
    }];
    [cellFortuneAmount.textSignal subscribeNext:^(NSString* valueStr) {
        CGFloat amount = [valueStr floatValue];
        _amountFortune = amount ;
        [btnAmount setTitle:[NSString stringWithFormat:@"%.2f",amount] forState:UIControlStateNormal];
    }];
}
- (void)setVc:(id<UITextFieldDelegate>)vc {
    _vc = vc;
    _descField.delegate = vc;
}
@end
