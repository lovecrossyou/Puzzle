//
//  ChartCommentCell.h
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFCommentsCellModel ;
@interface ChartCommentCell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(RRFCommentsCellModel*)m;
@property(copy,nonatomic)ItemClickParamBlock toolBarBlock;

@end
