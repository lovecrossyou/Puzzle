//
//  JNQPresentStoreCell.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQPresentModel.h"
#import "JNQAwardModel.h"

static NSString const *imgArr[5] = {
    @"第一名",
    @"第二名",
    @"第三名",
    @"第四名",
    @"第五名"
};

@interface JNQPresentStoreCell : UITableViewCell

@property (nonatomic, strong) JNQPresentModel *presentModel;
@property (nonatomic, strong) JNQAwardModel *awardModel;

@end
