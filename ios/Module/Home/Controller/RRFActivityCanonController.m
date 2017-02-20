//
//  RRFActivityCanonController.m
//  Puzzle
//
//  Created by huibei on 16/9/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFActivityCanonController.h"
#import "RRFActivityCanonCell.h"
#import "PZCommonCellModel.h"
@interface RRFActivityCanonController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_allData;
}
@property(nonatomic,weak)UITableView *tabelView;
@end

@implementation RRFActivityCanonController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tabelView = tabelView;
    tabelView.dataSource = self;
    tabelView.delegate = self;
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tabelView registerClass:[RRFActivityCanonCell class] forCellReuseIdentifier:@"RRFActivityCanonController"];
    tabelView.tableFooterView = [[UIView alloc]init];
    tabelView.estimatedRowHeight = 120.0f;
    tabelView.rowHeight = UITableViewAutomaticDimension;
    tabelView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bettingrecord_bg"]];
    [self.view addSubview:tabelView];
    [tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];

    [self settingTableView];
}

-(void)settingTableView
{
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"" title:@"活动说明" subTitle:@"猜涨跌是以上证综指、创业板指涨跌方向为标的金融游戏。用户竞猜下一个交易日大盘的涨跌方向（休市日竞猜休市日后第一个交易日），猜对赢取相应喜腾币，喜腾币可兑换丰富礼品。" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"" title:@"竞猜规则" subTitle:@"1、T日9:00-T+1日9:00竞猜T+1日上证综指或创业板指涨跌方向（休市日竞猜休市日后第一个交易日);\n2、投注喜腾币即可参与猜涨跌游戏，竞猜最低投注数量为10喜腾币;\n3、T+1日9:00系统公布当期赔率，15:30根据收盘指数公布开奖结果。系统根据用户的投注方向、投注金额及赔率计算盈亏。\n例：赔率为0.8，即投注100赢80。" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    PZCommonCellModel *mode3 = [PZCommonCellModel cellModelWithIcon:@"" title:@"喜腾币" subTitle:@"平台仅限于使用游戏币-喜腾币进行投注，喜腾币的获取方式:\n1、注册及邀请朋友可获得喜腾币奖励\n2、升级会员可获赠喜腾币\n3、购买钻石，可用钻石兑换喜腾币" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    PZCommonCellModel *mode4 = [PZCommonCellModel cellModelWithIcon:@"" title:@"奖励说明" subTitle:@"用户可参与每周、每月收益排名，周排名前3名可获得大赛奖品，周排名每周五16:00公布当周获奖名单；月排名前5名可获得大赛奖品，每月排名当月最后一个交易日16:00公布当月获奖名单。" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    _allData = @[mode1,mode2,mode3,mode4];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PZCommonCellModel *model = _allData[indexPath.row];
    RRFActivityCanonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFActivityCanonController"];
    if (cell == nil) {
        cell = [[RRFActivityCanonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFActivityCanonController"];
    }
    cell.model = model;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"猜涨跌游戏规则说明";
    titleLabel.textColor = [UIColor colorWithHexString:@"ffba26"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.layer.cornerRadius =3;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithRed:98/255.0 green:116/255.0 blue:220/255.0 alpha:0.3];
    [footerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(0);

    }];
    
    UIView *sep = [[UIView alloc]init];
    sep.backgroundColor = [UIColor colorWithHexString:@"2d3460"];
    [footerView addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

   return  footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 56;
}
@end
