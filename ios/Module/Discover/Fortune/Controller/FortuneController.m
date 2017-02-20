//
//  FortuneController.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneController.h"
#import "FortuneHeader.h"
#import "FortuneFooter.h"
#import "RRFBuyFortuneController.h"
#import "RRFFortuneDiaryController.h"
#import <FSCalendar/FSCalendar.h>
#import "FortuneCell.h"
#import "RRFCalendarView.h"
#import <LGAlertView/LGAlertView.h>
#import "FortuneWebController.h"
#import "FortuneTool.h"
#import "PZParamTool.h"
#import "RRFMeTool.h"
#import "LoginModel.h"
#import "RadioButton.h"
#import "CalendarHeader.h"

typedef void(^AlertAction)();

@interface FortuneController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource,FSCalendarDelegate,UIPickerViewDelegate,LGAlertViewDelegate,UIPickerViewDataSource,CAAnimationDelegate>
{
    NSArray* _titles ;
    NSArray* _images;
    LGAlertView* actionSheet ;
    
    
}
@property(nonatomic,weak)UIButton *cancelBtn;
@property(nonatomic,weak)RRFCalendarView *dayView;

//阴历
@property(nonatomic,strong)NSArray *chineseYears;
@property(nonatomic,strong)NSArray *chineseMonths;
@property(nonatomic,strong)NSArray *chineseDays;
@property(nonatomic,strong)NSArray *chineseHours;
//阳历
@property(nonatomic,strong)NSArray *solarYears;
@property(nonatomic,strong)NSArray *solarMonths;
@property(nonatomic,strong)NSArray *solarDays;
@property(nonatomic,strong)NSArray *solarHours;


@property(strong,nonatomic)    NSMutableDictionary* titleDictionary ;

@property(weak,nonatomic)FortuneHeader* header  ;
@property(weak,nonatomic)FortuneFooter* footer ;
@property(weak,nonatomic)UIImageView* leftDoor ;
@property(weak,nonatomic)UIImageView* rightDoor ;

@property(assign,nonatomic) int remainDays ;
@property(copy,nonatomic) NSString* fortuneDay;
@property(copy,nonatomic) NSString* birthday;


@property(assign,nonatomic) NSInteger yearIndex ;
@property(assign,nonatomic) NSInteger monthIndex ;
@property(assign,nonatomic) NSInteger dayIndex ;
@property(assign,nonatomic) NSInteger hourIndex ;

//1 boy 2 girl
@property(assign,nonatomic) NSInteger gender ;


//出生年月日 1 运程日 2
@property(assign,nonatomic) NSInteger actionSheetType;

//阴阳切换 0 阴  1 阳
@property(assign,nonatomic) NSInteger solarType;


@property(strong,nonatomic)NSMutableArray* buttons ;


@property(strong,nonatomic)NSArray* dateArray ;
@end

@implementation FortuneController

-(NSMutableArray *)buttons{
    if (_buttons == nil) {
        _buttons = [NSMutableArray arrayWithCapacity:2];
    }
    return _buttons ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.bounces = NO ;
//    self.gender = 1 ;
//    self.actionSheetType = 1 ;
//    self.yearIndex = 70 ;
//    self.monthIndex = 4 ;
//    self.dayIndex = 11 ;
//    self.hourIndex = 11 ;
    
//    self.solarType = 0 ;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    _titles = @[@"性别",@"八字",@"运程日"];
    _images = @[@"measure_icon_gender",@"measure_icon_gossip",@"measure_icon_time"];
    FortuneHeader* header = [[FortuneHeader alloc]init];
    self.header= header ;
    header.MemberCenterBlock = ^{
        RRFBuyFortuneController *desc = [[RRFBuyFortuneController alloc]init];
        desc.title = @"购买运程";
        desc.remainDays = weakSelf.remainDays ;
        [self.navigationController pushViewController:desc animated:YES];
    };
    header.frame = CGRectMake(0, 0, SCREENWidth, 140);
    self.tableView.tableHeaderView = header ;
    
    FortuneFooter* footer = [[FortuneFooter alloc]init];
    footer.computeFortune = ^(FortuneFooter* sender){
        NSString* fortuneDay = self.fortuneDay ;
        NSString* birthDay = self.birthday ;
        if (fortuneDay == nil  ||fortuneDay.length==0) {
            [MBProgressHUD showInfoWithStatus:@"请选择运势日期"];
            return ;
        }
        if (birthDay == nil ||birthDay.length==0) {
            [MBProgressHUD showInfoWithStatus:@"请选择生辰日期"];
            return ;
        }
        [sender doAnimateRotate];
        [weakSelf performSelector:@selector(doComputeFortune) withObject:nil afterDelay:.5];
    };
    footer.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-140-64-3*44);
    self.tableView.tableFooterView = footer ;
    self.footer = footer ;
    
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"measure_btn_record"] style:UIBarButtonItemStylePlain target:self action:@selector(diary)];
    self.navigationItem.rightBarButtonItem = right;
    [self date];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self setUpDoors];
    
    if ([PZParamTool hasLogin]) {
        [RRFMeTool requestUserInfoWithSuccess:^(id json) {
            if(json != nil){
                LoginModel* userM = [LoginModel yy_modelWithJSON:json[@"userInfo"]];
                [weakSelf.header configHeader:userM];
            }
        } failBlock:^(id json) {
        }];
    }
    
    //radio button
    CGRect btnRect = CGRectMake(25, 0, 100, 44);
    RadioButton* btnMale = [[RadioButton alloc] initWithFrame:btnRect];
    [btnMale addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];

    [btnMale setImage:[UIImage imageNamed:@"measure_icon_uncheck"] forState:UIControlStateNormal];
    [btnMale setImage:[UIImage imageNamed:@"measure_icon_selected"] forState:UIControlStateSelected];
    [btnMale setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnMale setTitle:@"男" forState:UIControlStateNormal];
    btnMale.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);

    RadioButton* btnFemale = [[RadioButton alloc] initWithFrame:btnRect];
    [btnFemale addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];

    [btnFemale setImage:[UIImage imageNamed:@"measure_icon_uncheck"] forState:UIControlStateNormal];
    [btnFemale setImage:[UIImage imageNamed:@"measure_icon_selected"] forState:UIControlStateSelected];
    btnFemale.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [btnFemale setTitle:@"女" forState:UIControlStateNormal];
    [btnFemale setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    [self.buttons addObjectsFromArray:@[btnMale,btnFemale]];
    
    [self.buttons[0] setGroupButtons:self.buttons]; // Setting buttons into the group
    [self.buttons[1] setGroupButtons:self.buttons]; // Setting buttons into the group
}


-(void)requestRemainDays{
    WEAKSELF
    [FortuneTool getuserFortuneInfoSuccessBlock:^(id json) {
        int remainTimes = [json[@"remainTimes"] intValue];
        weakSelf.remainDays = remainTimes ;
        [weakSelf.header update:json];
    } fail:^(id json) {
        
    }];
}

-(void)doComputeFortune{
    WEAKSELF
    NSString* fortuneDay = self.fortuneDay ;
    if (self.birthday == nil ||self.birthday.length==0) {
        [MBProgressHUD showInfoWithStatus:@"请选择生辰八字"];
        return ;
    }
    if (fortuneDay == nil||fortuneDay.length==0) {
        [MBProgressHUD showInfoWithStatus:@"请选择运势日期"];
        return ;
    }
    NSString* birthday = [self getDisplayDateString];
    [FortuneTool computeFortune:birthday fortuneDay:fortuneDay gender:self.gender successBlock:^(id json) {
        FortuneWebController* web = [[FortuneWebController alloc]init];
        NSString* pathUrl = [NSString stringWithFormat:@"%@xitenggame/singleWrap/dailyHoroscope.html",Base_url];
        web.pathUrl =pathUrl;
        web.param = @{
                      @"id":json[@"id"]
                      };
        web.title = @"运势" ;
        web.share = YES ;
        [weakSelf.navigationController pushViewController:web animated:YES];
        [weakSelf.footer stopAnimateRotate];
    } fail:^(id json) {
        [weakSelf.footer stopAnimateRotate];
        [weakSelf showActionWithTitle:@"测算运程天数不足" message:@"你需要购买新的运程测算天数!" cancelAction:^{
            
        } confirmAction:^{
            RRFBuyFortuneController* buyFortune = [[RRFBuyFortuneController alloc]init];
            buyFortune.remainDays = 0 ;
            [weakSelf.navigationController pushViewController:buyFortune animated:YES];
        } confirmTitle:@"确认"];
    }];
}

-(void)showActionWithTitle:(NSString*)title message:(NSString*)msg cancelAction:(AlertAction)cancelAct confirmAction:(AlertAction)confirm confirmTitle:(NSString*)confirmTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelAct];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirm];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    if(sender.selected) {
        NSString* genderString = sender.titleLabel.text ;
        self.gender = [genderString isEqualToString:@"男"] ? 1: 2 ;
    }
}


-(void)setUpDoors{
    UIImageView* leftDoor = [[UIImageView alloc]init];
    leftDoor.alpha = 0 ;
    leftDoor.image = [UIImage imageNamed:@"left_door"];
    self.leftDoor = leftDoor ;
    
    leftDoor.frame = CGRectMake(0, -44-14-24, SCREENWidth/2, SCREENHeight);
    [self.view addSubview:leftDoor];
    
    UIImageView* rightDoor = [[UIImageView alloc]init];
    rightDoor.alpha = 0 ;
    rightDoor.image = [UIImage imageNamed:@"right_door"];
    self.rightDoor = rightDoor ;
    rightDoor.frame = CGRectMake(SCREENWidth/2, -44-14-24, SCREENWidth/2, SCREENHeight);
    [self.view addSubview:rightDoor];
}

-(void)showDoor{
    CABasicAnimation *leftAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    leftAnimation.fromValue = [NSNumber numberWithFloat:-SCREENWidth/2];
    leftAnimation.toValue = [NSNumber numberWithFloat:0];
    leftAnimation.delegate = self;
    leftAnimation.duration = 1.0f;//动画持续时间
    leftAnimation.repeatCount = 1;//动画重复次数
    [self.leftDoor.layer addAnimation:leftAnimation forKey:@"leftDoor"];

    
    CABasicAnimation *rightAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    rightAnimation.fromValue = [NSNumber numberWithFloat:SCREENWidth];
    rightAnimation.toValue = [NSNumber numberWithFloat:0];
    
    rightAnimation.duration = 1.0f;//动画持续时间
    rightAnimation.repeatCount = 1;//动画重复次数
    
    [self.rightDoor.layer addAnimation:rightAnimation forKey:@"rightDoor"];
}


/**
 * 动画开始时
 */
- (void)animationDidStart:(CAAnimation *)theAnimation
{
    self.leftDoor.alpha = 1 ;
    self.rightDoor.alpha = 1 ;
}

/**
 * 动画结束时
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"end");
}


-(NSMutableDictionary *)titleDictionary{
    if (_titleDictionary == nil) {
        NSArray* sepDatas = [[[NSDate date] description] componentsSeparatedByString:@" "];
        NSString* dateString = [sepDatas firstObject];
        self.fortuneDay = dateString ;
        _titleDictionary = [NSMutableDictionary dictionary];
        [_titleDictionary setObject:self.birthday forKey:@"1"];
        [_titleDictionary setObject:dateString forKey:@"2"];
    }
    return _titleDictionary ;
}

-(void)diary
{
    //[self showDoor];
    //return ;
    RRFFortuneDiaryController *desc = [[RRFFortuneDiaryController alloc]init];
    desc.title = @"运程日记";
    [self.navigationController pushViewController:desc animated:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f ;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FortuneCell* cell = [[FortuneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FortuneCell"];
    if (indexPath.row == 0) {
        int index = 0 ;
        for (RadioButton* item in self.buttons) {
            item.frame = CGRectMake(96-16+index*80, 0, 80, 44);
            [cell addSubview:item];
            index++ ;
        }
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    NSString* title = _titles[indexPath.row] ;
    NSString* icon = _images[indexPath.row] ;
    NSString* key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [cell configTitle:title icon:icon  data:[self.titleDictionary objectForKey:key]];
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self setDayView];
    }
    else if (indexPath.row == 2) {
        WEAKSELF
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth-40, 360-40)];
        calendar.backgroundColor = [UIColor whiteColor];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        calendar.scrollDirection = FSCalendarScrollDirectionVertical;

        actionSheet = [[LGAlertView alloc]initWithViewAndTitle:@"运程日选择" message:nil style:LGAlertViewStyleActionSheet view:calendar buttonTitles:@[] cancelButtonTitle:@"取消" destructiveButtonTitle:@"" delegate:self];
        [actionSheet showAnimated:YES completionHandler:^{
            weakSelf.actionSheetType = 2 ;
        }];
    }
}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    WEAKSELF
    //这里处理8个小时时间差问题，下面这三句可以解决相差8个小时问题
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * nowDate = [date dateByAddingTimeInterval:interval];
    NSArray* sepDatas = [[nowDate description] componentsSeparatedByString:@" "];
    NSString* dateString = [sepDatas firstObject];
    self.fortuneDay = dateString ;
    if (actionSheet != nil) {
        [actionSheet dismissAnimated:YES completionHandler:^{
            [weakSelf.titleDictionary setValue:dateString forKey:@"2"];
            [weakSelf.tableView reloadData];
        }];
    }
}

-(void)setDayView
{
    WEAKSELF
    RRFCalendarView *dayView =[[RRFCalendarView alloc]init];
    dayView.frame = CGRectMake(0,0, SCREENWidth-40, 200);
    dayView.pickerView.delegate = self;
    dayView.pickerView.dataSource = self;
   
    [dayView.pickerView selectRow:self.yearIndex inComponent:0 animated:YES];
    [dayView.pickerView selectRow:self.monthIndex inComponent:1 animated:YES];
    [dayView.pickerView selectRow:self.dayIndex inComponent:2 animated:YES];
    [dayView.pickerView selectRow:self.hourIndex inComponent:3 animated:YES];

    self.dayView = dayView;
    actionSheet = [[LGAlertView alloc]initWithViewAndTitle:nil message:nil style:LGAlertViewStyleActionSheet view:dayView buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:nil delegate:self];
    actionSheet.dismissOnAction = YES ;
    [actionSheet showAnimated:YES completionHandler:^{
        weakSelf.actionSheetType = 1 ;
    }];
    dayView.confirmBlock = ^{
        [actionSheet dismissAnimated:YES completionHandler:nil];
    };
    //阴阳切换
    dayView.switchSolarBlock = ^(NSInteger index){
        weakSelf.solarType = index;
        [self.dayView.pickerView reloadAllComponents];
    };
}

-(NSString*)getDisplayDateString{
    //出生年月日
    NSString* year = self.dateArray[0][self.solarType][self.yearIndex];
    NSString* month = self.dateArray[1][self.solarType][self.monthIndex];
    NSString* day = self.dateArray[2][self.solarType][self.dayIndex];
    NSString* hour = self.dateArray[3][self.solarType][self.hourIndex];
    NSString* birthday = [NSString stringWithFormat:@"%@ %@ %@ %@",year,month,day,hour];
    [self.titleDictionary setValue:birthday forKey:@"1"];
    if (self.solarType == 0) {
        self.hourIndex = 24 - self.hourIndex -1;
        //转阳历
        Lunar *l = [[Lunar alloc]initWithYear:(int)(self.yearIndex+1920)
                                     andMonth:(int)(self.monthIndex+1)
                                       andDay:(int)(self.dayIndex+1)];
        Solar *s = [CalendarDisplyManager obtainSolarFromLunar:l];
        year = [NSString stringWithFormat:@"%i",s.solarYear];
        month = [NSString stringWithFormat:@"%i",s.solarMonth];
        day = [NSString stringWithFormat:@"%i",s.solarDay];
        NSString* paramStr = [NSString stringWithFormat:@"%@-%@-%@ %ld:00:00",year,month,day,self.hourIndex+1];
        return paramStr ;
//        self.birthday = paramStr ;
    }
    else{
        NSString* paramStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:00:00",self.yearIndex+1920,self.monthIndex+1,self.dayIndex+1,self.hourIndex+1];
//        self.birthday = paramStr ;
        return paramStr ;
    }
}

- (void)alertViewDidDismiss:(LGAlertView *)alertView{
    if (self.actionSheetType == 1) {
        self.birthday = [self getDisplayDateString];
//        //出生年月日
//        NSString* year = self.dateArray[0][self.solarType][self.yearIndex];
//        NSString* month = self.dateArray[1][self.solarType][self.monthIndex];
//        NSString* day = self.dateArray[2][self.solarType][self.dayIndex];
//        NSString* hour = self.dateArray[3][self.solarType][self.hourIndex];
//        NSString* birthday = [NSString stringWithFormat:@"%@ %@ %@ %@",year,month,day,hour];
//        [self.titleDictionary setValue:birthday forKey:@"1"];
//        if (self.solarType == 0) {
//            self.hourIndex = 24 - self.hourIndex -1;
//            //转阳历
//            Lunar *l = [[Lunar alloc]initWithYear:(int)(self.yearIndex+1920)
//                                         andMonth:(int)(self.monthIndex+1)
//                                           andDay:(int)(self.dayIndex+1)];
//            Solar *s = [CalendarDisplyManager obtainSolarFromLunar:l];
//            year = [NSString stringWithFormat:@"%i",s.solarYear];
//            month = [NSString stringWithFormat:@"%i",s.solarMonth];
//            day = [NSString stringWithFormat:@"%i",s.solarDay];
//            NSString* paramStr = [NSString stringWithFormat:@"%@-%@-%@ %ld:00:00",year,month,day,self.hourIndex+1];
//            self.birthday = paramStr ;
//        }
//        else{
//            NSString* paramStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:00:00",self.yearIndex+1920,self.monthIndex+1,self.dayIndex+1,self.hourIndex+1];
//            self.birthday = paramStr ;
//        }
        [self.tableView reloadData];
    }
}

// 共有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dateArray.count ;
}
// 每列多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray* dates = self.dateArray[component][self.solarType] ;
    return dates.count ;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString* title = self.dateArray[component][self.solarType][row];
    UILabel *titleView = [[UILabel alloc]init];
    [titleView sizeToFit];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont systemFontOfSize:14];
    titleView.textColor = [UIColor blackColor];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.text = title ;
    return titleView ;
}


// 每列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 90 ;
    }
    else if (component == 3){
        return 90 ;
    }
    return (SCREENWidth-40 - 2*90)/2;
}

// 每行显示的文字
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dateArray[component][self.solarType][row];
}
// 返回选中的数据
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.yearIndex = row ;
    }else if (component == 1){
        self.monthIndex = row ;
    }else if (component == 2){
        self.dayIndex = row ;
    }
    else{
        self.hourIndex = row ;
    }
}
-(void)hiddenShareView
{
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [self.dayView removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
    }];
}


-(void)date{
    NSMutableArray* years = [NSMutableArray array];
    for (int i = 1920; i<=2018; i++) {
        [years addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    self.chineseYears = years ;
    self.solarYears = years ;
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    self.chineseMonths = chineseMonths;
    
    NSMutableArray* solarMonths = [NSMutableArray array];
    for (int i = 1; i<=12; i++) {
        [solarMonths addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    self.solarMonths = solarMonths ;
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三十一", nil];
    self.chineseDays = chineseDays;
    
    NSMutableArray* solarDays = [NSMutableArray array];
    for (int i = 1; i<=31; i++) {
        [solarDays addObject:[NSString stringWithFormat:@"%d日",i]];
    }
    self.solarDays = solarDays ;
    self.chineseHours = @[
                          @"子时23点",@"子时0点",
                          @"丑时1点",@"丑时2点",
                          @"寅时3点",@"寅时4点",
                          @"卯时5点",@"卯时6点",
                          @"辰时7点",@"辰时8点",
                          @"巳时9点",@"巳时10点",
                          @"午时11点",@"午时12点",
                          @"未时13点",@"未时14点",
                          @"申时15点",@"申时16点",
                          @"酉时17点",@"酉时18点",
                          @"戌时19点",@"戌时20点",
                          @"亥时21点",@"亥时22点"];

    NSMutableArray* hours = [NSMutableArray array];
    for (int i = 1; i<=24; i++) {
        [hours addObject:[NSString stringWithFormat:@"%d时",i]];
    }
    self.solarHours = hours ;
    
    self.dateArray = @[@[self.chineseYears,self.solarYears],
                       @[self.chineseMonths,self.solarMonths],
                       @[self.chineseDays,self.solarDays],
                       @[self.chineseHours,self.solarHours]
                       ];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults] ;
    
    [userDefault setInteger:self.gender forKey:@"gender"];
    [userDefault setInteger:self.actionSheetType forKey:@"actionSheetType"];
    [userDefault setInteger:self.yearIndex forKey:@"yearIndex"];
    [userDefault setInteger:self.monthIndex forKey:@"monthIndex"];
    [userDefault setInteger:self.dayIndex forKey:@"dayIndex"];
    [userDefault setInteger:self.hourIndex forKey:@"hourIndex"];
    [userDefault setInteger:self.solarType forKey:@"solarType"];
    [userDefault synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestRemainDays];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults] ;

    self.gender = [userDefault integerForKey:@"gender"] ? [userDefault integerForKey:@"gender"]:1 ;
    self.actionSheetType = [userDefault integerForKey:@"actionSheetType"]?[userDefault integerForKey:@"actionSheetType"]:1 ;
    self.yearIndex = [userDefault integerForKey:@"yearIndex"] ? [userDefault integerForKey:@"yearIndex"]:70 ;
    self.monthIndex = [userDefault integerForKey:@"monthIndex"] ? [userDefault integerForKey:@"monthIndex"]:4 ;
    self.dayIndex = [userDefault integerForKey:@"dayIndex"]?[userDefault integerForKey:@"dayIndex"]:11 ;
    self.hourIndex = [userDefault integerForKey:@"hourIndex"]?[userDefault integerForKey:@"hourIndex"]:11 ;
    self.solarType = [userDefault integerForKey:@"solarType"]?[userDefault integerForKey:@"solarType"]:0 ;
    
    [self.buttons[self.gender-1] setSelected:YES]; // Making the first button initially selected
    
    NSString* year = self.dateArray[0][self.solarType][self.yearIndex];
    NSString* month = self.dateArray[1][self.solarType][self.monthIndex];
    NSString* day = self.dateArray[2][self.solarType][self.dayIndex];
    NSString* hour = self.dateArray[3][self.solarType][self.hourIndex];
    NSString* birthday = [NSString stringWithFormat:@"%@ %@ %@ %@",year,month,day,hour];
    if (birthday != nil) {
        self.birthday = birthday ;
    }
    else{
        self.birthday = @"" ;
    }
}


@end
