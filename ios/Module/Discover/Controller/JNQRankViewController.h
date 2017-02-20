//
//  JNQRankViewController.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, RankViewType) {
//    RankViewTypeCurrent = 1,        //本期
//    RankViewTypePrior   = 2         //上期
//};



@interface JNQRankViewController : UIViewController

@property (nonatomic, assign) RankViewType rankViewType;
@property (nonatomic, assign) RankType rankType;

@end
