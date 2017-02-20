//
//  HomePostCommentController.h
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZBaseViewController.h"
@class GameModel ;
@interface HomePostCommentController : PZBaseViewController
@property(nonatomic,copy)ControllerRefreBlock isRefre;
@property(strong,nonatomic)GameModel* indexM ;

@property(assign,nonatomic) BOOL dismissModel;
@property(assign,nonatomic) BOOL firendCircle;

@end
