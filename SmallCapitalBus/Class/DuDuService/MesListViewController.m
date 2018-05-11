//
//  MesListViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/5/11.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "MesListViewController.h"
#import "MesListTableViewCell.h"
#import "GroupMeetAlertView.h"
#import "MesListObj.h"

@interface MesListViewController ()
{
    BOOL isViewDidAppear;
}
@property(nonatomic, strong) NSMutableArray * showDataArray;

@end

@implementation MesListViewController

-(instancetype)init{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DuDuSerSB" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"MesListViewController"];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.title = @"服务消息";
        navBackTitle(@"返回");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isViewDidAppear = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isViewDidAppear == NO)
    {
        [self getMesList];
        isViewDidAppear = YES;
    }
}

-(void)getMesList
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc]init];
    [httpDic setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    
    [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"" withParams:httpDic withSuccess:^(NSDictionary *success) {
        
        [ToolsFunction hideHttpPromptView:nil];
        if([[success objectForKey:HTTP_RETURN_KEY] isEqualToString:@"1"])
        {
            NSArray * result = [success objectForKey:@"result"];
            NSMutableArray * temp = [[NSMutableArray alloc]init];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * dic = obj;
                MesListObj * rankGood = [[MesListObj alloc]init];

                [temp addObject:rankGood];
            }];
            weakSelf.showDataArray = temp;
            [_myTableView reloadData];
        }
        else
        {
            [ZYHttpAPI analysisErrorCode:success withRequestAdd:@""];
        }
        
    } withFailure:^(NSDictionary *failure) {
        
        [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MesListTableViewCell";
    MesListTableViewCell *cell = (MesListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //督督是否接单View
    GroupMeetAlertView * groupMeetAlert = [[GroupMeetAlertView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height) withTilte:@"是否接单？" complete:^{

    }];
    [groupMeetAlert show];
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
