//
//  RRFFriendCircleModel.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFriendCircleModel.h"
#import "RRFCommentsCellModel.h"
#import "ImageModel.h"
#import "BonusPaperModel.h"
@implementation RespModel

@end

@implementation ExchangeOrderModel

@end
@implementation ExchangeOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"productList" : [ExchangeOrderModel class]
             };
}
@end


@implementation AwardOrderModel

@end


@implementation BidOrderModel

@end
@implementation CommentModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"contentImages" : [ImageModel class]
             };
}
@end

@implementation GuessWithStockModel



@end
@implementation RRFFriendCircleModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             @"descriptionStr":@"description"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"praiseUsers" : [PraiseUsersModel class],
             @"presentUsers" : [PraiseUsersModel class],
             @"respModels" : [RespModel class],
             @"bonusPackageModel":[BonusPaperModel class]
             };
}
@end
