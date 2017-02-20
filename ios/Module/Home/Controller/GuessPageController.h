//
//  GuessPageController.h
//  Puzzle
//
//  Created by huipay on 2016/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameModel ,StockDetailModel;
@interface GuessPageController : UITableViewController
@property(assign,nonatomic)int guessType ;
@property(strong,nonatomic)GameModel* indexM ;
//@property(strong,nonatomic)StockDetailModel* stockDetailModel; ;

@end
