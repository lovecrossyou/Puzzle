// Created by huibei on 16/7/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RegisteredBlock)(NSString *checkCode);
@class PZTimerCountView;
@interface RRFResetPwdView : UIView

@property(nonatomic,weak)PZTimerCountView* btnSendVerifyCode;
@property(nonatomic,copy)RegisteredBlock regiseBlock;
-(void)setPwdViewHidden:(BOOL)hidden;
-(void)settingPhoneNum:(NSString *)phoneNum;
@end
