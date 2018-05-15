//
//  UserProfileTable.h
//  SkyEmergency
//
//  Created by ZY on 15/9/7.
//  Copyright (c) 2015年 ZY. All rights reserved.
//  个人信息表

#import <Foundation/Foundation.h>
#import "ZYDataBaseManager.h"

@interface UserProfileTable : ZYDataBaseManager

@property (nonatomic, strong) NSString * user_id;                           //用户唯一标识符
@property (nonatomic, strong) NSString * mobile;                            //用户电话
@property (nonatomic, strong) NSString * name;                              //用户姓名
@property (nonatomic, strong) NSString * sex_id;                            //用户性别
@property (nonatomic, strong) NSString * birthday;                          //出生时间
@property (nonatomic, strong) NSString * birth_place;                       //出生地址（6位编码）
@property (nonatomic, strong) NSString * live_province_id;                  //现居住地（6位编码）
@property (nonatomic, strong) NSString * live_place;                        //现居住地详情
@property (nonatomic, strong) NSString * privilege_id;                      //用户权限字段
@property (nonatomic, strong) NSString * blood_id;                          //用户血型
@property (nonatomic, strong) NSString * base_ver;                          //基本信息版本号
@property (nonatomic, strong) NSString * image_ver;                         //头像版本号
@property (nonatomic, strong) NSString * source_image_url;                  //大头像
@property (nonatomic, strong) NSString * thumbnail_image_url;               //小头像


//获取表名
+(NSString *)getTableName;

/**
 *  根据uid查找表
 *
 *  @param uid uid
 *
 *  @return UserProfileTable
 */
+(UserProfileTable *)getUserProfileTableWithUID:(NSString *)uid;

@end
