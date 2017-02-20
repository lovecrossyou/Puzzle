//
//  RRFFattestationWorkInfoControlle.m
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFattestationWorkInfoControlle.h"
#import "RRFFattestationWorkInfoView.h"
#import "RRFFattestationModel.h"
#import "UIImage+Image.h"
#import "PZHttpTool.h"
#import "RRFFattestationModel.h"
#import "RRFMeTool.h"
#import "UIViewController+ResignFirstResponser.h"
#import "RRFPersonalHomePageController.h"
#import "PZTextView.h"
#import "PZTitleInputView.h"
#import "MBProgressHUD+HBProgresss.h"

@interface RRFFattestationWorkInfoControlle ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>

@property(nonatomic,weak)RRFFattestationWorkInfoView *headView;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *imageUrls;
@end

@implementation RRFFattestationWorkInfoControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    if (self.images == nil) {
        self.images = [[NSMutableArray alloc]init];
    }
    if (self.imageUrls == nil) {
        self.imageUrls = [[NSMutableArray alloc]init];
    }
    WEAKSELF
    RRFFattestationWorkInfoView *headView = [[RRFFattestationWorkInfoView alloc]init];
    headView.nameLabel.vc = self;
    headView.workLabel.vc = self;
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    headView.fattestationWorkInfoBlock = ^(NSNumber *type){
        if ([type intValue] == 0) {
            // 添加图片
            [weakSelf addImage];
        }else{
            // 完成
            if (weakSelf.headView.workName.length == 0) {
                [MBProgressHUD showInfoWithStatus:@"请填写单位名称"];
                return;
            }
            if (weakSelf.headView.positionName.length == 0) {
                [MBProgressHUD showInfoWithStatus:@"请填写您的职位"];
                return ;
            }
            if (weakSelf.imageUrls.count == 0) {
                [MBProgressHUD showInfoWithStatus:@"请上传您的从业资格证照片"];
                return ;
            }
            if ([weakSelf.headView.infoView getText].length == 0) {
                [MBProgressHUD showInfoWithStatus:@"请填写个人简介,让小伙伴们对你有更多了解!"];
                return ;
            }
            self.model.jobName = weakSelf.headView.positionName;
            self.model.companyName = weakSelf.headView.workName;
            self.model.descriptionStr =[weakSelf.headView.infoView getText];
            self.model.professionalImages = weakSelf.imageUrls;
            [weakSelf applicationReview];
        }
    };
    
}
-(void)applicationReview
{
    [MBProgressHUD show];
    [RRFMeTool applicationReviewWithModel:self.model  Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"认证成功"];
        for (UIViewController *desc in self.navigationController.childViewControllers) {
            if ([desc isKindOfClass:[RRFPersonalHomePageController class]]) {
                [self.navigationController popToViewController:desc animated:YES];
            }
        }
    } failBlock:^(id json) {
        
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignAll];
}
// 添加图片
-(void)addImage
{
    [self resignAll];
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
    image = [UIImage scaleImage:image scaleFactor:0.5];
    [self addPic:image];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}
-(void)uploadPic:(UIImage*)img successBlock:(PZRequestSuccess)callBack{
    WEAKSELF
    [PZHttpTool postRequestWithUploadFile:@"upload" fileName:@"file" imageData:@[UIImageJPEGRepresentation(img, 0.001)] parmas:nil successBlock:^(id json) {
        [weakSelf.imageUrls addObject:json[@"big_img"]];
        callBack(json);
    }];
}

-(void)addPic:(UIImage*)image{
    [self uploadPic:image successBlock:^(id json) {
        [self.images addObject:image];
        [self.headView.imageContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        UIImageView* lastImageView ;
        for (UIImage* img in self.images) {
            UIImageView* imageView = [[UIImageView alloc]init];
            imageView.image = img ;
            [self.headView.imageContentView addSubview:imageView];
            if (lastImageView != nil) {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.centerY.mas_equalTo(self.headView.imageContentView.mas_centerY);
                    make.left.mas_equalTo(lastImageView.mas_right).offset(6);
                }];
            }
            else{
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(70, 70));
                    make.centerY.mas_equalTo(self.headView.imageContentView.mas_centerY);
                    make.left.mas_equalTo(82);
                }];
            }
            lastImageView = imageView ;
        }
    }];
}



@end
