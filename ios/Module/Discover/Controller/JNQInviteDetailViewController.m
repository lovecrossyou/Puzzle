//
//  JNQInviteDetailViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQInviteDetailViewController.h"
#import "JNQInviteAwardCell.h"
#import "InviteBonusesModel.h"
#import "HomeTool.h"
#import "InviteTwoPersonListModel.h"
#import "JNQHttpTool.h"
@interface JNQInviteDetailViewController () {
    NSArray<InviteBaseModel *> *_dataArray;
    int _pageNo;
}

@end

@implementation JNQInviteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSMutableArray array];
    [self setNav];
    [self requestData];
}

- (void)setNav {
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    navTitle.font = PZFont(11);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.numberOfLines = 2;
    navTitle.text = [NSString stringWithFormat:@"%@\n邀请%d人", self.model.model.acceptUserName, self.model.model.acceptUserInviteAmout];
    NSMutableAttributedString *navTitleString = [[NSMutableAttributedString alloc] initWithString:navTitle.text];
    [navTitleString addAttribute:NSFontAttributeName value:PZFont(16) range:[navTitle.text rangeOfString:self.model.model.acceptUserName]];
    navTitle.attributedText = navTitleString;
    self.navigationItem.titleView = navTitle;
}

- (void)loadHeaderView {
    if (_dataArray.count) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 18)];
        headerView.backgroundColor = HBColor(245, 245, 245);
        [self.tableView setTableHeaderView:headerView];
    } else {
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
        atten.text = @"该客户还没有邀请好友";
        [self.tableView setTableHeaderView:headerView];
    }
}

-(void)requestData{
    NSDictionary *param = @{
                            @"size"  : @"10",
                            @"pageNo": @(_pageNo),
                            @"otherUserId" : @(self.model.model.acceptUserId)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"inviteTwoPersonList" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        InviteTwoPersonListModel* list = [InviteTwoPersonListModel yy_modelWithJSON:json];
        _dataArray = list.content ;
        [self loadHeaderView];
        [self.tableView reloadData];
    } failureBlock:^(id json) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQInviteAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQInviteDetailViewController"];
    if (!cell) {
        cell = [[JNQInviteAwardCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"JNQInviteDetailViewController"];
    }
    cell.awardLabel.hidden = YES;
    cell.baseModel = _dataArray[indexPath.row];
    return cell;
}

@end
