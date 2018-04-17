//
//  UserInfoManager.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/17.
//  Copyright © 2018年 ZY. All rights reserved.
//  用户个人信息管理

#import <Foundation/Foundation.h>
#import "UserProfileTable.h"

@interface UserInfoManager : NSObject

// 初始化
- (id)initUserInfo;

//获取个人信息
-(void)getUserProfile:(NSString *)uid withPiv:(NSString *)piv  withSuccessBlock:(void(^)(UserProfileTable * userInfo))complete withFail:(void (^)(void))failBlock;

@end
