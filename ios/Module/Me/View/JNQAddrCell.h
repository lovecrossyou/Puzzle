//
//  RRFShippingAddressCell.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQAddressModel.h"
typedef void(^ReceiveAddrBlock)(int operate);
@interface JNQAddrCell : UITableViewCell

@property (nonatomic, strong) JNQAddressModel *addrModel;
@property (nonatomic, strong) ReceiveAddrBlock addrBlock;
@property(nonatomic,strong)UIButton *defaultBtn;

@end
