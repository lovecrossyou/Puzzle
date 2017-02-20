//
//  FBNewWinnerModel.h
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBNewWinnerModel : NSObject
@property(nonatomic,assign)NSInteger bidOrderId;
@property(nonatomic,assign)NSInteger bidRecordId;
@property(nonatomic,assign)NSInteger phoneNumber;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,assign)NSInteger purchaseGameId;
@property(nonatomic,assign)NSInteger stage;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,copy)NSString *productName;
@end

@interface FBNewWinnerListModel : NSObject
@property(strong,nonatomic) NSArray* content;
@end

