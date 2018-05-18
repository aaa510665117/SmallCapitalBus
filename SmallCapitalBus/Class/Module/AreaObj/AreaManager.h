//
//  AreaManager.h
//  SkyEmergency
//
//  Created by ZY on 15/10/13.
//  Copyright © 2015年 ZY. All rights reserved.
//  APP地区处理部分

#import <Foundation/Foundation.h>

@interface AreaManager : NSObject

+ (AreaManager *)shareAreaManager;

//关闭数据库
- (void)CloseDatabase;

//根据省份ID获取省名称
-(NSString *)getPName:(NSString *)areaID;

//根据区域ID获取省市名称
-(NSString *)getPCName:(NSString *)areaID;

//根据区域ID获取 省市区名称
- (NSString *)getPCAName:(NSString *)areaID;

//根据区域ID获取 市信息
- (NSDictionary *)getCInfo:(NSString *)areaID;

//根据市ID获取 市信息
- (NSDictionary *)getCInfoWithCID:(NSString *)cityID;

//根据区域ID获取 省ID
- (NSDictionary *)getPInfo:(NSString *)areaID;

//获取所有省份
- (NSArray *)getAllProvince;

//获取省份所有城市
- (NSArray *)getAllCity:(NSString *)proviceID;

//获取城市所有区域
- (NSArray *)getAllArea:(NSString *)cityID;

//判断一个id代表什么类型的id (0==无类型 1==省份id  2==市id  3==区id)
- (NSString *)isTypeID:(NSString *)areaID;

@end
