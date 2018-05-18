//
//  IQActionViewController.h
//  SkyHospital
//
//  Created by C_HAO on 14/9/19.
//  Copyright (c) 2014年 GrayWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum IQActionViewStyle
{
    IQActionViewStyleTextPicker,
    IQActionViewStyleDatePicker,
    IQActionViewStyleCityPicker,
    IQActionViewStyleDateTimePicker,
    IQActionViewStyleDateHourPicker,
    IQActionViewStyleCityDetailedPicker
    
}IQActionViewStyle;

@class IQActionView;

@protocol IQActionViewDelegate

- (void)actionView:(IQActionView *)pickerView didSelectTitles:(NSArray *)titles;

@end

@interface IQActionView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
@private
    UIPickerView    *_pickerView;
    UIDatePicker    *_datePicker;
    
    
    NSMutableArray *area;
    NSMutableArray *amongNum;
    NSMutableArray *cities;
    NSMutableArray *provinces;
    NSInteger _row0Component;
    NSInteger _row1Component;
    
    NSMutableArray *yearArray;    //年
    NSArray *monthArray;          //月
    NSMutableArray *dayArray;     //日
    NSArray *hoursArray;          //小时
    NSArray *minth_array;          //分钟
    NSString *yearStr;
    
    
    NSInteger day_num;
}

//Delegate
@property(nonatomic, assign) id<IQActionViewDelegate> actionDelegate;

//Default is IQActionViewStyleTextPicker;
@property(nonatomic, assign) IQActionViewStyle actionViewStyle;

/*for IQActionViewStyleTextPicker*/
@property(nonatomic,assign) BOOL isRangePickerView;
@property(nonatomic, strong) NSArray *titlesForComponenets;
@property(nonatomic, strong) NSArray *widthsForComponents;

/*for IQActionViewStyleDatePicker*/
//returning date string style.
@property(nonatomic, assign) NSDateFormatterStyle dateStyle;
//get/set date.
@property(nonatomic, assign) NSDate *date;


@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic)NSInteger _row0Component;
@property (nonatomic,retain)NSMutableArray *amongNum;
@property (nonatomic,retain)NSMutableArray *cities;
@property (nonatomic,retain)NSMutableArray *provinces;

//第一列 初始位置
@property (nonatomic,assign)NSInteger selectRowOne;
//第二列 初始位置
@property (nonatomic,assign)NSInteger selectRowTwo;
//第三列 初始位置
@property (nonatomic,assign)NSInteger selectRowThree;
//第四列 初始位置
@property (nonatomic,assign)NSInteger selectRowFour;
//第五列 初始位置
@property (nonatomic,assign)NSInteger selectRowFive;

- (id)initWithTitle:(NSString *)title withActionStyle:(IQActionViewStyle)style withDelegate:(id<IQActionViewDelegate>)delegate;

- (void)showInView:(UIView *)view;

@end
