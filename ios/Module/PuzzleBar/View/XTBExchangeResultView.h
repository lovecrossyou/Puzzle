//
//  XTBExchangeResultView.h
//  Puzzle
//
//  Created by huibei on 16/10/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTBExchangeResultView : UIView
-(instancetype)initWithJson:(id)resultJson;
@property(copy,nonatomic)ItemClickParamBlock confirmBlock;
@end
