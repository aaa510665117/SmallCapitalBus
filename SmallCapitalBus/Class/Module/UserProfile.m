//
//  UserProfile.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

-(BOOL)loadUserProfiles
{
    NSLog(@"UserProfile:-----------------loadUserProfiles");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.userAccountNumber == nil) {
        self.userAccountNumber = [defaults stringForKey:@"UserMobilePhone"];
    }
    if (self.userID == nil) {
        self.userID = [defaults stringForKey:@"UserID"];
    }
    if (self.userPassword == nil) {
        self.userPassword = [defaults stringForKey:@"UserPassword"];
    }
    if (self.userSession == nil) {
        self.userSession = [defaults stringForKey:@"UserSession"];
    }
    if (self.deviceToken == nil) {
        self.deviceToken = [defaults stringForKey:@"DeviceToken"];
    }
    if (self.userName == nil){
        self.userName = [defaults stringForKey:@"UserName"];
    }
    if (self.firstaidAPIServer == nil) {
        self.firstaidAPIServer  = [defaults stringForKey:@"FirstAidServer"];
    }
    if (self.firstaidAPIServerPort == nil) {
        self.firstaidAPIServerPort = [defaults stringForKey:@"FirstAidServerPort"];
    }
    if (self.firstaidFileServer == nil) {
        self.firstaidFileServer  = [defaults stringForKey:@"FileFirstAidServer"];
    }
    if (self.firstaidFileServerPort == nil) {
        self.firstaidFileServerPort = [defaults stringForKey:@"FileFirstAidServerPort"];
    }
    
    // 获取用户自己的Profile版本
    self.userProfileVersion = [defaults stringForKey:@"ProfileVersion"];
    if (self.userProfileVersion == nil) {
        self.userProfileVersion = @"0";
    }
    
    self.autoLoginState = [[defaults stringForKey:@"UserAutoLoginState"] intValue];
    
    BOOL isRegistered = [self isRegistered];
    
    if (isRegistered) {
        
        [self createUserDataDirectory];
    }
    return isRegistered;
}

// Wether the user is registered
-(BOOL)isRegistered
{
    return (self.userAccountNumber!=nil && self.userSession != nil && self.autoLoginState != AUTO_NONE);
}

// 登陆成功后初始化用户数据文件夹
- (void)createUserDataDirectory
{
    // 获取FileManager对象
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    
    // 创建Documents/用户号码File目录
    NSString *directory = [NSString stringWithFormat:[NSString documentDirectory], self.userID];
    if (NO == [manager fileExistsAtPath:directory isDirectory:&isDirectory])
    {
        [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.fileDirectory = directory;
    
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    // 为用户创建数据库
    appDelegate.dbManager = [ZYDataBaseManager getUsingLKDBHelperWithName:self.userID];
}

- (void)saveUserProfiles
{
    NSLog(@"UserProfile:-----------------saveUserProfiles");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.userID) {
        [defaults setValue:self.userID forKey:@"UserID"];
    }
    if (self.userSession) {
        [defaults setValue:self.userSession forKey:@"UserSession"];
    }
    if (self.deviceToken) {
        [defaults setValue:self.deviceToken forKey:@"DeviceToken"];
    }
    if (self.userAccountNumber) {
        [defaults setValue:self.userAccountNumber forKey:@"UserMobilePhone"];
    }
    if (self.userName){
        [defaults setValue:self.userName forKey:@"UserName"];
    }
    if (self.firstaidAPIServer) {
        [defaults setValue:self.firstaidAPIServer forKey:@"FirstAidServer"];
    }
    if (self.firstaidAPIServerPort) {
        [defaults setValue:self.firstaidAPIServerPort forKey:@"FirstAidServerPort"];
    }
    if (self.firstaidFileServer) {
        [defaults setValue:self.firstaidFileServer forKey:@"FileFirstAidServerPort"];
    }
    if (self.firstaidFileServerPort) {
        [defaults setValue:self.firstaidFileServerPort forKey:@"FileFirstAidServerPort"];
    }
    // 保存个人资料的版本号
    if (self.userProfileVersion) {
        [defaults setValue:self.userProfileVersion forKey:@"ProfileVersion"];
    }
    else {
        [defaults removeObjectForKey:@"ProfileVersion"];
    }
    
    [defaults setValue:[NSString stringWithFormat:@"%ld",(long)self.autoLoginState] forKey:@"UserAutoLoginState"];
    [defaults synchronize];
}

// 重置帐号
- (void)resetUserIDThread
{
    _autoLoginState = AUTO_NONE;
    NSLog(@"UserProfile:--------------resetUserIDThread");
    
    // 关闭数据库
    [ZYDataBaseManager closeDB];
    
    [self saveUserProfiles];
    
    // 清理用户信息
    [self resetUserProfile];
    
//    // 取消所有网络请求
//    [[SEHttpAPI sharedUpDownAPI] canelRequestAll];
//    [[SEUpDownAPI sharedManager] canelRequestAll];
    
    // 回到主线程处理UI的逻辑
    [self performSelectorOnMainThread:@selector(finishResetUserID) withObject:nil waitUntilDone:NO];
}

// 回到主线程处理UI的逻辑
- (void)finishResetUserID
{
//    // 弹出TabBarController中的view弹出
//    // Release Main Tabbar
//    [[AppDelegate appDelegate].mainTabController.view removeFromSuperview];
//    [AppDelegate appDelegate].mainTabController = nil;
//
//    // 返回登陆界面
//    [[AppDelegate appDelegate] createStartNavigator];
}

// Reset user account
- (void)resetUserProfile {
    
    // User Profile Info
    //    self.userAccountNumber = nil;
    self.userPassword = nil;
    self.userID = nil;
    // Server Address
    self.userSession = nil;
    //    self.deviceToken = nil;
    self.firstaidAPIServer = nil;
    self.fileDirectory = nil;
    self.autoLoginState = AUTO_NONE;
    // 保存用户的Profiles
    [self saveUserProfiles];
    NSLog(@"UserProfile:---------------resetUserProfile");
}

@end
