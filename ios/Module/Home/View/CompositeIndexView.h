//
//  CompositeIndexView.h
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameModel ;
@interface CompositeIndexView : UIControl
@property(weak,nonatomic)UIButton* leftBetGo ;
@property(weak,nonatomic)UIButton* rightBetGo ;

-(instancetype)initWithStock:(GameModel*)stockM;
-(void)updateStockData:(GameModel*)stockModel;

@end
