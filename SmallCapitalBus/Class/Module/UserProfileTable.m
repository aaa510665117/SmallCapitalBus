//
//  UserProfileTable.m
//  SkyEmergency
//
//  Created by ZY on 15/9/7.
//  Copyright (c) 2015年 ZY. All rights reserved.
//  个人信息表

#import "UserProfileTable.h"

@implementation UserProfileTable

//表名
+(NSString *)getTableName
{
    return @"UserProfileTable";
}

//主键
+(NSString *)getPrimaryKey
{
    return @"user_id";
}

+(UserProfileTable *)getUserProfileTableWithUID:(NSString *)uid
{
   NSArray * resultArray = [ZYDataBaseManager searchToDB:[UserProfileTable class] withSql:[NSString stringWithFormat:@"user_id='%@'",uid] withOrderBy:nil withOffSet:-1 withCount:-1];
    if(resultArray.count == 0)
    {
        return nil;
    }
    UserProfileTable * userPrifile = [resultArray objectAtIndex:0];
    return userPrifile;
}

@end
