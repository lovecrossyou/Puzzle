//
//  RRFMeView.h
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginModel ;
@interface RRFMeView : UIControl

@property(weak,nonatomic)UIButton* bindingPhoneBtn ;
-(instancetype)initWithUserInfo:(LoginModel*)userInfo;
@end
