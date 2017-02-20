//
//  BetCompletePopController.h
//  Puzzle
//
//  Created by huipay on 2016/10/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameModel ;
@interface BetCompletePopController : UIViewController
@property(strong,nonatomic)GameModel* stockDetailModel ;
@property(assign,nonatomic)int guessType ;
@property(strong,nonatomic)NSString* amount ;
@property(copy,nonatomic)ItemClickBlock popViewBlock;
@property(assign,nonatomic)BOOL praise ;
@end
