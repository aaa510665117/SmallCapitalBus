//
//  ComChoseHospitalViewController.h
//  SkyHospital
//
//  Created by ZY on 15/5/14.
//  Copyright (c) 2015年 GrayWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^CompleteChoseHspital)(NSDictionary *resultID,NSString *resultName);

@interface ComChoseHospitalViewController : UIViewController

@property(nonatomic, retain)NSDictionary * areaID;   //（默认省市区ID）
/*
name:医院名称
province:省代码
city：市代码
section ：区代码
 */
@property(nonatomic, retain)NSArray * hospitalArray;

@property(nonatomic, copy)CompleteChoseHspital completeChoseBlock;

@end
