//
//  DDSortView.h
//  DDNews
//
//  Created by Dvel on 16/4/15.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PZNewsCategoryModel ;
@interface DDSortView : UIView
- (instancetype)initWithFrame:(CGRect)frame channelList:(NSMutableArray *)channelList leftTitle:(NSString*)left rightTitle:(NSString*)right;

/** 箭头按钮点击回调 */
@property (nonatomic, copy) void(^arrowBtnClickBlock)();
/** 排序完成回调 */
@property (nonatomic, copy) void(^sortCompletedBlock)(NSMutableArray *channelList);
/** cell按钮点击回调 */
@property (nonatomic, copy) void(^cellButtonClick)(PZNewsCategoryModel* model);

@property(assign,nonatomic) BOOL haveVIP ;

-(void)update:(PZNewsCategoryModel*)model;
@end
