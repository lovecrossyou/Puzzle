//
//  PZNewsWebController.h
//  Puzzle
//
//  Created by huibei on 16/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseViewController.h"
@class PZNewsCellModel ;
@interface PZNewsWebController : PZBaseViewController
@property(strong,nonatomic)PZNewsCellModel* model ;
@property(nonatomic,strong)NSDictionary *param;
@property(copy,nonatomic) NSString* fileName ;
@end
