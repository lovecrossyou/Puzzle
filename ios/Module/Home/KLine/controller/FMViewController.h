//
//  FMViewController.h
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameModel ,StockDetailModel;


@interface FMViewSectionView : UIView
@property(strong,nonatomic)StockDetailModel* stockDetailM ;
@end


@interface FMViewController : UIViewController
@property(strong,nonatomic)GameModel* indexM ;


@end
