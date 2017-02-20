//
//  RRFReceiveView.m
//  Puzzle
//
//  Created by huipay on 2016/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFReceiveView.h"
#import "RRFFreeBuyOrderModel.h"
#import "UIImageView+WebCache.h"
#import "RRFWiningOrderModel.H"
@implementation RRFReceiveView



@end
@interface RRFPrizeInfoView :UIView
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UIImageView *luckIcon;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *lssueLabel;
@property(nonatomic,weak)UILabel *joinLabel;
@property(nonatomic,weak)UILabel *luckLabel;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@property(nonatomic,strong)RRFWiningOrderModel *winingM;

@end
@implementation RRFPrizeInfoView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"幸运奖品";
        titleLabel.textColor  =[UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(0);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        iconView.layer.borderWidth = 0.5;
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 3;
        iconView.image = DefaultImage;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView = iconView;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(sepView.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.numberOfLines = 2;
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(iconView.mas_top).offset(4);
            make.right.mas_equalTo(-12);
        }];
        
        UIImageView *luckIcon = [[UIImageView alloc]init];
        luckIcon.image = [UIImage imageNamed:@"fortune"];
        self.luckIcon = luckIcon;
        [self addSubview:luckIcon];
        [luckIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom);
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        
        UILabel *lssueLabel = [[UILabel alloc]init];
        lssueLabel.textColor = [UIColor colorWithHexString:@"666666"];
        lssueLabel.font = [UIFont systemFontOfSize:12];
        self.lssueLabel = lssueLabel;
        [self addSubview:lssueLabel];
        [lssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *joinLabel = [[UILabel alloc]init];
        joinLabel.textColor = [UIColor colorWithHexString:@"666666"];
        joinLabel.font = [UIFont systemFontOfSize:12];
        self.joinLabel = joinLabel;
        [self addSubview:joinLabel];
        [joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(lssueLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *luckLabel = [[UILabel alloc]init];
        luckLabel.textColor = [UIColor colorWithHexString:@"666666"];
        luckLabel.font = [UIFont systemFontOfSize:12];
        self.luckLabel = luckLabel;
        [self addSubview:luckLabel];
        [luckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(joinLabel.mas_bottom).offset(4);
        }];

        
    }
    return self;
}
-(void)setWiningM:(RRFWiningOrderModel *)winingM
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:winingM.awardPicture] placeholderImage:DefaultImage];
    self.nameLabel.text = winingM.awardName;
    self.lssueLabel.text = [NSString stringWithFormat:@"获奖类型:%@",winingM.awardType];
    self.joinLabel.text = [NSString stringWithFormat:@"开奖时间:%@",winingM.openResultTime ];
    NSString *typeStr ;
    if ([winingM.awardTypeName isEqualToString:@"week"]) {
        typeStr = @"本周收益";
    }else if([winingM.awardTypeName isEqualToString:@"month"]){
        typeStr = @"本月收益";
    }else{
        typeStr = @"本年收益";
    }
    self.luckLabel.text = [NSString stringWithFormat:@"%@:%ld",typeStr,winingM.profit];
}

-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = model.productName;
    self.lssueLabel.text = [NSString stringWithFormat:@"期数:%ld",model.stage];
    self.joinLabel.text = [NSString stringWithFormat:@"参与份数:%ld",model.bidRecords.count ];
    self.luckLabel.text = [NSString stringWithFormat:@"幸运号码:%ld",model.luckCode];
}
@end

@interface RRFReceiveFooterView ()
@property(nonatomic,weak)RRFPrizeInfoView *luckView;

@end
@implementation RRFReceiveFooterView

-(instancetype)init{
    if (self = [super init]) {
        
        RRFPrizeInfoView *luckView = [[RRFPrizeInfoView alloc]init];
        self.luckView = luckView;
        [self addSubview:luckView];
        [luckView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(150);
        }];
        
        UIButton *footBtn = [[UIButton alloc]init];
        [footBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"4964ef"]] forState:UIControlStateNormal];
        [footBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"999999"]] forState:UIControlStateDisabled];
        [footBtn setTitle:@"确认领奖" forState:UIControlStateNormal];
        [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.footBtn = footBtn;
        [self addSubview:footBtn];
        [footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, 44));
            make.top.mas_equalTo(luckView.mas_bottom).offset(30);
            make.left.mas_equalTo(12);
        }];
    }
    return self;
}
-(void)setWiningM:(RRFWiningOrderModel *)winingM
{
    self.luckView.winingM = winingM;
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    self.luckView.model = model;
}

@end
