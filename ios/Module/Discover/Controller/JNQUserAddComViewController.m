//
//  JNQUserAddComViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQUserAddComViewController.h"
#import "JNQHttpTool.h"
#import "PZWeakTimer.h"

@interface JNQUserAddComViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *placeHolderL;
@property (nonatomic, strong) PZWeakTimer *m_timer;

@end

@implementation JNQUserAddComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNav];
    [self buildUI];
}

- (void)setNav {
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _rightBtn.titleLabel.font = PZFont(14);
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [[_rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_textView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIBarButtonItem *navRight = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = navRight;
}

- (void)buildUI {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    
    UIView *textBV = [[UIView alloc] init];
    [header addSubview:textBV];
    [textBV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(header);
        make.height.mas_equalTo(136);
    }];
    textBV.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc] init];
    [textBV addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textBV).offset(5);
        make.left.mas_equalTo(textBV).offset(8);
        make.width.mas_equalTo(SCREENWidth-16);
        make.height.mas_equalTo(126);
    }];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    
    _placeHolderL = [[UILabel alloc] init];
    [textBV addSubview:_placeHolderL];
    [_placeHolderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textBV).offset(10);
        make.left.mas_equalTo(textBV).offset(15);
        make.height.mas_equalTo(20);
    }];
    _placeHolderL.font = PZFont(13);
    _placeHolderL.textColor = HBColor(153, 153, 153);
    _placeHolderL.text = @"粘贴京东商品链接";
    
    _addBtn = [[UIButton alloc] init];
    [header addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(header);
        make.centerY.mas_equalTo(header).offset(-30);
        make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 40));
    }];
    _addBtn.backgroundColor = BasicBlueColor;
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.cornerRadius = 3;
    _addBtn.titleLabel.font = PZFont(15);
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [[_addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([_textView.text isEqualToString:@""]) {
            [MBProgressHUD showInfoWithStatus:@"输入不能为空"];
            return;
        }
        [_textView resignFirstResponder];
        [self addProductByUser];
    }];
    
    UILabel *atten = [[UILabel alloc] init];
    [header addSubview:atten];
    [atten mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(header).offset(-25);
        make.centerX.mas_equalTo(header);
        make.width.mas_equalTo(_addBtn);
    }];
    atten.font = PZFont(13);
    atten.textColor = HBColor(153, 153, 153);
    atten.textAlignment = NSTextAlignmentCenter;
    atten.numberOfLines = 2;
    atten.text = @"请从京东复制商品链接\n添加商品通过审核即可进行兑换";
    
    [self.tableView setTableHeaderView:header];
}

- (void)addProductByUser {
    WEAKSELF
    [MBProgressHUD show];
    NSString *url = _textView.text;
    [JNQHttpTool JNQHttpRequestWithURL:@"net/product/add" requestType:@"post" showSVProgressHUD:NO parameters:@{@"productLink" : url} successBlock:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"操作成功，已提交审核"];
        [weakSelf createTimer];
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

- (void)createTimer {
    self.m_timer = [PZWeakTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(returnBack) userInfo:nil repeats:NO dispatchQueue:dispatch_get_main_queue()];
}

- (void)returnBack {
    [self.m_timer invalidate];
    self.m_timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    _placeHolderL.hidden = text.length>0 ? YES : NO;
    return YES;
}

@end
