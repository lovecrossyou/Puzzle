//
//  JChatRedPaperCell.h
//  Puzzle
//
//  Created by huibei on 17/1/13.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCHATChatModel ;

@protocol RedPaperDelegate <NSObject>
-(void)didClickRedPaper:(JCHATChatModel*)model;
-(void)clickAvatar:(JCHATChatModel*)model;
@end

@interface JChatRedPaperCell : UITableViewCell
- (void)setCellData:(JCHATChatModel *)model delegate:(id <RedPaperDelegate>)delegate;
- (void)layoutAllView ;
@end
