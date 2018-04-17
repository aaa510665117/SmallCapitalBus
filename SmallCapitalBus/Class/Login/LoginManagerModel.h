//
//  LoginManagerModel.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//  登录管理

#import <Foundation/Foundation.h>

@interface LoginManagerModel : NSObject
{
    UserProfile *userProfile;       // 个人用户的Profile
    NSThread * loginThread;         // 登录线程
}

// 登录服务器
- (void)loginServer;

@end
