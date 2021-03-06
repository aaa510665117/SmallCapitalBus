//
//  SecondViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/3/1.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "SecondViewController.h"
#import "SettingViewController.h"
#import "UserBasicSetViewController.h"

@interface SecondViewController ()
{
    NSArray * titleAry;
    NSArray * imgAry;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    titleAry = @[@"个人信息",@"设置"];
    imgAry = @[@"reservation_person",@"password_icon_image"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_myTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    darkView.backgroundColor = [UIColor grayColor];
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.translatesAutoresizingMaskIntoConstraints = NO;
    imageV.image = [UIImage imageNamed:@"backImage"];
    [darkView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(darkView.mas_centerY);
        make.centerX.equalTo(darkView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 200));
    }];
    
    UserProfileTable * userProfile = [UserProfileTable getUserProfileTableWithUID:[AppDelegate appDelegate].userProfile.userID];
    UIImageView * userImageView = [[UIImageView alloc]init];
    userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [userImageView getAvatarThumbnailWithURL:userProfile.thumbnail_image_url];
    userImageView.layer.cornerRadius = 45;
    userImageView.layer.masksToBounds = YES;
    [darkView addSubview:userImageView];
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(darkView.mas_centerY);
        make.centerX.equalTo(darkView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    UILabel * userNameLab = [[UILabel alloc]init];
    userNameLab.translatesAutoresizingMaskIntoConstraints = NO;
    userNameLab.text = userProfile.name;
    userNameLab.textAlignment = NSTextAlignmentCenter;
    [userNameLab setTintColor:[UIColor lightGrayColor]];
    userNameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [darkView addSubview:userNameLab];
    [userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(darkView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    return darkView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SecondViewTableViewCell";
    SecondViewTableViewCell *cell = (SecondViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.cellLabel.text = [titleAry objectAtIndex:indexPath.row];
    cell.cellImg.image = [UIImage imageNamed:[imgAry objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //个人信息
            UserBasicSetViewController *userBasicVC = [[UserBasicSetViewController alloc]init];
            userBasicVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userBasicVC animated:YES];
        }
            break;
        case 1:
        {
            //设置
            SettingViewController * setView = [[SettingViewController alloc]init];
            setView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setView animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
