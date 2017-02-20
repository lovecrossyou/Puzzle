//
//  RRFRewardController.h
//  Puzzle
//
//  Created by huibei on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFRewardController : UIViewController
//打赏该评论的用户id
@property(nonatomic,assign)NSUInteger userId;
//打赏评论id
@property(nonatomic,assign)NSUInteger entityId;
// 数据的类型
@property(nonatomic,strong)NSString * entityType;
@end
