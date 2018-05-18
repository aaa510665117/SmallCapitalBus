//
//  IQActionPickerViewOffice.h
//  SkyHospital
//
//  Created by Apple on 14-12-8.
//  Copyright (c) 2014年 GrayWang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum IQActionPickerViewStyle
{
    IQActionPickerViewForSreech,
    IQActionPickerViewForSetOffice,
    IQActionPickerViewForTitleAndTag
    
}IQActionPickerViewStyle;

@class IQActionPickerViewOffice;

@protocol IQActionPickerViewOfficeDelegate

- (void)actionPickerView:(IQActionPickerViewOffice *)pickerView didSelectTitle:(NSString *)title;
@optional
- (void)actionPickerView:(IQActionPickerViewOffice *)pickerView didSelectParameter:(NSDictionary *)parame;

@end


@interface IQActionPickerViewOffice : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UIPickerView * picker ;
    
}


@property(nonatomic) id <IQActionPickerViewOfficeDelegate> delegate;
@property (nonatomic) IQActionPickerViewStyle viewStyle;
-(id)initWithType:(IQActionPickerViewStyle ) type;

-(void)setPickerValue:(NSString *)selectNum;

-(void)showOfficePickerView;

@end
