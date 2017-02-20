//
//  RRFPrizeController.m
//  Puzzle
//
//  Created by huibei on 16/9/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//   领取奖品

#import "RRFPrizeController.h"
#import "RRFPrizeView.h"
#import "TPKeyboardAvoidingTableView.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/ContactsUI.h>

#import "JNQAddressOperateView.h"
#import "JNQAddressModel.h"
#import "JNQAddressOperateView.h"
#import "JNQSelectedDistrictController.h"
#import "ZFModalTransitionAnimator.h"
#import "RRFNoticeModel.h"
#import "RRFDrawModel.h"
#import "RRFMeTool.h"
#import "HBLoadingView.h"

@interface RRFPrizeController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
@property(nonatomic,weak)RRFPrizeView *headView;
@property(nonatomic,weak)TPKeyboardAvoidingTableView *tableView;
@property(nonatomic,strong)ZFModalTransitionAnimator *animator;
@end

@implementation RRFPrizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc]init];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor colorR:251 colorG:237 colorB:208];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    RRFPrizeView *headView = [[RRFPrizeView alloc]init];
    headView.model = self.model;
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight+200 + 64);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    headView.chooseContactBlock = ^(){
        [weakSelf showContact];
    };
    headView.chooseAddressBlcok = ^(){
        [weakSelf selectedCity];
    };
    headView.determineBlock = ^(){
        // 立即领取
        [weakSelf receive];
    };
}
-(void)receive
{
    RRFDrawModel* drawModel = self.headView.drawModel ;
    if (drawModel.phoneNum.length<1 || drawModel.fullAddress.length <1 ||drawModel.recievName.length <1) {
        [MBProgressHUD showInfoWithStatus:@"请完善联系信息！"];
        return ;
    }
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool prizeWithModel:self.headView.drawModel Success:^(id json) {
        [HBLoadingView hide];
        [MBProgressHUD showInfoWithStatus:@"领取成功!"];
        if (self.refreBlock) {
            self.refreBlock(YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failBlock:^(id json) {
        [HBLoadingView hide];
    }];
}
#pragma mark - 选择区域
-(void)selectedCity {
    [self.view resignFirstResponder];
    WEAKSELF
    JNQSelectedDistrictController *selectController = [[JNQSelectedDistrictController alloc]init];
    selectController.modalPresentationStyle = UIModalPresentationCustom;
    weakSelf.animator = [[ZFModalTransitionAnimator alloc]initWithModalViewController:selectController];
    weakSelf.animator.dragable = NO;
    weakSelf.animator.bounces = NO;
    weakSelf.animator.behindViewAlpha = 1.0f;
    weakSelf.animator.behindViewScale = 0.9f;
    weakSelf.animator.direction = ZFModalTransitonDirectionBottom;
    selectController.transitioningDelegate = weakSelf.animator;
    [weakSelf presentViewController:selectController animated:YES completion:^{}];
    selectController.districtNameBlock = ^(NSString *districtName, NSInteger provinceId, NSInteger cityId){
        weakSelf.headView.addView.addressView.textValue = districtName;
        weakSelf.headView.drawModel.districtAddress = districtName;
        weakSelf.headView.drawModel.provinceId = provinceId;
        weakSelf.headView.drawModel.cityId = cityId;

    };
}


#pragma mark - 获取通讯录
-(void)showContact{
    if (IOS_VERSION_9_OR_ABOVE) {
        CNContactPickerViewController *nav = [[CNContactPickerViewController alloc] init];
        nav.delegate = self;
        nav.predicateForSelectionOfContact = [NSPredicate predicateWithValue:false];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else{
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    id detailProperty = contactProperty.value ;
    if ([detailProperty isKindOfClass:[CNPhoneNumber class]]) {
        CNPhoneNumber* phoneNumber = (CNPhoneNumber*)detailProperty ;
        CNContact* contact = contactProperty.contact ;
        
        NSString* fullName = [NSString stringWithFormat:@"%@%@%@",contact.familyName,contact.middleName,contact.givenName];
        NSString* phoneNum = phoneNumber.stringValue ;
        self.headView.drawModel.phoneNum = phoneNum;
        self.headView.drawModel.recievName = fullName;
        self.headView.addView.phoneView.textValue = phoneNum;
        self.headView.addView.nameView.textValue = fullName;
        [self.tableView reloadData];
    }
}



- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    if (firstName == nil) {
        firstName = @"" ;
    }
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    if (lastName == nil) {
        lastName = @"" ;
    }
    NSString* contactName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (phoneNO != nil) {
        self.headView.drawModel.phoneNum = phoneNO;
        self.headView.drawModel.recievName = contactName;
        self.headView.addView.phoneView.textValue = phoneNO;
        self.headView.addView.nameView.textValue = contactName;
        [self.tableView reloadData];
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD dismiss];
}

@end
