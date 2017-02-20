//
//  RRFJoinView.h
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PZTitleInputView,RRFApplyDelegaterModel;
@interface RRFJoinView : UIView
@property(nonatomic,strong)RRFApplyDelegaterModel *delegaterModel;
@property(nonatomic,weak)PZTitleInputView *areaLabel ;
@property(nonatomic,copy)ItemClickParamBlock applyForBlock;

-(void)keyboardUp;
@end
