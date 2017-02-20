//
//  RRFMeInfoController.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMeInfoController.h"
#import "RRFMeInfoHeadView.h"
#import "PZCommonCellModel.h"
#import "JNQAddressController.h"
#import "RRFModifyNameController.h"
#import "PZHttpTool.h"
#import "UIImage+Image.h"
#import "RRFMeTool.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "RRFSignatureController.h"
#import "RRFChooseSexController.h"
#import "JNQSelectedDistrictController.h"
#import "ZFModalTransitionAnimator.h"
#import "RRFInviteViewController.h"
#import "HBLoadingView.h"
#import "XTChatUtil.h"
@interface RRFMeInfoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_allData;
    RRFMeInfoHeadView *_headerView;
}
@property(nonatomic,strong)ZFModalTransitionAnimator *animator;
@end

@implementation RRFMeInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
-(void)requestUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HBLoadingView showCircleView:self.view];
    });
    [RRFMeTool requestUserInfoWithSuccess:^(id json) {
        if(json != nil){
            RLMRealm *defaultRealm = [RLMRealm defaultRealm];
            [defaultRealm beginWriteTransaction];
            LoginModel* userM = [LoginModel yy_modelWithJSON:json[@"userInfo"]];
            LoginModel *userInfo = [PZParamTool currentUser];
            userInfo.cnName = userM.cnName;
            userInfo.icon = userM.icon;
            userInfo.phoneNumber =userM.phoneNumber;
            userInfo.xtNumber =userM.xtNumber;
            userInfo.userId =userM.userId;
            userInfo.sex = userM.sex;
            userInfo.selfSign = userM.selfSign;
            userInfo.address = userM.address;
            [defaultRealm commitWriteTransaction];
            [self settingTabelViewWithModel:userInfo];
            [self settingHeadViewWithModel:userInfo];
            [self.tableView reloadData];
            [HBLoadingView hide];
        }
        
    } failBlock:^(id json) {
        [HBLoadingView hide];

    }];
}
- (void)settingHeadViewWithModel:(LoginModel*)model{
    _headerView = [[RRFMeInfoHeadView alloc]init];
    _headerView.iconUrl = model.icon.length> 0 ? model.icon:model.headimgurl;
    _headerView.frame = CGRectMake(0, 0, SCREENWidth, 75);
    self.tableView.tableHeaderView = _headerView;
    [_headerView addTarget:self action:@selector(addHeadIcon) forControlEvents:UIControlEventTouchUpInside];
}
-(void)settingTabelViewWithModel:(LoginModel*)model
{
    WEAKSELF
    NSString *name = model.cnName.length > 0 ? model.cnName:model.nickname;
    if (name.length == 0) {
        name = @"请填写名字";
    }
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"" title:@"名字" subTitle:name accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode1.itemClick = ^(){
        RRFModifyNameController *desc = [[RRFModifyNameController alloc]init];
        desc.title = @"名字";
        desc.name = name;
        [self.navigationController pushViewController:desc animated:YES];
    };
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"" title:@"喜腾号" subTitle:model.xtNumber accessoryType:UITableViewCellAccessoryNone descVc:nil];
    PZCommonCellModel *modelInvite = [PZCommonCellModel cellModelWithIcon:@"" title:@"我的二维码" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFInviteViewController class]];
    modelInvite.rightIcon = @"qr-code";
    
    PZCommonCellModel *mode3 = [PZCommonCellModel cellModelWithIcon:@"" title:@"个性签名" subTitle:model.selfSign accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode3.itemClick = ^(){
        RRFSignatureController *desc = [[RRFSignatureController alloc]init];
        desc.title = @"签名";
        desc.signStr = model.selfSign;
        [self.navigationController pushViewController:desc animated:YES];
    };
    NSString *sexStr =  [model.sex intValue]== 1?@"男":@"女";
    PZCommonCellModel *mode4 = [PZCommonCellModel cellModelWithIcon:@"" title:@"性别" subTitle:sexStr accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFChooseSexController class]];
    PZCommonCellModel *mode5 = [PZCommonCellModel cellModelWithIcon:@"" title:@"地区" subTitle:model.address accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode5.itemClick = ^(){
        [weakSelf selectedCity];
    };
    PZCommonCellModel *mode6 = [PZCommonCellModel cellModelWithIcon:@"" title:@"送货地址" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQAddressController class]];
    _allData = @[@[mode1,mode2,modelInvite,mode3],@[mode4,mode5,mode6]];

}
-(void)selectedCity
{
    WEAKSELF
    JNQSelectedDistrictController *selectController = [[JNQSelectedDistrictController alloc]init];
    selectController.modalPresentationStyle = UIModalPresentationCustom;
    self.animator = [[ZFModalTransitionAnimator alloc]initWithModalViewController:selectController];
    self.animator.dragable = NO;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1.0f;
    self.animator.behindViewScale = 0.9f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    selectController.transitioningDelegate = weakSelf.animator;
    [self presentViewController:selectController animated:YES completion:^{}];
    selectController.districtNameBlock = ^(NSString *districtName, NSInteger provinceId, NSInteger cityId){
        [RRFMeTool modifyUserAreaWithAddress:districtName Success:^(id json) {
            [MBProgressHUD showInfoWithStatus:@"修改成功"];
            [weakSelf requestUserInfo];
        } failBlock:^(id json) {
            
        }];
        [weakSelf.tableView reloadData];
    };
}
// 添加头像
-(void)addHeadIcon
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    } ];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         UIImagePickerController *imagePicker = [self createImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }];
    
    UIAlertAction *photoLIbraryAction = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
        UIImagePickerController *imagePicker = [self createImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoLIbraryAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
    
}
#pragma mark - 创建图片选择器
-(UIImagePickerController*)createImagePickerControllerWithType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self ;
    imagePickerController.allowsEditing = YES ;
    imagePickerController.sourceType = type ;
    return imagePickerController ;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [PZHttpTool postRequestWithUploadFile:@"upload" fileName:@"file" imageData:@[UIImageJPEGRepresentation(image, 0.001)] parmas:nil successBlock:^(id json) {
             NSString *iconUrl = json[@"head_img"];
            _headerView.iconUrl = iconUrl;
            [self updataIconimage:iconUrl];
            [XTChatUtil updateAvatar:image];
        }];
    }];
    
}
-(void)updataIconimage:(NSString *)urlStr
{
    if (urlStr.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请选择头像"];
        return;
    }
    [RRFMeTool modifyIconWithUrlStr:urlStr Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"修改成功"];
    } failBlock:^(id json) {
        
    }];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sec = _allData[section];
    return sec.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RRFMeInfoController"];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    if (model.rightIcon.length != 0) {
        UIView *accessoryView = [[UIView alloc]init];
        accessoryView.frame = CGRectMake(0, 0, 40, 20);
        UIImageView *rightView = [[UIImageView alloc]init];
        rightView.image = [UIImage imageNamed:model.rightIcon];
        rightView.frame = CGRectMake(3, 2.5, 15, 15);
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.alpha = 0.7;
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        arrowIcon.frame = CGRectMake(30, 4, 8, 13);
        [accessoryView addSubview:arrowIcon];
        
        [accessoryView addSubview:rightView];
        cell.accessoryView = accessoryView;
    }
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = model.accessoryType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    if (model.itemClick) {
        model.itemClick();
        return;
    }
    UIViewController *desc = [[model.descVc alloc]init];
    desc.title = model.title;
    [self.navigationController pushViewController:desc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUserInfo];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
@end
