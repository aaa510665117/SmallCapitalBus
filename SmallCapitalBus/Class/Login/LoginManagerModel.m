//
//  LoginManagerModel.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "LoginManagerModel.h"

@implementation LoginManagerModel

- (void)loginVerify:(NSString *)pin
{
//    // 网络通并且PushSession存在，获取Push通知并处理
//    if (kNetworkNotReachability)
//    {
//        [ToolsFunction showPromptViewWithString:@"无法连接网络，请检查你的数据网络连接。" background:nil timeDuration:1];
//        return;
//    }
    
    //进行登录
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc]init];
    [httpDic setValue:[AppDelegate appDelegate].userProfile.userAccountNumber forKey:@"un"];
    [httpDic setValue:pin forKey:@"pin"];
    [httpDic setValue:[AppDelegate appDelegate].userProfile.deviceToken forKey:@"mid"];
    [httpDic setValue:[NSString stringWithFormat:@"%d",PUSH_SERVER_APNS] forKey:@"push_service_type"];
    [httpDic setValue:@"2" forKey:@"ct"];
    
    [ToolsFunction showHttpPromptView:nil];
    
    [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"api/ysbt/auth/mobile/login" withParams:httpDic withSuccess:^(NSDictionary *success) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        if([[success objectForKey:HTTP_RETURN_KEY] isEqualToString:@"1"])
        {
            //登录成功
            [AppDelegate appDelegate].userProfile.autoLoginState = AUTO_LOGIN_CS;
            NSDictionary *resultDic = [success objectForKey:HTTP_RETURN_RESULT];
            //保存用户部分信息
            [AppDelegate appDelegate].userProfile.userSession = [resultDic ac_stringForKey:@"session"];
            [AppDelegate appDelegate].userProfile.userID = [resultDic ac_stringForKey:@"user_id"];
            [AppDelegate appDelegate].userProfile.userName = [resultDic ac_stringForKey:@"user_name"];
            [AppDelegate appDelegate].userProfile.userProfileVersion = [resultDic ac_stringForKey:@"piv"];
            [AppDelegate appDelegate].userProfile.userAvatarVersion = [resultDic ac_stringForKey:@"pav"];
            [AppDelegate appDelegate].userProfile.privlegeId = [resultDic ac_stringForKey:@"privilege_id"];
            [AppDelegate appDelegate].userProfile.firstaidAPIServer = [resultDic ac_stringForKey:@"fristaid_api_server"];
            [AppDelegate appDelegate].userProfile.firstaidAPIServerPort = [resultDic ac_stringForKey:@"fristaid_api_server_port"];
            [AppDelegate appDelegate].userProfile.firstaidNewsAPIServer = [resultDic ac_stringForKey:@"fristaid_news_server"];
            [AppDelegate appDelegate].userProfile.firstaidNewsAPIServerPort = [resultDic ac_stringForKey:@"fristaid_news_server_port"];
            [AppDelegate appDelegate].userProfile.firstaidFileServer = [resultDic ac_stringForKey:@"file_server"];
            [AppDelegate appDelegate].userProfile.firstaidFileServerPort = [resultDic ac_stringForKey:@"file_server_port"];
            //创建用户目录
            [[AppDelegate appDelegate].userProfile createUserDataDirectory];
            //保存用户数据
            [[AppDelegate appDelegate].userProfile saveUserProfiles];
            //获取最新个人信息
            [[AppDelegate appDelegate].userInfo getUserProfile:[AppDelegate appDelegate].userProfile.userID withPiv:nil withSuccessBlock:^(UserProfileTable *userInfo) {

            } withFail:^{
            }];
            
//            //获取所有好友
//            [[AppDelegate appDelegate].userInfo getAllFriendBaseInfoFromServer:^(NSArray * friendArray) {
//            } withFail:^{
//            }];
            //进入主界面
            [[AppDelegate appDelegate] showMainTabNav];
        }
        else
        {
            [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"api/ysbt/auth/mobile/login"];
        }
        
    } withFailure:^(NSDictionary *failure) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
    }];
}

@end
