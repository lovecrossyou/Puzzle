//
//  PZNewsWebCommentView.h
//  Puzzle
//
//  Created by huipay on 2017/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZNewsCommentView:UIView

@end
@interface PZNewsWebCommentView : UIView
@property(nonatomic,copy)ItemClickBlock moreBlock;
-(CGFloat)getHeightWtihCommentList:(NSArray *)commentList;
@end
@interface PZNewsShareView :UIView
@property(nonatomic,copy)ItemClickParamBlock shareBlock;
@end
