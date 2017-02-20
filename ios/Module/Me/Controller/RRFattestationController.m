//
//  RRFattestationController.m
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFattestationController.h"
#import "RRFattestationView.h"
#import "RRFFattestationWorkInfoControlle.h"
#import "UIImage+Image.h"
#import "PZHttpTool.h"
#import "RRFFattestationModel.h"
#import "UIViewController+ResignFirstResponser.h"
#import "PZTitleInputView.h"
#import "MBProgressHUD+HBProgresss.h"

@interface RRFattestationController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>

@property(nonatomic,weak)RRFattestationView *headView;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *imageUrls;


@end

@implementation RRFattestationController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    if (self.images == nil) {
        self.images = [[NSMutableArray alloc]init];
    }
    if (self.imageUrls == nil) {
        self.imageUrls = [[NSMutableArray alloc]init];
    }
    RRFattestationView *headView= [[RRFattestationView alloc]init];
    headView.nameLabel.vc = self;
    headView.noLabel.vc = self;
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    headView.fattestationBlock = ^(NSNumber *type){
        if ([type intValue] == 0) {
            // 选择图片
            [weakSelf addImage];
        }else{
            if (weakSelf.headView.nameStr.length == 0) {
                [MBProgressHUD showInfoWithStatus:@"请填写您的姓名"];
                return ;
            }
            NSString *card = weakSelf.headView.identityCardStr;
            if (card.length == 0 ) {
                [MBProgressHUD showInfoWithStatus:@"请输入您的身份证号"];
                return ;
            }
            if ([self isValidIDCard:card] == NO) {
                [MBProgressHUD showInfoWithStatus:@"请输入正确的身份证号"];
                return ;
            }
            if (weakSelf.imageUrls.count == 0) {
                [MBProgressHUD showInfoWithStatus:@"请上传手持身份证照片"];
                return ;
            }
            // 下一步
            RRFFattestationWorkInfoControlle *desc = [[RRFFattestationWorkInfoControlle alloc]init];
            RRFFattestationModel *mdoel = [[RRFFattestationModel alloc]init];
            mdoel.realName = weakSelf.headView.nameStr;
            mdoel.cardIdNumber = weakSelf.headView.identityCardStr;
            mdoel.cardIdImages = weakSelf.imageUrls;
            desc.title = @"认证";
            desc.model = mdoel;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }
    };
}

-(BOOL)isValidIDCard:(NSString*)card{
    return card.length==15 || card.length == 18 ;
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
-(void)uploadPic:(UIImage*)img successBlock:(PZRequestSuccess)callBack{
    WEAKSELF
    [PZHttpTool postRequestWithUploadFile:@"upload" fileName:@"file" imageData:@[UIImageJPEGRepresentation(img, 0.001)] parmas:nil successBlock:^(id json) {
        [weakSelf.imageUrls addObject:json[@"big_img"]];
        callBack(json);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignAll];
}
@end
