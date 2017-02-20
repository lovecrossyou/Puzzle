//
//  JNQDiamondViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQDiamondViewController.h"
#import "JNQPayViewContoller.h"

#import "JNQOrderModel.h"
#import "JNQConfirmOrderModel.h"

#import "JNQHttpTool.h"

static NSString *titleArr[5] = {
    @"10",
    @"50",
    @"100",
    @"500",
    @"1000"
};


@interface JNQDiamondHeaderView : UIView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *payCountLabel;
@property (nonatomic, strong) UITextField *countInput;
@property (nonatomic, assign) NSInteger diamondCount;

@end

@implementation JNQDiamondHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        UILabel *atten = [[UILabel alloc] init];
        [self addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.mas_equalTo(self).offset(17);
            make.height.mas_equalTo(32);
        }];
        atten.font = PZFont(13);
        atten.textColor = HBColor(153, 153, 153);
        atten.text = @"购买满1000钻石送100喜腾币";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:atten.text];
        [string addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:[atten.text rangeOfString:@"送100"]];
        atten.attributedText = string;
        
        CGFloat width = (SCREENWidth-40)/3;
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten.mas_bottom);
            make.left.mas_equalTo(self).offset(4);
            make.right.mas_equalTo(self).offset(-4);
            make.height.mas_equalTo(width*2+10);
        }];
        for (int i = 0; i<6; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i%3+1)*8+(i%3)*width, i/3*(width+10), width, width)];
            [_backView addSubview:btn];
            btn.backgroundColor = [UIColor whiteColor];
            UIImage *img = i < 5 ? [UIImage imageNamed:@"jnq-diamonds_img"] : [UIImage imageNamed:@"jnq-diamonds_img_n"];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            btn.contentMode = UIViewContentModeScaleAspectFill;
            btn.tag = i;
            if (i<5) {
                [btn setTitle:[NSString stringWithFormat:@"%@颗", titleArr[i]] forState:UIControlStateNormal];
                [btn setTitleColor:BasicBlueColor forState:UIControlStateNormal];
                [btn setTitleColor:BasicRedColor forState:UIControlStateSelected];
                btn.titleLabel.font = PZFont(14.5);
                btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
                btn.layer.borderColor = [UIColor clearColor].CGColor;
                btn.layer.borderWidth = 0.5;
                [btn addTarget:self action:@selector(diamondBtnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.selected = btn.tag == 1 ? YES : NO;
                UIColor *boundColor = btn.tag == 1 ? BasicRedColor : [UIColor clearColor];
                btn.layer.borderColor = boundColor.CGColor;
                if (btn.tag == 4) {
                    UIButton *salesBtn = [[UIButton alloc] init];
                    [btn addSubview:salesBtn];
                    [salesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(22, 22));
                        make.top.mas_equalTo(btn);
                        make.right.mas_equalTo(btn).offset(-8);
                    }];
                    [salesBtn setImage:[UIImage imageNamed:@"icon_preferential"] forState:UIControlStateNormal];
                }
            } else {
                _countInput = [[UITextField alloc] init];
                [btn addSubview:_countInput];
                [_countInput mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.width.mas_equalTo(btn);
                    make.height.mas_equalTo(40);
                }];
                _countInput.textAlignment = NSTextAlignmentCenter;
                _countInput.textColor = BasicRedColor;
                _countInput.font = PZFont(14);
                _countInput.placeholder = @"自定义数额";
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"自定义数额"];
                [string addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:NSMakeRange(0, 5)];
                _countInput.attributedPlaceholder = string;
                _countInput.keyboardType = UIKeyboardTypeNumberPad;
                [_countInput addTarget:self action:@selector(countInputDidChanged:) forControlEvents:UIControlEventEditingDidBegin];
                [[_countInput rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
                    self.diamondCount = [_countInput.text integerValue];
                }];
            }
        }
        
        _payCountLabel = [[UILabel alloc] init];
        [self addSubview:_payCountLabel];
        [_payCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_backView.mas_bottom).offset(10);
            make.right.mas_equalTo(self).offset(-12);
            make.height.mas_equalTo(17);
        }];
        _payCountLabel.font = PZFont(15);
        _payCountLabel.textColor = HBColor(51, 51, 51);
        _payCountLabel.textAlignment = NSTextAlignmentRight;
        
        _payBtn = [[UIButton alloc] init];
        [self addSubview:_payBtn];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_backView.mas_bottom).offset(75);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-32, 40));
        }];
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = 2;
        _payBtn.backgroundColor = BasicBlueColor;
        [_payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = PZFont(15);
    }
    return self;
}

- (void)diamondBtnsDidClicked:(UIButton *)button {
    [_countInput resignFirstResponder];
    _countInput.text = @"";
    self.diamondCount = [titleArr[button.tag] integerValue];
    for (UIButton *btn in _backView.subviews) {
        UIColor *boundColor = btn.tag == button.tag ? BasicRedColor : [UIColor clearColor];
        btn.layer.borderColor = boundColor.CGColor;
        btn.selected = btn.tag == button.tag ? YES : NO;
    }
}

- (void)countInputDidChanged:(UITextField *)textField {
    for (UIButton *btn in _backView.subviews) {
        if (btn.tag != 6) {
            btn.selected = NO;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _diamondCount = diamondCount;
    _payCountLabel.text = [NSString stringWithFormat:@"金额：￥%.2f", (float)diamondCount];
    NSMutableAttributedString *payCountString = [[NSMutableAttributedString alloc] initWithString:_payCountLabel.text];
    [payCountString addAttribute:NSFontAttributeName value:PZFont(12) range:[_payCountLabel.text rangeOfString:@"￥"]];
    [payCountString addAttribute:NSFontAttributeName value:PZFont(12) range:NSMakeRange(_payCountLabel.text.length-2, 2)];
    _payCountLabel.attributedText = payCountString;
}

@end

@interface JNQDiamondViewController () <UITextFieldDelegate>

@property (nonatomic, strong) JNQDiamondHeaderView *headerView;
@property (nonatomic, strong) JNQOrderModel *orderModel;
@property (nonatomic, assign) NSInteger diamondCount;

@end

@implementation JNQDiamondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self buildUI];
}


- (void)buildUI {
    _headerView = [[JNQDiamondHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-60)];
    [self.tableView setTableHeaderView:_headerView];
    _headerView.countInput.delegate = self;
    _headerView.diamondCount = 50;
    [[_headerView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_headerView.countInput resignFirstResponder];
        if (_headerView.diamondCount > 100000 || _headerView.diamondCount < 1) {
            if (_headerView.diamondCount>100000) {
                [MBProgressHUD showInfoWithStatus:@"购买钻石数量最多不可超过100000！"];
            } else if (_headerView.diamondCount<1) {
                [MBProgressHUD showInfoWithStatus:@"购买钻石数量不可少于1！"];
            }
            return;
        }
        _diamondCount = _headerView.diamondCount;
        [self diamondPayWithCount:_diamondCount];
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 60)];
    UILabel *atten = [[UILabel alloc] init];
    [footerView addSubview:atten];
    [atten mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    atten.font = PZFont(13);
    atten.textColor = HBColor(51, 51, 51);
    atten.textAlignment = NSTextAlignmentCenter;
    atten.numberOfLines = 2;
    atten.text = @"购买钻石后自动兑换为喜腾币\n1钻石兑换12喜腾币";
    [self.tableView setTableFooterView:footerView];
}


- (void)diamondPayWithCount:(NSInteger)diamondCount {
    [MBProgressHUD show];
    [JNQHttpTool payOrderWithType:OrderTypeDiamond productId:0 totalParice:diamondCount successBlock:^(id json) {
        JNQConfirmOrderModel *model = [JNQConfirmOrderModel yy_modelWithJSON:json];
        JNQPayViewContoller *payVC = [[JNQPayViewContoller alloc] init];
        payVC.navigationItem.title = @"确认订单";
        payVC.confirmOrderModel = model;
        payVC.viewType = PayViewTypeDiamond;
        [MBProgressHUD dismiss];
        [self.navigationController pushViewController:payVC animated:YES];
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textString = [NSString stringWithFormat:@"%@%@",textField.text, string];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [textString dataUsingEncoding:enc];
    NSInteger count = [da length];
    return count>6 ? NO : YES;
}


@end
