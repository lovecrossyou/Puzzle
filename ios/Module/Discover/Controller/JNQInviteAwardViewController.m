//
//  JNQInviteAwardViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQInviteAwardViewController.h"
#import "InviteFriendController.h"
#import "JNQInviteDetailViewController.h"

#import "InviteBonusesModel.h"

#import "JNQFailFooterView.h"
#import "JNQInviteAwardView.h"
#import "JNQInviteAwardCell.h"

#import "HomeTool.h"
#import "JNQHttpTool.h"

#import "MJRefresh.h"

@interface JNQInviteAwardBottomView : UIView

@property (nonatomic, strong) InviteBonusesModel *inviteModel;
@property (nonatomic, strong) UIButton *amountBtn;
@property (nonatomic, strong) UILabel *attenLabel;


@end

@implementation JNQInviteAwardBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor =  [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = HBColor(231, 231, 231);
        
        _amountBtn = [[UIButton alloc] init];
        [self addSubview:_amountBtn];
        [_amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-12);
        }];
        [_amountBtn setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_amountBtn setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _amountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _amountBtn.titleLabel.font = PZFont(15);
        
        _attenLabel = [[UILabel alloc] init];
        [self addSubview:_attenLabel];
        [_attenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.right.mas_equalTo(_amountBtn.mas_left);
        }];
        _attenLabel.font = PZFont(14);
        _attenLabel.textColor = HBColor(51, 51, 51);
        _attenLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setInviteModel:(InviteBonusesModel *)inviteModel {
    _inviteModel = inviteModel;
    [_amountBtn setTitle:[NSString stringWithFormat:@" +%d", inviteModel.inviteBonusCount] forState:UIControlStateNormal];
    _attenLabel.text = [NSString stringWithFormat:@"邀请%d人，合计奖励", inviteModel.selfInviteAmount];
}

@end


@interface JNQInviteAwardViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_dataArray;
    JNQInviteAwardHeadView *_headerView;
    int _pageNo;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) JNQInviteAwardBottomView *bottomView;
@property (nonatomic, strong) JNQFailFooterView *failFooterView;

@end

@implementation JNQInviteAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HBColor(245, 245, 245);
    WEAKSELF
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-45)];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = HBColor(245, 245, 245);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableview.mj_header = header;
    
    _bottomView = [[JNQInviteAwardBottomView alloc] init];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    _bottomView.hidden = YES;
    
    _failFooterView = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:_failFooterView];
    _failFooterView.reloadBlock = ^() {
        [weakSelf.tableview.mj_header beginRefreshing];
    };
    _failFooterView.hidden = YES;
    
    _dataArray = [NSMutableArray array];
    [self setNav];
    [self.tableview.mj_header beginRefreshing];
}

- (void)setNav {
    UIButton *navRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [navRight setTitle:@"+邀请" forState:UIControlStateNormal];
    [navRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRight.titleLabel.font = PZFont(13.5);
    navRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRight addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:navRight];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)requestData:(UIView *)sender {
    _pageNo = sender.tag == 10010 ? 0 : _pageNo;
    NSDictionary *param = @{
                           @"size" : @(10),
                           @"pageNo" : @(_pageNo)
                           };
    [JNQHttpTool JNQHttpRequestWithURL:@"inviteBonuses" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        _bottomView.hidden = NO;
        _failFooterView.hidden = YES;
        InviteBonusesModel* inviteBonuses = [InviteBonusesModel yy_modelWithJSON:json];
        _bottomView.inviteModel = inviteBonuses;
        if (_pageNo) {
            [_dataArray addObjectsFromArray:inviteBonuses.content];
        } else {
            _dataArray = [NSMutableArray arrayWithArray:inviteBonuses.content];
        }
        [self.tableview reloadData];
        _pageNo++;
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        self.tableview.mj_footer.hidden = [json[@"last"] boolValue];
        [self buildUI];
    } failureBlock:^(id json) {
        _failFooterView.hidden = NO;
    }];
}

- (void)buildUI {
    if (_dataArray == nil ||_dataArray.count == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        UILabel *atten = [[UILabel alloc] init];
        [headerView addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headerView);
            make.centerY.mas_equalTo(headerView).offset(-40);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-24, 50));
        }];
        atten.font = PZFont(14);
        atten.textColor = HBColor(153, 153, 153);
        atten.textAlignment = NSTextAlignmentCenter;
        atten.numberOfLines = 0;
        atten.text = @"想要更多奖励？快点击右上角邀请好友吧！";
        [self.tableview setTableHeaderView:headerView];
    } else {
        NSString *attenStr = @"您邀请1个朋友可获奖励100喜腾币，您的朋友每邀请5个朋友您可获得奖励100喜腾币";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:PZFont(12), NSParagraphStyleAttributeName:paragraphStyle};
        CGRect rect = [attenStr boundingRectWithSize:CGSizeMake(SCREENWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, rect.size.height+24)];
        UILabel *atten = [[UILabel alloc] init];
        [headerView addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(headerView).offset(12);
            make.width.mas_equalTo(SCREENWidth-24);
            make.height.mas_equalTo(rect.size.height+5);
        }];
        atten.font = PZFont(12);
        atten.textColor = HBColor(153, 153, 153);
        atten.numberOfLines = 0;
        atten.text = attenStr;
        [self.tableview setTableHeaderView:headerView];
    }
}

-(void)inviteFriend{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQInviteAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQInviteAwardViewController"];
    if (!cell) {
        cell = [[JNQInviteAwardCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"JNQInviteAwardViewController"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = _dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteBonuses* model = _dataArray[indexPath.row];
    JNQInviteDetailViewController* detail = [[JNQInviteDetailViewController alloc]init];
    detail.model = model ;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
