//
//  RRFCreatAddressController.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddressOperateController.h"
#import "JNQAddressOperateView.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/ContactsUI.h>

#import "JNQSelectedDistrictController.h"
#import "ZFModalTransitionAnimator.h"
#import "JNQHttpTool.h"

@interface JNQAddressOperateController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate, UITextFieldDelegate> {
    UIButton *_navRight;
}
@property (nonatomic, strong) JNQAddressOperateHeaderView *headView;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation JNQAddressOperateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self settingUIView];
    [self settingNavItem];
}
-(void)settingNavItem {
    _navRight = [[UIButton alloc]init];
    [_navRight setTitle:@"保存" forState:UIControlStateNormal];
    [_navRight setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    _navRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [_navRight addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    _navRight.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_navRight];
    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)settingUIView {
    WEAKSELF
    _headView = [[JNQAddressOperateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 224)];
    _headView.showTitle = NO;
    self.tableView.tableHeaderView = _headView;
    _headView.nameView.vc = self;
    _headView.phoneView.vc = self;
    _headView.addressView.vc = self;
    _headView.detailInfoView.vc = self;
    if (_viewType == AddressViewTypeEdit) {
        _headView.addrModel = _addrModel;
    }
    _headView.chooseContactBlock = ^(){
        [weakSelf showContact];
    };
    _headView.chooseAddressBlcok = ^(){
        [weakSelf selectedCity];
    };
    
}
#pragma mark - 保存地址
-(void)saveAddress {
    _navRight.userInteractionEnabled = NO;
    JNQAddressModel *addrModel = _headView.addrModel ;
    addrModel.phoneNum = [addrModel.phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    addrModel.fullAddress = [NSString stringWithFormat:@"%@%@", addrModel.districtAddress, addrModel.detailAddress];
    if ([addrModel.phoneNum  isEqual: @""] || [addrModel.fullAddress  isEqual: @""]) {
        [MBProgressHUD showInfoWithStatus:@"请正确填写地址信息！"];
        return;
    }
    NSDictionary *dict = [addrModel yy_modelToJSONObject];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (_viewType == AddressViewTypeCreate) {
        [param removeObjectForKey:@"id"];
    }
    [param removeObjectForKey:@"isSelected"];
    [param setObject:@"" forKey:@"positionX"];
    [param setObject:@"" forKey:@"positionY"];
    NSString *URLstr;
    if (_viewType == AddressViewTypeCreate) {
        URLstr = @"deliveryAddress/create";
    } else {
        URLstr = @"deliveryAddress/edit";
    }
    [JNQHttpTool JNQHttpRequestWithURL:URLstr requestType:@"post" showSVProgressHUD:YES parameters:param successBlock:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"操作成功！"];
        if (self.shouldReload) {
            self.shouldReload(YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(id json) {
        _navRight.userInteractionEnabled = YES;
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
        weakSelf.headView.addressView.textValue = districtName;
        weakSelf.headView.addrModel.districtAddress = districtName;
        weakSelf.headView.addrModel.provinceId = provinceId;
        weakSelf.headView.addrModel.cityId = cityId;
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


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    id detailProperty = contactProperty.value ;
    if ([detailProperty isKindOfClass:[CNPhoneNumber class]]) {
        CNPhoneNumber* phoneNumber = (CNPhoneNumber*)detailProperty ;
        CNContact* contact = contactProperty.contact ;
        
        NSString* fullName = [NSString stringWithFormat:@"%@%@%@",contact.familyName,contact.middleName,contact.givenName];
        NSString* phoneNum = phoneNumber.stringValue ;
        _headView.addrModel.phoneNum = phoneNum;
        _headView.addrModel.recievName = fullName;
        _headView.phoneView.textValue = phoneNum;
        _headView.nameView.textValue = fullName;
    
        [self.tableView reloadData];
    }
}



//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
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
        //        选中该号码
        _headView.addrModel.phoneNum = phoneNO;
        _headView.addrModel.recievName = contactName;
        _headView.phoneView.textValue = phoneNO;
        _headView.nameView.textValue = contactName;
//        _headView.addrModel = _addrModel;
        [self.tableView reloadData];
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return;
}

@end
