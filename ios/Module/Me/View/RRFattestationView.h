//
//  RRFattestationView.h
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFFattestationModel,PZTitleInputView;
@interface RRFattestationView : UIView
@property(nonatomic,weak)PZTitleInputView *nameLabel;
@property(nonatomic,weak)PZTitleInputView *noLabel;

@property(nonatomic,weak)UIView *imageContentView;

@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *identityCardStr;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)RRFFattestationModel *mdoel;
@property(nonatomic,copy)ItemClickParamBlock fattestationBlock;
@end
