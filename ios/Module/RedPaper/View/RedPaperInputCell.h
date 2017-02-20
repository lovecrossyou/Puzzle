//
//  RedPaperInputCell.h
//  Puzzle
//
//  Created by huibei on 17/1/18.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPaperInputCell : UIView
@property(strong,nonatomic)RACSignal* textSignal;
@property(copy,nonatomic) NSString* valueString ;
-(instancetype)initWithTitle:(NSString*)title unitStr:(NSString*)unitStr placeHolder:(NSString*)placeholder;
@end
