//
//  RRFRebateView.m
//  Puzzle
//
//  Created by huipay on 2016/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRebateView.h"
#import "RRFRebateDetailInfoModel.h"
#import "RRFRebateModel.h"
@interface RRFRebateCellView : UIView
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *subTitleLabel;
@end
@implementation RRFRebateCellView
-(instancetype)init{
    if (self = [super init]) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        [subTitleLabel sizeToFit];
        self.subTitleLabel = subTitleLabel;
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
    }
    return self;
}
@end
@interface RRFRebateView ()
@property(nonatomic,weak)RRFRebateCellView *joinPorfitCell;
@property(nonatomic,weak)RRFRebateCellView *joinOneCell;
@property(nonatomic,weak)RRFRebateCellView *joinTowCell;

@property(nonatomic,weak)RRFRebateCellView *titleCell;
@property(nonatomic,weak)RRFRebateCellView *mineCell;
@property(nonatomic,weak)RRFRebateCellView *oneCell;
@property(nonatomic,weak)RRFRebateCellView *twoCell;
@property(nonatomic,weak)RRFRebateCellView *threeCell;
@property(nonatomic,weak)RRFRebateCellView *infoCell;


@end
@implementation RRFRebateView
-(instancetype)init
{
    if (self = [super init]) {
        
        
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        RRFRebateCellView *joinPorfitCell = [[RRFRebateCellView alloc]init];
        joinPorfitCell.backgroundColor = [UIColor whiteColor];
        joinPorfitCell.titleLabel.text = @"加盟费返利";
        joinPorfitCell.subTitleLabel.textColor = [UIColor redColor];
        self.joinPorfitCell = joinPorfitCell;
        [self addSubview:joinPorfitCell];
        [joinPorfitCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(12);

        }];
        
        RRFRebateCellView *joinOneCell = [[RRFRebateCellView alloc]init];
        
        joinOneCell.backgroundColor = [UIColor whiteColor];
        self.joinOneCell = joinOneCell;
        [self addSubview:joinOneCell];
        [joinOneCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(joinPorfitCell.mas_bottom).offset(1);
        }];
        
        RRFRebateCellView *joinTowCell = [[RRFRebateCellView alloc]init];
        joinTowCell.backgroundColor = [UIColor whiteColor];
        self.joinTowCell = joinTowCell;
        [self addSubview:joinTowCell];
        [joinTowCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(joinOneCell.mas_bottom).offset(1);
        }];

        RRFRebateCellView *titleCell = [[RRFRebateCellView alloc]init];
        titleCell.backgroundColor = [UIColor whiteColor];
        titleCell.titleLabel.text = @"购买钻石返利";
        titleCell.subTitleLabel.textColor = [UIColor redColor];
        self.titleCell = titleCell;
        [self addSubview:titleCell];
        [titleCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(joinTowCell.mas_bottom).offset(12);
            make.height.mas_equalTo(44);
        }];
        
        RRFRebateCellView *mineCell = [[RRFRebateCellView alloc]init];
        mineCell.backgroundColor = [UIColor whiteColor];
        self.mineCell = mineCell;
        [self addSubview:mineCell];
        [mineCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(titleCell.mas_bottom).offset(1);
        }];
        
        RRFRebateCellView *oneCell = [[RRFRebateCellView alloc]init];
        oneCell.backgroundColor = [UIColor whiteColor];
        self.oneCell = oneCell;
        [self addSubview:oneCell];
        [oneCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(mineCell.mas_bottom).offset(1);
        }];
        
        
        
        RRFRebateCellView *twoCell = [[RRFRebateCellView alloc]init];
        twoCell.backgroundColor = [UIColor whiteColor];
        self.twoCell = twoCell;
        [self addSubview:twoCell];
        [twoCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(oneCell.mas_bottom).offset(1);
        }];
        
        
        RRFRebateCellView *threeCell = [[RRFRebateCellView alloc]init];
       
        threeCell.backgroundColor = [UIColor whiteColor];
        self.threeCell = threeCell;
        [self addSubview:threeCell];
        [threeCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(twoCell.mas_bottom).offset(1);
        }];
        
        RRFRebateCellView *infoCell = [[RRFRebateCellView alloc]init];
        infoCell.titleLabel.text = @"返利明细";
        infoCell.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.infoCell = infoCell;
        [self addSubview:infoCell];
        [infoCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(threeCell.mas_bottom).offset(1);
        }];
    }
    
    return self;
}
-(void)setModel:(RRFRebateDetailInfoModel *)model
{
    
    NSMutableAttributedString *oneDelegateStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一级代理(%@)",model.levelARate]];
    [oneDelegateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
    [oneDelegateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,oneDelegateStr.length- 4)];
    self.joinOneCell.titleLabel.attributedText = oneDelegateStr;
    
    NSMutableAttributedString *twoDelegateStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二级代理(%@)",model.levelBRate]];
    [twoDelegateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
    [twoDelegateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4, twoDelegateStr.length -4)];
    self.joinTowCell.titleLabel.attributedText = twoDelegateStr;
    
    NSMutableAttributedString *mineStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"我(%@)",model.rebateselfRate]];
    [mineStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
    [mineStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(1,mineStr.length - 1)];
    self.mineCell.titleLabel.attributedText = mineStr;
    
    
    NSMutableAttributedString *oneStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一级客户(%@)",model.levelARate]];
    [oneStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
    [oneStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,oneStr.length- 4)];
    self.oneCell.titleLabel.attributedText = oneStr;
    
    NSMutableAttributedString *twoStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二级客户(%@)",model.levelBRate]];
    [twoStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
    [twoStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4, twoStr.length -4)];
     self.twoCell.titleLabel.attributedText = twoStr;
    
    
    NSMutableAttributedString *threeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"三级客户(%@)",model.levelCRate]];
    [threeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
    [threeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4, threeStr.length - 4)];
    self.threeCell.titleLabel.attributedText = threeStr;
    
    self.titleCell.subTitleLabel.text = [NSString stringWithFormat:@"¥%.2f",model.rebateCount];
    self.titleCell.subTitleLabel.textColor = [UIColor redColor];
    
    self.mineCell.subTitleLabel.text = [NSString stringWithFormat:@"%.2f",model.rebateForMySelf];
    self.oneCell.subTitleLabel.text = [NSString stringWithFormat:@"%.2f",model.rebateForAConsumer];
    self.twoCell.subTitleLabel.text = [NSString stringWithFormat:@"%.2f",model.rebateForBConsumer];
    self.threeCell.subTitleLabel.text = [NSString stringWithFormat:@"%.2f",model.rebateForCConsumer];


}

@end
@interface RRFRebateSectionHeaderView ()
@property(nonatomic,weak)UIButton *titleBtn;
@property(nonatomic,weak)UILabel *subTitle;

@end
@implementation RRFRebateSectionHeaderView
-(instancetype)init
{
    if (self = [super init ]){
        self.backgroundColor = [UIColor whiteColor];
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [titleBtn setTitle:@"11月" forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"xique_btn_open"] forState:UIControlStateSelected];
        [titleBtn setImage:[UIImage imageNamed:@"xique_btn_stop"] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleBtn = titleBtn;
        [self addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(50);
        }];
        
        UILabel *subTitle = [[UILabel alloc]init];
        subTitle.textColor = [UIColor redColor];
        subTitle.font = [UIFont systemFontOfSize:13];
        subTitle.text = @"120.00";
        self.subTitle = subTitle;
        [self addSubview:subTitle];
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];

        
    }
    return self;
}
-(void)setModel:(RRFRebateMonthModel *)model
{
    self.titleBtn.selected = model.isOpen;
    [self.titleBtn setTitle:[NSString stringWithFormat:@"%@月",model.month] forState:UIControlStateNormal];
    self.subTitle.text = [NSString stringWithFormat:@"¥%.2f",model.rebateCount ];
}
@end
