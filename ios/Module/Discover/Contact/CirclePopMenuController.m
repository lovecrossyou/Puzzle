//
//  CirclePopMenuController.m
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CirclePopMenuController.h"
#import "ContactPopMenuCell.h"
@interface CirclePopMenuController ()

@end

@implementation CirclePopMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorR:0.1 colorG:0.1 colorB:0.1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36.0f ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CirclePopMenu"];
    if (cell== nil) {
        cell = [[ContactPopMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CirclePopMenu"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = cell.backgroundColor;
        cell.textLabel.font = PZFont(13.0f);
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    cell.imageName = self.menusImages[indexPath.row];
    cell.menuTitle = self.menuTitles[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row ;
    self.itemBlock(@(row));
}

@end
