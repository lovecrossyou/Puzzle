//
//  RRFReplyListController.h
//  Puzzle
//
//  Created by huibei on 16/9/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseViewController.h"

@interface RRFReplyListController : PZBaseViewController
@property(nonatomic,assign) NSInteger commentId;
@property(nonatomic,strong) NSString *commentName;
@property(nonatomic,assign) BOOL showCancel ;
@property(nonatomic,assign) RRFCommentDetailInfoType viewType;
@end
