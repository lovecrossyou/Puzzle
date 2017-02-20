//
//  RRFRespToRespListModel.h
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFRespToRespListModel : NSObject
@property(nonatomic,strong)NSString *noStr;
//回复回复的用户名
@property(nonatomic,strong)NSString *respTorespUserName;

// 回复的回复的内容
@property(nonatomic,strong)NSString *respTorespContent;
@end
