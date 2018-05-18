//
//  ComChoseHospitalViewController.m
//  SkyHospital
//
//  Created by ZY on 15/5/14.
//  Copyright (c) 2015年 GrayWang. All rights reserved.
//

#import "ComChoseHospitalViewController.h"
#import "AWCollectionViewDialLayout.h"
#import "AWCollectionViewCell.h"
#import "AreaManager.h"

@interface ComChoseHospitalViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UITableView * mTableView;
    UITextField * textField;
    NSMutableArray * showDataHospital;
    UICollectionView * areaCollectView;
    //用于地区选择
    AWCollectionViewDialLayout *dialLayout;
    NSArray * hospitalToAreaArray;          //地区数组
    AreaManager * seleAreaObj;
    UILabel * showAreaLabel;                //选择地区页面展示LabeL
    NSIndexPath * indePath;                 //选择的index值
}
@end

@implementation ComChoseHospitalViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.title = @"选择医院";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, 50)];
    backView.backgroundColor = [UIColor colorWithRed:0.860 green:0.860 blue:0.873 alpha:1.000];
    textField = [[UITextField alloc]init];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    textField.frame = CGRectMake(10, 10, UISCREEN_BOUNDS_SIZE.width-90, 30);
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textField.returnKeyType = UIReturnKeyDone;  //键盘返回类型
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    textField.keyboardType = UIKeyboardTypeDefault;//键盘显示类型
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //设置居中输入
    textField.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    textField.placeholder = @"筛选/填写不存在医院";
    [textField addTarget:self action:@selector(textfieldDidchange:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:textField];
    
    UIButton * updateButton = [[UIButton alloc] initWithFrame:CGRectMake(textField.frame.origin.x+textField.frame.size.width+5, 10, 70, 30)];
    [updateButton setTitle:@"提交输入" forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:13];
    updateButton.titleLabel.textColor = [UIColor whiteColor];
    [updateButton setBackgroundImage:[ToolsFunction imageWithColor:[UIColor appColor] size:updateButton.frame.size] forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(clickUpdateButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:updateButton];
    [self.view addSubview:backView];
    
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height-64-50) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    static NSString *cellId = @"cellId";
    [areaCollectView registerClass:[AWCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    areaCollectView.delegate = self;
    areaCollectView.dataSource = self;
    seleAreaObj = [AreaManager shareAreaManager];
    
    showDataHospital = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(showDataHospital.count != 0)
    {
        return showDataHospital.count;
    }
    return _hospitalArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Identifier = @"hospitalCell";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    NSDictionary * hospitalInfo;
    if(showDataHospital.count != 0)
    {
        hospitalInfo = [showDataHospital objectAtIndex:indexPath.row];
    }
    else
    {
        hospitalInfo = [_hospitalArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [hospitalInfo objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [ToolsFunction setCellAccessoryView:cell];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * hospitalInfo;
    if(showDataHospital.count != 0)
    {
        hospitalInfo = [showDataHospital objectAtIndex:indexPath.row];
    }
    else
    {
        hospitalInfo = [_hospitalArray objectAtIndex:indexPath.row];
    }
    
    NSMutableDictionary * comhospitalInfo = [[NSMutableDictionary alloc]init];
    [comhospitalInfo setValue:[hospitalInfo objectForKey:@"province"] forKey:@"provinceId"];
    [comhospitalInfo setValue:[hospitalInfo objectForKey:@"city"] forKey:@"cityID"];
    [comhospitalInfo setValue:[hospitalInfo objectForKey:@"section"] forKey:@"areaId"];

    _completeChoseBlock(comhospitalInfo,[hospitalInfo objectForKey:@"name"]);
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textFields
{// 点击return收起键盘（方法 1）
    [textFields resignFirstResponder];// 收键盘
    return YES;
}

-(void)textfieldDidchange:(id)sender
{
    [showDataHospital removeAllObjects];
    UITextField * textFields = (UITextField *)sender;
    
    //得到输入框的内容 进行筛选
    for(int i=0; i<_hospitalArray.count; i++)
    {
        NSString * hospitalName = [[_hospitalArray objectAtIndex:i] objectForKey:@"name"];
        if([hospitalName rangeOfString:textFields.text].location !=NSNotFound)
        {
            //包含
            [showDataHospital addObject:[_hospitalArray objectAtIndex:i]];
        }
    }

    [mTableView reloadData];
}

#pragma mark - UICollectionViewDelegate methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return hospitalToAreaArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AWCollectionViewCell * cell = (AWCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSDictionary *item = [hospitalToAreaArray objectAtIndex:indexPath.item];
    
    cell.areaNameLabel.text = [item objectForKey:@"Name"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(240, 100);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

-(void)clickUpdateButton
{
    [textField resignFirstResponder];
    
    if([textField.text isEqualToString:@""])
    {
        [ToolsFunction showPromptViewWithString:@"如果列表中没有你所在医院,请输入你有效的医院名称" background:nil timeDuration:1];
        return;
    }
    
    if(textField.text.length > 25)
    {
        [ToolsFunction showPromptViewWithString:@"请输入25字以内医院名称" background:nil timeDuration:1];
        return;
    }
    
    //选择区后进行提交  点击提交
    hospitalToAreaArray = [seleAreaObj getAllArea:[_areaID objectForKey:@"cityID"]];
    
    //罩层view
    UIView * layerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height)];
    layerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    layerView.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissChoseAreaView)];
    [layerView addGestureRecognizer:gesture];
    
    //背景view
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(-(UISCREEN_BOUNDS_SIZE.width-100), 0, 220, UISCREEN_BOUNDS_SIZE.height)];
    backView.tag = 100;
    backView.backgroundColor = [UIColor colorWithRed:0.346 green:0.708 blue:0.646 alpha:1.000]
    ;
    
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, backView.frame.size.width-20, 35)];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.text = @"提交你自己填写的医院，请选择你所在医院的区";
    warnLabel.font = [UIFont systemFontOfSize:13];
    warnLabel.textColor = [UIColor colorWithRed:1.000 green:0.288 blue:0.000 alpha:1.000];
    warnLabel.numberOfLines = 0;
    warnLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [backView addSubview:warnLabel];
    
    showAreaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, warnLabel.frame.origin.y+warnLabel.frame.size.height+5, backView.frame.size.width-20, 50)];
    showAreaLabel.backgroundColor = [UIColor clearColor];
    showAreaLabel.font = [UIFont systemFontOfSize:15];
    if(hospitalToAreaArray.count == 0)
    {
        showAreaLabel.text = [NSString stringWithFormat:@"%@",textField.text];
    }
    else
    {
        showAreaLabel.text = [NSString stringWithFormat:@"%@\n%@",[[hospitalToAreaArray objectAtIndex:0] objectForKey:@"Name"],textField.text];
    }

    indePath = [NSIndexPath indexPathForRow:0 inSection:0];         //对indexPath进行初始化
    
    showAreaLabel.textAlignment = NSTextAlignmentCenter;
    showAreaLabel.numberOfLines = 0;
    showAreaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [backView addSubview:showAreaLabel];
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:400 andAngularSpacing:5 andCellSize:CGSizeMake(250, 40) andAlignment:WHEELALIGNMENTCENTER andItemHeight:40 andXOffset:160];
    [areaCollectView setCollectionViewLayout:dialLayout];
    static NSString *cellId = @"cellId";
    areaCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, showAreaLabel.frame.origin.y+showAreaLabel.frame.size.height+10, backView.frame.size.width, backView.frame.size.height-(showAreaLabel.frame.origin.y+showAreaLabel.frame.size.height)-60) collectionViewLayout:dialLayout];
    [areaCollectView registerClass:[AWCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    areaCollectView.delegate = self;
    areaCollectView.dataSource = self;
    areaCollectView.backgroundColor = [UIColor clearColor];
    
    //提交按钮
    UIButton * completeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, backView.frame.size.height-40, backView.frame.size.width-20, 30)];
    [completeButton setBackgroundImage:[ToolsFunction imageWithColor:[UIColor colorWithRed:0.843 green:0.976 blue:0.870 alpha:1.000] size:completeButton.frame.size] forState:UIControlStateNormal];
    [completeButton setTitle:@"提交" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor colorWithRed:0.346 green:0.708 blue:0.646 alpha:1.000] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(clickCompleteDocHospital) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:completeButton];
    
    [backView addSubview:areaCollectView];
    [layerView addSubview:backView];
    [[UIApplication sharedApplication].delegate.window addSubview:layerView];

    [UIView animateWithDuration:0.5 animations:^{
        backView.frame = CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height);
    } completion:^(BOOL finished) {

    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UIView * backView = (UIView *)[[UIApplication sharedApplication].delegate.window viewWithTag:100];

    CGPoint pointFrom = CGPointMake(backView.frame.size.width/2,areaCollectView.frame.origin.y+areaCollectView.frame.size.height/2);

    CGPoint pointTo = [[UIApplication sharedApplication].delegate.window convertPoint:pointFrom toView:areaCollectView];
    indePath =  [areaCollectView indexPathForItemAtPoint:pointTo];
    
    if(hospitalToAreaArray.count == 0)
    {
        showAreaLabel.text = [NSString stringWithFormat:@"%@",textField.text];
    }
    else
    {
        showAreaLabel.text = [NSString stringWithFormat:@"%@\n%@",[[hospitalToAreaArray objectAtIndex:indePath.row] objectForKey:@"Name"],textField.text];
    }
}

-(void)clickCompleteDocHospital
{
    //提交医生自己的医院
    NSMutableDictionary * comhospitalInfo = [[NSMutableDictionary alloc]init];
    [comhospitalInfo setValue:[_areaID objectForKey:@"provinceId"] forKey:@"provinceId"];
    [comhospitalInfo setValue:[_areaID objectForKey:@"cityID"] forKey:@"cityID"];
    [comhospitalInfo setValue:[[hospitalToAreaArray objectAtIndex:indePath.row] objectForKey:@"ID"] forKey:@"areaId"];
    _completeChoseBlock(comhospitalInfo,textField.text);
    
    [self dismissChoseAreaView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissChoseAreaView
{
    UIView * backView = (UIView *)[[UIApplication sharedApplication].delegate.window viewWithTag:100];
    
    [UIView animateWithDuration:0.5 animations:^{
        backView.frame = CGRectMake(-(UISCREEN_BOUNDS_SIZE.width-100), 0, backView.frame.size.width, backView.frame.size.height);
        backView.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [backView.superview removeFromSuperview];
    }];
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
