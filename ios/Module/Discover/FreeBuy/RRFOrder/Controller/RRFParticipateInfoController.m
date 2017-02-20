//
//  RRFParticipateInfoController.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFParticipateInfoController.h"
#import "RRFParticipateInfoView.h"

@implementation RRFParticipateInfoController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, 12)];
    
    RRFParticipateInfoView *footView = [[RRFParticipateInfoView alloc]init];
    CGFloat height = [footView ViewHeightWithListArray:self.recordList];
    footView.frame = CGRectMake(0, 0, SCREENWidth, height);
    [self.tableView setTableHeaderView:footView];
}
@end
