//
//  CommentsHeadView.h
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFStar,PZTextView;
@interface RRFOrderCommentsHeadView : UIView
@property(nonatomic,weak)UIButton *submitBtn;
//@property(nonatomic,weak)UILabel *scoreLabel;
@property(nonatomic,weak)RRFStar *star;
@property(nonatomic,weak)PZTextView *contentV;

@property(nonatomic,assign)NSString *commentStr;

@end
