//
//  FortuneWebController.h
//  Puzzle
//
//  Created by huibei on 16/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FortuneWebController : UIViewController
@property(copy,nonatomic) NSString* pathUrl ;
@property(nonatomic,strong)NSDictionary *param;
@property(copy,nonatomic) NSString* fileName ;
@property(assign,nonatomic)BOOL share;
@property(assign,nonatomic)BOOL hiddenTitle;
@end
