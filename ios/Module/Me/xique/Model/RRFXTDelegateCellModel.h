//
//  RRFXTDelegateCellModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFXTDelegateCellModel : NSObject
//{
//    diamondAmount = 3000;
//    inventoryAmount = 0;
//    operationType = "\U8d2d\U4e70";
//    sex = "<null>";
//    userIconUrl = "http://wx.qlogo.cn/mmopen/zw9xd1aIFpHfYv2Pn8laNaOOLKKBpaLWQWmhSUU8ibiczCEhicGeFYkicDGEZ679DxsBTBibKpm78LrcR9Hw9eFbrsKcBCSE0eMrU/0";
//    userId = 34;
//    userName = 13;
//}
@property(nonatomic,assign)NSInteger diamondAmount;
@property(nonatomic,assign)NSInteger inventoryAmount;
@property(nonatomic,strong)NSString *operationType;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *userIconUrl;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *userName;
// 是否是代理 noDelegate"//isDelegate
@property(nonatomic,strong)NSString *isDelegate;

@end
