
#import "JCHATConversationListViewController.h"
#import "JCHATConversationListCell.h"
#import "JCHATConversationViewController.h"
#import "JCHATSelectFriendsCtl.h"
#import "MBProgressHUD+HBProgresss.h"
#import "JCHATAlertViewWait.h"
#import "AppDelegate.h"
#import "MyFriendCircleController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "CirclePopMenuController.h"
#import "FriendSearchController.h"
#import "PZNavController.h"
#import "YCXMenu.h"
#import "UIView+Extension.h"
#import "XTChatUtil.h"
#define kBackBtnFrame CGRectMake(0, 0, 50, 30)
#define kBubbleBtnColor UIColorFromRGB(0x4880d7)
@interface JCHATConversationListViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    __block NSMutableArray *_conversationArr;
    UIButton *_rightBarButton;
    NSInteger _unreadCount;
    UILabel *_titleLabel;
}
@property(strong,nonatomic)CirclePopMenuController *menuVc ;
@end

@implementation JCHATConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [self addNotifications];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupBubbleView];
    [self setupChatTable];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (!appDelegate.isDBMigrating) {
        [self addDelegate];
    } else {
        NSLog(@"is DBMigrating don't get allconversations");
        [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
    }
}

-(void)setNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.titleLabel.textAlignment = NSTextAlignmentRight;
    [right setImage:[UIImage imageNamed:@"xixin_nav_btn_more"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)rightItemClick:(UIButton*)sender{
    WEAKSELF
    NSArray* items = [self createItems] ;
    [YCXMenu showMenuInView:self.chatTableView fromRect:CGRectMake(self.view.frame.size.width - 50, 0, 50, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        //喜信登录检测
        [XTChatUtil autoLogin:^(id resultObject, NSError *error) {
            if (index == 0) {
                [weakSelf creatGroupChat];
            }
            else if (index == 1){
                MyFriendCircleController* circle = [[MyFriendCircleController alloc]init];
                circle.title = @"朋友通讯录" ;
                [weakSelf.navigationController pushViewController:circle animated:YES];
            }
            else if(index ==2){
                FriendSearchController* friendSearch = [[FriendSearchController alloc]init];
                friendSearch.title = @"添加朋友" ;
                [weakSelf.navigationController pushViewController:friendSearch animated:YES];
            }
        }];
    }];
}

- (NSArray *)createItems {
        // set title
    NSArray* _items = @[
                [YCXMenuItem menuItem:@"发起群聊"
                                image:[UIImage imageNamed:@"xixin_icon_group-chat"]
                                  tag:100
                             userInfo:nil
                 ],
                [YCXMenuItem menuItem:@"通讯录"
                                image:[UIImage imageNamed:@"xixin_icon_mail-list"]
                                  tag:101
                             userInfo:nil

                             ]
                ];
    return _items;
}


#pragma mark - 创建群聊
-(void)creatGroupChat{
    WEAKSELF
    MyFriendCircleController* chatFriendChoose = [[MyFriendCircleController alloc]init];
    chatFriendChoose.seleteMode = YES ;
    chatFriendChoose.chooseCompleteBlock = ^(NSArray* persons){
        if (persons.count) {
            [weakSelf beginChatGroup:persons];
        }
    };
    chatFriendChoose.title = @"选择联系人" ;
    PZNavController* nav = [[PZNavController alloc]initWithRootViewController:chatFriendChoose];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - 开始群聊
-(void)beginChatGroup:(NSArray*)persons{
    //  创建群组
    [JMSGGroup createGroupWithName:@"群聊" desc:@"大家一起来" memberArray:persons completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            JMSGGroup *group = (JMSGGroup *)resultObject;
            JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
            sendMessageCtl.superViewController = self;
            JMSGConversation *conversation = [JMSGConversation groupConversationWithGroupId:group.gid];
            sendMessageCtl.conversation = conversation;
            [self.navigationController pushViewController:sendMessageCtl animated:YES];
        }
    }];
}


- (void)setupNavigation {
    
//     UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"circle-of-friends_icon_mail-list"] style:UIBarButtonItemStylePlain target:self action:@selector(goMyCircle)];
//    self.navigationItem.rightBarButtonItem = rightItem;//为导航栏添加右侧按钮
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJPFNetworkDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnecting)
                                                 name:kJPFNetworkIsConnectingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dBMigrateFinish)
                                                 name:kDBMigrateFinishNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadyLoginClick)
                                                 name:kLogin_NotifiCation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creatGroupSuccessToPushView:)
                                                 name:kCreatGroupState
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skipToSingleChatView:)
                                                 name:kSkipToSingleChatViewState
                                               object:nil];
}

- (void)setupBubbleView {
    _addBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kApplicationWidth - 100, 1, 100, 100)];
    [_addBgView setBackgroundColor:[UIColor clearColor]];
    [_addBgView setUserInteractionEnabled:YES];
    UIImage *frameImg = [UIImage imageNamed:@"frame"];
    frameImg = [frameImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 64) resizingMode:UIImageResizingModeTile];
    [_addBgView setImage:frameImg];
    [_addBgView setHidden:YES];
    [self.view addSubview:self.addBgView];
    [self.view bringSubviewToFront:self.addBgView];
    [self addBtn];
}

- (void)setupChatTable {
    JCHATChatTable* chatTableView = [[JCHATChatTable alloc]init];
    self.chatTableView = chatTableView ;
    [self.view addSubview:chatTableView];
    [chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_chatTableView setBackgroundColor:[UIColor whiteColor]];
    _chatTableView.dataSource=self;
    _chatTableView.delegate=self;
    _chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _chatTableView.touchDelegate = self;
    
    [_chatTableView registerNib:[UINib nibWithNibName:@"JCHATConversationListCell" bundle:nil] forCellReuseIdentifier:@"JCHATConversationListCell"];
}

- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}

- (void)skipToSingleChatView :(NSNotification *)notification {
    JMSGUser *user = [[notification object] copy];
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];//!!
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:user.username appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            //DDLogDebug(@"createSingleConversationWithUsername");
        }
    }];
}

- (void)dBMigrateFinish {
    NSLog(@"Migrate is finish  and get allconversation");
    JCHATMAINTHREAD(^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    [self addDelegate];
    [self getConversationList];
}

- (JMSGConversation *)getConversationWithTargetId:(NSString *)targetId {
    for (NSInteger i=0; i< [_conversationArr count]; i++) {
        JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
        
        if (conversation.conversationType == kJMSGConversationTypeSingle) {
            if ([((JMSGUser *)conversation.target).username isEqualToString:targetId]) {
                return conversation;
            }
        } else {
            if ([((JMSGGroup *)conversation.target).gid isEqualToString:targetId]) {
                return conversation;
            }
        }
    }
    //DDLogDebug(@"Action getConversationWithTargetId  fail to meet conversation");
    return nil;
}

- (void)reloadConversationInfo:(JMSGConversation *)conversation {
    //DDLogDebug(@"Action - creatGroupSuccessToPushView - %@", conversation);
    for (NSInteger i=0; i<[_conversationArr count]; i++) {
        JMSGConversation *conversationObject = [_conversationArr objectAtIndex:i];
        if ([conversationObject.target isEqualToConversation:conversation.target]) {
            [_conversationArr removeObjectAtIndex:i];
            [_conversationArr insertObject:conversation atIndex:i];
            [_chatTableView reloadData];
            return;
        }
    }
}

#pragma mark --创建群成功Push group viewctl
- (void)creatGroupSuccessToPushView:(NSNotification *)object{//group
    //DDLogDebug(@"Action - creatGroupSuccessToPushView - %@", object);
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed=YES;
    [JMSGConversation createGroupConversationWithGroupId:((JMSGGroup *)[object object]).gid completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = (JMSGConversation *)resultObject;
            JCHATMAINTHREAD(^{
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            //DDLogDebug(@"createGroupConversationwithgroupid fail");
        }
    }];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (!appDelegate.isDBMigrating) {
        [self getConversationList];
    } else {
        NSLog(@"is DBMigrating don't get allconversations");
        [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
    }
}


- (void)netWorkConnectClose {
    _titleLabel.text =@"未连接";
}

- (void)netWorkConnectSetup {
    //DDLogDebug(@"Action - netWorkConnectSetup");
    _titleLabel.text =@"收取中...";
}

- (void)connectSucceed {
    //DDLogDebug(@"Action - connectSucceed");
    _titleLabel.text =@"会话";
}

- (void)isConnecting {
    //DDLogDebug(@"Action - isConnecting");
    _titleLabel.text =@"连接中...";
}


#pragma mark JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    //DDLogDebug(@"Action -- onReceivemessage %@",message);
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    //DDLogDebug(@"Action -- onConversationChanged");
    [self getConversationList];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    //DDLogDebug(@"Action -- onGroupInfoChanged");
    [self getConversationList];
}



- (void)getConversationList {
    WEAKSELF
    [self.addBgView setHidden:YES];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        JCHATMAINTHREAD(^{
            if (error == nil) {
                _conversationArr = [self sortConversation:resultObject];
                _unreadCount = 0;
                for (NSInteger i=0; i < [_conversationArr count]; i++) {
                    JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
                    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
                }
                [self saveBadge:_unreadCount];
            } else {
                _conversationArr = nil;
            }
            weakSelf.chatTableView.emptyDataSetSource = weakSelf ;
            weakSelf.chatTableView.emptyDataSetDelegate = weakSelf ;
            [self.chatTableView reloadData];
        });
    }];
}

NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)alreadyLoginClick {
    [self getConversationList];
}

- (void)addBtn {
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            [btn setTitle:@"发起群聊" forState:UIControlStateNormal];
        }
        if (i==1) {
            [btn setTitle:@"发起单聊" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i + 100;
        [btn setFrame:CGRectMake(10, i*30+30, 80, 30)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setBackgroundImage:[ViewUtil colorImage:kBubbleBtnColor frame:btn.frame] forState:UIControlStateHighlighted];
        [self.addBgView addSubview:btn];
    }
}

- (void)btnClick :(UIButton *)btn {
    [self.addBgView setHidden:YES];
    if (btn.tag == 100) {
        JCHATSelectFriendsCtl *selectCtl =[[JCHATSelectFriendsCtl alloc] init];
        UINavigationController *selectNav =[[UINavigationController alloc] initWithRootViewController:selectCtl];
        [self.navigationController presentViewController:selectNav animated:YES completion:nil];
    } else if (btn.tag == 101) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加聊天对象"
                                                          message:@"输入对方的用户名!"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
        [alerView show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    } else if (buttonIndex == 1)
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请输入用户名" view:self.view];
            return;
        }
        
        [[JCHATAlertViewWait ins] showInView];
        __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
        sendMessageCtl.superViewController = self;
        sendMessageCtl.hidesBottomBarWhenPushed = YES;
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        __weak __typeof(self)weakSelf = self;
        [JMSGConversation createSingleConversationWithUsername:[alertView textFieldAtIndex:0].text appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
            [[JCHATAlertViewWait ins] hidenAll];
            
            if (error == nil) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                sendMessageCtl.conversation = resultObject;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            } else {
                //DDLogDebug(@"createSingleConversationWithUsername fail");
                [MBProgressHUD showMessage:@"添加的用户不存在" view:self.view];
            }
        }];
    }
}

#pragma mark - 我的朋友圈
-(void)goMyCircle{
    MyFriendCircleController* friendCircle = [[MyFriendCircleController alloc]init];
    friendCircle.title = @"朋友通讯录" ;
    [self.navigationController pushViewController:friendCircle animated:YES];
}

- (void)perFormAdd {
    
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    [self.addBgView setHidden:YES];
    _rightBarButton.selected=NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //DDLogDebug(@"Action - tableView");
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username appKey:JMESSAGE_APPKEY
         ];
    } else {
        [JMSGConversation deleteGroupConversationWithGroupId:((JMSGGroup *)conversation.target).gid];
    }
    
    [_conversationArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_conversationArr count] > 0) {
        return [_conversationArr count];
    } else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JCHATConversationListCell";
    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell setCellDataWithConversation:conversation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar {
    
}

//响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_conversationArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    sendMessageCtl.superViewController = self;
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    sendMessageCtl.conversation = conversation;
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
    
    NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
    [self saveBadge:badge];
}

- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyChat object:nil];

}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
    
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无会话信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: PZFont(14.0f),
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self goMyCircle];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


@end
