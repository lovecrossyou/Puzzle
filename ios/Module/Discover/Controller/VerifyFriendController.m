//
//  VerifyFriendController.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "VerifyFriendController.h"

#import <AddressBook/AddressBook.h>
#import "ContactManager.h"
#import "MBProgressHUD.h"
#import "VerifyFriendCell.h"
#import "RRFDetailInfoController.h"
#import "HomeTool.h"
#import "FriendListModel.h"
#import "RRFDetailInfoModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface VerifyFriendController ()<UIAlertViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ContactManager *contactManager;
@property (nonatomic, strong) NSDictionary *contactsDic;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation VerifyFriendController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self requestData];
}

-(void)requestData{
    WEAKSELF
    [MBProgressHUD show];
    [HomeTool inviteListWithSuccessBlock:^(id json) {
        FriendListModel* friendList = [FriendListModel yy_modelWithJSON:json];
        weakSelf.contactManager = [[ContactManager alloc] initWithFriends:friendList.list];
        weakSelf.contactsDic = [self.contactManager friendsWithGroup];
        weakSelf.keys = [[self.contactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        weakSelf.tableView.emptyDataSetSource = self;
        weakSelf.tableView.emptyDataSetDelegate = self;
        [weakSelf.tableView reloadData];
        [MBProgressHUD dismiss];
    } fail:^(id json) {
        [MBProgressHUD dismiss];
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
    static NSString *reuseIdentifier = @"VerifyFriendCell";
    VerifyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[VerifyFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    RRFDetailInfoModel *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
    cell.contact = people ;
    cell.itemClock = ^(){
        [weakSelf verifyFriend:people];
    };
    return cell;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前没有验证请求信息";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


//验证朋友
-(void)verifyFriend:(RRFDetailInfoModel*)people{
    WEAKSELF
    [MBProgressHUD show];
    [HomeTool verifyFriendWithUserId:people.inviteId successBlock:^(id json) {
        [MBProgressHUD dismiss];
        [weakSelf goFriendDetailInfo:people.userId];
    } fail:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

-(void)goFriendDetailInfo:(NSInteger)userId{
    RRFDetailInfoController* detail = [[RRFDetailInfoController alloc]init];
    detail.title = @"详细资料" ;
    detail.userId = userId ;
    detail.detailInfoComeInType = RRFDetailInfoComeInTypeOther;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    RRFDetailInfoModel *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
    [self goFriendDetailInfo:people.inviteId];
}


@end
