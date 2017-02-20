//
//  ContactListController.m
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ContactListController.h"
#import <AddressBook/AddressBook.h>
#import "Contact.h"
#import "ContactManager.h"
#import "MBProgressHUD.h"
#import "ContactListCell.h"
#import "HomeTool.h"
#import "PZContact.h"
#import "RRFDetailInfoController.h"
#import "CommonPopOutController.h"
#import <STPopup/STPopup.h>
#import "ContactFilterPopMenuController.h"
#import "FPPopoverController.h"
#import "HBLoadingView.h"
#import "RRFMyFriendHeadView.h"
#import "MyFriendCircleController.h"
@interface ContactListController ()<UIAlertViewDelegate>

@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) ContactManager *contactManager;
@property(strong,nonatomic)FPPopoverController* popover ;
@property(strong,nonatomic)NSArray* contacts ;

@property (nonatomic, strong) NSDictionary *contactsDic;
@property (nonatomic, copy) NSArray *keys;

@property (nonatomic, strong) NSDictionary *allContactsDic;
@property (nonatomic, copy) NSArray *allKeys;


@end

@implementation ContactListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView = [UIView new];
    [self checkAddressBookAuthorizationStatus];
//    [self createHeader];
    [self setNavItem];
}

- (void)dealloc
{
    CFRelease(self.addressBook);
}

- (void)checkAddressBookAuthorizationStatus
{
    //初始化
    self.addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    if (kABAuthorizationStatusAuthorized == ABAddressBookGetAuthorizationStatus())
    {
        NSLog(@"已经授权");
    }
    [HBLoadingView showCircleView:self.tableView];
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [HBLoadingView dismiss];
            }else if (!granted){
                [HBLoadingView dismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Denied"
                                                                message:@"Set permissions in Setting>Genearl>Privacy."
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            }else{
                //还原 ABAddressBookRef
                ABAddressBookRevert(self.addressBook);
                self.contactManager = [[ContactManager alloc] initWithArray:(__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(self.addressBook))];
                self.contactsDic = [self.contactManager contactsWithGroup];
                self.keys = [[self.contactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                NSMutableArray* conatctsToSave = [NSMutableArray array];
                int section = 0 ;
                for (NSDictionary* c in self.contactsDic) {
                    NSString *key = [self.keys objectAtIndex:section];
                    NSArray * array = [self.contactsDic objectForKey:key];
                   [conatctsToSave addObjectsFromArray:array];
                    section++ ;
                }
                NSArray* changedContacts = [self.contactManager getNewlyContactList:conatctsToSave];
                WEAKSELF
                [HomeTool addOrUpdateFriendWithFriends:changedContacts successBlock:^(id json) {
                    PZContactList* lists = [PZContactList yy_modelWithJSON:json];
                    weakSelf.contacts = lists.content ;
                    self.contactManager = [[ContactManager alloc] initWithPlatformContacts:lists.content];
                    self.contactsDic = [self.contactManager platformContactsWithGroup];
                    self.keys = [[self.contactsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
                    //缓存所有
                    self.allContactsDic = self.contactsDic ;
                    self.allKeys = self.keys ;
                    
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                    [self.tableView reloadData];
                    [HBLoadingView dismiss];
                } fail:^(id json) {
                    [HBLoadingView dismiss];
                }];
            }
        });
    });
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
    static NSString *reuseIdentifier = @"contactCellIdentifier";
    ContactListCell *cell = [[ContactListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    PZContact *people = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
    cell.itemClock = ^(){
        [MBProgressHUD show];
        [HomeTool inviteByMessageWithPhone:people.phoneNum successBlock:^(id json) {
            [MBProgressHUD dismiss];
            [MBProgressHUD showInfoWithStatus:@"邀请已发送"];
        } fail:^(id json) {
            [MBProgressHUD dismiss];
        }];
    };
    
    cell.contact = people ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    PZContact *contact = [[self.contactsDic objectForKey:key] objectAtIndex:indexPath.row];
    NSString* status = contact.status ;
    if ([status isEqualToString:@"no_regist"])return;
    RRFDetailInfoController* detail = [[RRFDetailInfoController alloc]init];
    detail.title = @"详细资料" ;
    detail.userId = contact.userId ;
    detail.detailInfoComeInType = RRFDetailInfoComeInTypeOther;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)setNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.titleLabel.textAlignment = NSTextAlignmentRight;
    right.titleLabel.font = PZFont(13.0f);
    [right setTitle:@"筛选" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(showFilter:) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)showFilter:(UIButton*)sender{
    WEAKSELF
    ContactFilterPopMenuController *menuVc=[[ContactFilterPopMenuController alloc]init];
    menuVc.view.backgroundColor = [UIColor clearColor];
    menuVc.itemBlock = ^(NSNumber* index){
        NSInteger row = [index integerValue];
        if (row == 0) {
            weakSelf.keys = weakSelf.allKeys ;
            weakSelf.contactsDic = weakSelf.allContactsDic ;
        }
        else if (row == 1){
            NSArray* allKeys = [self.allContactsDic allKeys] ;
            NSMutableArray* tempArray = [NSMutableArray array];
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionary];
            for (NSString* key in allKeys) {
                NSArray* contacts = self.allContactsDic[key];
                NSMutableArray* registeContacts = [NSMutableArray array];
                for (PZContact* c  in contacts) {
                    if ([c.status isEqualToString:@"no_regist"])continue;
                    [registeContacts addObject:c];
                }
                if (registeContacts.count) {
                    [tempDic setValue:registeContacts forKey:key];
                    [tempArray addObject:key];
                }
            }
            weakSelf.keys = [tempArray sortedArrayUsingSelector:@selector(compare:)];
            weakSelf.contactsDic = tempDic ;
        }
        else if (row == 2){
            NSArray* allKeys = [self.allContactsDic allKeys] ;
            NSMutableArray* tempArray = [NSMutableArray array];
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionary];
            for (NSString* key in allKeys) {
                NSArray* contacts = self.allContactsDic[key];
                NSMutableArray* unregisteContacts = [NSMutableArray array];
                for (PZContact* c  in contacts) {
                    if (![c.status isEqualToString:@"no_regist"])continue;
                    [unregisteContacts addObject:c];
                }
                if (unregisteContacts.count) {
                    [tempDic setValue:unregisteContacts forKey:key];
                    [tempArray addObject:key];
                }
            }
            weakSelf.keys = [tempArray sortedArrayUsingSelector:@selector(compare:)];
            weakSelf.contactsDic = tempDic ;
        }
        [weakSelf.tableView reloadData];
        [weakSelf.popover dismissPopoverAnimated:YES];
    };
    //2.新建一个popoverController，并设置其内容控制器
    self.popover= [[FPPopoverController alloc]initWithViewController:menuVc];
    //3.设置尺寸
    self.popover.contentSize = CGSizeMake(160,152);
    self.popover.tint = FPPopoverLightGrayTint ;
    //4.显示
    [self.popover presentPopoverFromView:sender];
}




@end
