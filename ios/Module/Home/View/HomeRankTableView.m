//
//  HomeRankTableView.m
//  Puzzle
//
//  Created by huipay on 2016/10/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeRankTableView.h"
#import "HomeRankModel.h"
#import "HomeRankCell.h"
#import "JNQHttpTool.h"
#import "HomeRankListModel.h"
#import "UIImageView+WebCache.h"
#import "JNQAwardModel.h"
#define kMargin 12
@interface HomeRankTableView()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSArray* rankDataList  ;
@property(assign,nonatomic) int rankType ;
@property(weak,nonatomic)UITableView* tableView ;

@property(strong,nonatomic)UIView* headerView ;
@property(strong,nonatomic)UIControl* footerView ;

@property(weak,nonatomic)UILabel* titleLabel ;
@property(weak,nonatomic)UIButton *yearBtn;
@property(weak,nonatomic)UIButton *monthlyBtn;
@property(weak,nonatomic)UIButton *weeklyBtn;


@property(weak,nonatomic)UIButton *selectedBtn;
@property(weak,nonatomic)UIImageView* prizeLogo ;



@end

@implementation HomeRankTableView


-(NSArray*)rankDataList{
    if (_rankDataList == nil) {
        _rankDataList = [NSArray array];
    }
    return _rankDataList ;
}

-(instancetype)init{
    if (self = [super init]) {
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self ;
        tableView.dataSource = self ;
        UIImageView* bgView = [[UIImageView alloc]init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"2e343e"];
//        bgView.image = [UIImage imageNamed:@"gushen_bg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        tableView.scrollEnabled = NO ;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        UIView* tableClearView = [[UIView alloc]init];
        tableClearView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = tableClearView ;
        tableView.backgroundColor = [UIColor clearColor];
        self.tableView = tableView ;
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.rankType = 3 ;
    }
    return self ;
}

-(UIView *)footerView{
    WEAKSELF
    if (_footerView == nil) {
        _footerView = [[UIControl alloc]init];
        _footerView.frame = CGRectMake(0, 0, SCREENWidth, 130);
        [[_footerView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.prizeBlock();
        }];
        UIImageView* prizeLogo = [[UIImageView alloc]init];
        prizeLogo.frame = CGRectMake(kMargin, 8, SCREENWidth - 2*kMargin, 130);
        self.prizeLogo = prizeLogo ;
        [_footerView addSubview:prizeLogo];
    }
    return _footerView ;
}

-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        _headerView.userInteractionEnabled = YES ;
        _headerView.frame = CGRectMake(0, 0, SCREENWidth,44+12);
        
        UIImageView* mainView = [[UIImageView alloc]init];
        mainView.userInteractionEnabled = YES ;
        mainView.frame = CGRectMake(0, 6, SCREENWidth, 44);
        [_headerView addSubview:mainView];
        
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = PZFont(16.0f);
        titleLabel.text = @"股神争霸" ;
        [titleLabel sizeToFit];
        [mainView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(2);
            make.height.mas_equalTo(32.0);
        }];
        self.titleLabel = titleLabel ;
        
        UIButton *weeklyBtn = [[UIButton alloc]init];
        [weeklyBtn setTitle:@"本周排行" forState:UIControlStateNormal];
        [weeklyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weeklyBtn setTitleColor:StockRed forState:UIControlStateSelected];
        weeklyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [weeklyBtn sizeToFit];
        self.weeklyBtn = weeklyBtn;
        [mainView addSubview:weeklyBtn];
        [weeklyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12-4);
            make.bottom.mas_equalTo(titleLabel.mas_bottom);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        WEAKSELF
        [[weeklyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            weakSelf.rankBlock(@(1));
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor =[ UIColor colorWithHexString:@"999999"];
        [mainView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weeklyBtn.mas_left).offset(-12);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(1, 10));
        }];
        
        UIButton *monthBtn = [[UIButton alloc]init];
        [monthBtn setTitle:@"本月排行" forState:UIControlStateNormal];
        [monthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [monthBtn setTitleColor:StockRed forState:UIControlStateSelected];
        monthBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [monthBtn sizeToFit];
        self.monthlyBtn = monthBtn;
        [mainView addSubview:monthBtn];
        [monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(sep.mas_left).offset(-8);
            make.bottom.mas_equalTo(titleLabel.mas_bottom);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        [[monthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            weakSelf.rankBlock(@(2));
        }];
        
        UIView *sep1 = [[UIView alloc]init];
        sep1.backgroundColor =[ UIColor colorWithHexString:@"999999"];
        [mainView addSubview:sep1];
        [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(monthBtn.mas_left).offset(-12);
            make.size.mas_equalTo(CGSizeMake(1, 10));
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        UIButton *yearBtn = [[UIButton alloc]init];
        [yearBtn setTitle:@"本年排行" forState:UIControlStateNormal];
        [yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [yearBtn setTitleColor:StockRed forState:UIControlStateSelected];
        yearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        yearBtn.selected = YES ;
        [yearBtn sizeToFit];
        self.yearBtn = yearBtn;
        [mainView addSubview:yearBtn];
        [yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(sep1.mas_left).offset(-8);
            make.bottom.mas_equalTo(titleLabel.mas_bottom);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        [[yearBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            weakSelf.rankBlock(@(3));
        }];
        UIImageView* sepLine = [[UIImageView alloc]init];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"4d525b"];
        sepLine.frame = CGRectMake(0, 44 -1, SCREENWidth, 1);
        [_headerView addSubview:sepLine];

    }
    return _headerView ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rankDataList.count ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectio{
    return self.headerView ;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        return self.footerView ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f + 12.0f ;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130.0f ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* currCellIdentifier = @"HomeRankCell";
    HomeRankModel* model = [self.rankDataList objectAtIndex:indexPath.row] ;
    HomeRankCell* cell = [tableView dequeueReusableCellWithIdentifier:currCellIdentifier];
    if (cell == nil) {
        cell = [[HomeRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeRankCell"];
    }
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f ;
}

-(void)refreshUI{
    if (self.footerView != nil) {
        [self requestRankListWithType:self.rankType];
        [self loadPrizeLogo];
    }
}


#pragma mark - 获取年/月排行
-(void)requestRankListWithType:(int)type{
    self.rankType = type ;
    WEAKSELF
    NSString* rankTypeString = @"currentWeek" ;
    if (type == 2) {
        rankTypeString = @"currentMonth" ;
    }
    else if (type == 3){
        rankTypeString = @"currentYear" ;
    }
    NSDictionary *param = @{
                            @"size"   : @(3),
                            @"pageNo" : @(0),
                            @"type"   : rankTypeString
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"rakingList" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        HomeRankListModel* rankListModel = [HomeRankListModel yy_modelWithJSON:json];
        NSArray* list = rankListModel.content ;
        weakSelf.rankDataList = list ;
        //修改底部图
        [weakSelf.tableView reloadData];
        [MBProgressHUD dismiss];
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

- (void)loadPrizeLogo {
    WEAKSELF
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString* urlStr = @"award/list";
    [param setObject:@(RankTypeCurrentYear-3) forKey:@"awardType"];
    [JNQHttpTool JNQHttpRequestWithURL:urlStr requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *data = json[@"awards"];
        if (data.count != 0) {
            NSDictionary* d = [data firstObject] ;
            JNQAwardModel *model = [JNQAwardModel yy_modelWithJSON:d];
            [weakSelf.prizeLogo sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"home_prize"] options:SDWebImageRefreshCached];
        }
        else{
            weakSelf.prizeLogo.image = [UIImage imageNamed:@"home_prize"] ;
        }
        [MBProgressHUD dismiss];
    } failureBlock:^(id json) {
        
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.rankBlock(@(3));
}
@end
