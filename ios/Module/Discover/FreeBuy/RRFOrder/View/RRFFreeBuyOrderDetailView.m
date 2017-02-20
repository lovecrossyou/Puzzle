//
//  RRFFreeBuyOrderDetailView.m
//  Puzzle
//
//  Created by huipay on 2016/12/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFreeBuyOrderDetailView.h"
#import "RRFFreeBuyOrderModel.h"
#import "UIImageView+WebCache.h"
@interface ProductInfoView:UIControl
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *lssueLabel;
@property(nonatomic,weak)UILabel *statusLabel;
@property(nonatomic,weak)UIButton *luckView;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;


@end
@implementation ProductInfoView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
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
            make.size.mas_equalTo(CGSizeMake(65, 65));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(6);
            make.top.mas_equalTo(iconView.mas_top).offset(4);
            make.right.mas_equalTo(-12);
        }];
        
        
        UILabel *lssueLabel = [[UILabel alloc]init];
        lssueLabel.textColor = [UIColor colorWithHexString:@"666666"];
        lssueLabel.font = [UIFont systemFontOfSize:14];
        self.lssueLabel = lssueLabel;
        [self addSubview:lssueLabel];
        [lssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(6);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(-12);
        }];
        
        UILabel *statusLabel = [[UILabel alloc]init];
        statusLabel.textColor = [UIColor colorWithHexString:@"666666"];
        statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel = statusLabel;
        [self addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(6);
            make.top.mas_equalTo(lssueLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(-12);
        }];
        
        
        UIButton *luckView = [[UIButton alloc]init];
        [luckView setImage:[UIImage imageNamed:@"lable_weizhongjiang"] forState:UIControlStateNormal];
        [luckView setImage:[UIImage imageNamed:@"fortune"] forState:UIControlStateSelected];
        self.luckView = luckView;
        [self addSubview:luckView];
        [luckView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(nameLabel.mas_bottom);
        }];
    }
    return self;
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = model.productName;
    self.lssueLabel.text = [NSString stringWithFormat:@"期数:%ld",model.stage];
    self.luckView.hidden = [model.bidOrderStatus hiddenLuck];
    self.luckView.selected = [model.bidOrderStatus isLuck];
    BOOL isWaiting = [model.bidOrderStatus isEqualToString:@"waiting"];
    self.statusLabel.textColor = isWaiting ?[UIColor redColor]:[UIColor colorWithHexString:@"777777"];
    self.statusLabel.text = isWaiting?@"等待揭晓":[NSString stringWithFormat:@"幸运号码:%ld",model.luckCode];
}
@end

@interface OrderDetailView:UIView
@property(nonatomic,weak)UILabel *orderNumberLabel;
@property(nonatomic,weak)UILabel *productNameLabel;
@property(nonatomic,weak)UILabel *lssueLabel;
@property(nonatomic,weak)UILabel *joinLabel;
@property(nonatomic,weak)UILabel *bidOrderNumberLabel;
@property(nonatomic,weak)UIButton *seeAllBtn;
@property(nonatomic,weak)UIButton *sumLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;

@end
@implementation OrderDetailView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

        UILabel *orderNumberLabel = [[UILabel alloc]init];
        orderNumberLabel.textColor = [UIColor colorWithHexString:@"666666"];
        orderNumberLabel.font = [UIFont systemFontOfSize:14];
        [orderNumberLabel sizeToFit];
        self.orderNumberLabel = orderNumberLabel;
        [self addSubview:orderNumberLabel];
        [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        
        UILabel *productNameLabel = [[UILabel alloc]init];
        productNameLabel.textColor = [UIColor colorWithHexString:@"666666"];
        productNameLabel.font = [UIFont systemFontOfSize:14];
        [productNameLabel sizeToFit];
        self.productNameLabel = productNameLabel;
        [self addSubview:productNameLabel];
        [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(orderNumberLabel.mas_bottom).offset(8);
        }];
        
        
        
        UILabel *lssueLabel = [[UILabel alloc]init];
        lssueLabel.textColor = [UIColor colorWithHexString:@"666666"];
        lssueLabel.font = [UIFont systemFontOfSize:14];
        [lssueLabel sizeToFit];
        self.lssueLabel = lssueLabel;
        [self addSubview:lssueLabel];
        [lssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(productNameLabel.mas_bottom).offset(8);
        }];
        
        
        
        UILabel *joinLabel = [[UILabel alloc]init];
        joinLabel.textColor = [UIColor colorWithHexString:@"666666"];
        joinLabel.font = [UIFont systemFontOfSize:14];
        [joinLabel sizeToFit];
        self.joinLabel = joinLabel;
        [self addSubview:joinLabel];
        [joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(lssueLabel.mas_bottom).offset(8);
        }];
        
        
        UILabel *bidOrderNumberLabel = [[UILabel alloc]init];
        bidOrderNumberLabel.textColor = [UIColor colorWithHexString:@"666666"];
        bidOrderNumberLabel.font = [UIFont systemFontOfSize:14];
        [bidOrderNumberLabel sizeToFit];
        self.bidOrderNumberLabel = bidOrderNumberLabel;
        [self addSubview:bidOrderNumberLabel];
        [bidOrderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(joinLabel.mas_bottom).offset(8);
        }];
        
        
        UIButton *seeAllBtn = [[UIButton alloc]init];
        [seeAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [seeAllBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        seeAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.seeAllBtn = seeAllBtn;
        [self addSubview:seeAllBtn];
        [seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.centerY.mas_equalTo(bidOrderNumberLabel.mas_centerY);
        }];
        
        UILabel *sumTitleLabel = [[UILabel alloc]init];
        sumTitleLabel.text = @"金额:";
        sumTitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        sumTitleLabel.font = [UIFont systemFontOfSize:14];
        [sumTitleLabel sizeToFit];
        [self addSubview:sumTitleLabel];
        [sumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(bidOrderNumberLabel.mas_bottom).offset(8);
        }];
        
        UIButton *sumLabel = [[UIButton alloc]init];
        sumLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [sumLabel setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [sumLabel setImage:[UIImage imageNamed:@"xitengbi"] forState:UIControlStateNormal];
        sumLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [sumLabel sizeToFit];
        self.sumLabel = sumLabel;
        [self addSubview:sumLabel];
        [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sumTitleLabel.mas_right).offset(3);
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(sumTitleLabel.mas_centerY);

        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(sumLabel.mas_bottom).offset(8);

        }];
        
    }
    return self;
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%ld",model.orderId];
    self.productNameLabel.text = [NSString stringWithFormat:@"商品:%@",model.productName];
    self.lssueLabel.text =[NSString stringWithFormat:@"期数：%ld",model.stage];
    self.joinLabel.text =[NSString stringWithFormat: @"参与份数：%ld",model.bidRecords.count];
    NSMutableString *numbersStr = [[NSMutableString alloc]initWithString:@"夺宝号码:"];
    for (RRFBidRecordsModel *recordsM in model.bidRecords) {
        [numbersStr appendFormat:@"  %ld",recordsM.purchaseCode];
    }
    self.bidOrderNumberLabel.text = numbersStr;
    if (model.bidRecords.count >= 2) {
        self.seeAllBtn.hidden = NO;
        [self.bidOrderNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-92);
        }];
    }else{
        self.seeAllBtn.hidden = YES;
        [self.bidOrderNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
        }];
    }
    [self.sumLabel setTitle:[NSString stringWithFormat:@"%.0f",model.price] forState:UIControlStateNormal];
    self.timeLabel.text = [NSString stringWithFormat:@"时间:%@",model.createTime];

}
@end

@interface OperationView:UIControl
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;

@property(nonatomic,weak)UIButton *operationBtn;
@end
@implementation OperationView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

        UIButton *operationBtn = [[UIButton alloc]init];
        operationBtn.userInteractionEnabled = NO;
        [operationBtn setBackgroundImage:[UIImage imageNamed:@"0yuan_home_btn_joinborder"] forState:UIControlStateNormal];
        [operationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        operationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.operationBtn = operationBtn;
        [self addSubview:operationBtn];
        [operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 32));
        }];
    }
    return self;
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    NSString *str = [model.bidOrderStatus bidOrderStatusOperationBtnStr];
    [self.operationBtn setTitle:str forState:UIControlStateNormal];
}
@end


@interface RRFFreeBuyOrderDetailView ()
@property(nonatomic,weak)ProductInfoView *productView;
@property(nonatomic,weak)OrderDetailView *orderView;
@property(nonatomic,weak)OperationView *operation;
@end
@implementation RRFFreeBuyOrderDetailView

-(instancetype)init{
    if (self = [super init]) {
        WEAKSELF
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        ProductInfoView *productView = [[ProductInfoView alloc]init];
        self.productView = productView;
        [self addSubview:productView];
        [productView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(90);
            make.top.mas_equalTo(12);
        }];
        [[productView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.productBtnBlock) {
                weakSelf.productBtnBlock();
            }
        }];
        
        
        OrderDetailView *orderView = [[OrderDetailView alloc]init];
        self.orderView = orderView;
        [self addSubview:orderView];
        [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(190);
            make.top.mas_equalTo(productView.mas_bottom).offset(12);
        }];
        [[orderView.seeAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.seeAllBlock) {
                weakSelf.seeAllBlock();
            }
        }];
        
        OperationView *operation = [[OperationView alloc]init];
        self.operation = operation;
        [self addSubview:operation];
        [operation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(orderView.mas_bottom).offset(1);
        }];
        [[operation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.operationBlock) {
                weakSelf.operationBlock();
            }
        }];
    }
    return self;
}
-(void)setModel:(RRFFreeBuyOrderModel *)model
{
    self.productView.model = model;
    self.orderView.model = model;
    self.operation.model = model;
    NSString *operationStr = [model.bidOrderStatus bidOrderStatusOperationBtnStr];
    if ([operationStr isEqualToString:@"等待揭晓"]) {
        self.operation.hidden = YES;
    }else{
        self.operation.hidden = NO;
    }
}
@end
