
//  CommonChoseCityPickerView.m
//  SkyHospital
//
//  Created by ZY on 15-4-2.
//  Copyright (c) 2015年 GrayWang. All rights reserved.
//

#import "CommonChoseCityPickerView.h"
#import "UserProfileTable.h"
#import "AppDelegate.h"
#import "AreaManager.h"

@interface CommonChoseCityPickerView()
{
    NSArray * provinceArray;
    NSArray * cityArray;
    NSArray * areaArray;
    
    AreaManager *selectsArae;
}
@property(nonatomic, retain)UIView * backView;
@property(nonatomic, retain)UIPickerView * picker;
@property(nonatomic, retain)UIBarButtonItem *lableBar;
@property(nonatomic, retain)UIToolbar * Ztoolbar;

@end

@implementation CommonChoseCityPickerView

@synthesize backView,picker,Ztoolbar,lableBar;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.500 green:0.461 blue:0.439 alpha:0.4];
        [self initShowData];
        [self initChoseArea];
    }
    return self;
}

-(void)show
{
    self.frame = CGRectMake(0, 0, UISCREEN_BOUNDS_SIZE.width, UISCREEN_BOUNDS_SIZE.height);
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    [window addSubview:self];
}

-(void)initShowData
{
    provinceArray = [[NSArray alloc]init];
    cityArray = [[NSArray alloc]init];
    areaArray = [[NSArray alloc]init];
    selectsArae = [AreaManager shareAreaManager];
    
    provinceArray = [selectsArae getAllProvince];
}

-(void)initChoseArea
{
    //将toolbar和picker放在一个view上进行操作
    //创建遮罩层，防止多次点击
    
    Ztoolbar = [[UIToolbar alloc]init];
    Ztoolbar.frame = CGRectMake(0, UISCREEN_BOUNDS_SIZE.height-200-44, self.frame.size.width, 44);

    Ztoolbar.barStyle = UIBarStyleBlackTranslucent;
    [Ztoolbar sizeToFit];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked:)];
    //用于调节间距
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    lableBar = [[UIBarButtonItem alloc]initWithTitle:@"省-市-区" style:UIBarButtonItemStylePlain target:self action:nil];
    lableBar.tag = 1000;
    lableBar.tintColor = [UIColor colorWithRed:0.445 green:0.077 blue:0.020 alpha:1.000];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    [Ztoolbar setItems:[NSArray arrayWithObjects:cancelButton,flexSpace,lableBar,flexSpace,doneBtn, nil] animated:YES];
    [self addSubview:Ztoolbar];
    
    picker = [[UIPickerView alloc]init];
    picker.frame = CGRectMake(0, Ztoolbar.frame.origin.y+Ztoolbar.frame.size.height, UISCREEN_BOUNDS_SIZE.width, 200);
    
    picker.backgroundColor = [UIColor whiteColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
            [picker sizeToFit];
    }
    
    [picker setShowsSelectionIndicator:YES];
    [picker setDelegate:self];
    picker.dataSource = self;
    [self addSubview:picker];
    
    //刷新pickView
    [picker reloadAllComponents];
}

-(void)setIsShowChoseHospital:(BOOL)isShowChoseHospital
{
    _isShowChoseHospital = isShowChoseHospital;
    if(_isShowChoseHospital == YES)
    {
        [lableBar setTitle:@"省-市"];
    }
}

//取消
-(void)pickerCancelClicked:(id)sender
{
     [UIView animateWithDuration:1.0 animations:^{
         [self removeFromSuperview];
     } ];
    
}

//完成
-(void)pickerDoneClicked:(id)sender
{
    if(_isShowChoseHospital == YES)     //选择医院只选择省-市  用市ID进行查找医院
    {
        //没有选择医院直接返回
        NSInteger proviceRow = [picker selectedRowInComponent:0];
        NSInteger cityRow = [picker selectedRowInComponent:1];
        
        NSString * allAreaStr = [NSString stringWithFormat:@"%@%@",[[provinceArray objectAtIndex:proviceRow] objectForKey:@"Name"],[[cityArray objectAtIndex:cityRow] objectForKey:@"Name"]];
        
        NSMutableDictionary * areaDic = [[NSMutableDictionary alloc]init];
        [areaDic setObject:[[provinceArray objectAtIndex:proviceRow] objectForKey:@"ID"] forKey:@"provinceId"];
        [areaDic setObject:[[cityArray objectAtIndex:cityRow] objectForKey:@"ID"] forKey:@"cityID"];
        
        _clickUpdateArea(areaDic, allAreaStr);
    }
    else
    {
        //没有选择医院直接返回
        NSInteger proviceRow = [picker selectedRowInComponent:0];
        NSInteger cityRow = [picker selectedRowInComponent:1];
        NSInteger areaRow = [picker selectedRowInComponent:2];
        
        NSString * allAreaStr = [NSString stringWithFormat:@"%@%@%@",[[provinceArray objectAtIndex:proviceRow] objectForKey:@"Name"],[[cityArray objectAtIndex:cityRow] objectForKey:@"Name"],[[areaArray objectAtIndex:areaRow] objectForKey:@"Name"]];
        
        NSMutableDictionary * areaDic = [[NSMutableDictionary alloc]init];
        [areaDic setObject:[[provinceArray objectAtIndex:proviceRow] objectForKey:@"ID"] forKey:@"provinceId"];
        [areaDic setObject:[[cityArray objectAtIndex:cityRow] objectForKey:@"ID"] forKey:@"cityID"];
        [areaDic setObject:[[areaArray objectAtIndex:areaRow] objectForKey:@"ID"] forKey:@"areaID"];
        
        _clickUpdateArea(areaDic, allAreaStr);
    }
    
    [self removeFromSuperview];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(_isShowChoseHospital == YES)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(0 == component)
    {
        return provinceArray.count;
    }
    else if(1 == component)
    {
        NSInteger provinceRow = [pickerView selectedRowInComponent:0];
        cityArray = [selectsArae getAllCity: [[provinceArray objectAtIndex:provinceRow] objectForKey:@"ID"]];
        return cityArray.count;
    }
    else
    {
        NSInteger cityRtow = [pickerView selectedRowInComponent:1];
        areaArray = [selectsArae getAllArea: [[cityArray objectAtIndex:cityRtow] objectForKey:@"ID"]];
        return areaArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(0 == component)
    {
        return [[provinceArray objectAtIndex:row] objectForKey:@"Name"];
    }
    else if(1 == component)
    {
        return [[cityArray objectAtIndex:row] objectForKey:@"Name"];
    }
    else
    {
        return [[areaArray objectAtIndex:row] objectForKey:@"Name"];
    }
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(_isShowChoseHospital == YES)     //选择医院  只选择省-市
    {
        if (component == 0)
        {
            cityArray = [selectsArae getAllCity: [[provinceArray objectAtIndex:row] objectForKey:@"ID"]];
            
            //重点！更新第二个轮子的数据
            [self.picker selectRow:0 inComponent:1 animated:NO];
            [self.picker reloadComponent:1];
        }
        else
        {
            
        }
    }
    else
    {
        if (component == 0)
        {
            cityArray = [selectsArae getAllCity: [[provinceArray objectAtIndex:row] objectForKey:@"ID"]];
            
            areaArray = [selectsArae getAllArea: [[cityArray objectAtIndex:0] objectForKey:@"ID"]];
            
            //重点！更新第二个轮子的数据
            [self.picker selectRow:0 inComponent:1 animated:NO];
            [self.picker selectRow:0 inComponent:2 animated:NO];
            [self.picker reloadComponent:1];
            [self.picker reloadComponent:2];
        }
        else if(component == 1)
        {
            areaArray = [selectsArae getAllArea: [[cityArray objectAtIndex:row] objectForKey:@"ID"]];
            [self.picker selectRow:0 inComponent:2 animated:NO];
            [self.picker reloadComponent:2];
        }
        else
        {
            
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pickerCancelClicked:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
