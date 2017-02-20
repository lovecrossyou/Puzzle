//
//  PTChooseAddrCell.h
//  PrivateTeaStall
//
//  Created by HuHuiPay on 16/6/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CommonTableViewCell.h"
@class JNQAddressModel;
@interface PZChooseAddrCell : CommonTableViewCell
@property(nonatomic,copy) ButtonBlock btnClick;
@property(nonatomic,strong)JNQAddressModel *addrModel;
@property (nonatomic, strong) UIButton *chooseBtn;
@end
