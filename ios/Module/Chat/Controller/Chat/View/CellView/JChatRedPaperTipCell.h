//
//  JChatRedPaperTipCell.h
//  Puzzle
//
//  Created by huibei on 17/1/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCHATChatModel;
@protocol RedPaperTipDelegate <NSObject>
-(void)didClickRedPaperTip:(JCHATChatModel*)model;
@end

@interface JChatRedPaperTipCell : UITableViewCell
-(void)setCellData:(JCHATChatModel *)model delegate:(id<RedPaperTipDelegate>)delegate;
@end
