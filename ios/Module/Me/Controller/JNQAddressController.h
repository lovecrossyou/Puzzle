//
//  RRFShippingAddressController.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

@class JNQAddressModel;
typedef NS_ENUM(NSInteger, PZAddrViewType) {
    PZAddrViewTypeNormal = 1,    //我的收货地址过来的
    PZAddrViewTypeSelect = 2      //从订制礼盒过来的
};

typedef void (^AddrSelectBlock)(JNQAddressModel *addrModel);

@interface JNQAddressController : UITableViewController

@property (nonatomic, assign) PZAddrViewType viewType;
@property (nonatomic, strong) AddrSelectBlock selectBlock;

@end
