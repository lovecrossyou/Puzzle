//
//  RRFShowOrderInfoView.m
//  Puzzle
//
//  Created by huipay on 2017/2/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFShowOrderInfoView.h"
#import "RRFFriendCircleModel.h"
#import "UIImageView+WebCache.h"
@interface RRFShowOrderInfoView ()
@property(nonatomic,weak)UIImageView *productIcon;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UIButton *titleLabel1;
@property(nonatomic,weak)UILabel *titleLabel2;
@property(nonatomic,weak)UIButton *titleLabel3;
@property(nonatomic,weak)UILabel *titleLabel4;
@property(nonatomic,weak)UIImageView *luckIcon;


@end
@implementation RRFShowOrderInfoView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UIImageView *productIcon = [[UIImageView alloc]init];
        productIcon.backgroundColor = [UIColor whiteColor];
        productIcon.contentMode = UIViewContentModeScaleAspectFit;
        productIcon.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
        productIcon.layer.borderWidth = 0.5;
        productIcon.layer.cornerRadius = 3;
        productIcon.layer.masksToBounds = YES;
        productIcon.image = DefaultImage;
        self.productIcon = productIcon;
        [self addSubview:productIcon];
        [productIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productIcon.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(productIcon.mas_top).offset(4);
        }];
        
        UIButton *titleLabel1 = [[UIButton alloc]init];
        titleLabel1.contentMode = UIViewContentModeLeft;
        [titleLabel1 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        titleLabel1.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel1 = titleLabel1;
        [self addSubview:titleLabel1];
        [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productIcon.mas_right).offset(10);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(2);
        }];
        
        UILabel *titleLabel2 = [[UILabel alloc]init];
        titleLabel2.textColor = [UIColor colorWithHexString:@"666666"];
        titleLabel2.font = [UIFont systemFontOfSize:12];
        self.titleLabel2 = titleLabel2;
        [self addSubview:titleLabel2];
        [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productIcon.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(titleLabel1.mas_bottom).offset(2);
        }];
        
        UIButton *titleLabel3 = [[UIButton alloc]init];
        titleLabel1.contentMode = UIViewContentModeLeft;
        [titleLabel3 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        titleLabel3.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel3 = titleLabel3;
        [self addSubview:titleLabel3];
        [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productIcon.mas_right).offset(10);
            make.top.mas_equalTo(titleLabel2.mas_bottom).offset(2);
        }];
        
        UILabel *titleLabel4 = [[UILabel alloc]init];
        titleLabel4.textColor = [UIColor colorWithHexString:@"666666"];
        titleLabel4.font = [UIFont systemFontOfSize:12];
        self.titleLabel4 = titleLabel4;
        [self addSubview:titleLabel4];
        [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productIcon.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(titleLabel3.mas_bottom).offset(4);
        }];
        
        UIImageView *luckIcon = [[UIImageView alloc]init];
        luckIcon.image = [UIImage imageNamed:@"fortune"];
        self.luckIcon = luckIcon;
        [self addSubview:luckIcon];
        [luckIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
    }
    return self;
}

-(void)setExchangeOrderModel:(ExchangeOrderListModel *)exchangeOrderModel
{
    NSArray *modelList = exchangeOrderModel.productList;
    ExchangeOrderModel *model = modelList.firstObject;
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = model.productName;
    [self.titleLabel1 setTitle:[NSString stringWithFormat:@"%ld",model.xtbAmount] forState:UIControlStateNormal];
    [self.titleLabel1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [self.titleLabel1 setImage:[UIImage imageNamed:@"icon_maddle_red"] forState:UIControlStateNormal];
    self.titleLabel2.text = @"";
    self.titleLabel4.text = @"";
    [self.titleLabel3 setTitle:@"" forState:UIControlStateNormal];
    self.luckIcon.hidden = YES;
}
-(void)setAwardOrderModel:(AwardOrderModel *)awardOrderModel
{
     [self.productIcon sd_setImageWithURL:[NSURL URLWithString:awardOrderModel.picUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = awardOrderModel.productName;
    [self.titleLabel1 setTitle:[NSString stringWithFormat:@"获奖类型 :%@",awardOrderModel.awardType] forState:UIControlStateNormal];
    self.titleLabel2.text = [NSString stringWithFormat:@"开奖时间:%@",awardOrderModel.openResultTime];
    NSString *type ;
    if ([awardOrderModel.awardTypeName isEqualToString:@"week"]) {
        type = @"本周收益";
    }else if ([awardOrderModel.awardTypeName isEqualToString:@"month"]){
        type = @"本月收益";
    }else if ([awardOrderModel.awardTypeName isEqualToString:@"year"]){
        type = @"本年收益";
    }
    [self.titleLabel3 setTitle:[NSString stringWithFormat:@"%@:%@喜腾币",type,awardOrderModel.bonusAmount] forState:UIControlStateNormal];
    self.titleLabel4.text = @"";
    self.luckIcon.hidden = NO;
    
}
-(void)setBidOrderModel:(BidOrderModel *)bidOrderModel
{
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:bidOrderModel.picUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = bidOrderModel.productName;
    [self.titleLabel1 setTitle:[NSString stringWithFormat:@"期 数 :%ld",bidOrderModel.stage] forState:UIControlStateNormal];
    self.titleLabel2.text = [NSString stringWithFormat:@"幸运号码:%@",bidOrderModel.luckCode];
    [self.titleLabel3 setTitle:[NSString stringWithFormat:@"参与份数:%ld",bidOrderModel.bidCount] forState:UIControlStateNormal];
    self.titleLabel4.text = [NSString stringWithFormat:@"揭晓时间:%@",bidOrderModel.openResultTime];
    self.luckIcon.hidden = NO;

}
@end
