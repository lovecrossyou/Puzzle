//
//  RRFFattestationWorkInfoView.h
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PZTextView,PZTitleInputView;
@interface RRFFattestationWorkInfoView : UIView
@property(nonatomic,weak)PZTitleInputView *nameLabel;;
@property(nonatomic,weak)PZTitleInputView *workLabel;;
@property(nonatomic,weak)PZTextView *infoView;;
@property(nonatomic,weak)UIView *imageContentView;

@property(nonatomic,strong)NSString *workName;
@property(nonatomic,strong)NSString *positionName;
@property(nonatomic,copy)ItemClickParamBlock fattestationWorkInfoBlock;
@end
