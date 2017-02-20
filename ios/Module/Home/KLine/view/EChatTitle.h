//
//  EChatTitle.h
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EChatTitle : UIView
-(instancetype)initWithTitle:(NSString*)title value:(NSString*)value;
-(instancetype)initWithTitle:(NSString *)title value:(NSString*)value attr:(NSDictionary *)attr;
@end
