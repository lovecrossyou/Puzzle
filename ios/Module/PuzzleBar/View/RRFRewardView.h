//
//  RRFRewardView.h
//  Puzzle
//
//  Created by huibei on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
typedef void (^RewardBlock)(int selNum);
#import <UIKit/UIKit.h>

@interface RRFRewardView : UIView
-(instancetype)initWithJSONData:(id)json;
@property(nonatomic,strong)NSArray *rewardArray;
@property(nonatomic,copy)RewardBlock rewardBlock;
-(void)setInputNum:(NSString*)num;
@end
