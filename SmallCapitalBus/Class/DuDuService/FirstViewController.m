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
#import "MJRefresh.h"
#import "ServiceListObj.h"
#import "CkeckQRCodeViewController.h"

#define MAX_SERVICE_PAGE 10

@interface FirstViewController ()
{
    BOOL isViewDidAppear;
}
@property(nonatomic, assign) long page;
@property(nonatomic, strong) NSMutableArray * showDataArray;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //我的消息按钮
    UIBarButtonItem * todayGoodMes = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"benefit_message"] style:UIBarButtonItemStylePlain target:self action:@selector(clickMesList)];
    self.navigationItem.rightBarButtonItem = todayGoodMes;
    //扫一扫
    UIBarButtonItem * checkQr = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkQr"] style:UIBarButtonItemStylePlain target:self action:@selector(checkQr)];
    self.navigationItem.leftBarButtonItem = checkQr;
    todayGoodMes.tintColor = [UIColor lightGrayColor];
    checkQr.tintColor = [UIColor darkGrayColor];

    isViewDidAppear = NO;
    _showDataArray = [[NSMutableArray alloc]init];
    [self addHeader];
    [self addFooter];
}

-(void)clickMesList
{
    MesListViewController * mesList = [[MesListViewController alloc]init];
    mesList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mesList animated:YES];
}

-(void)checkQr
{
    CkeckQRCodeViewController * checkQr = [[CkeckQRCodeViewController alloc]init];
    checkQr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkQr animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isViewDidAppear == NO)
    {
        [_myTableView.mj_header beginRefreshing];         //获取列表展示数据
    }
    isViewDidAppear = YES;
}

- (void)addHeader
{
    __weak typeof(self) vc = self;
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [vc getServiceList:1];
    }];
}

- (void)addFooter
{
    __weak typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        [vc getServiceList:vc.page];
    }];
}

-(void)getServiceList:(long)page
{
    __weak typeof (self)vc = self;
    NSMutableDictionary *httpDic = [NSMutableDictionary dictionary];
    [httpDic setObject:SESSION forKey:@"ss"];
    [httpDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"api/v1/baseuser/check/order/list" withParams:httpDic withSuccess:^(NSDictionary *success) {
        
        if([[success objectForKey:HTTP_RETURN_KEY] integerValue] == 1)
        {
            NSMutableArray * temp = [[NSMutableArray alloc]init];
            NSMutableArray * dic = [success objectForKey:HTTP_RETURN_RESULT];
            [dic enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ServiceListObj *groupMode = [[ServiceListObj alloc]init];
                groupMode.order_id = [obj ac_stringForKey:@"order_id"];
                groupMode.created_at = [obj ac_stringForKey:@"created_at"];
                groupMode.actual_start_time = [obj ac_stringForKey:@"actual_start_time"];
                if(groupMode.actual_start_time == nil)
                {
                    groupMode.actual_start_time = @"--";
                }
                groupMode.logo = [obj ac_stringForKey:@"logo"];
                groupMode.order_status = [obj ac_stringForKey:@"order_status"];
                groupMode.user_name = [obj ac_stringForKey:@"user_name"];
                groupMode.store_name = [obj ac_stringForKey:@"store_name"];
                groupMode.thumbnail_image_url = [obj ac_stringForKey:@"thumbnail_image_url"];
                groupMode.phone = [obj ac_stringForKey:@"phone"];
                groupMode.price = [obj ac_stringForKey:@"price"];
                groupMode.payed_amount = [obj ac_stringForKey:@"payed_amount"];
                if(groupMode.payed_amount == nil)
                {
                    groupMode.payed_amount = @"--";
                }
                groupMode.address = [obj ac_stringForKey:@"address"];
                [temp addObject:groupMode];
            }];
            
            //数据处理结果加载
            if (page == 1)
            {
                if (dic.count) vc.page = 2;
                vc.showDataArray = temp;
            }
            else
            {
                if (dic.count) vc.page++;
                [vc.showDataArray addObjectsFromArray:temp];
            }
            
            //刷新控件判断加载
            if(dic.count < MAX_SERVICE_PAGE)
            {
                [vc.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [vc.myTableView.mj_footer endRefreshing];
            }
            
            [vc.myTableView reloadData];
            [vc.myTableView.mj_header endRefreshing];
        }
        else
        {
            [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"api/v1/baseuser/check/order/list"];
        }
        
    } withFailure:^(NSDictionary *failure) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
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
    return _showDataArray.count;
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
    ServiceListObj * serviceObj = [_showDataArray objectAtIndex:indexPath.row];
    FirstViewTableViewCell *cell = (FirstViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.userImg getAvatarThumbnailWithURL:serviceObj.thumbnail_image_url];
    cell.userNameLab.text = serviceObj.user_name;
    cell.timeLab.text = serviceObj.created_at;
    cell.addressLab.text = serviceObj.address;
    switch ([serviceObj.order_status intValue]) {
        case 0:
        {cell.stateLab.text = @"待支付";}
            break;
        case 1:
        {cell.stateLab.text = @"待服务";}
            break;
        case 2:
        {cell.stateLab.text = @"服务中";}
            break;
        case 3:
        {cell.stateLab.text = @"已完成";}
            break;
        case 4:
        {cell.stateLab.text = @"已取消";}
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ServiceListObj * serviceObj = [_showDataArray objectAtIndex:indexPath.row];
    DuDuSerInfoViewController * duduSerInfo = [[DuDuSerInfoViewController alloc]init];
    duduSerInfo.hidesBottomBarWhenPushed = YES;
    duduSerInfo.serInfo = serviceObj;
    [self.navigationController pushViewController:duduSerInfo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
