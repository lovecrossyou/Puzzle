//
//  RRFCreatAddressView.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZTitleInputView.h"
#import "RRFSettingDefaultView.h"
#import "JNQAddressModel.h"

@interface JNQAddressOperateView : UIView
@end


@interface JNQAddressOperateHeaderView : UIView

@property (nonatomic, strong) PZTitleInputView *nameView;
@property (nonatomic, strong) PZTitleInputView *phoneView;
@property (nonatomic, strong) PZTitleInputView *addressView;
@property (nonatomic, strong) PZTitleInputView *detailInfoView;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, strong) RRFSettingDefaultView *settingView;

@property(nonatomic,copy)ItemClickBlock chooseContactBlock;
@property(nonatomic,copy)ItemClickBlock chooseAddressBlcok;
@property (nonatomic, strong) JNQAddressModel *addrModel;
@property (nonatomic, strong) id<UITextFieldDelegate> vc;
@property(nonatomic,assign)BOOL hiddenDefault;
@property(nonatomic,assign)BOOL showTitle;

@end
