//
//  FBPublicListCell.h
//  Puzzle
//
//  Created by huibei on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"

@interface FBPublicListCell : UITableViewCell
// 获取table view cell 的indexPath
@property (nonatomic, weak) NSIndexPath *m_indexPath;
@property (nonatomic)       BOOL         m_isDisplayed;

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath;
@end
