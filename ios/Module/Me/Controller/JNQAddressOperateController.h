//
//  RRFCreatAddressController.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddressModel.h"
typedef NS_ENUM(NSInteger, AddressViewType) {
    AddressViewTypeCreate     = 1,      //新建
    AddressViewTypeEdit     = 2         //编辑
};

@interface JNQAddressOperateController : UITableViewController

@property (nonatomic, assign) AddressViewType viewType;
@property (nonatomic, strong) JNQAddressModel *addrModel;
@property (nonatomic, strong) ReloadBlock shouldReload;

@end
