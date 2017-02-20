//
//  FortuneHeader.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginModel ;
@interface FortuneHeader : UIView
@property(copy,nonatomic) void(^MemberCenterBlock)();
-(void)configHeader:(LoginModel* )userM;
-(void)update:(NSDictionary*)data;
@end
