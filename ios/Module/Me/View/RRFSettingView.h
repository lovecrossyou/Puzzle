//
//  RRFSettingView.h
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFModifyPwdView : UIView
@property (nonatomic, strong) NSString *oldPwdStr;
@property (nonatomic, strong) NSString *firshPwdStr;
@property (nonatomic, strong) NSString *secondPwdStr;
@property(nonatomic,copy)ItemClickBlock updatePwdBlock;
@end


@interface RRFSettingFootView : UIView
@property(nonatomic,weak)UIButton *editBtn;
@end


@interface RRFSettingView : UIView

@end
