//
//  JNQFrendsCircleCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQFriendCircleModel.h"
@class JNQFriendsCircleCell;



typedef void(^FriendCircleCellBlock)(JNQFriendsCircleCell *cell);

@interface JNQFriendsCircleCell : UITableViewCell

@property (nonatomic, strong) JNQFriendCircleModel *friendCircleModel;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, strong) FriendCircleCellBlock cellBlock;
@end
