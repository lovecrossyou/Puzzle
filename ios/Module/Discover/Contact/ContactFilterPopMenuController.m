//
//  ContactFilterPopMenuController.m
//  Puzzle
//
//  Created by huipay on 2016/11/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ContactFilterPopMenuController.h"
#import "ContactPopMenuCell.h"
@interface ContactFilterPopMenuController ()
@property(strong,nonatomic)NSArray* menuTitles ;
@property(strong,nonatomic)NSArray* menusImages ;

@end

@implementation ContactFilterPopMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO ;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = [UIColor colorR:0.1 colorG:0.1 colorB:0.1];
    self.menuTitles = @[@"全部通讯录" ,@"已注册喜腾",@"未注册喜腾"];
    self.menusImages = @[@"circle-of-friends_icon_mail-list", @"circle-of-friends_icon_invitation-", @"circle-of-friends_icon_my-friends"];

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
    ContactPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactFilter"];
    if (cell== nil) {
        cell = [[ContactPopMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactFilter"];
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
