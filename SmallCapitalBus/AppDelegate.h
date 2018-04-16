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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserProfile * userProfile;                        //用户信息
@property (nonatomic, strong) LKDBHelper * dbManager;                           //FMDB


+ (AppDelegate *)appDelegate;

@end

