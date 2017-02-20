//
//  JNQProductListModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQPresentClassifyModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *picture;

@end

@interface JNQProductListModel : NSObject

@property (nonatomic, assign) int size;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) int salesTag;
@property (nonatomic, assign) int priceTag;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) NSInteger categoryId;

@end
