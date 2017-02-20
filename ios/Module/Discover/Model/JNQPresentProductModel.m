//
//  JNQPresentProductModel.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentProductModel.h"

@implementation Picture

@end

@implementation Pictures
@end


@implementation JNQPresentProductModel

+ (NSArray *)ignoredProperties {
    return @[@"specifications", @"pictures"];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    JNQPresentProductModel* model = [[JNQPresentProductModel allocWithZone:zone]init];
    model.productId = self.productId;
    model.price = self.price;
    model.productName = self.productName;
    model.inventory = self.inventory;
    model.sales = self.sales;
    model.shopId = self.shopId;
    model.specifications = self.specifications;
    model.pictures = self.pictures;
    model.count = self.count;
    model.validState = self.validState;
    model.selected = self.selected;
    model.smallPicture = self.smallPicture;
    return model ;
}


@end
RLM_ARRAY_TYPE(JNQPresentProductModel)

