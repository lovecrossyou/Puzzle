//
//  RRFBuyFortuneController.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBuyFortuneController.h"
#import "JNQPayViewContoller.h"
#import "JNQConfirmOrderModel.h"
#import "RRFMyOrderView.h"
#import "FortuneTool.h"
#import "HBLoadingView.h"
#import "FortuneProductList.h"
#import "JNQHttpTool.h"
#import "UIButton+EdgeInsets.h"
#import "UIImageView+WebCache.h"

@interface RRFBuyFortuneHeaderView : UIView

@end

@implementation RRFBuyFortuneHeaderView
-(instancetype)initWithDay:(int)days{
    if (self = [super init]) {
        NSString* str = [NSString stringWithFormat:@"您的剩余测算时间 %d 天",days];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = PZFont(14.0f);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"member_icon_time"] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 70));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [btn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:12 imageWidth:18];
    }
    return self;
}
@end
@interface RRFBuyFortuneCell : UITableViewCell
{
    UILabel *nameLabel ;
    UILabel *timeLabel ;
    UILabel *priceLabel ;
}

@property(weak,nonatomic)UIImageView *iconView ;

@property (nonatomic, strong) ButtonBlock buttonBlock;
@end

@implementation RRFBuyFortuneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.layer.masksToBounds = YES ;
        iconView.layer.cornerRadius = 22 ;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.bottom.mas_equalTo(-24);
            make.top.mas_equalTo(24);
        }];
        self.iconView = iconView ;
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(18);
        }];
        
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor darkGrayColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(10);
            make.bottom.mas_equalTo(-18);
        }];
        
        UIButton *buyLabel = [[UIButton alloc]init];
        buyLabel.layer.masksToBounds = YES ;
        buyLabel.layer.cornerRadius = 2 ;
        [buyLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [buyLabel setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyLabel setBackgroundImage:[UIImage imageNamed:@"0yuan_home_btn_joinborder"] forState:UIControlStateNormal];
        buyLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:buyLabel];
        [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [[buyLabel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.buttonBlock) {
                self.buttonBlock(buyLabel);
            }
        }];
        
        priceLabel = [[UILabel alloc]init];
        priceLabel.textColor = StockRed;
        priceLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self.contentView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(buyLabel.mas_left).offset(-20);
        }];
    }
    return self;
}

-(void)configModel:(FortuneProduct*)model{
    nameLabel.text = model.name ;
    timeLabel.text = model.desc;
    priceLabel.text = [NSString stringWithFormat:@"%.0f颗钻",model.price/100];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"measure_icon_gossip"]];
}

@end
@interface RRFBuyFortuneController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSArray* list ;
@end

@implementation RRFBuyFortuneController

- (void)viewDidLoad {
    WEAKSELF
    [super viewDidLoad];
    [self.tableView registerClass:[RRFBuyFortuneCell class] forCellReuseIdentifier:@"RRFBuyFortuneController"];
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    RRFBuyFortuneHeaderView *headView = [[RRFBuyFortuneHeaderView alloc]initWithDay:self.remainDays];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 78);
    self.tableView.tableHeaderView = headView;
    [HBLoadingView showCircleView:self.view];
    [FortuneTool getFortuneListSuccessBlock:^(id json) {
        FortuneProductList* listM = [FortuneProductList yy_modelWithJSON:json];
        weakSelf.list = listM.fortuneList ;
        [weakSelf.tableView reloadData];
        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}

- (void)createTradeOrder:(FortuneProduct *)productM {
    [MBProgressHUD show];
    [JNQHttpTool payHautOrderWithFortuneProduct:productM successBlock:^(id json) {
        [MBProgressHUD dismiss];
        JNQConfirmOrderModel *confirmOrderM = [JNQConfirmOrderModel yy_modelWithJSON:json];
        confirmOrderM.desc = productM.name;
        confirmOrderM.iconstr = productM.image;
        JNQPayViewContoller *payVC = [[JNQPayViewContoller alloc] init];
        payVC.navigationItem.title = @"确认购买";
        payVC.confirmOrderModel = confirmOrderM;
        payVC.viewType = PayViewTypeHaul;
        [self.navigationController pushViewController:payVC animated:YES];
    } failureBlock:^(id json) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFBuyFortuneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFBuyFortuneController"];
    if (cell == nil) {
        cell = [[RRFBuyFortuneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFBuyFortuneController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    FortuneProduct* model  = self.list[indexPath.row];
    [cell configModel:model];
    cell.buttonBlock = ^(UIButton *button) {
        [weakSelf createTradeOrder:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self createTradeOrder:self.list[indexPath.row]];
}

@end
