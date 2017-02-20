//
//  PZVerticalButton.h
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalTextButton : UIControl
-(instancetype)initWithTitle:(NSString*)title subTitle:(NSString*)subtitle;
-(instancetype)initWithHorizonTitle:(NSString*)title subTitle:(NSString*)subtitle;
-(void)setBackViewColor:(UIColor*)color;
@end

@interface PZVerticalButton : UIButton
@end


