//
//  RRFCommentInputView.h
//  Puzzle
//
//  Created by huibei on 16/10/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFCommentInputView : UIControl
-(instancetype)initWithTitle:(NSString*)title redPaper:(BOOL)redPaper;
@property(copy,nonatomic)void(^redPaperBlock)();
@end
