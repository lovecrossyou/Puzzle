//
//  HBWebController.h
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZWebController : UIViewController
@property(copy,nonatomic) NSString* pathUrl ;
@property(nonatomic,strong)NSDictionary *param;
@property(copy,nonatomic) NSString* fileName ;
@property(assign,nonatomic)BOOL share;
@property(assign,nonatomic)BOOL hiddenTitle;
@property(assign,nonatomic)BOOL hiddenNav;

@end
