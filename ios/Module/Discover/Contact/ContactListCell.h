//
//  ContactListCell.h
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZContact.h"
#import "RRFDetailInfoModel.h"
#import "SWTableViewCell.h"

@interface ContactListCell : SWTableViewCell
@property(strong,nonatomic)PZContact* contact ;
@property(strong,nonatomic)RRFDetailInfoModel* circleContact ;

@property(copy,nonatomic)ItemClickBlock itemClock;
@property(copy,nonatomic)ItemClickBlock headClock;

@property(assign,nonatomic) BOOL myCircle ;
@end
