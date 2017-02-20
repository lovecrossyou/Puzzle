//
//  PraiseResultView.h
//  Puzzle
//
//  Created by huipay on 2016/10/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseResultView : UIView
-(instancetype)initWithNumble:(NSString *)num;
@property(nonatomic,copy)ItemClickBlock closeClick;
@end
