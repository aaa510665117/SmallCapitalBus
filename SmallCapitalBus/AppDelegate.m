//
//  AppDelegate.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/3/1.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "AppDelegate.h"
#import "SignViewController.h"

@interface AppDelegate ()

@end  

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册推送
    [self registerNotice];
    
    //用户数据
    [self applicationInitialize];
    
    //load App
    [self launchApp:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"APNS: didRegisterForRemoteNotificationsWithDeviceToken deviceToken = %@", deviceToken);
    
    // 获取设备DeviceToken
    NSString *strDeviceToken = [NSString stringWithFormat:@"%@", deviceToken];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    if (strDeviceToken == nil) {
        NSLog(@"EROOR: strDeviceToken == nil");
        return;
    }
    
    self.userProfile.deviceToken = strDeviceToken;
}

// 推送出错时显示信息
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"APNS: didFailToRegisterForRemoteNotificationsWithError err: %@", err);
    
#ifdef DEBUG
    [ToolsFunction showPromptViewWithString:@"通知无法注册，暂时无法使用！请检查证书是否正确？" background:nil timeDuration:1];
#endif
}

- (void)registerNotice
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    //点击允许
                    NSLog(@"注册通知成功");
                    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        NSLog(@"%@", settings);
                    }];
                } else {
                    //点击不允许
                    NSLog(@"注册通知失败");
                }
                
                if (!error) {
                    NSLog(@"request authorization succeeded!");
                }
            }];
        } else {
            // Fallback on earlier versions
        }if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    //点击允许
                    NSLog(@"注册通知成功");
                    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        NSLog(@"%@", settings);
                    }];
                } else {
                    //点击不允许
                    NSLog(@"注册通知失败");
                }
                
                if (!error) {
                    NSLog(@"request authorization succeeded!");
                }
            }];
            
        } else {
            // Fallback on earlier versions
        }     [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
    }
}

-(void)applicationInitialize
{
    //用户信息类
    _userProfile = [[UserProfile alloc]init];
    [self.userProfile loadUserProfiles];
    //用户信息管理类
    _userInfo = [[UserInfoManager alloc] initUserInfo];
    //登陆管理
    _loginManager = [[LoginManagerModel alloc]init];
}

//主TabBar
-(void)showMainTabNav
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [AppDelegate appDelegate].window.rootViewController=[storyBoard instantiateInitialViewController];
}

//登录与注册
-(void)showLoginNav
{
    UINavigationController *navController = [[UINavigationController alloc] init];
    SignViewController *startViewController = [[SignViewController alloc]init];
    [navController pushViewController:startViewController animated:NO];
    
    // create naviagtion container
    self.window.rootViewController = navController;
}

- (void)launchApp:(NSDictionary *)launchOptions
{
    // 如果用户已经注册过,且也设置过密码，则直接跳转到主页面（如果网络不通也只是提示而不再返回登录页面）
    if([self.userProfile isRegistered])
    {
        // 登录成功后的处理
        [self showMainTabNav];
        
        [self.userInfo getUserProfile:[AppDelegate appDelegate].userProfile.userID withPiv:nil withSuccessBlock:^(UserProfileTable *userInfo) {
        } withFail:^{
        }];
        
        // 网络通并且PushSession存在，获取Push通知并处理
        if (!kNetworkNotReachability && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
        {
//            NSLog(@"DEBUG: didFinishLaunchingWithOptions:launchOptions -> UIApplicationLaunchOptionsRemoteNotificationKey = %@",
//                      [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]);
//            // 接收并处理服务器Push的通知信息
//            [self.pushMessageManager dealRemotePushNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
//            // 检查用户是否开启推送
//            [ToolsFunction checkAndShowPushNotificationDisableAlert];
        }
    }
    else {
        //        // 如果没有注册过，则进入注册界面进行用户第一次注册
        [self showLoginNav];
    }
}

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
