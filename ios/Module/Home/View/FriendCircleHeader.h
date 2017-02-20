//
//  FriendCircleHeader.h
//  Puzzle
//
//  Created by huibei on 16/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCircleHeader : UIView
@property(copy,nonatomic)ItemClickParamBlock delBlock;
@property(copy,nonatomic)ItemClickParamBlock addBlock;
@property(copy,nonatomic)ItemClickParamBlock broswerBlock;
-(void)updateImages:(NSArray *)images;
-(NSString*)getContent;
-(BOOL)syncState;

@end
