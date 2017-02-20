//
//  PZBetCurrency.h
//  Puzzle
//
//  Created by huipay on 2016/10/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetsLabel.h"
@interface PZBetCurrency : UIView
@property(strong,nonatomic)InsetsLabel* textLabel ;
@property(strong,nonatomic)UILabel* subLabel ;
@property(strong,nonatomic)UIImageView* imageCurrency ;
-(instancetype)initWithTitle:(NSString*)title imageLeft:(BOOL)left;
-(instancetype)initWithMidImageTitle:(NSString*)title  subtitle:(NSString*)subtitle;
@end
