//
//  VerifyFriendCell.h
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRFDetailInfoModel.h"

@interface VerifyFriendCell : UITableViewCell
@property(strong,nonatomic)RRFDetailInfoModel* contact ;
@property(copy,nonatomic)ItemClickBlock itemClock;
@end
