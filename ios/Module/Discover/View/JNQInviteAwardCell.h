//
//  JNQInviteAwardCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InviteBonuses,InviteBaseModel ;
@interface JNQInviteAwardCell : UITableViewCell
@property(strong,nonatomic)InviteBonuses* model ;
@property(strong,nonatomic)InviteBaseModel* baseModel ;

@property (nonatomic, strong) UIButton *awardLabel;

@end
