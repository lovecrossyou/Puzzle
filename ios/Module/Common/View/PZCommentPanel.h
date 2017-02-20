//
//  PZCommentPanel.h
//  Puzzle
//
//  Created by huipay on 2016/10/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZCommentPanel : UIView
@property(copy,nonatomic)ItemClickParamBlock sendMsgBlock ;


-(instancetype)initWithTitle:(NSString*)title targetView:(UIView*)target;
-(void)keyboardUp;
-(void)keyboardDown;

@end
