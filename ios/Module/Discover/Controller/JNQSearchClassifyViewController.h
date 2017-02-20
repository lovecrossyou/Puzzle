//
//  JNQSearchClassifyViewController.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQProductListModel.h"

typedef NS_ENUM(NSInteger, SearchViewType) {
    SearchViewTypeProduct = 1,       //支付钻石
    SearchViewTypeClassify= 2        //兑换喜腾币
};

@interface JNQSearchClassifyViewController : UIViewController

@property (nonatomic, strong) JNQProductListModel *productListModel;
@property (nonatomic, strong) NSString *categoryName;

@end
