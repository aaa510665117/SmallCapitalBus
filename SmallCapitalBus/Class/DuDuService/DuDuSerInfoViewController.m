//
//  DuDuSerInfoViewController.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/12.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "DuDuSerInfoViewController.h"
#import "DuSerInfoOneCell.h"
#import "DuSerInfoTwoCell.h"

@interface DuDuSerInfoViewController ()

@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *imgArr;
@property (strong, nonatomic) NSMutableArray *contectArr;

@end

@implementation DuDuSerInfoViewController

-(instancetype)init{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DuDuSerSB" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"DuDuSerInfoViewController"];
    if (self) {
        // Custom initialization
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.title = @"服务详情";
        navBackTitle(@"返回");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imgArr = @[@"ActDetail_contect",@"ActDetail_name",@"ActDetail_Address",@"ActDetail_time",@"ActDetail_timeEnd",@"ActDetail_num"];
    _titleArr = @[@"服务内容",@"店铺名称",@"店铺地点",@"开始时间",@"服务时间",@"付款金额"];
    _contectArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _contectArr = [NSMutableArray arrayWithObjects:@"督脉正阳",_serInfo.store_name,_serInfo.address,_serInfo.created_at,_serInfo.actual_start_time,_serInfo.payed_amount, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _titleArr.count;
            break;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    else{
        return 40;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(15, 0, UISCREEN_BOUNDS_SIZE.width - 30, 1);
        imgView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
        [view addSubview:imgView];
        
        UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 14, 14)];
        titleImg.image = [UIImage imageNamed:@"ActDetail_icon"];
        [view addSubview:titleImg];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(37, 7, 100, 26)];
        titleLabel.text = @"服务详情";
        titleLabel.textColor = [UIColor colorWithRed:0.867 green:0.251 blue:0.231 alpha:1.000];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:titleLabel];

        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 270+[ToolsFunction getSizeFromString:_serInfo.address withFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(UISCREEN_BOUNDS_SIZE.width - 30, 1000)].height;
        case 1:
            return [ToolsFunction getSizeFromString:_contectArr[indexPath.row] withFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(UISCREEN_BOUNDS_SIZE.width - 52, 1000)].height + 44;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"DuSerInfoOneCell";
            DuSerInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell.storeImg sd_setImageWithURL:[NSURL URLWithString:_serInfo.logo]];
            cell.userNameLab.text = _serInfo.user_name;
            cell.addressLab.text = _serInfo.address;
            [cell.userImg getAvatarThumbnailWithURL:_serInfo.thumbnail_image_url];
            cell.telLab.text = [NSString stringWithFormat:@"Tel:%@",_serInfo.phone];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhone)];
            [cell.telLab addGestureRecognizer:tap];

            if ([_serInfo.order_status isEqualToString:@"0"]) {
                cell.stateLab.text = @"待支付";
                cell.stateLab.backgroundColor = [UIColor colorWithRed:0.196 green:0.757 blue:0.475 alpha:1.000];
            }else if([_serInfo.order_status isEqualToString:@"1"]) {
                cell.stateLab.text = @"待服务";
                cell.stateLab.backgroundColor = [UIColor colorWithRed:0.867 green:0.251 blue:0.231 alpha:1.000];
            }else if([_serInfo.order_status isEqualToString:@"2"]) {
                cell.stateLab.text = @"服务中";
                cell.stateLab.backgroundColor = [UIColor colorWithRed:0.867 green:0.251 blue:0.231 alpha:1.000];
            }else if([_serInfo.order_status isEqualToString:@"3"]) {
                cell.stateLab.text = @"已结束";
                cell.stateLab.backgroundColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            }else if([_serInfo.order_status isEqualToString:@"4"]){
                cell.stateLab.text = @"已作废";
                cell.stateLab.backgroundColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"DuSerInfoTwoCell";
            DuSerInfoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            CGFloat high = [ToolsFunction getSizeFromString:_contectArr[indexPath.row] withFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(UISCREEN_BOUNDS_SIZE.width - 52, 1000)].height;
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 34, 1, 73)];
            [cell.contentView addSubview:imgView];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            [shapeLayer setBounds:imgView.bounds];
            [shapeLayer setPosition:CGPointMake(1, 40)];
            [shapeLayer setFillColor:[UIColor clearColor].CGColor];
            //  设置虚线颜色
            [shapeLayer setStrokeColor:[UIColor colorWithWhite:0.600 alpha:1.000].CGColor];
            //  设置虚线宽度
            [shapeLayer setLineWidth:1];
            [shapeLayer setLineJoin:kCALineJoinRound];
            //  设置线宽，线间距
            [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:2], nil]];
            //  设置路径
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, high - 9);
            [shapeLayer setPath:path];
            CGPathRelease(path);
            //  把绘制好的虚线添加上来
            [imgView.layer addSublayer:shapeLayer];
            
            cell.imgView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
            cell.titleLab.text = _titleArr[indexPath.row];
            cell.contenctLab.text = _contectArr[indexPath.row];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)clickPhone
{    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"您确定要给对方打电话吗"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件
        [ToolsFunction callToGSM:_serInfo.phone];
    }]];

    //弹出提示框；
    [self presentViewController:alert animated:YES completion:nil];
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
