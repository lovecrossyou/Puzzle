//
//  HomePostCommentController.m
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define ImageSize 72
#import "HomePostCommentController.h"
#import "HomePostCommentContent.h"
#import "STInputBar.h"
#import "HomeTool.h"
#import "GameModel.h"
#import "PZHttpTool.h"
#import "UIImage+Image.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "TZImageManager.h"
#import "PZReactUIManager.h"
@interface HomePostCommentController ()<TZImagePickerControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong) STInputBar *inputBar;
@property(weak,nonatomic)HomePostCommentContent* headView ;
@property(strong,nonatomic)NSMutableArray* pics ;

@property(strong,nonatomic) NSString* content ;
@property(strong,nonatomic)NSMutableArray* picUrls ;

@property(strong,nonatomic)NSMutableArray *currentAssets ;
@property(strong,nonatomic)NSMutableArray *currentImages ;
@property(strong,nonatomic)UIActivityIndicatorView* indicatorView ;


@end

@implementation HomePostCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
  UIView* rootView = [PZReactUIManager createWithPage:@"send_comment" params:nil size:CGSizeZero];
  self.view = rootView ;
  
  return;
    WEAKSELF
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.title = @"评论";
    //nav
    UIBarButtonItem* sendItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    if (self.dismissModel) {
        UIBarButtonItem* cencelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(disMissController)];
        self.navigationItem.leftBarButtonItem = cencelItem;
    }
    
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    
    HomePostCommentContent* headView = [[HomePostCommentContent alloc]init];
    headView.firendCircle = self.firendCircle ;
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight - 64);
    tableView.tableHeaderView = headView ;
    tableView.tableFooterView = [UIView new];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [headView.textView.rac_textSignal subscribeNext:^(id x) {
        weakSelf.content = x ;
    }];
    headView.tapPhotoHandler = ^(BOOL edit){
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
    };
    self.headView = headView ;
   
    _inputBar = [STInputBar inputBar];
    [_inputBar setFitWhenKeyboardShowOrHide:YES];
    _inputBar.commonMode = YES ;
    _inputBar.inputSender = self.headView.textView ;
    _inputBar.inputSender.returnKeyType = UIReturnKeyDone;
    _inputBar.takePhotoClickedHandler = ^(){
        [weakSelf didClickPicture:NO];
    };
    [self.view addSubview:_inputBar];
    [_inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(44);
    }];
}


-(void)refreshComment{
    if (self.indexM != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFMViewController object:nil];
    }
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
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:limit delegate:self];
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
            }
            else{
                [weakSelf.picUrls addObjectsFromArray:imageUrls];
            }
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

#pragma mark - 发送评论
-(void)sendClick{
    int stockGameId = 0 ;
    if (self.indexM != nil) {
        stockGameId = self.indexM.stockGameId ;
    }
    NSString* content = self.content ;
    if (content.length == 0 && self.picUrls.count == 0) {
        return ;
    }
    WEAKSELF
    [MBProgressHUD show];
    [HomeTool addCommentWithStockId:stockGameId imgs:self.picUrls content:content successBlock:^(id json) {
        [MBProgressHUD dismiss];
        if (weakSelf.isRefre) {
            weakSelf.isRefre(YES);
        }
        if (weakSelf.dismissModel) {
            [weakSelf disMissController];
        }
        else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
//        [weakSelf refreshComment];
        [MBProgressHUD showInfoWithStatus:@"发布成功!"];
    } fail:^(id json) {
        [MBProgressHUD dismiss];
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
    [self keyboardUp];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];

//    [MBProgressHUD dismiss];
}



@end
