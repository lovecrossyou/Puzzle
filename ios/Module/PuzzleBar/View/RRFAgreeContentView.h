//
//  RRFAgreeContentView.h
//  Puzzle
//
//  Created by huipay on 2016/12/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RRFAgreeContentView : UIView
-(CGFloat)contentHeightWithAgreeArray:(NSArray *)agreeArray rewardArray:(NSArray *)rewardArray commentArray:(NSArray *)commentArray type:(RRFCommentDetailInfoType)type indexPath:(NSIndexPath *)indexPath;
@end
@interface RRFAgreeContentCell : UIView

@end
@interface RRFCommentContentCell : UIView

@end
