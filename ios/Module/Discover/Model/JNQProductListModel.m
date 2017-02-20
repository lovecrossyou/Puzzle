//
//  JNQProductListModel.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQProductListModel.h"

@implementation JNQPresentClassifyModel

@end

@implementation JNQProductListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.size = 10;
        self.pageNo = 0;
        self.tagName = @"";
        self.salesTag = 0;
        self.priceTag = 0;
        self.productName = @"";
        self.categoryId = 0;
    }
    return self;
}

@end
