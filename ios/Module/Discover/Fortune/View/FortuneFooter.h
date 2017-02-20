//
//  FortuneFooter.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FortuneFooter : UIView
@property(copy,nonatomic)void(^computeFortune)(FortuneFooter* footer);
-(void)doAnimateRotate;
-(void)stopAnimateRotate;
@property(strong,nonatomic) UIView* rootView ;
@end
