//
//  JNQPersonalHomepageViewController.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ComeViewType) {
    ComeViewTypePerson   = 0,         //上期
    ComeViewTypeRank = 1              //本期
};

@interface JNQPersonalHomepageViewController : UITableViewController

@property (nonatomic, assign) NSInteger otherUserId;
@property (nonatomic, strong) NSString *rankingType;

@end
