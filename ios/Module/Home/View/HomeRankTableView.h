//
//  HomeRankTableView.h
//  Puzzle
//
//  Created by huipay on 2016/10/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRankTableView : UIView
@property(copy,nonatomic)ItemClickParamBlock rankBlock;
@property(copy,nonatomic)ItemClickBlock prizeBlock;
-(void)refreshUI ;
@end
