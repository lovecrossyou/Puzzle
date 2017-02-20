//
//  JNQCalculateDetailView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNQCalculateDetailHeaderView : UIView
@property (nonatomic, strong) ButtonBlock buttonBlock;
@property (nonatomic, assign) NSInteger aValue;

@end

@interface JNQCalculateDetailFooterView : UIView
- (void)setBValue:(NSInteger)bValue tradeTime:(NSString *)tradeTime;
- (void)setBidStatus:(NSString *)bidStatus luckCode:(NSInteger)luckCode;

@end

@interface JNQCalculateDetailView : UIView

@end
