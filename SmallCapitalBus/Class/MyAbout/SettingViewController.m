//
//  SettingViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/23.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

-(instancetype)init{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecondSB" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.title = @"设置";
        navBackTitle(@"返回");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView * darkView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60-64, [UIScreen mainScreen].bounds.size.width, 60)];
    darkView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    UIButton * outBtn = [[UIButton alloc]init];
    outBtn.backgroundColor = [UIColor whiteColor];
    outBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor appColor] forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(clickOutBtn) forControlEvents:UIControlEventTouchUpInside];
    [darkView addSubview:outBtn];
    [outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(darkView.mas_centerY);
        make.centerX.equalTo(darkView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 35));
    }];
    [self.view addSubview:darkView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingTableViewCell";
    SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    switch (indexPath.row) {
        case 0:
        {
            cell.cellLabel.text = @"关于我们";
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //关于我们
            AboutUsViewController * aboutUs = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)clickOutBtn
{
    //点击退出登录
    [[AppDelegate appDelegate].userProfile resetUserIDThread];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
