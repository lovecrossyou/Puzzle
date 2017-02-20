 //
//  JCHATSendMessageViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "JCHATFileManager.h"
#import "JCHATShowTimeCell.h"
#import "JCHATDetailsInfoViewController.h"
#import "JCHATGroupSettingCtl.h"
#import "AppDelegate.h"
#import "MBProgressHUD+HBProgresss.h"
#import "UIImage+ResizeMagick.h"
#import "JCHATFriendDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <JMessage/JMSGConversation.h>
#import "JCHATStringUtils.h"
#import <UIKit/UIPrintInfo.h>
#import "JCHATLoadMessageTableViewCell.h"
#import "JCHATSendMsgManager.h"
#import "JCHATGroupDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RedPaperSeleController.h"
#import "PZNavController.h"
#import "JChatRedPaperCell.h"
#import "BonusPackage.h"
#import "BonusPaperTool.h"
#import "BonusPaperModel.h"
#import "JNQRedPaperViewController.h"
#import "JNQRedPaperClickedView.h"
#import "BonusPackage.h"
#import "UIView+Extension.h"
#import "JNQHttpTool.h"
#import "JChatRedPaperTipCell.h"
@interface JCHATConversationViewController ()<RedPaperDelegate,RedPaperTipDelegate> {
  
@private
  BOOL isNoOtherMessage;
  NSInteger messageOffset;
  NSMutableArray *_imgDataArr;
  JMSGConversation *_conversation;//
  NSMutableDictionary *_allMessageDic; //缓存所有的message model
  NSMutableArray *_allmessageIdArr; //按序缓存后有的messageId， 于allMessage 一起使用
  NSMutableArray *_userArr;//
  UIButton *_rightBtn;
}

@property (nonatomic, strong) JNQRedPaperClickedView *clickedV;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) NSInteger bonusPackageId;
@property (nonatomic, assign) BOOL isSingle;
@property (nonatomic, assign) BOOL isSend;
@end


@implementation JCHATConversationViewController//change name chatcontroller
- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  _allMessageDic = @{}.mutableCopy;
  _allmessageIdArr = @[].mutableCopy;
  _imgDataArr = @[].mutableCopy;
  self.title = _conversation.title;
  [self setupView];
  [self addNotification];
  [self addDelegate];
  [self getGroupMemberListWithGetMessageFlag:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
  
  [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
    
    if (self.conversation.conversationType == kJMSGConversationTypeGroup) {
      [self updateGroupConversationTittle:nil];
    } else {
      self.title = [resultObject title];
    }
    [_messageTableView reloadData];
  }];
}

- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
  JMSGGroup *group;
  if (newGroup == nil) {
    group = self.conversation.target;
  } else {
    group = newGroup;
  }
  
  if ([group.name isEqualToString:@""]) {
    self.title = @"群聊";
  } else {
    self.title = group.name;
  }
  self.title = [NSString stringWithFormat:@"%@(%lu)",self.title,(unsigned long)[group.memberArray count]];
  [self getGroupMemberListWithGetMessageFlag:NO];
  if (self.isConversationChange) {
    [self cleanMessageCache];
    [self getPageMessage];
    self.isConversationChange = NO;
  }
}

- (void)viewDidLayoutSubviews {
  [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_conversation clearUnreadCount];
  [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}

- (void)setupView {
  [self setupNavigation];
  [self setupComponentView];
}

- (void)addtoolbar {
  self.toolBarContainer.toolbar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
  [self.toolBarContainer addSubview:self.toolBarContainer.toolbar];
}

- (void)setupComponentView {
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapClick:)];
  [self.view addGestureRecognizer:gesture];
  [self.view setBackgroundColor:messageTableColor];
  _toolBarContainer.toolbar.delegate = self;
  [_toolBarContainer.toolbar setUserInteractionEnabled:YES];
  self.toolBarContainer.toolbar.textView.text = [[JCHATSendMsgManager ins] draftStringWithConversation:_conversation];
  _messageTableView.userInteractionEnabled = YES;
  _messageTableView.showsVerticalScrollIndicator = NO;
  _messageTableView.delegate = self;
  _messageTableView.dataSource = self;
  _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageTableView.backgroundColor = messageTableColor;
  
  _moreViewContainer.moreView.delegate = self;
  _moreViewContainer.moreView.backgroundColor = messageTableColor;
}

- (void)setupNavigation {
  self.navigationController.navigationBar.translucent = NO;
  _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [_rightBtn setFrame:navigationRightButtonRect];
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    [_rightBtn setImage:[UIImage imageNamed:@"userDetail"] forState:UIControlStateNormal];
  } else {
    [self updateGroupConversationTittle:nil];
    if ([((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
      [_rightBtn setImage:[UIImage imageNamed:@"groupDetail"] forState:UIControlStateNormal];
    } else _rightBtn.hidden = YES;
  }
  
  [_conversation clearUnreadCount];
  
  [_rightBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];//为导航栏添加右侧按钮
}

- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
  if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
    JMSGGroup *group = nil;
    group = self.conversation.target;
    _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
    [self isContantMeWithUserArr:_userArr];
    if (getMesageFlag) {
      [self getPageMessage];
    }
  } else {
    if (getMesageFlag) {
      [self getPageMessage];
    }
    [self hidenDetailBtn:NO];
  }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
  BOOL hideFlag = YES;
  for (NSInteger i =0; i< [userArr count]; i++) {
    JMSGUser *user = [userArr objectAtIndex:i];
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      hideFlag = NO;
      break;
    }
  }
  [self hidenDetailBtn:hideFlag];
}

- (void)hidenDetailBtn:(BOOL)flag {
  [_rightBtn setHidden:flag];
}

- (void)setTitleWithUser:(JMSGUser *)user {
  self.title = _conversation.title;
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
  [self relayoutTableCellWithMsgId:message.msgId];
  if (error != nil) {
    [_conversation clearUnreadCount];
    NSString *alert = [JCHATStringUtils errorAlert:error];
    if (alert == nil) {
      alert = [error description];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showMessage:alert view:self.view];
    return;
  }
  JCHATChatModel *model = _allMessageDic[message.msgId];
  if (!model) {
    return;
  }
}

#pragma mark --收到消息
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
  if (error != nil) {
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setErrorMessageChatModelWithError:error];
    [self addMessage:model];
    return;
  }
  
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  //if (message.contentType == kJMSGContentTypeCustom) {
    //return;
  //}
  JCHATMAINTHREAD((^{
    if (!message) {
      return;
    }
    
    if (_allMessageDic[message.msgId] != nil) {
      return;
    }
    
    if (message.contentType == kJMSGContentTypeEventNotification) {
      if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
          && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
        [self setupNavigation];
      }
    }
    
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
      return;
    }
    
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
    }
    model.photoIndex = [_imgDataArr count] -1;
    [self addmessageShowTimeData:message.timestamp];
    [self addMessage:model];
  }));
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  JCHATMAINTHREAD((^{
    if (!message) {
      return;
    }
    
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
      return;
    }
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
    }
    model.photoIndex = [_imgDataArr count] -1;
    [self addmessageShowTimeData:message.timestamp];
    [self addMessage:model];
  }));
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
  [self updateGroupConversationTittle:group];
}

- (void)relayoutTableCellWithMsgId:(NSString *) messageId{
  if ([messageId isEqualToString:@""]) {
    return;
  }
  NSInteger index = [_allmessageIdArr indexOfObject:messageId];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  
  JCHATMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
  [tableviewcell layoutAllView];
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    [self.navigationController popViewControllerAnimated:NO];//目的回到根视图
    [MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [JMSGUser logout:^(id resultObject, NSError *error) {
    }];
  }
}
#pragma mark --获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
  for (NSInteger i=0; i< [_allmessageIdArr count]; i++) {
    NSString *getMessageID = _allmessageIdArr[i];
    if ([getMessageID isEqualToString:messageID]) {
      return i;
    }
  }
  return 0;
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
  [_allMessageDic removeAllObjects];
  [_allmessageIdArr removeAllObjects];
  [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allmessageIdArr addObject:model.timeId];
    [self addCellToTabel];
    return;
  }
  [_allMessageDic setObject:model forKey:model.message.msgId];
  [_allmessageIdArr addObject:model.message.msgId];
  [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
  JMSGMessage *message1 = (JMSGMessage *)object1;
  JMSGMessage *message2 = (JMSGMessage *)object2;
  if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
    return NSOrderedDescending;
  } else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
    return NSOrderedAscending;
  }
  return NSOrderedSame;
}

- (void)AlertToSendImage:(NSNotification *)notification {
  UIImage *img = notification.object;
  [self prepareImageMessage:img];
}

- (void)deleteMessage:(NSNotification *)notification {
  JMSGMessage *message = notification.object;
  [_conversation deleteMessageWithMessageId:message.msgId];
  [_allMessageDic removeObjectForKey:message.msgId];
  [_allmessageIdArr removeObject:message.msgId];
  [_messageTableView loadMoreMessage];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
  NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
  return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)getPageMessage {
  [self cleanMessageCache];
  NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [_allmessageIdArr addObject:[[NSObject alloc] init]];
  
  messageOffset = messagefristPageNumber;
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
  if ([arrList count] < messagefristPageNumber) {
    isNoOtherMessage = YES;
    [_allmessageIdArr removeObjectAtIndex:0];
  }
  
  for (NSInteger i=0; i< [arrList count]; i++) {
    JMSGMessage *message = [arrList objectAtIndex:i];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
      model.photoIndex = [_imgDataArr count] - 1;
    }
    
    [self dataMessageShowTime:message.timestamp];
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
  }
  [_messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
}

- (void)flashToLoadMessage {
  NSMutableArray * arrList = @[].mutableCopy;
  NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(messagePageNumber)];
  [arrList addObjectsFromArray:newMessageArr];
  if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
    isNoOtherMessage = YES;
    [_allmessageIdArr removeObjectAtIndex:0];
  }
  
  messageOffset += messagePageNumber;
  for (NSInteger i = 0; i < [arrList count]; i++) {
    JMSGMessage *message = arrList[i];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr insertObject:model atIndex:0];
      model.photoIndex = [_imgDataArr count] - 1;
    }

    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr insertObject:model.message.msgId atIndex: isNoOtherMessage?0:1];
    [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
  }
  
  [_messageTableView loadMoreMessage];
}

- (JMSGUser *)getAvatarWithTargetId:(NSString *)targetId {
  for (NSInteger i=0; i<[_userArr count]; i++) {
    JMSGUser *user = [_userArr objectAtIndex:i];
    if ([user.username isEqualToString:targetId]) {
      return user;
    }
  }
  return nil;
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
  if (!_voiceRecordHelper) {
    WEAKSELF
    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf finishRecorded];
    };
    
    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
    };
    
    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
  }
  return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
  if (!_voiceRecordHUD) {
    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
  }
  return _voiceRecordHUD;
}

- (void)backClick {
  if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  _toolBarHeightConstrait.constant = 45;
  [self dropToolBar];
}

- (void)switchToTextInputMode {
  UITextField *inputview = self.toolBarContainer.toolbar.textView;
  [inputview becomeFirstResponder];
  [self layoutAndAnimateMessageInputTextView:inputview];
}
#pragma mark --增加朋友
- (void)addFriends
{
    JCHATGroupDetailViewController *groupDetailCtl = [[JCHATGroupDetailViewController alloc] init];
    groupDetailCtl.conversation = _conversation;
    groupDetailCtl.sendMessageCtl = self;
    [self.navigationController pushViewController:groupDetailCtl animated:YES];
}

#pragma mark -调用相册
- (void)photoClick {
  ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
  [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    JCHATPhotoPickerViewController *photoPickerVC = [[JCHATPhotoPickerViewController alloc] init];
    photoPickerVC.photoDelegate = self;
    [self presentViewController:photoPickerVC animated:YES completion:NULL];
  } failureBlock:^(NSError *error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有相册权限" message:@"请到设置页面获取相册权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
  }];
}

#pragma mark --点击红包
-(void)redPaperClick{
    WEAKSELF
    RedPaperSeleController* redPaper = [[RedPaperSeleController alloc]init];
    id target = self.conversation.target ;
    if ([target isKindOfClass:[JMSGGroup class]]) {
        //群
        JMSGGroup* group = (JMSGGroup*)target ;
        redPaper.menbers = [group memberArray].count ;
    }
    else{
        //
        redPaper.menbers = 0;
    }
    redPaper.singleBonusPaper = (self.conversation.conversationType == kJMSGConversationTypeSingle);
    redPaper.title = @"发红包" ;
    redPaper.sendRedPaperBlock = ^(id json,BonusPackage* model){
        NSString* desc = json[@"description"];
        model.desInfo = desc ;
        if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
            //单个红包
            NSInteger packageId = [json[@"bonusPackageId"] integerValue];
            [weakSelf createBonusPaper:packageId model:model];
        }
        else{
            //群红包 bonusPackageId
            NSInteger packageId = [json[@"bonusPackageId"] integerValue];
            [weakSelf createBonusPaper:packageId model:model];
        }
    };
    PZNavController* nav = [[PZNavController alloc]initWithRootViewController:redPaper];
    [nav redTheme];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 创建红包已领取消息
-(void)createRedPaperTipMsg:(NSInteger)bonusPackageId model:(BonusPackage*)m{
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    NSString* bonusPackageStr = [NSString stringWithFormat:@"%ld",(long)bonusPackageId];
    JMSGCustomContent* redPaperContent = [[JMSGCustomContent alloc] initWithCustomDictionary:@{@"bonusPackageId":bonusPackageStr,@"desInfo":m.desInfo,@"bonusType":@(1)}];
    [redPaperContent setContentText:@"已领取红包"];
    
    JMSGMessage* message = [_conversation createMessageWithContent:redPaperContent];
    [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

#pragma mark - 创建红包
-(void)createBonusPaper:(NSInteger)bonusPackageId model:(BonusPackage*)m{
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    NSString* bonusPackageStr = [NSString stringWithFormat:@"%ld",(long)bonusPackageId];
    JMSGCustomContent* redPaperContent = [[JMSGCustomContent alloc] initWithCustomDictionary:@{@"bonusPackageId":bonusPackageStr,@"desInfo":m.desInfo,@"bonusType":@(1)}];
    [redPaperContent setContentText:@"红包"];
    //创建红包消息
    JMSGMessage* message = [_conversation createMessageWithContent:redPaperContent];
    [_conversation sendMessage:message];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

-(NSInteger)getBouceType:(JMSGMessage*)message{
    return 0;
//    JMSGCustomContent* contentM = (JMSGCustomContent*)message.content ;
//    NSDictionary* d = contentM.customDictionary ;
//    id type = d[@"bonusType"];
//    if (type!=nil) {
//        return [type integerValue];
//    }
//    else{
//        return 0 ;
//    }
}

#pragma mark --调用相机
- (void)cameraClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [picker setMediaTypes:arrMediaTypes];
    picker.showsCameraControls = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.editing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  }
}

#pragma mark - ZYQAssetPickerController Delegate

#pragma mark - HMPhotoPickerViewController Delegate
- (void)JCHATPhotoPickerViewController:(JCHATPhotoSelectViewController *)PhotoPickerVC selectedPhotoArray:(NSArray *)selected_photo_array {
  for (UIImage *image in selected_photo_array) {
    [self prepareImageMessage:image];
  }
  [self dropToolBarNoAnimate];
}
#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  if ([mediaType isEqualToString:@"public.movie"]) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showMessage:@"不支持视频发送" view:self.view];
    return;
  }
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self prepareImageMessage:image];
  [self dropToolBarNoAnimate];
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
  img = [img resizedImageByWidth:upLoadImgWidth];
  
  JMSGMessage* message = nil;
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
  if (imageContent) {
    message = [_conversation createMessageWithContent:imageContent];
    [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [_imgDataArr addObject:model];
    model.photoIndex = [_imgDataArr count] - 1;
    [model setupImageSize];
    [self addMessage:model];
  }
}

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --add Delegate
- (void)addDelegate {
  [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark --加载通知
- (void)addNotification{
  //给键盘注册通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cleanMessageCache)
                                               name:kDeleteAllMessage
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(AlertToSendImage:)
                                               name:kAlertToSendImage
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deleteMessage:)
                                               name:kDeleteMessage
                                             object:nil];

  [self.toolBarContainer.toolbar.textView addObserver:self
                                           forKeyPath:@"contentSize"
                                              options:NSKeyValueObservingOptionNew
                                              context:nil];
  self.toolBarContainer.toolbar.textView.delegate = self;
}

- (void)inputKeyboardWillShow:(NSNotification *)notification{
  _barBottomFlag=NO;
  CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  
  [UIView animateWithDuration:animationTime animations:^{
    _moreViewHeight.constant = keyBoardFrame.size.height;
    [self.view layoutIfNeeded];
  }];
  [self scrollToEnd];//!
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [UIView animateWithDuration:animationTime animations:^{
    _moreViewHeight.constant = 0;
    [self.view layoutIfNeeded];
  }];
  [self scrollToBottomAnimated:NO];
}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}

- (void)perform {
  _moreViewHeight.constant = 0;
  _toolBarToBottomConstrait.constant = 0;
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.addButton.selected = NO;
  [_messageTableView reloadData];
  [UIView animateWithDuration:0.3 animations:^{
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 0;
  }];
}

- (void)dropToolBarNoAnimate {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.addButton.selected = NO;
  [_messageTableView reloadData];
  _toolBarToBottomConstrait.constant = 0;
  _moreViewHeight.constant = 0;
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
  _barBottomFlag=NO;
  [_toolBarContainer.toolbar.textView resignFirstResponder];
  
  _toolBarToBottomConstrait.constant = 0;
  _moreViewHeight.constant = 227;
  [_messageTableView setNeedsDisplay];
  [_moreViewContainer setNeedsLayout];
  [_toolBarContainer setNeedsLayout];
  [UIView animateWithDuration:0.25 animations:^{
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 227;
    [_messageTableView layoutIfNeeded];
    [_toolBarContainer layoutIfNeeded];
    [_moreViewContainer layoutIfNeeded];
  }];
  [_toolBarContainer.toolbar switchToolbarToTextMode];
  [self scrollToBottomAnimated:NO];
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
  [_toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
  if ([text isEqualToString:@""] || text == nil) {
    return;
  }
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
  JMSGMessage *message = nil;
  JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  
  message = [_conversation createMessageWithContent:textContent];//!
  [_conversation sendMessage:message];
  [self addmessageShowTimeData:message.timestamp];
  [model setChatModelWith:message conversationType:_conversation];
  [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
  [_messageTableView beginUpdates];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageTableView endUpdates];
  [self scrollToEnd];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count] > 0 && lastModel.isTime == NO) {
      
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([_allmessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
  }
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr addObject:timeModel.timeId];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr addObject:timeModel.timeId];
  } else {
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
  } else {
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];//!
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([_allmessageIdArr count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//!UITableViewScrollPositionBottom
  }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!isNoOtherMessage) {
    if (indexPath.row == 0) { //这个是第 0 行 用于刷新
      return 40;
    }
  }
  NSString *messageId = _allmessageIdArr[indexPath.row];
  JCHATChatModel *model = _allMessageDic[messageId ];
  if (model.isTime == YES) {
    return 31;
  }
  
  if (model.message.contentType == kJMSGContentTypeEventNotification) {
    return model.contentHeight + 17;
  }
    //红包类型
  if (model.message.contentType == kJMSGContentTypeCustom) {
        return [self getBouceType:model.message]==0? 110.0f : 32.0f ;
  }
  
  if (model.message.contentType == kJMSGContentTypeText) {
    return model.contentHeight + 17;
  } else if (model.message.contentType == kJMSGContentTypeImage) {
    
    if (model.imageSize.height == 0) {
      [model setupImageSize];
    }
    return model.imageSize.height < 44?59:model.imageSize.height + 14;
    
  } else if (model.message.contentType == kJMSGContentTypeVoice) {
    return 69;
  } else {
    return 49;
  }
}

#pragma mark --释放内存
- (void)dealloc {
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
  //remove delegate
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
  [JMessage removeDelegate:self withConversation:_conversation];
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  [self dropToolBar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_allmessageIdArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!isNoOtherMessage) {
    if (indexPath.row == 0) {
      static NSString *cellLoadIdentifier = @"loadCell"; //name
      JCHATLoadMessageTableViewCell *cell = (JCHATLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
      if (cell == nil) {
        cell = [[JCHATLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
      }
      [cell startLoading];
      [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
      return cell;
    }
  }
  NSString *messageId = _allmessageIdArr[indexPath.row];
  if (!messageId) {
    return nil;
  }
  
  JCHATChatModel *model = _allMessageDic[messageId];
  if (!model) {
    return nil;
  }
  
  if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
    static NSString *cellIdentifier = @"timeCell";
    JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:self options:nil] lastObject];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (model.isErrorMessage) {
      cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
      return cell;
    }
    
    if (model.message.contentType == kJMSGContentTypeEventNotification) {
      cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
    }else {
      cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
    }
    return cell;
    
  } else {
      static NSString *cellIdentifier = @"MessageCell";
      static NSString *cellIdentifier1 = @"RedPaperCell";
//      static NSString *cellIdentifier2 = @"JChatRedPaperTipCell";

    JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (model.message.contentType==kJMSGContentTypeCustom) {
//          if ([self getBouceType:model.message] == 0) {
              //红包
               JChatRedPaperCell* cell = [[JChatRedPaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
                [cell setCellData:model delegate:self];
              return cell ;
//          }
//          else{
////              红包提示
//              JChatRedPaperTipCell* cell = [[JChatRedPaperTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
//              [cell setCellData:model delegate:self];
//              return cell ;
//          }
          
      }
    if (cell == nil) {
      cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      cell.conversation = _conversation;
    }
    
    [cell setCellData:model delegate:self indexPath:indexPath];
    return cell;
  }
}

#pragma mark - 点击红包提示信息
-(void)didClickRedPaperTip:(JCHATChatModel *)model{
    
}

#pragma mark - 点击红包
-(void)didClickRedPaper:(JCHATChatModel *)model{
    WEAKSELF
    JMSGMessage* msg = model.message ;
    JMSGCustomContent* content = (JMSGCustomContent*)msg.content ;
    NSDictionary* param = content.customDictionary ;
    _bonusPackageId = [param[@"bonusPackageId"] integerValue] ;
    //拆红包
    [MBProgressHUD show];
    _isSend = ![model.message isReceived];
    if(_conversation.conversationType == kJMSGConversationTypeSingle){
        _isSingle = YES;
        [BonusPaperTool singleDraw:_bonusPackageId Success:^(id json) {
            BonusPaperModel* pModel = (BonusPaperModel *)json;
            [MBProgressHUD dismiss];
            if (_isSend ||
                (!_isSend&&[pModel.isReceive isEqualToString:@"alreadyReceive"])) {
                //跳转
                //(我是收方):收方-已拆-过期/结束/X
                //(我是发方):收方-已拆/未拆-过期(提示过期)/结束(提示已领取)/进行(提示等待领取)
                JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                vc.isSend = ![model.message isReceived];
                vc.pModel = pModel;
                [self presentViewController:nav animated:YES completion:nil];
            } else if (!_isSend&&[pModel.isReceive isEqualToString:@"noReceive"]&&![pModel.status isEqualToString:@"empty_finish"]) {
                //弹出
                //(我是收方):收方-未拆-过期(提示过期)/X/进行(提示可拆)
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self.backBtn];
                [window addSubview:self.clickedV];
                self.clickedV.pModel = pModel;
                self.clickedV.isSend = YES;
                [weakSelf showAnimateForView:weakSelf.clickedV];
            }
        } failBlock:^(id json) {
            [MBProgressHUD dismiss];
        }];
    } else {
        _isSingle = NO;
        [BonusPaperTool groupDraw:_bonusPackageId Success:^(id json) {
            BonusPaperModel* pModel = (BonusPaperModel *)json;
            [MBProgressHUD dismiss];
            if ([pModel.isReceive isEqualToString:@"alreadyReceive"] ||
                (_isSend&&[pModel.bonusType isEqualToString:@"average"])) {
                //跳转
                //发方-群普通-过期(跳转)/结束(跳转)/进行(跳转)
                //发方-群手气-已拆-过期(跳转)/结束(跳转)/进行(跳转)
                //收方-群普通-已拆-X/结束(跳转)/X
                //收方-群手气-已拆-过期(跳转)/结束(跳转)/进行(跳转)
                JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                vc.pModel = pModel;
                vc.isSend = _isSend;
                [self presentViewController:nav animated:YES completion:nil];
            } else if ([pModel.isReceive isEqualToString:@"noReceive"] && !(_isSend&&[pModel.bonusType isEqualToString:@"average"])
                       ) {
                //弹出
                //收方-群普通/手气-未拆-过期(弹出)/结束(弹出)/进行(弹出)
                //发方-群手气-未拆-过期(弹出)/结束(弹出)/进行(弹出)
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self.backBtn];
                [window addSubview:self.clickedV];
                self.clickedV.isSend = _isSend;
                self.clickedV.pModel = pModel;
                [weakSelf showAnimateForView:weakSelf.clickedV];
            }
        } failBlock:^(id json) {
            [MBProgressHUD dismiss];
            NSError *error = (NSError *)json;
            NSString *errorStr = [JNQHttpTool errorDataString:error];
            if ([errorStr isEqualToString:@"红包已过期"]) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self.backBtn];
                [window addSubview:self.clickedV];
                [weakSelf showAnimateForView:weakSelf.clickedV];
                self.clickedV.isOver = YES;
                self.clickedV.isTimeOut = YES;
            }
        }];
    }
}

#pragma mark - 点击 (红包)头像
-(void)clickAvatar:(JCHATChatModel *)model{
    
}

#pragma mark - 缩放动画
-(void)showAnimateForView:(UIView*)myView{
    /* 放大缩小 */
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.7;
    group.repeatCount = 1;
    // 设定为放大
    CABasicAnimation *aniBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    aniBig.duration = 0.3; // 动画持续时间
    aniBig.repeatCount = 1; // 重复次数
    aniBig.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    // 缩放倍数
    aniBig.fromValue = [NSNumber numberWithFloat:0.6]; // 开始时的倍率
    aniBig.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    //缩小
    CABasicAnimation *aniSmall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    aniSmall.duration = 0.4; // 动画持续时间
    aniSmall.repeatCount = 1; // 重复次数
    aniSmall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    // 缩放倍数
    aniSmall.fromValue = [NSNumber numberWithFloat:0.6]; // 开始时的倍率
    aniSmall.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
//    合并动画组
    group.animations = @[aniBig];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;

    // 添加动画
    [myView.layer addAnimation:group forKey:@"scale-layer"];
}

#pragma mark - 点击红包弹出页
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
        _backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_backBtn addTarget:self action:@selector(backBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (JNQRedPaperClickedView *)clickedV {
    WEAKSELF
    if (!_clickedV) {
        _clickedV = [[JNQRedPaperClickedView alloc] initWithFrame:CGRectMake(25, (SCREENHeight-(SCREENWidth-50)*866/650)/2, SCREENWidth-50, (SCREENWidth-50)*866/650)];
        _clickedV.btnBlock = ^(UIButton *button) {
            [MBProgressHUD show];
            if (button.tag == 888) {
                if (weakSelf.isSingle) {
                    [BonusPaperTool singleOpenBonus:weakSelf.bonusPackageId Success:^(id json) {
                        [MBProgressHUD dismiss];
                        [weakSelf backBtnDidClicked:weakSelf.backBtn];
                        BonusPaperModel* pModel = (BonusPaperModel *)json;
                        JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                        vc.isSend = NO;
                        vc.pModel = pModel;
                        if ([pModel.bonusType isEqualToString:@"average"]) {
                            vc.isSend = weakSelf.isSend;
                        }
                        [weakSelf presentViewController:nav animated:YES completion:nil];
                    } failBlock:^(id json) {
                        [MBProgressHUD dismiss];
                    }];
                } else {
                    [BonusPaperTool groupOpenBonus:weakSelf.bonusPackageId Success:^(id json) {
                        [MBProgressHUD dismiss];
                        [weakSelf backBtnDidClicked:weakSelf.backBtn];
                        BonusPaperModel* pModel = (BonusPaperModel *)json;
                        JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                        vc.pModel = pModel;
                        vc.isSend = weakSelf.isSend;
                        [weakSelf presentViewController:nav animated:YES completion:nil];
                    } failBlock:^(id json) {
                        [MBProgressHUD dismiss];
                        NSError *error = (NSError *)json;
                        NSString *errorStr = [JNQHttpTool errorDataString:error];
                        if ([errorStr isEqualToString:@"红包已被抢完"]) {
                            weakSelf.clickedV.isOver = YES;
                        }
                    }];
                }
            } else if (button.tag == 666) {
                [BonusPaperTool groupDraw:weakSelf.bonusPackageId Success:^(id json) {
                    BonusPaperModel* pModel = (BonusPaperModel *)json;
                    [MBProgressHUD dismiss];
                    [weakSelf backBtnDidClicked:weakSelf.backBtn];
                        JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                        PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                        vc.isSend = weakSelf.isSend;
                        vc.pModel = pModel;
                        [weakSelf presentViewController:nav animated:YES completion:nil];
                } failBlock:^(id json) {
                    [MBProgressHUD dismiss];
                }];

            } else if (button.tag == 100) {
                [MBProgressHUD dismiss];
                [weakSelf backBtnDidClicked:weakSelf.backBtn];
            }
        };
    }
    return _clickedV;
}

- (void)backBtnDidClicked:(UIButton *)button {
    [UIView animateWithDuration:0.3 animations:^{
        //_clickedV.frame = CGRectMake(SCREENWidth/2-10, SCREENHeight/2-10, 20, 20);
    } completion:^(BOOL finished) {
        [_clickedV removeFromSuperview];
        [_backBtn removeFromSuperview];
    }];
}

#pragma mark -PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    
    if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
      JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
      [voiceCell playVoice];
    }
  }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
  [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
  [_allMessageDic setObject:*chatModel forKey:message.msgId];
  
  if ([_allmessageIdArr count] > index) {
    [_allmessageIdArr removeObjectAtIndex:index];
    [_allmessageIdArr insertObject:message.msgId atIndex:index];
  }
}

- (void)selectHeadView:(JCHATChatModel *)model {
  if (!model.message.fromUser) {
    [MBProgressHUD showMessage:@"该用户为API用户" view:self.view];
    return;
  }
  
  if ([model.message isReceived]) {
      JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
      if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
          friendCtl.userInfo = model.message.fromUser;
          friendCtl.isGroupFlag = NO;
      } else {
          friendCtl.userInfo = model.message.fromUser;
          friendCtl.isGroupFlag = YES;
      }
      [self.navigationController pushViewController:friendCtl animated:YES];
  }
}

#pragma mark -连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
      if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        tempCell.continuePlayer = YES;
      }else {
        tempCell.continuePlayer = NO;
      }
    }
  }
}

#pragma mark 预览图片 PictureDelegate
//PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
  NSInteger count = _imgDataArr.count;
  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i<count; i++) {
    JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.message = messageObject;
    photo.srcImageView = tapView; // 来源于哪个UIImageView
    [photos addObject:photo];
  }
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
//  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
  browser.photos = photos; // 设置所有的图片
  browser.conversation =_conversation;
  [browser show];
}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
  NSMutableArray *urlArr =[NSMutableArray array];
  for (NSInteger i=0; i<[_allmessageIdArr count]; i++) {
    NSString *messageId = _allmessageIdArr[i];
    JCHATChatModel *model = _allMessageDic[messageId];
    if (model.message.contentType == kJMSGContentTypeImage) {
      [urlArr addObject:((JMSGImageContent *)model.message.content)];
    }
  }
  return urlArr;
}
#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
  [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
  [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  [self resumeRecord];
}

- (void)didDragInsideAction {
  [self pauseRecord];
}

- (void)pauseRecord {
  [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
  [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
  WEAKSELF
  [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    
  }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
  [self.voiceRecordHUD startRecordingHUDAtView:self.view];
  [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
  }];
}

- (void)finishRecorded {
  WEAKSELF
  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                       voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
  }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
    } else {
    }
    return;
  }
  
  JMSGMessage *voiceMessage = nil;
  JCHATChatModel *model =[[JCHATChatModel alloc] init];
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                 voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
  
  voiceMessage = [_conversation createMessageWithContent:voiceContent];
  [_conversation sendMessage:voiceMessage];
  [model setChatModelWith:voiceMessage conversationType:_conversation];
  [JCHATFileManager deleteFile:voicePath];
  [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (self.barBottomFlag) {
    return;
  }
  if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
    [self layoutAndAnimateMessageInputTextView:object];
  }
}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
  } else {
    return textView.contentSize.height;
  }
}

#pragma mark - Layout Message Input View Helper Method

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
  CGFloat maxHeight = [JCHATToolBar maxHeight];
  
  CGFloat contentH = [self getTextViewContentH:textView];
  
  BOOL isShrinking = contentH < _previousTextViewContentHeight;
  CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
  
  if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
    changeInHeight = 0;
  }
  else {
    changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
  }
  if (changeInHeight != 0.0f) {
    [UIView animateWithDuration:0.25f
                     animations:^{
                       [self setTableViewInsetsWithBottomValue:_messageTableView.contentInset.bottom + changeInHeight];
                       
                       [self scrollToBottomAnimated:NO];
                       
                       if (isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           _previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // if shrinking the view, animate text view frame BEFORE input view frame
                         [_toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                       
                       if (!isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // growing the view, animate the text view frame AFTER input view frame
                         [self.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                     }
                     completion:^(BOOL finished) {
                     }];
    JCHATMessageTextView *textview =_toolBarContainer.toolbar.textView;
    CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:textview.text withWidthLimit:textView.frame.size.width withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
    CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
    _toolBarHeightConstrait.constant = textHeight + 16;//!
    self.previousTextViewContentHeight = MIN(contentH, maxHeight);
  }
  
  // Once we reached the max height, we have to consider the bottom offset for the text view.
  // To make visible the last line, again we have to set the content offset.
  if (self.previousTextViewContentHeight == maxHeight) {
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime,
                   dispatch_get_main_queue(),
                   ^(void) {
                     CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                     [textView setContentOffset:bottomOffset animated:YES];
                   });
  }
}

- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView {
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:messageInputTextView.text];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  if (![self shouldAllowScroll]) return;
  
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
  //      if (self.isUserScrolling) {
  //          if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
  //              && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
  //              return NO;
  //          }
  //      }
  
  return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
  //    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
  //    self.messageTableView.contentInset = insets;
  //    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    insets.top = 64;
  }
  insets.bottom = bottom;
  return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

// ---------------------------------- Private methods



@end
