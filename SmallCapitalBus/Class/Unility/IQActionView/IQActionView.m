//
//  IQActionViewController.m
//  SkyHospital
//
//  Created by C_HAO on 14/9/19.
//  Copyright (c) 2014年 GrayWang. All rights reserved.
//

#import "IQActionView.h"
#import <QuartzCore/QuartzCore.h>

#define SHOW_HIGHT         216   //UIPickerView 默认高度
#define TITLE_HIGHT        44

@interface IQActionView ()
{
    UIView *contentView;
}

@end

@implementation IQActionView

@synthesize actionViewStyle = _actionViewStyle;
@synthesize titlesForComponenets = _titlesForComponenets;
@synthesize widthsForComponents = _widthsForComponents;
@synthesize isRangePickerView = _isRangePickerView;
@synthesize dateStyle = _dateStyle;
@synthesize date = _date;
@synthesize actionDelegate;


@synthesize country = _country;
@synthesize state = _state;
@synthesize city = _city;
@synthesize district = _district;
@synthesize street = _street;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


@synthesize _row0Component;
@synthesize cities;
@synthesize provinces;
@synthesize amongNum;


- (id)initWithTitle:(NSString *)title withActionStyle:(IQActionViewStyle)style withDelegate:(id<IQActionViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        self.frame = [UIScreen mainScreen].bounds;
        
        contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-SHOW_HIGHT, self.frame.size.width, TITLE_HIGHT+SHOW_HIGHT)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.alpha = 1;
        
        [self addSubview:contentView];
        
        UIView *handView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, TITLE_HIGHT)];
        handView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UIButton *canceButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 50, 34)];
        canceButton.backgroundColor = [UIColor clearColor];
        [canceButton setTitle:@"取消" forState:UIControlStateNormal];
        [canceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [canceButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [handView addSubview:canceButton];
        
        UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-55, 5, 50, 34)];
        doneButton.backgroundColor = [UIColor clearColor];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [handView addSubview:doneButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(canceButton.frame.size.width+canceButton.frame.origin.x, 5, self.frame.size.width-doneButton.frame.size.width-canceButton.frame.size.width-10, 34)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = title;
        
        [handView addSubview:titleLabel];
        
        [contentView addSubview:handView];
        
        self.actionViewStyle = style;
        
        self.actionDelegate = delegate;
        
        //单项选择
        if (self.actionViewStyle == IQActionViewStyleTextPicker) {
            
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, handView.frame.origin.y+handView.frame.size.height, self.frame.size.width, 0)];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                [_pickerView sizeToFit];
            }
            
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            
            [contentView addSubview:_pickerView];
            
        }
        //日期选择
        if (self.actionViewStyle == IQActionViewStyleDatePicker) {
            
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, handView.frame.origin.y+handView.frame.size.height, UISCREEN_BOUNDS_SIZE.width, SHOW_HIGHT)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                [_datePicker sizeToFit];
            }

            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            
            [self setDateStyle:NSDateFormatterMediumStyle];
            
            [contentView addSubview:_datePicker];
        }
        //城市选择
        if (self.actionViewStyle == IQActionViewStyleCityPicker) {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, handView.frame.origin.y+handView.frame.size.height, self.frame.size.width, SHOW_HIGHT)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                [_pickerView sizeToFit];
            }
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            
            [contentView addSubview:_pickerView];
        }
        //区县选择
        if (self.actionViewStyle == IQActionViewStyleCityDetailedPicker) {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, handView.frame.origin.y+handView.frame.size.height, self.frame.size.width, SHOW_HIGHT)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                [_pickerView sizeToFit];
            }
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            
            [contentView addSubview:_pickerView];
        }
        //日期选择 带时间选择
        if (self.actionViewStyle == IQActionViewStyleDateTimePicker) {
            
            [self actionViewStyleDateTimePicker];
            
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, handView.frame.origin.y+handView.frame.size.height, self.frame.size.width, SHOW_HIGHT)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                [_pickerView sizeToFit];
            }
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            
            [contentView addSubview:_pickerView];
        }
        if(self.actionViewStyle == IQActionViewStyleDateHourPicker)
        {
            [self actionViewStyleDateTimePicker];
            
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, handView.frame.origin.y+handView.frame.size.height, self.frame.size.width, SHOW_HIGHT)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                [_pickerView sizeToFit];
            }
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            
            [contentView addSubview:_pickerView];
        }
    }
    return self;
}

- (void)actionViewStyleDateTimePicker
{
    
    day_num = 31;
    yearArray = [[NSMutableArray alloc]init];
    monthArray = [[NSArray alloc]initWithObjects:@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月", nil];
    hoursArray = [[NSArray alloc]initWithObjects:@"00时",@"01时",@"02时",@"03时",@"04时",@"05时",@"06时",@"07时",@"08时",@"09时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时",nil];
    minth_array = [[NSArray alloc]initWithObjects:@"00分",@"10分",@"20分",@"30分",@"40分",@"50分",nil];

    // -------------获取当前系统时间-------------
    NSDate *senddate = [NSDate date];
    NSCalendar  *cal = [NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *conponent = [cal components:unitFlags fromDate:senddate];
    NSInteger year = [conponent year];
    
    // -------------当前时间，前百年-----------
    for (int i = 0; i < year+1-1899; i ++) {
        NSInteger x = 1900+i;
        [yearArray addObject:[NSString stringWithFormat:@"%ld年",(long)x]];
    }
}

- (NSMutableArray *)monthDay:(NSString *)year   //返回每年的月份天数
{
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil];
    
    if (([year intValue] % 400 == 0) || (([year intValue] % 100 != 100) && ([year intValue] % 4 == 0))) {
        [array removeObjectAtIndex:1];
        [array insertObject:@"29" atIndex:1];
    }
    NSMutableArray *monday = [[NSMutableArray alloc]init];
    for (int i = 0; i < 12; i ++) {
        NSMutableArray *day = [[NSMutableArray alloc]init];
        for (int y = 0; y < [[array objectAtIndex:i] integerValue]; y ++) {
            NSString *string = [[NSString alloc]init];
            if ((y + 1) < 10) {
                string = [NSString stringWithFormat:@"0%d日",y+1];
            }else{
                string = [NSString stringWithFormat:@"%d日",y+1];
            }
            [day addObject:string];
        }
        [monday addObject:day];
    }
    return monday;
}



- (void)doneClicked:(UIBarButtonItem*)barButton
{
    NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
    if (_actionViewStyle == IQActionViewStyleTextPicker)
    {
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                [selectedTitles addObject:[[_titlesForComponenets objectAtIndex:component] objectAtIndex:row]];
                [selectedTitles addObject:[NSString stringWithFormat:@"%ld",(long)row]];
            }
            else
            {
                [selectedTitles addObject:[NSNull null]];
            }
        }
    }
    else if (_actionViewStyle == IQActionViewStyleDatePicker)
    {
        NSDateFormatter  * dataformatter = [[NSDateFormatter alloc]init];
        [dataformatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dataStr = [dataformatter stringFromDate:_datePicker.date];
        [selectedTitles addObject:dataStr];
        [self setDate:_datePicker.date];
        
    }
    //-----------------------------------------------------------------------------------------------
    else if (_actionViewStyle == IQActionViewStyleCityPicker)
    {
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                NSInteger provinceRow = [_pickerView selectedRowInComponent:0];
                NSInteger cityRow = [_pickerView selectedRowInComponent:1];
                
                NSString *province = [provinces objectAtIndex:provinceRow];
                NSString *city = [cities objectAtIndex:cityRow];
                
                NSString *message = [[NSString alloc] initWithFormat:@"%@ %@", province,city];
                
                [selectedTitles addObject:message];
                [selectedTitles addObject:[NSString stringWithFormat:@"%ld",(long)provinceRow]];
                [selectedTitles addObject:[NSString stringWithFormat:@"%ld",(long)cityRow]];
            }
            else
            {
                [selectedTitles addObject:[NSNull null]];
            }
        }
    }
    else if (_actionViewStyle == IQActionViewStyleDateTimePicker)
    {
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                NSInteger year = [_pickerView selectedRowInComponent:0];
                NSInteger mon = [_pickerView selectedRowInComponent:1];
                NSInteger day = [_pickerView selectedRowInComponent:2];
                NSInteger hour = [_pickerView selectedRowInComponent:3];
                NSInteger minth = [_pickerView selectedRowInComponent:4];
                
                NSString *message = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",
                                     [[yearArray objectAtIndex:year]stringByReplacingOccurrencesOfString:@"年" withString:@"-"],
                                     [[monthArray objectAtIndex:mon]stringByReplacingOccurrencesOfString:@"月" withString:@"-"],
                                     [[dayArray objectAtIndex:day] stringByReplacingOccurrencesOfString:@"日" withString:@" "],
                                     [[hoursArray objectAtIndex:hour]stringByReplacingOccurrencesOfString:@"时" withString:@":"],
                                     [[minth_array objectAtIndex:minth]stringByReplacingOccurrencesOfString:@"分" withString:@""]];
                [selectedTitles addObject:message];
            }
            else
            {
                [selectedTitles addObject:[NSNull null]];
            }
        }
    }
    else if (_actionViewStyle == IQActionViewStyleDateHourPicker)
    {
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                NSInteger year = [_pickerView selectedRowInComponent:0];
                NSInteger mon = [_pickerView selectedRowInComponent:1];
                NSInteger day = [_pickerView selectedRowInComponent:2];
                NSInteger hour = [_pickerView selectedRowInComponent:3];
                
                NSString *message = [[NSString alloc] initWithFormat:@"%@%@%@%@",
                                     [[yearArray objectAtIndex:year]stringByReplacingOccurrencesOfString:@"年" withString:@"-"],
                                     [[monthArray objectAtIndex:mon]stringByReplacingOccurrencesOfString:@"月" withString:@"-"],
                                     [[dayArray objectAtIndex:day] stringByReplacingOccurrencesOfString:@"日" withString:@" "],
                                     [[hoursArray objectAtIndex:hour]stringByReplacingOccurrencesOfString:@"时" withString:@""]];
                [selectedTitles addObject:message];
            }
            else
            {
                [selectedTitles addObject:[NSNull null]];
            }
        }
    }
    //代理 返回数据设置
    else if (_actionViewStyle == IQActionViewStyleCityDetailedPicker)
    {
        for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
        {
            NSInteger row = [_pickerView selectedRowInComponent:component];
            
            if (row!= -1)
            {
                NSInteger row1 = [_pickerView selectedRowInComponent:0];
                NSInteger row2 = [_pickerView selectedRowInComponent:1];
                NSInteger row3 = [_pickerView selectedRowInComponent:2];
                
                NSMutableArray *provs = [_titlesForComponenets objectAtIndex:0];
                NSMutableArray *city = [_titlesForComponenets objectAtIndex:1];
                NSMutableArray *citys = [city objectAtIndex:row1];
                
                NSMutableArray *citytemp = [_titlesForComponenets objectAtIndex:2];
                NSMutableArray *citytemp1 = [citytemp objectAtIndex:row1];
                NSMutableArray *areatemp = [citytemp1 objectAtIndex:row2];
                
                NSString *message = [[NSString alloc] initWithFormat:@"%@ %@ %@", [provs objectAtIndex:row1],[citys objectAtIndex:row2],[areatemp objectAtIndex:row3]];
                
                [selectedTitles addObject:message];
                [selectedTitles addObject:[NSString stringWithFormat:@"%ld",(long)row1]];
                [selectedTitles addObject:[NSString stringWithFormat:@"%ld",(long)row2]];
                [selectedTitles addObject:[NSString stringWithFormat:@"%ld",(long)row3]];
            }
            else
            {
                [selectedTitles addObject:[NSNull null]];
            }
        }
    }
    //-----------------------------------------------------------------------------------------------
    [self.actionDelegate actionView:self didSelectTitles:selectedTitles];
    
    [self hide];

}
//取消
- (void)cancelClicked:(UIBarButtonItem*)barButton
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    if (_date != nil)
        _datePicker.date = _date;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_actionViewStyle == IQActionViewStyleDateTimePicker) {
        switch (component) {
            case 0:{
                return 80;
                break;
            }case 1:{
                return 56;
                break;
            }case 2:{
                return 56;
                break;
            }case 3:{
                return 56;
                break;
            }
                case 4:
            {
            return 56;
                break;
            }
            default:
                return 0;
                break;
        }
    }
    else if(_actionViewStyle == IQActionViewStyleDateHourPicker)
    {
        switch (component) {
            case 0:{
                return 80;
                break;
            }case 1:{
                return 56;
                break;
            }case 2:{
                return 56;
                break;
            }case 3:{
                return 56;
                break;
            }
            default:
                return 0;
                break;
        }
    }
    else
    {
        //If having widths
        if (_widthsForComponents)
        {
            //If object isKind of NSNumber class
            if ([[_widthsForComponents objectAtIndex:component] isKindOfClass:[NSNumber class]])
            {
                CGFloat width = [[_widthsForComponents objectAtIndex:component] floatValue];
                
                //If width is 0, then calculating it's size.
                if (width == 0)
                    return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
                //Else returning it's width.
                else
                    return width;
            }
            //Else calculating it's size.
            else
                return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
        }
        //Else calculating it's size.
        else
        {
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
        }
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView   //返回列数
{
    
    if (_actionViewStyle == IQActionViewStyleDateTimePicker)
    {
        return 5;
    }
    else if(_actionViewStyle == IQActionViewStyleDateHourPicker)
    {
        return 4;
    }
    else
    {
        return [_titlesForComponenets count];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    //----------------------------------------------------------------------------------------
    
    if (_actionViewStyle == IQActionViewStyleCityPicker) {
        
        if(0 == component)
            return [[_titlesForComponenets objectAtIndex:component] count];
        else
        {
            _row0Component = [pickerView selectedRowInComponent:0];
            provinces = [_titlesForComponenets objectAtIndex:0];
            amongNum = [_titlesForComponenets objectAtIndex:1];
            cities = [amongNum objectAtIndex:_row0Component];
            
            return cities.count;
        }
    }
    
    if (_actionViewStyle == IQActionViewStyleCityDetailedPicker) {
        if (0 == component) {
            return [[_titlesForComponenets objectAtIndex:component] count];
        }
        if (1 == component) {
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSMutableArray *city = [_titlesForComponenets objectAtIndex:1];
            NSMutableArray *citys = [city objectAtIndex:row1];
            
            return citys.count;
        }
        else {
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSInteger row2 = [pickerView selectedRowInComponent:1];
            
            NSMutableArray *city = [_titlesForComponenets objectAtIndex:2];
            NSMutableArray *citytemp = [city objectAtIndex:row1];
            NSMutableArray *areatemp = [citytemp objectAtIndex:row2];
            
            return areatemp.count;
        }
    }
    //----------------------------------------------------------------------------------------
    if (_actionViewStyle == IQActionViewStyleDateTimePicker) {   //返回每列行数
        
        if(0 == component)
        {
            return yearArray.count;
        }
        else  if(1 == component)
        {
            return monthArray.count;
        }
        else if(2 == component)
        {
            dayArray = [[self monthDay:[yearArray objectAtIndex:[pickerView selectedRowInComponent:0]]] objectAtIndex:[pickerView selectedRowInComponent:1]];
            return  dayArray.count;
        }
        else if(3 == component)
        {
            return hoursArray.count;
        }
        else if(4 == component)
        {
            return minth_array.count;
        }
        
    }
    if(_actionViewStyle == IQActionViewStyleDateHourPicker)
    {
        if(0 == component)
        {
            return yearArray.count;
        }
        else  if(1 == component)
        {
            return monthArray.count;
        }
        else if(2 == component)
        {
            dayArray = [[self monthDay:[yearArray objectAtIndex:[pickerView selectedRowInComponent:0]]] objectAtIndex:[pickerView selectedRowInComponent:1]];
            return  dayArray.count;
        }
        else if(3 == component)
        {
            return hoursArray.count;
        }
    }
    //----------------------------------------------------------------------------------------
    
    return [[_titlesForComponenets objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    //----------------------------------------------------------------------------------------
    if (_actionViewStyle == IQActionViewStyleCityPicker) {
        if (0 == component) {
            return [[_titlesForComponenets objectAtIndex:component] objectAtIndex:row];
        }
        else{
            return [cities objectAtIndex:row];
        }
    }
    //----------------------------------------------------------------------------------------
    
    if (_actionViewStyle == IQActionViewStyleDateTimePicker) {   //每行内容
        if (0 == component) {
            return [yearArray objectAtIndex:row];
        }
        else if(1 == component)
        {
            return [monthArray objectAtIndex:row];
        }
        else if(2 == component)
        {
            return [dayArray objectAtIndex:row];
        }
        else if(3 == component)
        {
            return [hoursArray objectAtIndex:row];
        }
        else if(4 == component)
        {
            return [minth_array objectAtIndex:row];
        }
        
    }
    if(_actionViewStyle == IQActionViewStyleDateHourPicker)
    {
        if (0 == component) {
            return [yearArray objectAtIndex:row];
        }
        else if(1 == component)
        {
            return [monthArray objectAtIndex:row];
        }
        else if(2 == component)
        {
            return [dayArray objectAtIndex:row];
        }
        else if(3 == component)
        {
            return [hoursArray objectAtIndex:row];
        }
    }
    if (_actionViewStyle == IQActionViewStyleCityDetailedPicker) {
        if (0 == component) {
            return [[_titlesForComponenets objectAtIndex:component] objectAtIndex:row];
        }
        if (1 == component) {
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSMutableArray *city = [_titlesForComponenets objectAtIndex:1];
            NSMutableArray *citys = [city objectAtIndex:row1];
            
            return [citys objectAtIndex:row];
        }
        if (2 == component) {
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSInteger row2 = [pickerView selectedRowInComponent:1];
            
            NSMutableArray *city = [_titlesForComponenets objectAtIndex:2];
            NSMutableArray *citytemp = [city objectAtIndex:row1];
            NSMutableArray *areatemp = [citytemp objectAtIndex:row2];
            
            return [areatemp objectAtIndex:row];
        }
    }
    
    //----------------------------------------------------------------------------------------
    return [[_titlesForComponenets objectAtIndex:component] objectAtIndex:row];
}

//刷新行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //----------------------------------------------------------------------------------------
    if (_actionViewStyle == IQActionViewStyleCityPicker) {
        if (0 == component) {
            [pickerView selectRow:0 inComponent:1 animated:YES];
            cities = [amongNum objectAtIndex:row];
            [pickerView reloadComponent:1];
        }
    }
    //----------------------------------------------------------------------------------------
    else if (_actionViewStyle == IQActionViewStyleDateTimePicker){
        
        if (0 == component) {
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            dayArray = [[self monthDay:[yearArray objectAtIndex:row]] objectAtIndex:[pickerView selectedRowInComponent:1]];
            [pickerView reloadComponent:2];
        }
        else if(1 == component) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
            dayArray = [[self monthDay:[yearArray objectAtIndex:[pickerView selectedRowInComponent:0]]] objectAtIndex:row];
            [pickerView reloadComponent:2];
        }
    }
    else if(_actionViewStyle == IQActionViewStyleDateHourPicker)
    {
        if (0 == component) {
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            dayArray = [[self monthDay:[yearArray objectAtIndex:row]] objectAtIndex:[pickerView selectedRowInComponent:1]];
            [pickerView reloadComponent:2];
        }
        else if(1 == component) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
            dayArray = [[self monthDay:[yearArray objectAtIndex:[pickerView selectedRowInComponent:0]]] objectAtIndex:row];
            [pickerView reloadComponent:2];
        }
    }
    else if (_actionViewStyle == IQActionViewStyleCityDetailedPicker) {
        if (0 == component) {
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
        if (1 == component) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
        if (2 == component) {
            
        }
    }
    //----------------------------------------------------------------------------------------
    
    else{
        if (_isRangePickerView && pickerView.numberOfComponents == 3)
        {
            if (component == 0)
            {
                [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
            }
            else if (component == 2)
            {
                [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
            }
        }
    }
}


- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    if (_selectRowOne < 0) {
        _selectRowOne = 0;
    }
    if (_selectRowTwo < 0) {
        _selectRowTwo = 0;
    }
    if (_selectRowThree < 0) {
        _selectRowThree = 0;
    }
    if (_selectRowFour < 0) {
        _selectRowFour = 0;
    }
    if(_selectRowFive < 0)
    {
        _selectRowFive = 0;
    }
    
    self.alpha = 0;
    
    if (_actionViewStyle == IQActionViewStyleDatePicker) {
        [_pickerView reloadAllComponents];
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.alpha = 1;
            }
        }];
    }
    if (_actionViewStyle == IQActionViewStyleCityPicker) {
        if (_selectRowOne) {
            [_pickerView selectRow:_selectRowOne inComponent:0 animated:NO];
        }
        if (_selectRowTwo) {
            [_pickerView selectRow:_selectRowTwo inComponent:1 animated:NO];
        }
        [_pickerView reloadAllComponents];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.alpha = 1;
            }
        }];
    }
    if (_actionViewStyle == IQActionViewStyleTextPicker) {
        if (_selectRowOne) {
            [_pickerView selectRow:_selectRowOne inComponent:0 animated:NO];
        }
        [_pickerView reloadAllComponents];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.alpha = 1;
            }
        }];
    }
    if (_actionViewStyle == IQActionViewStyleDateTimePicker) {
        if (_selectRowOne) {
            [_pickerView selectRow:_selectRowOne inComponent:0 animated:NO];
        }
        if (_selectRowTwo) {
            [_pickerView selectRow:_selectRowTwo inComponent:1 animated:NO];
        }
        if (_selectRowThree) {
            [_pickerView selectRow:_selectRowThree inComponent:2 animated:NO];
        }
        if (_selectRowFour) {
            [_pickerView selectRow:_selectRowFour inComponent:3 animated:NO];
        }
        if (_selectRowFive)
        {
            [_pickerView selectRow:_selectRowFive inComponent:4 animated:NO];
        }
        [_pickerView reloadAllComponents];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.alpha = 1;
            }
        }];
    }
    if (_actionViewStyle == IQActionViewStyleDateHourPicker) {
        if (_selectRowOne) {
            [_pickerView selectRow:_selectRowOne inComponent:0 animated:NO];
        }
        if (_selectRowTwo) {
            [_pickerView selectRow:_selectRowTwo inComponent:1 animated:NO];
        }
        if (_selectRowThree) {
            [_pickerView selectRow:_selectRowThree inComponent:2 animated:NO];
        }
        if (_selectRowFour) {
            [_pickerView selectRow:_selectRowFour inComponent:3 animated:NO];
        }
        [_pickerView reloadAllComponents];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.alpha = 1;
            }
        }];
    }
    if (_actionViewStyle == IQActionViewStyleCityDetailedPicker) {
        [_pickerView reloadAllComponents];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                self.alpha = 1;
            }
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat y = point.y;
    
    if (y < contentView.frame.origin.y) {
        [self hide];
    }
    
}

@end
