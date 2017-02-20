//
//  RRFMyFriendCell.h
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteBonusesModel.h"

@interface RRFMyFriendCell : UITableViewCell

@property(strong,nonatomic)InviteBonuses* model ;
@property(strong,nonatomic)InviteBaseModel* baseModel;

@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isBot;
@property (nonatomic, copy) ItemClickBlock clickBlock;
@property(nonatomic,copy)ItemClickBlock headerBlock ;
@end
