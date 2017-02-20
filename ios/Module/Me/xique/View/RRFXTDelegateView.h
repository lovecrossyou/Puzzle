//
//  RRFXTDelegateView.h
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFXTDelegateInfoModel;
@interface RRFXTDelegateView : UIView

@end

@interface RRFXTDelegateHeaderView : UIView
@property(nonatomic,strong)RRFXTDelegateInfoModel *model;
@property(nonatomic,copy)ItemClickParamBlock XTDelegateHeaderBlock;
@end

@interface RRFXTDelegateFootBarView : UIView
-(void)setNumber:(NSString *)numberStr;
@end
