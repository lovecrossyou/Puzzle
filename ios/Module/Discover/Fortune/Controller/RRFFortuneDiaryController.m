//
//  RRFFortuneDiaryController.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFortuneDiaryController.h"
#import "FortuneStar.h"
#import "FortuneTool.h"
#import "FortuneModel.h"
#import "HBLoadingView.h"
#import "FortuneWebController.h"
#import "MJRefresh.h"

@interface RRFFortuneDiaryCell:UITableViewCell
{
    UILabel *timeLabel ;
    FortuneStar *star ;
    UILabel *scoresLabel ;

}
@end
@implementation RRFFortuneDiaryCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        timeLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        star = [[FortuneStar alloc]initWithStar:5];
        star.userInteractionEnabled = NO ;
        [star sizeToFit];
        [self.contentView addSubview:star];
        [star mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeLabel.mas_right).offset(55);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        scoresLabel = [[UILabel alloc]init];
        scoresLabel.textColor = [UIColor colorWithHexString:@"ff9e08"];
        scoresLabel.font = [UIFont systemFontOfSize:26];
        [self.contentView addSubview:scoresLabel];
        [scoresLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(star.mas_right).offset(16);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(void)configModel:(FortuneModel*)model{
    timeLabel.text = model.fortuneDay ;
    [star updateStar:model.point];
    scoresLabel.text = [NSString stringWithFormat:@"%d",model.point];
}


@end
@interface RRFFortuneDiaryController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSArray* models ;
@property(strong,nonatomic)FortuneListModel* list ;
@property(assign,nonatomic) int pageNo ;
@end

@implementation RRFFortuneDiaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[];
    [self.tableView registerClass:[RRFFortuneDiaryCell class] forCellReuseIdentifier:@"RRFFortuneDiaryController"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    [tabfooter beginRefreshing];
}

-(void)requestData{
    WEAKSELF
    NSMutableArray* tempDataSource = [NSMutableArray arrayWithArray:self.models];
    [FortuneTool getRecordListListWithPageNo:self.pageNo pageSize:10 successBlock:^(id json) {
        FortuneListModel* list = [FortuneListModel yy_modelWithJSON:json];
        weakSelf.list = list ;
        [tempDataSource addObjectsFromArray:list.content];
        weakSelf.models = tempDataSource ;
        [weakSelf.tableView.mj_footer endRefreshing];
        if (list.last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        [weakSelf.tableView reloadData];
        weakSelf.pageNo++;
        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFFortuneDiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFFortuneDiaryController"];
    if (cell == nil) {
        cell = [[RRFFortuneDiaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFFortuneDiaryController"];
    }
    FortuneModel* model = self.models[indexPath.row];
    [cell configModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f ;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f1f9"];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    timeLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.textColor = [UIColor colorWithHexString:@"999999"];
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.text = [NSString stringWithFormat:@"共测算%d次",self.list.totalElements];
    [headerView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FortuneModel* model = self.models[indexPath.row];
    FortuneWebController* web = [[FortuneWebController alloc]init];
    NSString* pathUrl = [NSString stringWithFormat:@"%@xitenggame/singleWrap/dailyHoroscope.html",Base_url];
    web.pathUrl =pathUrl;
    web.param = @{
                  @"id":@(model.ID)
                  };
    web.title = @"运势" ;
    web.share = YES ;
    [self.navigationController pushViewController:web animated:YES];
}

@end
