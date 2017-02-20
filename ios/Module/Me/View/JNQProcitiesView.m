//
//  RRFSelectedAreaView.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQProcitiesView.h"

@implementation JNQProcitiesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWidth-100)/2, 10, 100, 20)];
        [self addSubview:attentionLabel];
        attentionLabel.text = @"所在区域";
        attentionLabel.textColor = HBColor(51, 51, 51);
        attentionLabel.textAlignment = NSTextAlignmentCenter;
        attentionLabel.font = PZFont(14);
        
        _quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth-44, 0, 44, 44)];
        [self addSubview:_quitBtn];
        [_quitBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        _quitBtn.tag = 66666;
        [_quitBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _proBtn = [[UIButton alloc]init];
        _proBtn.tag = 0;
        [_proBtn setTitle:@" 请选择 " forState:UIControlStateNormal];
        [_proBtn setTitleColor:[UIColor colorWithHexString:@"0988fe"] forState:UIControlStateSelected];
        [_proBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        _proBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_proBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_proBtn];
        [_proBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(attentionLabel.mas_bottom).offset(8);
        }];
        [[_proBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
        }];
        
        _cityBtn = [[UIButton alloc]init];
        _cityBtn.tag = 1;
        _cityBtn.hidden = YES;
        [_cityBtn setTitle:@" 请选择 " forState:UIControlStateNormal];
        [_cityBtn setTitleColor:[UIColor colorWithHexString:@"0988fe"] forState:UIControlStateSelected];
        [_cityBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cityBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cityBtn];
        [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_proBtn.mas_right).offset(8);
            make.centerY.mas_equalTo(_proBtn.mas_centerY);
        }];
        
        _areaBtn = [[UIButton alloc]init];
        _areaBtn.tag = 2;
        _areaBtn.hidden = YES;
        [_areaBtn setTitle:@" 请选择 " forState:UIControlStateNormal];
        [_areaBtn setTitleColor:[UIColor colorWithHexString:@"0988fe"] forState:UIControlStateSelected];
        [_areaBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        _areaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_areaBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_areaBtn];
        [_areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_cityBtn.mas_right).offset(8);
            make.centerY.mas_equalTo(_cityBtn.mas_centerY);
        }];
        
        
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 62, SCREENWidth, 0.9)];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepLine];
        
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  62.9, SCREENWidth, SCREENHeight/2 - 46)];
        _backScrollView.pagingEnabled = YES;
        _backScrollView.bounces = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backScrollView];
        _backScrollView.scrollEnabled = NO;
        _backScrollView.contentSize = CGSizeMake(SCREENWidth*3, 0);
        
        _proTv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight/2 -  62.9)];
        [_backScrollView addSubview:_proTv];
        _proTv.backgroundColor = HBColor(245, 245, 245);
        _proTv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _proTv.tag = 0;

        _cityTv = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWidth, 0, SCREENWidth, SCREENHeight/2 -  62.9)];
        [_backScrollView addSubview:_cityTv];
        _cityTv.backgroundColor = HBColor(245, 245, 245);
        _cityTv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTv.tag = 1;
        
        _areaTv = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWidth*2, 0, SCREENWidth, SCREENHeight/2 -  62.9)];
        [_backScrollView addSubview:_areaTv];
        _areaTv.backgroundColor = HBColor(245, 245, 245);
        _areaTv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _areaTv.tag = 2;
 
        _glideView = [[UIView alloc]initWithFrame:CGRectMake(7,  62, 58, 0.9)];
        _glideView.backgroundColor = BasicBlueColor;
        [self addSubview:_glideView];
    }
    return self;
}

- (void)btnsClick:(UIButton *)btn {
    if (self.selectBlock) {
        self.selectBlock(btn);
    }
}
- (void)setVc:(id<UITableViewDelegate,UITableViewDataSource>)vc {
    _vc = vc;
    _proTv.delegate = _vc;
    _proTv.dataSource = _vc;
    
    _cityTv.delegate = _vc;
    _cityTv.dataSource = _vc;
    
    _areaTv.delegate = _vc;
    _areaTv.dataSource = _vc;
    
}
@end
