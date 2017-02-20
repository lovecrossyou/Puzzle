//
//  BetResultView.h
//  Puzzle
//
//  Created by huibei on 16/10/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameModel;
@interface BetResultView : UIView
@property(nonatomic,copy)ItemClickBlock closeClick;
-(instancetype)initWithModel:(GameModel *)model type:(int)guessType amount:(NSString *)amount;
@end
