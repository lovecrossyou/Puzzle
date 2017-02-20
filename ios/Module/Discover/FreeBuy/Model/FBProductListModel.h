//
//  FBProductListModel.h
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBidRecordModel : NSObject

@property (nonatomic, assign) NSInteger bidRecordId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger purchaseCode;

@end

@interface FBProductModel : NSObject
@property(assign,nonatomic) NSInteger popularity ;
@property(assign,nonatomic) NSInteger priceOfOneBidInRmb ;
@property(assign,nonatomic) NSInteger priceOfTotalGameInRmb ;
@property(assign, nonatomic)NSInteger priceOfOneBidInXtb;
@property(copy,nonatomic) NSString* productName ;
@property(copy,nonatomic) NSString* purchaseGameDescription ;
@property(assign,nonatomic) NSInteger purchaseGameId ;
@property(copy,nonatomic) NSString* rateOfProgress ;
@property(copy,nonatomic) NSString* picUrl ;
@property(assign,nonatomic) CGFloat restPurchaseCount ;
@property(assign,nonatomic) NSInteger stage ;
@property(assign,nonatomic) NSInteger targetPurchaseCount ;
@property(assign, nonatomic) NSInteger fbOrderId;
@property(assign, nonatomic) int purchaseGameCount;
@property(assign, nonatomic) int productId;
@property(assign, nonatomic) NSInteger bidOrderId;

@property(assign, nonatomic) NSInteger price;
@property(strong, nonatomic) NSString *bidOrderStatus;
@property(strong, nonatomic) NSArray *bidRecords;
@property(strong, nonatomic) NSString *createTime;
@property(assign, nonatomic) NSInteger nextPurchaseGameId;
@property(strong, nonatomic) NSString *purchaseGameStatus;
@property(strong, nonatomic) NSArray *pictures;
@end

@interface FBProductListModel : NSObject
@property(strong,nonatomic) NSArray* content;
@property(assign,nonatomic) BOOL last ;
@end


