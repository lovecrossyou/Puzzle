//
//  PZTextView.h
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZTextView : UIView
@property(strong,nonatomic)RACSignal* signal ;
@property(weak,nonatomic)UITextView* textView ;
@property(strong,nonatomic)UILabel *placeHolderView;
-(instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder;
-(instancetype)initWithPlaceHolder:(NSString*)placeHolder;
-(NSString*)getText;
-(void)setText:(NSString*)text;
-(void)setPlaceHolder:(NSString*)placeHolder;
@end
