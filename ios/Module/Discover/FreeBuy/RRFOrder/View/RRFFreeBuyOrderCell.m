//
//  RRFFreeBuyOrderCell.m
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderCell.h"
#import "RRFFreeBuyOrderModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeConvert.h"
#import "UIButton+WebCache.h"
@interface RRFFreeBuyOrderCell ()
@property(nonatomic,weak)UIButton *iconView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *lssueLabel;
@property(nonatomic,weak)UILabel *joinLabel;
@property(nonatomic,weak)UILabel *numLabel;
@property(nonatomic,weak)UIButton *seeAllBtn;
@property(nonatomic,weak)UIButton *luckIcon;
@property(nonatomic,weak)UIButton *operationBtn;
@end
@implementation RRFFreeBuyOrderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *iconView = [[UIButton alloc]init];
        iconView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        iconView.layer.borderWidth = 0.5;
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 3;
        iconView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        [[iconView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.productBtnBlock) {
                self.productBtnBlock();
            }
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"苹果7plus";
        titleLabel.numberOfLines = 1;
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(iconView.mas_top).offset(4);
        }];
        UIButton *luckIcon = [[UIButton alloc]init];
        [luckIcon setImage:[UIImage imageNamed:@"lable_weizhongjiang"] forState:UIControlStateNormal];
        [luckIcon setImage:[UIImage imageNamed:@"fortune"] forState:UIControlStateSelected];
        self.luckIcon = luckIcon;
        [self.contentView addSubview:luckIcon];
        [luckIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(-8);
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *lssueLabel = [[UILabel alloc]init];
        lssueLabel.text = @"期数:202932323";
        lssueLabel.textColor = [UIColor colorWithHexString:@"666666"];
        lssueLabel.font = [UIFont systemFontOfSize:12];
        self.lssueLabel = lssueLabel;
        [self.contentView addSubview:lssueLabel];
        [lssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel *joinLabel = [[UILabel alloc]init];
        joinLabel.text = @"参与分数:20";
        joinLabel.textColor = [UIColor colorWithHexString:@"666666"];
        joinLabel.font = [UIFont systemFontOfSize:12];
        self.joinLabel = joinLabel;
        [self.contentView addSubview:joinLabel];
        [joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(lssueLabel.mas_bottom).offset(4);
        }];
        
        UIButton *seeAllBtn = [[UIButton alloc]init];
        [seeAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [seeAllBtn setTitleColor:[UIColor colorWithHexString:@"6479e7"] forState:UIControlStateNormal];
        seeAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.seeAllBtn = seeAllBtn;
        [self.contentView addSubview:seeAllBtn];
        [seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(joinLabel.mas_bottom).offset(0);
        }];
        [[seeAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.FreeBuyOrderCellBlock) {
                self.FreeBuyOrderCellBlock(@(0));
            }
        }];
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.text = @"夺宝号码:2089989 9989898 009090 009090 009090 009090";
        numLabel.textColor = [UIColor colorWithHexString:@"666666"];
        numLabel.font = [UIFont systemFontOfSize:12];
        self.numLabel = numLabel;
        [self.contentView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(8);
            make.top.mas_equalTo(joinLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(-90);
        }];
        
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self.contentView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(4);
            make.right.mas_equalTo(-4);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(iconView.mas_bottom).offset(12);
        }];
        
        UIButton *operationBtn = [[UIButton alloc]init];
        operationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.operationBtn = operationBtn;
        [self.contentView addSubview:operationBtn];
        [operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(sep.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        [[operationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.FreeBuyOrderCellBlock) {
                self.FreeBuyOrderCellBlock(@(1));
            }
        }];
        
        UIView *sep1 = [[UIView alloc]init];
        sep1.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self.contentView addSubview:sep1];
        [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.top.mas_equalTo(operationBtn.mas_bottom).offset(10);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] forState:UIControlStateNormal placeholderImage:DefaultImage];
    self.titleLabel.text = model.productName;
    self.lssueLabel.text = [NSString stringWithFormat:@"期数：%ld",model.stage];
    NSMutableAttributedString *joinStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与份数：%ld",model.purchaseGameCount]];
    [joinStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
    [joinStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,joinStr.length - 5)];
    self.joinLabel.attributedText = joinStr;
    NSMutableString *recordsStr = [NSMutableString stringWithString:@"夺宝号码:"];
    NSArray *bidRecords = model.bidRecords;
    for (int i = 0; i<model.bidRecords.count; i++) {
        RRFBidRecordsModel *recordmodel = bidRecords[i];
        NSString *num = [NSString stringWithFormat:@"  %ld",recordmodel.purchaseCode];
        [recordsStr appendString:num];
    }
    self.numLabel.text = recordsStr;
    self.luckIcon.hidden = [model.bidOrderStatus hiddenLuck];
    self.luckIcon.selected = [model.bidOrderStatus isLuck];
    NSString *operationStr = [model.bidOrderStatus bidOrderStatusOperationBtnStr];
    if ([operationStr isEqualToString:@"等待揭晓"]) {
        [self.operationBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.operationBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.operationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }else{
        [self.operationBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateNormal];
        [self.operationBtn setBackgroundImage:[UIImage imageNamed:@"me_indent-duobao_btn_border"] forState:UIControlStateNormal];
        self.operationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

    }
    [self.operationBtn setTitle:operationStr forState:UIControlStateNormal];
    if(model.bidRecords.count >= 2){
        self.seeAllBtn.hidden = NO;
        [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-90);
        }];
    }else{
        self.seeAllBtn.hidden = YES;
        [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
        }];
    }
}
@end
