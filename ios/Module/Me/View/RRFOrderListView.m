//
//  RRFOrderListHeadView.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderListView.h"
#import "RRFOrderListModel.h"
@implementation RRFOrderListSectionFooterView

-(instancetype)init
{
    if (self = [super init]) {
        UIView *contentView = [[UIView alloc]init];
        contentView.userInteractionEnabled = NO;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(0.8);
        }];
        
    
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"实付款:";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];
        
        UIButton *totalBtn = [[UIButton alloc]init];
        [totalBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [totalBtn setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        totalBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        totalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [totalBtn sizeToFit];
        self.totalBtn = totalBtn;
        [self addSubview:totalBtn];
        [totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(6);
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];
        
        UIButton *clickBtn = [[UIButton alloc]init];
        [clickBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateNormal];
        [clickBtn setBackgroundImage:[UIImage imageNamed:@"0yuan_home_btn_joinborder"] forState:UIControlStateNormal];
        [clickBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
        clickBtn.titleLabel.font = PZFont(14.0);
        [clickBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [clickBtn sizeToFit];
        self.clickBtn = clickBtn;
        [contentView addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 28));
            
        }];

    }
    return self;
}

@end
@implementation RRFOrderListSectionHeaderView
{
    UILabel *_timeLabel;
    UILabel *_stateLabel;
}
-(instancetype)init
{
    if (self = [super init]) {
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
        }];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_timeLabel sizeToFit];
        [contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];
        
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        [_stateLabel sizeToFit];
        [contentView addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(contentView.mas_centerY);
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [contentView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.8);
            make.left.mas_equalTo(12);
            
        }];
    }
    return self;
}
-(void)setModel:(RRFOrderListModel *)model
{
    if(model.tradeWay == 2){
        _timeLabel.text = [NSString stringWithFormat:@"下单时间:%@",model.createTime];
    }else if(model.tradeWay == 5){
        _timeLabel.text = [NSString stringWithFormat:@"领取时间:%@",model.createTime];
     }
    _stateLabel.text = model.status;
    
}
@end

@implementation RRFOrderListView


@end

