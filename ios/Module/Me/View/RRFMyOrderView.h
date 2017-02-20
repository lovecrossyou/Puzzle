//
//  RRFMyOrderView.h
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RRFMyOrderButton :UIControl
-(instancetype)initWithTitle:(NSString *)title iconStr:(NSString *)iconStr;
-(void)hiddenNumBtn:(BOOL)hidden;
-(void)setNumber:(int)number;
@end


@interface RRFGiftOrderView : UIView
@property(nonatomic,copy)ItemClickParamBlock giftOrderBlock;
-(void)setPresentWaitEvaluateCount:(int)presentWaitEvaluateCount presentWaitReceiveCount:(int)presentWaitReceiveCount presentWaitSendCount:(int)presentWaitSendCount;
@end

@interface RRFBidOrderView : UIView
@property(nonatomic,copy)ItemClickParamBlock bidOrderBlock;
-(void)setBidOrderWaitAcceptCount:(int)bidOrderWaitAcceptCount bidOrderWaitEvaluateCount:(int)bidOrderWaitEvaluateCount bidOrderWaitLotteryCount:(int)bidOrderWaitLotteryCount;

@end

@interface RRFWinningOrderView : UIView
@property(nonatomic,copy)ItemClickParamBlock winningOrderBlock;
-(void)setWiningOrderWaitAcceptCount:(int)winingOrderWaitAcceptCount WiningOrderWaitEvaluateCount:(int)winingOrderWaitSendCount WiningOrderWaitLotteryCount:(int)winingOrderWaitEvaluateCount;

@end





@interface RRFMyOrderView : UIView
@property(nonatomic,weak)RRFGiftOrderView *giftOrder;
@property(nonatomic,weak)RRFBidOrderView *bidOrder;
@property(nonatomic,weak)RRFWinningOrderView *WinningOrder;

@end
