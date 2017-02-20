//
//  RRFRemarkViewController.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define headerHeight 250
#import "RRFRemarkViewController.h"
#import "HomePostCommentContent.h"
#import "STInputBar.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "TZImageManager.h"
#import "PZHttpTool.h"
#import "HomeTool.h"
#import "RRFRemarkView.h"
#import "RRFFreeBuyOrderTool.h"
#import "RRFFreeBuyOrderModel.h"
#import "ImageModel.h"
#import "RRFFreeBuyOrderViewController.h"
#import "RRFWiningOrderModel.h"
#import "RRFWiningOrderListController.h"
#import "RRFMeTool.h"
#import "RRFOrderListModel.h"
#import "RRFOrderListController.h"
#import "RRFWiningOrderListController.h"
@interface RRFRemarkViewController ()
@property(nonatomic,weak)HomePostCommentContent* headView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)STInputBar *inputBar;
@property(strong,nonatomic)NSMutableArray* pics ;
@property(strong,nonatomic) NSString* content ;
@property(strong,nonatomic)NSMutableArray* picUrls ;
@property(strong,nonatomic)NSMutableArray *currentAssets ;
@property(strong,nonatomic)NSMutableArray *currentImages ;
@property(strong,nonatomic)UIActivityIndicatorView* indicatorView ;
@end
@implementation RRFRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingUIView];
}
-(void)settingUIView
{
    WEAKSELF
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    
    HomePostCommentContent* headView = [[HomePostCommentContent alloc]init];
    headView.firendCircle = NO ;
    headView.frame = CGRectMake(0, 0, SCREENWidth, headerHeight);
    tableView.tableHeaderView = headView ;
    tableView.tableFooterView = [UIView new];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [headView.textView.rac_textSignal subscribeNext:^(id x) {
        weakSelf.content = x ;
    }];
    headView.tapPhotoHandler = ^(BOOL edit){
        if(self.picUrls.count >= 9){
            [MBProgressHUD showInfoWithStatus:@"最多选择9张"];
            return ;
        };
        [weakSelf didClickPicture:edit] ;
    };
    //删除
    headView.delItemHandler = ^(NSNumber* index){
        NSUInteger allCount = weakSelf.picUrls.count ;
        NSUInteger delIndex = [index intValue] ;
        if (delIndex <allCount) {
            [weakSelf.picUrls removeObjectAtIndex:delIndex];
//            [weakSelf.currentAssets removeObjectAtIndex:delIndex];
            [weakSelf.currentImages removeObjectAtIndex:delIndex];
        }
        
        //更新header高度
        CGFloat iconW = (SCREENWidth-40)/3;
        CGFloat deltaHeight = headerHeight ;
        NSInteger totalCount = weakSelf.picUrls.count + 1;
        if (totalCount >= 3) {
            NSInteger rows = (totalCount+3-1)/3 ;
            deltaHeight += (iconW+10) *(rows-1);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.headView.frame = CGRectMake(0, 0, SCREENWidth, deltaHeight);
            [weakSelf.tableView reloadData];
        });
    };
    self.headView = headView ;
    self.tableView.tableHeaderView = headView;
    
    
    RRFRemarkFootView *footerView = [[RRFRemarkFootView alloc]init];
    if(self.showOrderType == RRFShowOrderTypeFreeBuy){
        
        footerView.model = self.model;
    }else if (self.showOrderType == RRFShowOrderTypeGift){
        
        footerView.listModel = self.listModel;
    }else if (self.showOrderType == RRFShowOrderTypeWining){
        
        footerView.winingModel = self.winingModel;
    }
    footerView.frame = CGRectMake(0, 0, SCREENWidth, 230);
    self.tableView.tableFooterView = footerView;
    
    RRFRemarkFootBarView *footBar = [[RRFRemarkFootBarView alloc]init];
    footBar.comeInType = self.showOrderType;
    footBar.frame = CGRectMake(0, 0, SCREENWidth, 44);
    [self.view addSubview:footBar];
    [footBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    footBar.sendBlock = ^(NSNumber *num){
        int isSel = [num intValue];
        if(self.showOrderType == RRFShowOrderTypeFreeBuy){
            
            [weakSelf sendClickWith:isSel];
        }else if (self.showOrderType == RRFShowOrderTypeGift){
            
            [weakSelf giftOrderCommentWithIsSynchoron:isSel];
        }else if (self.showOrderType == RRFShowOrderTypeWining){
            
            [weakSelf winingOrderClickWith:isSel];
        }
    };
    
    STInputBar *inputBar = [STInputBar inputBar];
    [inputBar setFitWhenKeyboardShowOrHide:YES];
    inputBar.commonMode = YES ;
    inputBar.inputSender = self.headView.textView ;
    inputBar.inputSender.returnKeyType = UIReturnKeyDone;
    inputBar.takePhotoClickedHandler = ^(){
        [weakSelf didClickPicture:NO];
    };
    [self.view addSubview:inputBar];
    [inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(44);
    }];

}
-(UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view.center);
        }];
    }
    return _indicatorView ;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25 ;
}

#pragma mark - 取消
-(void)disMissController{
    [self.headView.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder] ;
        return NO;
    }
    return YES;
}

-(void)showPictureControllerWithEditMode:(BOOL)editMode SuccessBlock:(PZRequestSuccess)callBack{
    WEAKSELF
    TZImagePickerController *imagePickerVc = nil ;
    if (editMode) {
        imagePickerVc = [[TZImagePickerController alloc]initWithSelectedAssets:self.currentAssets selectedPhotos:self.currentImages index:0];
    }
    else{
        NSInteger limit = 9 - (self.currentImages.count) ;
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:limit delegate:weakSelf];
    }
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> * images, NSArray * assets, BOOL isSelectOriginalPhoto) {
        weakSelf.currentAssets = [[NSMutableArray alloc]initWithArray:assets] ;
        if (editMode) {
            weakSelf.currentImages = [NSMutableArray arrayWithArray:images] ;
            [weakSelf.picUrls removeAllObjects];
        }
        else{
            [weakSelf.currentImages addObjectsFromArray:images];
        }
        NSMutableArray* scaledImages = [NSMutableArray array];
        for (PHAsset* asset in assets) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            options.resizeMode = PHImageRequestOptionsResizeModeFast ;
            options.synchronous = YES ;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                NSString* imageType = [NSString typeForImageData:imageData];
                if (![imageType isEqualToString:@"image/gif"]) {
                    UIImage* img = [UIImage imageWithData:imageData];
                    img = [UIImage scaleImage:img scaleFactor:0.6];
                    imageData = UIImageJPEGRepresentation(img,0.5);
                }
                [scaledImages addObject:imageData];
            }];
        }
        
        [PZHttpTool postRequestWithUploadFile:@"uploads" fileName:@"file" imageData:scaledImages parmas:nil successBlock:^(id json) {
            callBack(weakSelf.currentImages);
            NSArray* imagesDic = (NSArray*)json;
            NSMutableArray* imageUrls = [NSMutableArray array];
            for (NSDictionary* d in imagesDic) {
                NSString* bigUrl = d[@"big_img"] ;
                NSString* head_img = d[@"head_img"] ;
                [imageUrls addObject:
                 @{
                   @"head_img":head_img,
                   @"big_img":bigUrl
                   }];
            }
            if (editMode) {
                //编辑模式
                weakSelf.picUrls = imageUrls;
            }else{
                [weakSelf.picUrls addObjectsFromArray:imageUrls];
            }
            //更新header高度
            CGFloat iconW = (SCREENWidth-40)/3;
            CGFloat deltaHeight = headerHeight ;
            NSInteger totalCount = weakSelf.picUrls.count + 1;
            if (totalCount >= 3) {
                NSInteger rows = (totalCount+3-1)/3 ;
                deltaHeight += (iconW+10) *(rows-1);
            }
            weakSelf.headView.frame = CGRectMake(0, 0, SCREENWidth, deltaHeight);
            [weakSelf.tableView reloadData];

//            dispatch_async(dispatch_get_main_queue(), ^{
//                            });
            [MBProgressHUD dismiss];
        }];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(NSMutableArray *)picUrls{
    if (_picUrls == nil) {
        _picUrls = [NSMutableArray array];
    }
    return _picUrls ;
}



-(NSMutableArray *)currentImages{
    if (_currentImages == nil) {
        _currentImages = [NSMutableArray array];
    }
    return _currentImages ;
}

#pragma mark - 点击图片
-(void)tapImage{
    if (self.currentImages.count > 0) {
        WEAKSELF
        [self showPictureControllerWithEditMode:YES SuccessBlock:^(NSArray* images) {
            [weakSelf addPic:images];
        }];
    }
}
// 中奖订单的评论
-(void)winingOrderClickWith:(int)isSel
{
    WEAKSELF
    NSString* content = self.content ;
    if (content.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请填写文字"];
        return ;
    }
    if(self.picUrls.count == 0){
        [MBProgressHUD showInfoWithStatus:@"请上传图片!"];
        return;
    };
    [MBProgressHUD show];
    [RRFFreeBuyOrderTool requestShowWiningOrderWithTradeOrderId:self.winingModel.tradeOrderId content:content isSynchoron:isSel pictures:self.picUrls Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"晒单成功!"];
        NSArray *controllers = weakSelf.navigationController.viewControllers;
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
        
    }];

}
#pragma mark - 0元夺宝订单发送评论
-(void)sendClickWith:(int)isSel{
    WEAKSELF
    NSString* content = self.content ;
    if (content.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请填写文字"];
        return ;
    }
    if(self.picUrls.count == 0){
        [MBProgressHUD showInfoWithStatus:@"请上传图片!"];
        return;
    };
    [MBProgressHUD show];
    [RRFFreeBuyOrderTool requestShowOrderWithBidOrderId:self.model.ID content:content isSynchoron:isSel pictures:self.picUrls Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"晒单成功!"];
        
        NSArray *controllers = weakSelf.navigationController.viewControllers;
        for (UIViewController *vc  in controllers) {
            if ([vc isKindOfClass:[RRFFreeBuyOrderViewController class]]) {
                if(weakSelf.isRefre){
                    weakSelf.isRefre(YES);
                }
                [weakSelf.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failBlock:^(id json) {
        
    }];
}

//#pragma mark - 礼品订单的评论
-(void)giftOrderCommentWithIsSynchoron:(int)isSynchoron
{
    WEAKSELF
    NSString* content = self.content ;
    if (content.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请填写文字"];
        return ;
    }
    if(self.picUrls.count == 0){
        [MBProgressHUD showInfoWithStatus:@"请上传图片!"];
        return;
    };
    [MBProgressHUD show];
    [RRFMeTool addCommentWithContent:content OrderId:self.listModel.ID  Score:10 ImageUrls:self.picUrls IsSynchoron:isSynchoron Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"评价成功!"];
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *vc  in controllers) {
            if ([vc isKindOfClass:[RRFOrderListController class]]) {
                if(weakSelf.isRefre){
                    weakSelf.isRefre(YES);
                }
                [weakSelf.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    } failBlock:^(id json) {
        
    }];
    
}

-(void)addPic:(NSArray*)images{
    [self.headView updateImages:images];
}


-(NSMutableArray *)pics{
    if (_pics == nil) {
        _pics = [NSMutableArray array];
    }
    return _pics ;
}

-(void)didClickPicture:(BOOL)edit{
    WEAKSELF
    [self showPictureControllerWithEditMode:edit SuccessBlock:^(NSArray* images) {
        [weakSelf addPic:images];
        [MBProgressHUD dismiss];
    }];
}

-(void)keyboardUp{
    [self.headView.textView becomeFirstResponder];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self keyboardUp];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD dismiss];
}
@end
