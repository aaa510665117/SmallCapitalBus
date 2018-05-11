//
//  FirstViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/3/1.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstViewTableViewCell.h"
#import "DuDuSerInfoViewController.h"
#import "MesListViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //我的消息按钮
    UIBarButtonItem * todayGoodMes = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"benefit_message"] style:UIBarButtonItemStylePlain target:self action:@selector(clickMesList)];
    self.navigationItem.rightBarButtonItem = todayGoodMes;
}

-(void)clickMesList
{
    MesListViewController * mesList = [[MesListViewController alloc]init];
    mesList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mesList animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FirstViewTableViewCell";
    FirstViewTableViewCell *cell = (FirstViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DuDuSerInfoViewController * duduSerInfo = [[DuDuSerInfoViewController alloc]init];
    duduSerInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:duduSerInfo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
