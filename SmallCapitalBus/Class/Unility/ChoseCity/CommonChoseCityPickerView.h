//
//  CommonChoseCityPickerView.h
//  SkyHospital
//
//  Created by ZY on 15-4-2.
//  Copyright (c) 2015年 GrayWang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickUpdateArea)(NSDictionary * areaId,NSString * areaStr);

@interface CommonChoseCityPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic, assign)BOOL isShowChoseHospital;           //选择医院  只选择省-市

@property(nonatomic, copy)ClickUpdateArea clickUpdateArea;

-(void)show;

@end
