//
//  MyFriendCircleController.m
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MyFriendCircleController.h"
#import "ContactManager.h"
#import "MBProgressHUD.h"
#import "ContactListCell.h"
#import "RRFDetailInfoController.h"
#import "VerifyFriendController.h"
#import "HomeTool.h"
#import "FriendListModel.h"
#import "RRFDetailInfoModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "NotificateMsgUtil.h"
#import "HBLoadingView.h"
#import "MJRefresh.h"
#import "RRFMyFriendHeadView.h"
#import "RRFMyFriendController.h"
#import "FriendSearchController.h"
@interface MyFriendCircleHeader : UIControl

@end


@implementation MyFriendCircleHeader
-(instancetype)init{
    if (self = [super init]) {
        UIButton* leftBtn = [UIButton new];
        [leftBtn sizeToFit];
        [leftBtn setImage:[UIImage imageNamed:@"icon_s"] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = PZFont(14.0f);
        [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [leftBtn setTitle:@"  验证朋友" forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(12);
        }];
        
        UIView* tipView=  [[UIView alloc]init];
        tipView.alpha = 0.6 ;
        tipView.backgroundColor = [UIColor redColor];
        tipView.layer.cornerRadius = 4.5 ;
        [self addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 9));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(-20);
        }];
        
        
        UIView* bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        bottomLine.alpha = 0.2 ;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.left.right.mas_equalTo(0);
        }];
    }
    return self ;
}
@end



@interface MyFriendCircleController ()<UIAlertViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ContactManager *contactManager;
@property (nonatomic, strong) NSDictionary *contactsDic;
@property (nonatomic, copy) NSArray *keys;

@property(strong,nonatomic) NSArray* friendList ;


@property(assign,nonatomic)int pageSize ;
@property(assign,nonatomic)int pageNo ;


//
@property(strong,nonatomic) NSMutableArray* selectedIndexPaths ;

@end

@implementation MyFriendCircleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    [self.tableView setEditing:self.seleteMode animated:YES];
    self.selectedIndexPaths = [NSMutableArray array];
//    friendInvite(21,"添加朋友"),
//    acceptInviteFriend(22,"通过朋友验证");
    [NotificateMsgUtil clearVerifyFriendData];
    [self requestData];
    [self setNavRight];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyClearCircle object:nil];

}

#pragma mark - 添加、搜索朋友
-(void)setNavRight{
    if (self.seleteMode) {
        UIBarButtonItem* completeItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeClick)];
        self.navigationItem.rightBarButtonItem = completeItem ;
    }
    else{
//        UIBarButtonItem* addFriendItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"friendcircle_icon_invitation"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
//        self.navigationItem.rightBarButtonItem = addFriendItem ;
    }
}

#pragma mark - 完成选择
-(void)completeClick{
    WEAKSELF
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray* personIds = [NSMutableArray array];
        for (NSIndexPath* indexPath in weakSelf.selectedIndexPaths) {
            NSString *key = [self.keys objectAtIndex:indexPath.section];
            RRFDetailInfoModel *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
            NSString* xtNumber = people.xtNumber ;
            if (xtNumber != nil) {
                [personIds addObject:people.xtNumber];
            }
        }
        if (weakSelf.chooseCompleteBlock) {
            weakSelf.chooseCompleteBlock(personIds);
        }
    }];
}

-(void)addFriend{
    FriendSearchController* search = [[FriendSearchController alloc]init];
    search.title = @"添加朋友" ;
    [self.navigationController pushViewController:search animated:YES];
}


-(void)checkAuthenticateFriend{
    WEAKSELF
    [HomeTool inviteListWithSuccessBlock:^(id json) {
        FriendListModel* friendList = [FriendListModel yy_modelWithJSON:json];
        weakSelf.friendList = friendList.list ;
        if (friendList.list.count) {
            [weakSelf createHeaderView];
        }
        else{
            weakSelf.tableView.tableHeaderView = [weakSelf createHeader] ;
        }
        [HBLoadingView dismiss];
        weakSelf.tableView.emptyDataSetSource = weakSelf;
        weakSelf.tableView.emptyDataSetDelegate = weakSelf;
        [weakSelf.tableView reloadData];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

// 这个回调决定了在当前indexPath的Cell是否可以编辑。
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES ;
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"你还没有任何朋友";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - 二级邀请
-(UIView*)createHeader{
    RRFMyFriendHeadView *headView = [[RRFMyFriendHeadView alloc]initWithTitle:@"邀请的朋友" isShowDesc:NO];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 50);
    self.tableView.tableHeaderView = headView;
    [[headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RRFMyFriendController *bVC = [[RRFMyFriendController alloc] init];
        [self.navigationController pushViewController:bVC animated:YES];
        
    }];
    return headView ;
}

-(void)createHeaderView{
    WEAKSELF
    MyFriendCircleHeader* header = [[MyFriendCircleHeader alloc]init];
    header.frame = CGRectMake(0, 0, SCREENWidth, 60);
    self.tableView.tableHeaderView = header ;
    [[header rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        VerifyFriendController* verifyController = [[VerifyFriendController alloc]init];
        verifyController.title = @"验证朋友" ;
        [weakSelf.navigationController pushViewController:verifyController animated:YES];
    }];
}

-(void)requestData{
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [HomeTool friendListWithSuccessBlock:^(id json) {
        FriendListModel* friendList = [FriendListModel yy_modelWithJSON:json];
        weakSelf.friendList = friendList.list ;
        weakSelf.contactManager = [[ContactManager alloc] initWithFriends:friendList.list];
        weakSelf.contactsDic = [self.contactManager friendsWithGroup];
        weakSelf.keys = [[self.contactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [weakSelf.tableView reloadData];
        [weakSelf checkAuthenticateFriend];
    } fail:^(id json) {
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.keys objectAtIndex:section];
    NSArray * array = [self.contactsDic objectForKey:key];
    return [array count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keys[section];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 + 12*2 ;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    static NSString *reuseIdentifier = @"contactCellIdentifier";
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    RRFDetailInfoModel *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];

    ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[ContactListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.headClock = ^{
        if (weakSelf.seleteMode) {
            [weakSelf.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        else{
            RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
            desc.title = @"详细资料";
            desc.userId = people.userId;
            desc.verityInfo = NO;
            desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }
    };
    cell.myCircle = YES ;
    cell.circleContact = people ;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seleteMode) {
        ContactListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setEditing:YES animated:YES];
        [self.selectedIndexPaths addObject:indexPath];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString *key = [self.keys objectAtIndex:indexPath.section];
        RRFDetailInfoModel *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
        RRFDetailInfoController* detail = [[RRFDetailInfoController alloc]init];
        detail.title = @"详细资料" ;
        detail.userId = people.userId ;
        detail.detailInfoComeInType = RRFDetailInfoComeInTypeOther;
        [self.navigationController pushViewController:detail animated:YES];
    }
}





@end
