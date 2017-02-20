//
//  RRFReceiveController.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFReceiveController.h"
#import "RRFRequestAcceptPrizeModel.h"
#import "RRFFreeBuyOrderTool.h"
#import "RRFFreeBuyOrderModel.h"
#import "JNQConfirmOrderView.h"
#import "JNQAddressController.h"
#import "JNQAddressModel.h"
#import "RRFReceiveView.h"
#import "RRFFreeBuyOrderTool.h"
#import "JNQAddressOperateView.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/ContactsUI.h>
#import "ZFModalTransitionAnimator.h"
#import "JNQSelectedDistrictController.h"
#import "RRFFreeBuyOrderViewController.h"
#import "RRFWiningOrderModel.h"
#import "RRFDrawModel.h"
#import "HBLoadingView.h"
#import "RRFMeTool.h"
#import "RRFWiningOrderListController.h"
@interface RRFReceiveController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate, UITextFieldDelegate>
@property(nonatomic,weak)JNQConfirmOrderHeaderView *headerView;
@property(nonatomic,assign)NSInteger addressId;
@property(nonatomic,strong)JNQAddressModel *addressModel;
@property(nonatomic,weak)RRFReceiveFooterView *footView;
@property(nonatomic,weak)JNQAddressOperateHeaderView *nohaveAddreView;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,strong)RRFDrawModel* drawModel;

@end

@implementation RRFReceiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingUIView];
    [self loadAddress];
}
-(RRFDrawModel *)drawModel
{
    if (_drawModel == nil) {
        _drawModel = [[RRFDrawModel alloc]init];
    }
    return _drawModel;
}
- (void)settingUIView {
    WEAKSELF
    RRFReceiveFooterView *footView = [[RRFReceiveFooterView alloc]init];
    if (self.winingM == nil) {
        footView.model = self.model;
    }else{
        footView.winingM = self.winingM;
    }
    footView.frame = CGRectMake(0, 0, SCREENWidth, 300);
    self.footView = footView;
    [self.tableView setTableFooterView:footView];
    [[footView.footBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.winingM == nil) {
            [weakSelf receive];
        }else{
            [weakSelf winingReceive];
        }
    }];
    
}


- (void)loadAddress{
    WEAKSELF
    [RRFFreeBuyOrderTool requestAddressWithSuccess:^(id json) {
        JNQAddressModel *addressModel = [JNQAddressModel yy_modelWithJSON:json];
        if (addressModel.addressId == 0) {
            [weakSelf setCreatAddressUIView];
        }else{
            [weakSelf setHaveAddressUIViewWithModel:addressModel];
        }
    } failBlock:^(id json) {
        
    }];
}
-(void)setHaveAddressUIViewWithModel:(JNQAddressModel *)addrM
{
    WEAKSELF
    JNQConfirmOrderHeaderView *headerView = [[JNQConfirmOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 90)];
    headerView.backgroundColor = [UIColor redColor];
    headerView.addrModel = addrM;
    weakSelf.footView.footBtn.enabled = !addrM.addressId?NO:YES;
    weakSelf.addressId = addrM.addressId;
    self.headerView = headerView;
    [self.tableView setTableHeaderView:headerView];
    headerView.block = ^() {
        JNQAddressController *addrVC = [[JNQAddressController alloc] init];
        addrVC.viewType = PZAddrViewTypeSelect;
        addrVC.navigationItem.title = @"选择地址";
        addrVC.selectBlock = ^(JNQAddressModel *addrModel) {
            weakSelf.headerView.addrModel = addrModel;
        };
        [weakSelf.navigationController pushViewController:addrVC animated:YES];
    };
    
}
-(void)setCreatAddressUIView{
    WEAKSELF
    JNQAddressOperateHeaderView *nohaveAddreView = [[JNQAddressOperateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 224)];
    nohaveAddreView.showTitle = NO;
    nohaveAddreView.hiddenDefault = YES;
    self.nohaveAddreView = nohaveAddreView;
    self.tableView.tableHeaderView = nohaveAddreView;
    nohaveAddreView.nameView.vc = self;
    nohaveAddreView.phoneView.vc = self;
    nohaveAddreView.addressView.vc = self;
    nohaveAddreView.detailInfoView.vc = self;
    nohaveAddreView.chooseContactBlock = ^(){
        [weakSelf showContact];
    };
    nohaveAddreView.chooseAddressBlcok = ^(){
        [weakSelf selectedCity];
    };

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
        weakSelf.nohaveAddreView.addressView.textValue = districtName;
        weakSelf.nohaveAddreView.addrModel.districtAddress = districtName;
        weakSelf.nohaveAddreView.addrModel.provinceId = provinceId;
        weakSelf.nohaveAddreView.addrModel.cityId = cityId;
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
        self.nohaveAddreView.addrModel.phoneNum = phoneNum;
        self.nohaveAddreView.addrModel.recievName = fullName;
        self.nohaveAddreView.phoneView.textValue = phoneNum;
        self.nohaveAddreView.nameView.textValue = fullName;
    
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
        self.nohaveAddreView.addrModel.phoneNum = phoneNO;
        self.nohaveAddreView.addrModel.recievName = contactName;
        self.nohaveAddreView.phoneView.textValue = phoneNO;
        self.nohaveAddreView.nameView.textValue = contactName;

        [self.tableView reloadData];
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return;
}
// 0元夺宝订单的领取
-(void)receive
{
    WEAKSELF
    if (self.nohaveAddreView != nil) {
        self.addressModel = self.nohaveAddreView.addrModel;
    }else{
        self.addressModel = self.headerView.addrModel;
    }
    if (self.addressModel == nil) {
        [MBProgressHUD showInfoWithStatus:@"请填写收货地址"];
        return;
    }
    self.addressModel.phoneNum = [self.addressModel.phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.addressModel.fullAddress = [NSString stringWithFormat:@"%@%@", self.addressModel.districtAddress, self.addressModel.detailAddress];
    if ([self.addressModel.phoneNum  isEqual: @""] ||[self.addressModel.recievName isEqualToString:@""]|| [self.addressModel.fullAddress  isEqual: @""]) {
        [MBProgressHUD showInfoWithStatus:@"请正确填写地址信息！"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.addressModel.recievName forKey:@"recievName"];
    [param setObject:self.addressModel.phoneNum forKey:@"phoneNum"];
    [param setObject:self.addressModel.districtAddress forKey:@"districtAddress"];
    [param setObject:self.addressModel.detailAddress forKey:@"detailAddress"];
    [param setObject:self.addressModel.fullAddress forKey:@"fullAddress"];
    [param setObject:@(self.addressModel.addressId) forKey:@"deliveryAddressId"];
    [param setObject:@(self.model.ID) forKey:@"bidOrderId"];
    [MBProgressHUD show];
    [RRFFreeBuyOrderTool requestAcceptPrizeWithParam:param Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"领取成功！"];
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *vc  in controllers) {
            if ([vc isKindOfClass:[RRFFreeBuyOrderViewController class]]) {
                if(self.isRefre){
                    self.isRefre(YES);
                }
                [weakSelf.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
    
}
// 中奖订单的领取
-(void)winingReceive
{
    WEAKSELF
    self.drawModel.awardRecordId = self.winingM.awardRecordId;

    if (self.nohaveAddreView != nil) {
        self.drawModel.phoneNum = self.nohaveAddreView.addrModel.phoneNum;
        self.drawModel.fullAddress = [NSString stringWithFormat:@"%@%@", self.nohaveAddreView.addrModel.districtAddress, self.nohaveAddreView.addrModel.detailAddress];
        self.drawModel.recievName = self.nohaveAddreView.addrModel.recievName;
        self.drawModel.detailAddress = self.nohaveAddreView.addrModel.detailAddress;
        self.drawModel.districtAddress = self.nohaveAddreView.addrModel.districtAddress;
        self.drawModel.provinceId = self.nohaveAddreView.addrModel.provinceId;
        self.drawModel.cityId = self.nohaveAddreView.addrModel.cityId;
        self.drawModel.deliveryAddressId = self.nohaveAddreView.addrModel.deliveryAddressId;

        
    }else{
        self.drawModel.phoneNum = self.headerView.addrModel.phoneNum;
        self.drawModel.fullAddress = [NSString stringWithFormat:@"%@%@", self.headerView.addrModel.districtAddress, self.headerView.addrModel.detailAddress];
        self.drawModel.recievName = self.headerView.addrModel.recievName;
        self.drawModel.detailAddress = self.headerView.addrModel.detailAddress;
        self.drawModel.districtAddress = self.headerView.addrModel.districtAddress;
        self.drawModel.provinceId = self.headerView.addrModel.provinceId;
        self.drawModel.cityId = self.headerView.addrModel.cityId;
        self.drawModel.deliveryAddressId = self.headerView.addrModel.deliveryAddressId;

    }
    if (self.drawModel.phoneNum.length<1 || self.drawModel.fullAddress.length <1 || self.drawModel.recievName.length <1) {
        [MBProgressHUD showInfoWithStatus:@"请完善联系信息！"];
        return ;
    }
    [MBProgressHUD show];
    [RRFMeTool prizeWithModel:self.drawModel Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"领取成功!"];
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *vc  in controllers) {
            if ([vc isKindOfClass:[RRFWiningOrderListController class]]) {
                if(weakSelf.isRefre){
                    weakSelf.isRefre(YES);
                }
                [weakSelf.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}
@end
