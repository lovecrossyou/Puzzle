//
//  RRFBFriendController.h
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
#import "InviteBonusesModel.h"

typedef NS_ENUM(NSInteger, BFriendViewType) {
    BFriendViewTypeSelf    = 1,       //支付钻石
    BFriendViewTypeOther   = 2        //兑换喜腾币
};

@interface RRFBFriendController : PZBaseTableViewController

@property (nonatomic, strong) InviteBonuses *model ;
@property (nonatomic, assign) BFriendViewType viewType;

@end
