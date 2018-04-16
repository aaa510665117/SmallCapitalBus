//
//  UserProfile.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic, retain) NSString * userID;                                  //用户ID(用户唯一不可变编号)
@property (nonatomic, retain) NSString * userAccountNumber;                       //用户账号
@property (nonatomic, retain) NSString * userPassword;                            //用户密码
@property (nonatomic, retain) NSString * userName;                                //用户姓名
@property (nonatomic, copy)   NSString * userProfileVersion;                      //个人信息的版本号
@property (nonatomic, copy)   NSString * userAvatarVersion;                       //头像的版本号

@property (nonatomic, retain) NSString * userSession;                             //用户Session
@property (nonatomic, retain) NSString * deviceToken;                             //设备的令牌
@property (nonatomic, strong) NSString * privlegeId;                              //用户权限标识符

//备用端口
@property (nonatomic, strong) NSString * firstaidAPIServer;                      //急救API服务器地址
@property (nonatomic, strong) NSString * firstaidAPIServerPort;                  //急救API服务器端口
@property (nonatomic, strong) NSString * firstaidNewsAPIServer;                  //急救API服务器地址news
@property (nonatomic, strong) NSString * firstaidNewsAPIServerPort;              //急救API服务器端口news
@property (nonatomic, strong) NSString * firstaidFileServer;                     //文件服务器的地址
@property (nonatomic, strong) NSString * firstaidFileServerPort;                 //文件服务器的端口号

@property (nonatomic, retain) NSString * fileDirectory;                          // 文件保存目录

@property (nonatomic) NSInteger autoLoginState;                                  //Mobile Auto LoginCS/GetMyProfile Mode

@property (nonatomic, retain) NSString *lastUserMobilePhone;                     // 最后一次登录成功的账号
@property (nonatomic, retain) NSString *lastAppVersion;                          // 最后一次用户使用版本号
@property (nonatomic, retain) NSString *lastSystemLanguage;                      // 最后一次保存的系统语言
@property (nonatomic, retain) NSString *lastSystemVersion;                       // 最后一次保存的系统版本

@property (nonatomic, retain) NSDate *lastLoginDate;                             // 最后一次登录成功的时间

@property (nonatomic) BOOL isPromptLogoutOrBannedUser;                           // 是否提示为被踢或被禁止的用户

@property (nonatomic) BOOL isUpgradeiOS;                                         // 是否进行了系统升级

@property (nonatomic, retain) NSDate *backgroundDate;                            // 程序驻留后台时间点

- (BOOL)loadUserProfiles;  // Load User Profile from Database
- (void)saveUserProfiles;  // Save User Profile to Database
// 初始化用户数据文件夹
- (void)createUserDataDirectory;
// Clear all user information
- (void)resetUserProfile;
// Wether the user is registered
- (BOOL)isRegistered;

// 重置账号
- (void)resetUserIDThread;
// 回到主线程处理UI的逻辑
- (void)finishResetUserID;

@end
