//
//  JNQRedPaperViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "JNQRedPaperViewController.h"
#import "JNQRedPaperView.h"
#import "JNQRedPaperCell.h"

@interface JNQRedPaperViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *redPaperTv;
@property (nonatomic, strong) NSMutableArray *rpArray;
@property (nonatomic, strong) JNQRedPaperHeaderView *headerV;

@end

@implementation JNQRedPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(235, 82, 82);
    
    if ([_pModel.place isEqualToString:@"group"] || [_pModel.place isEqualToString:@"friendCircle"]) {
        //列表显示
        //发/收方-群手气-已拆-过期/结束/进行
        //发方-群手气-未拆-过期/结束/进行
        //收方-群手气-未拆-结束
        //发方-群普通-过期/结束/进行
        if (([_pModel.bonusType isEqualToString:@"random"] && !(!_isSend&&[_pModel.isReceive isEqualToString:@"noReceive"]&&![_pModel.status isEqualToString:@"empty_finish"])) ||
            (_isSend&&[_pModel.bonusType isEqualToString:@"average"])) {
            _rpArray = [NSMutableArray arrayWithArray:_pModel.acceptModels];
        } else if (!_isSend && [_pModel.bonusType isEqualToString:@"average"]) {
            //列表不显示
            //收方-群普通-已拆-结束
            //收方-群普通-未拆-过期/进行
            _rpArray = [NSMutableArray array];
        }
    } else {
        //收方已拆
        _rpArray = _isSend&&[_pModel.isReceive isEqualToString:@"alreadyReceive"]&&![_pModel.status isEqualToString:@"running"] ? [NSMutableArray arrayWithObject:_pModel.acceptModel] : [NSMutableArray array];
    }
    [self buildUI];
    [self setNav];
    [_redPaperTv reloadData];
}

- (void)setNav {
    UIView *navBar = [[UIView alloc] init];
    [self.view insertSubview:navBar atIndex:0];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    navBar.backgroundColor = HBColor(227, 85, 75);
    
    UIButton *navLeft = [[UIButton alloc] init];
    [navBar addSubview:navLeft];
    [navLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(navBar);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(44);
    }];
    navLeft.titleLabel.font = PZFont(13.5);
    [navLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navLeft setTitle:@"关闭" forState:UIControlStateNormal];
    [[navLeft rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UILabel *navTitle = [[UILabel alloc] init];
    [navBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navBar).offset(20);
        make.left.bottom.width.mas_equalTo(navBar);
    }];
    navTitle.font = [UIFont boldSystemFontOfSize:15];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.text = @"喜腾红包";
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)buildUI {
    _redPaperTv = [[UITableView alloc] init];
    [self.view addSubview:_redPaperTv];
    [_redPaperTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.left.bottom.width.mas_equalTo(self.view);
    }];
    _redPaperTv.backgroundColor = HBColor(245, 245, 245);
    _redPaperTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    _redPaperTv.delegate = self;
    _redPaperTv.dataSource = self;
    
    CGFloat height = 0;
    if ([_pModel.place isEqualToString:@"group"] || [_pModel.place isEqualToString:@"friendCircle"]) {
        if ([_pModel.isReceive isEqualToString:@"noReceive"] ||
            (_isSend&&[_pModel.bonusType isEqualToString:@"average"])) {
            //无金额
            //发方-群普通-过期/结束/进行
            //发方-群手气-未拆-过期/结束/进行
            //收方-群手气-未拆-结束
            height = 165;
        } else if ([_pModel.isReceive isEqualToString:@"alreadyReceive"]) {
            //有金额
            //收方-群普通-已拆-结束
            //发/收方-群手气-已拆-过期/结束/进行
            height = 280;
        }
    } else {
        //无金额：发方-单红包-过期/结束/进行
        //有金额：收方-单红包-已拆-结束
        height = _isSend ? 165 : 280;
    }

    _headerV = [[JNQRedPaperHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, height)];
    [_redPaperTv setTableHeaderView:_headerV];
    _headerV.isSend = _isSend;
    _headerV.pModel = _pModel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rpArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_pModel.place isEqualToString:@"group"] || [_pModel.place isEqualToString:@"friendCircle"]) {
        //列表显示
        //发/收方-群手气-已拆-过期/结束/进行
        //发方-群手气-未拆-过期/结束/进行
        //收方-群手气-未拆-结束
        //发方-群普通-过期/结束/进行
        CGFloat height;
        if (([_pModel.bonusType isEqualToString:@"random"] && !(!_isSend&&[_pModel.isReceive isEqualToString:@"noReceive"]&&![_pModel.status isEqualToString:@"empty_finish"])) ||
            (_isSend&&[_pModel.bonusType isEqualToString:@"average"])) {
            height = 26;
        } else if (!_isSend && [_pModel.bonusType isEqualToString:@"average"]) {
            //列表不显示
            //收方-群普通-已拆-结束
            //收方-群普通-未拆-过期/进行
            height = 0;
        }
        return height;
    } else {
        //收方已拆
        return _isSend ? 26 : 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((_isSend&&[_pModel.place isEqualToString:@"single"]) ||
        [_pModel.bonusType isEqualToString:@"random"] ||
        (_isSend&&[_pModel.bonusType isEqualToString:@"average"])) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 26)];
        header.backgroundColor = HBColor(245, 245, 245);
        UILabel *attenL = [[UILabel alloc] init];
        [header addSubview:attenL];
        [attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(header).offset(8);
            make.left.mas_equalTo(header).offset(15);
            make.height.mas_equalTo(18);
        }];
        attenL.font = PZFont(12);
        attenL.textColor = HBColor(153, 153, 153);
        NSString *atten;
        if (_isSend) {
            int count = [_pModel.isReceive isEqualToString:@"noReceive"] ? 0 : 1;
            NSInteger mount = [_pModel.isReceive isEqualToString:@"noReceive"] ? 0 : _pModel.mount;
                atten = [_pModel.place isEqualToString:@"single"] ? [NSString stringWithFormat:@"已领取%d/1个，共%ld/%ld喜腾币", count, (long)mount, (long)_pModel.mount] : [NSString stringWithFormat:@"已领取%ld/%ld个，共%ld/%ld喜腾币", (long)_pModel.receiveCount, (long)_pModel.totalCount, (long)_pModel.receiveMount, (long)_pModel.totalMount];
            if ([_pModel.status isEqualToString:@"time_out"] &&
                (([_pModel.isReceive isEqualToString:@"noReceive"]&&[_pModel.place isEqualToString:@"single"]) ||
                 (_pModel.receiveCount<_pModel.totalCount))) {
                atten = [NSString stringWithFormat:@"该红包已过期，%@", atten];
            } else if (([_pModel.bonusType isEqualToString:@"random"] &&
                        (_pModel.receiveCount==_pModel.totalCount))) {
                atten = [NSString stringWithFormat:@"%@，%@被抢光", atten, _pModel.finshUseTime];
            } else if ([_pModel.place isEqualToString:@"single"]&&[_pModel.status isEqualToString:@"running"]) {
                atten = [NSString stringWithFormat:@"红包金额%ld喜腾币，等待对方领取", (long)_pModel.mount];
            }
        } else if (!_isSend && [_pModel.bonusType isEqualToString:@"random"]) {
            atten = [NSString stringWithFormat:@"已领取%ld/%ld个", (long)_pModel.receiveCount, (long)_pModel.totalCount];
            if ([_pModel.status isEqualToString:@"empty_finish"]) {
                atten = [NSString stringWithFormat:@"%@，%@被抢光", atten, _pModel.finshUseTime];
            }
        }
        attenL.text = atten;
        return header;
    } else {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQRedPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQRedPaperCell"];
    if (!cell) {
        cell = [[JNQRedPaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQRedPaperCell"];
    }
    cell.isAverage = ([_pModel.bonusType isEqualToString:@"average"] && ([_pModel.place isEqualToString:@"group"]||[_pModel.place isEqualToString:@"friendCircle"])) || [_pModel.place isEqualToString:@"single"];
    cell.acceptM = _rpArray[indexPath.row];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
