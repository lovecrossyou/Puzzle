//
//  RedPaperHeader.h
//  Puzzle
//
//  Created by huibei on 17/1/11.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPaperHeader : UIView
@property(copy,nonatomic) void(^sendRedPaperBlock)(NSInteger count,NSInteger singleAmount,NSInteger totalAmount,NSString* bonusType,NSString* desInfo,NSString* place);
//人数
@property (nonatomic, strong) id<UITextFieldDelegate> vc;
-(instancetype)initWithSingle:(BOOL)single count:(NSInteger)count;
@end
