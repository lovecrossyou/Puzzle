//
//  RRFRemarkView.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRemarkView.h"
#import "RRFFreeBuyOrderModel.h"
#import "UIImageView+WebCache.h"
#import "RRFWiningOrderModel.h"
#import "RRFOrderListModel.h"
#import "RRFProductModel.h"

@interface RRFRemarkFootBarView ()
@property(nonatomic,assign)int isSelected;
@property(nonatomic,weak)UIButton *btn;
@end
@implementation RRFRemarkFootBarView
-(instancetype)init
{
    if(self = [super init]){
        self.isSelected = 1;
        self.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]init];
        btn.selected = YES;
        btn.userInteractionEnabled = YES;
        [btn setTitle:@" 同步财富圈动态" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_choose_d"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_choose_s"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn = btn;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        WEAKSELF
        UIButton *rightBtn = [[UIButton alloc]init];
        [rightBtn setTitle:@"发表评论" forState:UIControlStateNormal];
        [rightBtn setBackgroundColor:[UIColor colorWithHexString:@"4964ef"]];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(@(weakSelf.isSelected));
            }
        }];


    };
    return self;
}
-(void)setComeInType:(RRFShowOrderType)comeInType
{
    if (comeInType == RRFShowOrderTypeFreeBuy) {
        self.btn.hidden = NO;
    }else{
        self.btn.hidden = YES;
    }
}
-(void)btnClick:(UIButton *)sender
{
    BOOL selected = sender.selected;
    sender.selected = !selected;
    self.isSelected = sender.selected == YES?1:0;
}
@end

@interface RRFRemarkFootView ()
@property(nonatomic,weak)UILabel *titleInfoLabel;
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UIButton *lssueLabel;
@property(nonatomic,weak)UILabel *totalNumLabel;
@property(nonatomic,weak)UILabel *luckNumLabel;
@property(nonatomic,weak)UILabel *participateLabel;
@property(nonatomic,weak)UILabel *timeLabel;

@end
@implementation RRFRemarkFootView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
        
        UILabel *titleInfoLabel =[[ UILabel alloc]init];
        titleInfoLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleInfoLabel.font = [UIFont systemFontOfSize:15];
        self.titleInfoLabel = titleInfoLabel;
        [self addSubview:titleInfoLabel];
        [titleInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
        }];
        
        UIView *sepView1 = [[UIView alloc]init];
        sepView1.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView1];
        [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(titleInfoLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        iconView.layer.borderWidth = 0.5;
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 3;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.image = DefaultImage;
        self.iconView = iconView;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(sepView1.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(iconView.mas_top);
            make.right.mas_equalTo(-12);
        }];
        
        
        UIButton *lssueLabel = [[UIButton alloc]init];
        [lssueLabel setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        lssueLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        self.lssueLabel = lssueLabel;
        [self addSubview:lssueLabel];
        [lssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(4);
        }];
        
        UILabel *totalNumLabel = [[UILabel alloc]init];
        totalNumLabel.textColor = [UIColor colorWithHexString:@"666666"];
        totalNumLabel.font = [UIFont systemFontOfSize:14];
        self.totalNumLabel = totalNumLabel;
        [self addSubview:totalNumLabel];
        [totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(lssueLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *luckNumLabel = [[UILabel alloc]init];
        luckNumLabel.textColor = [UIColor colorWithHexString:@"666666"];
        luckNumLabel.font = [UIFont systemFontOfSize:14];
        self.luckNumLabel = luckNumLabel;
        [self addSubview:luckNumLabel];
        [luckNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(totalNumLabel.mas_bottom).offset(4);
        }];
        
        UILabel *participateLabel = [[UILabel alloc]init];
        participateLabel.textColor = [UIColor colorWithHexString:@"666666"];
        participateLabel.font = [UIFont systemFontOfSize:14];
        self.participateLabel = participateLabel;
        [self addSubview:participateLabel];
        [participateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(luckNumLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(participateLabel.mas_bottom).offset(4);
        }];
    }
    return self;
}
-(void)setListModel:(RRFOrderListModel *)listModel
{
    self.titleInfoLabel.text = @"礼品详情";
    RRFProductModel *productM = listModel.products.firstObject;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:productM.picUrl] placeholderImage:DefaultImage];
    self.titleLabel.text = productM.productName;
    [self.lssueLabel setTitle:[NSString stringWithFormat:@"%ld",productM.xtbPrice] forState:UIControlStateNormal];
    [self.lssueLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal] ;
    [self.lssueLabel setImage:[UIImage imageNamed:@"icon_maddle_red"] forState:UIControlStateNormal];
    self.totalNumLabel.text = @"";
    self.luckNumLabel.text = @"";
    self.participateLabel.text = @"";
    self.timeLabel.text = @"";

    
}
-(void)setWiningModel:(RRFWiningOrderModel *)winingModel
{
    self.titleInfoLabel.text = @"中奖详情";
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:winingModel.awardPicture] placeholderImage:DefaultImage];
    self.titleLabel.text = winingModel.awardName;
    [self.lssueLabel setTitle: [NSString stringWithFormat:@"开奖类型:%@",winingModel.awardType] forState:UIControlStateNormal];
    self.totalNumLabel.text = [NSString stringWithFormat:@"开奖时间:%@",winingModel.openResultTime];
    
    NSString *typeStr ;
    if ([winingModel.awardTypeName isEqualToString:@"week"]) {
        typeStr = @"本周收益";
    }else if([winingModel.awardTypeName isEqualToString:@"month"]){
        typeStr = @"本月收益";
    }else{
        typeStr = @"本年收益";
    }
    self.luckNumLabel.text = [NSString stringWithFormat:@"%@:%ld喜腾币",typeStr,winingModel.profit];
    self.participateLabel.text = @"";
    self.timeLabel.text = @"";
    
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    self.titleInfoLabel.text = @"夺宝详情";
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:DefaultImage];
    self.titleLabel.text = model.productName;
    [self.lssueLabel setTitle: [NSString stringWithFormat:@"期数:%ld",model.stage] forState:UIControlStateNormal];
    self.totalNumLabel.text = [NSString stringWithFormat:@"总需:%ld份",model.targetPurchaseCount];
    NSMutableAttributedString *luckNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"幸运号码:%ld",model.luckCode]];
    [luckNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
    [luckNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, luckNumStr.length-5)];

    self.luckNumLabel.attributedText =luckNumStr;
    
    NSMutableAttributedString *participateStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与份数:%ld",model.purchaseGameCount]];
    [participateStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
    [participateStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, participateStr.length-5)];
    self.participateLabel.attributedText = participateStr;
    self.timeLabel.text = [NSString stringWithFormat:@"参与时间:%@",model.createTime];
    
}
@end
@implementation RRFRemarkView



@end
