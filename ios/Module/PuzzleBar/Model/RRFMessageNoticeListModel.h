//
//  RRFMessageNoticeListModel.h
//  Puzzle
//
//  Created by huibei on 16/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFMessageNoticeListModel : NSObject
//{
//    \"responseUserId\": 5,
//    \"iconUrl\": \"http: //wx.qlogo.cn/mmopen/IJdPq631CVH88LaWrOwdFdpoBfR1tiacS7Qw5jM8KlDkuTnUeTia8M509zfcULsXVKFpcqXC7F9LibkTQuxic0Yj0CXdssWaK2pT/0\",
//    \"userName\": \"\U77e5\U5df1\",
//    \"entityId\": 209,
//    \"entityConent\": \"\U7834\Uff0c\U725b\U903c\U542c\U4f60\U60ca\U53f9\U3002\U6211\U662f\",
//    \"responseContent\": \"\U5728\U6211\U4eec\",
//    \"time\": \"2016-10-17\",
//    \"respImage\": null
//}
@property(nonatomic,assign)int responseUserId;
@property(nonatomic,strong)NSString *iconUrl;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)int entityId;
@property(nonatomic,strong)NSString *entityConent;
@property(nonatomic,strong)NSString *responseContent;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *respImage;
// 7:打赏 10/11：评论 15：点赞
@property(assign,nonatomic) int type ;
@end
