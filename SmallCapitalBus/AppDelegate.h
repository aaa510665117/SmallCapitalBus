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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserInfoManager * userInfo;
@property (nonatomic, strong) UserProfile * userProfile;                        //用户信息
@property (nonatomic, strong) LKDBHelper * dbManager;                           //FMDB


//主tabbar
-(void)showMainTabNav;

//登录与注册
-(void)showLoginNav;

+ (AppDelegate *)appDelegate;

@end

