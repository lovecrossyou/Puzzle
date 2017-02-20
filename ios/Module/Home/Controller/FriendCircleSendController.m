//
//  FriendCircleSendController.m
//  Puzzle
//
//  Created by huibei on 16/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FriendCircleSendController.h"
#import "FriendCircleHeader.h"
#import "HomeTool.h"
#import "PZHttpTool.h"
#import "UIImage+Image.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "TZImageManager.h"
@interface FriendCircleSendController ()
@property(weak,nonatomic)FriendCircleHeader* headerView ;
@property(strong,nonatomic)NSMutableArray* pics ;

@property(strong,nonatomic) NSString* content ;
@property(strong,nonatomic)NSMutableArray* picUrls ;

@property(strong,nonatomic)NSMutableArray *currentAssets ;
@property(strong,nonatomic)NSMutableArray *currentImages ;
@end

@implementation FriendCircleSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.view.backgroundColor = HBColor(243, 243, 243);
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = HBColor(243, 243, 243);
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    FriendCircleHeader* headerView = [[FriendCircleHeader alloc]init];
    headerView.addBlock = ^(id obj){
        
    };
    
    headerView.delBlock = ^(NSNumber* index){
        int i = [index intValue] ;
        if (weakSelf.picUrls.count -1 >= i) {
            [weakSelf.currentImages removeObjectAtIndex:i];
            [weakSelf.picUrls removeObjectAtIndex:i];
        }
    };
    
    headerView.broswerBlock = ^(id obj){
        [weakSelf didClickPicture:NO];
    };
    
    self.headerView = headerView ;
    self.headerView.userInteractionEnabled = YES ;
    headerView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
    tableView.tableHeaderView = headerView ;
    
    [self settingNavItem];
    
}

-(void)settingNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"发送" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
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



#pragma mark - 发表
-(void)share:(UIButton*)sender
{
    WEAKSELF
    NSString* content = [self.headerView getContent];
    if (content.length == 0 && self.picUrls.count == 0) {
        [MBProgressHUD showInfoWithStatus:@"内容不能为空！"];
        return ;
    }
    BOOL syncState = [self.headerView syncState];
    [MBProgressHUD show];
    [HomeTool addFriendCircleCommentWithContent:content imgs:self.picUrls isSynchroniz:syncState successBlock:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"发布成功！"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (self.isRefre) {
            self.isRefre(YES);
        }
    } fail:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

-(void)didClickPicture:(BOOL)edit{
    WEAKSELF
    [self showPictureControllerWithEditMode:edit SuccessBlock:^(NSArray* images) {
        [weakSelf addPic:images];
        [MBProgressHUD dismiss];
    }];
}


-(void)addPic:(NSArray*)images{
    [self.headerView updateImages:images];
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
                    imageData = UIImageJPEGRepresentation(img,0.0001);
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
        }];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


@end
