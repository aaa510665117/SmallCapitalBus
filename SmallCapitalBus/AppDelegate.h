//
//  AppDelegate.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/3/1.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "LKDBHelper.h"
#import "UserInfoManager.h"
#import "LoginManagerModel.h"
#import <UserNotifications/UserNotifications.h>     //ios10


@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserInfoManager * userInfo;
@property (nonatomic, strong) UserProfile * userProfile;                        //用户信息
@property (nonatomic, strong) LKDBHelper * dbManager;                           //FMDB
@property (nonatomic, strong) LoginManagerModel * loginManager;                 //用户登陆


//主tabbar
-(void)showMainTabNav;

//登录与注册
-(void)showLoginNav;

+ (AppDelegate *)appDelegate;

@end

