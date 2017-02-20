//
//  PayPasswordPanel.h
//  Puzzle
//
//  Created by huipay on 2016/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPasswordPanel : UIView
-(instancetype)initWithPwdCount:(int)count completeBlock:(ItemClickParamBlock)callBack;
-(void)keyboardUp;
@end
