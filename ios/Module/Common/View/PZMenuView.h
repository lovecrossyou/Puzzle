//
//  PZMenuView.h
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZMenuView : UIView
@property(assign,nonatomic) CGFloat itemHeight ;
@property(copy,nonatomic)ItemClickParamBlock rankTypeBlock ;
-(void)setTitles:(NSArray *)titles fontSize:(CGFloat)size;
@end
