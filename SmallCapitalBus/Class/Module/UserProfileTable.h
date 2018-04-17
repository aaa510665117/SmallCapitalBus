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

@property (nonatomic, strong) NSString * uid;                           //用户唯一标识符
@property (nonatomic, strong) NSString * mobile;                        //用户电话
@property (nonatomic, strong) NSString * name;                          //用户姓名
@property (nonatomic, strong) NSString * sex;                           //用户性别
@property (nonatomic, strong) NSString * email;                         //用户邮箱
@property (nonatomic, strong) NSString * birthday;                      //出生时间
@property (nonatomic, strong) NSString * birth_place;                   //出生地址（6位编码）
@property (nonatomic, strong) NSString * live_place;                    //现居住地（6位编码）
@property (nonatomic, strong) NSString * live_placeinfo;                //现居住地详情
@property (nonatomic, strong) NSString * piv;                           //个人信息版本号
@property (nonatomic, strong) NSString * pav;                           //头像信息版本号
@property (nonatomic, strong) NSString * privilege_id;                  //用户权限字段
@property (nonatomic, strong) NSString * blood;                         //用户血型
@property (nonatomic, strong) NSString * clock;                         //是否开启生命时钟
@property (nonatomic, strong) NSString * rank;                          //志愿者称号  0表示无称号  1黑衣骑士  2 红衣骑士  3 白衣骑士
@property (nonatomic, strong) NSArray  * gps;
//----------------------------------------医生特有部分-----------------------------------------------//
@property (nonatomic, strong) NSString * hospital;                      //所属医院
@property (nonatomic, strong) NSString * recollection;                  //科室
@property (nonatomic, strong) NSString * skyname;                       //空中医院名称
@property (nonatomic, strong) NSString * duty;                          //职称
@property (nonatomic, strong) NSString * skill;                         //擅长
@property (nonatomic, strong) NSString * auth;                          //认证
@property (nonatomic, strong) NSString * honour;                        //荣誉
@property (nonatomic, strong) NSString * summary;                       //简介
@property (nonatomic, strong) NSString * docvurl;                       //医生视频


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
