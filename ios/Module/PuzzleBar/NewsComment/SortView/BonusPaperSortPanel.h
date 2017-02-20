//
//  BonusPaperSortPanel.h
//  Puzzle
//
//  Created by huibei on 17/1/18.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BonusPaperSortPanel : UIView
-(instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data;
/** 箭头按钮点击回调 */
@property (nonatomic, copy) void(^arrowBtnClickBlock)();
/** 排序完成回调 */
@property (nonatomic, copy) void(^sortCompletedBlock)(NSMutableArray *channelList);
/** cell按钮点击回调 */
@property (nonatomic, copy) void(^cellButtonClick)(UIButton *button);
@end
