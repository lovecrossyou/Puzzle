//
//  CommentKeyboard.h
//  Puzzle
//
//  Created by huipay on 2016/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentKeyboard : UIView
-(instancetype)initWithPlaceholder:(NSString *)placeholder commentCount:(NSString *)count;
- (void)sendClicked:(void(^)(NSString *text))handler;
- (void)shareHandle:(void(^)())handler;
- (void)commentHandle:(void(^)())handler;

@end
