//
//  UserInfoManager.m
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/17.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "UserInfoManager.h"
#import "NSObject+ObjectMap.h"

@implementation UserInfoManager

// 初始化
- (id)initUserInfo
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

//获取个人信息
-(void)getUserProfile:(NSString *)uid withPiv:(NSString *)piv withSuccessBlock:(void(^)(UserProfileTable * userInfo))complete withFail:(void (^)(void))failBlock
{
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc]init];
    [httpDic setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    if(piv && ![piv isEqualToString:@""])
    {
        [httpDic setValue:piv forKey:@"piv"];
    }
    if(uid && ![uid isEqualToString:@""])
    {
        [httpDic setValue:uid forKey:@"uid"];
    }
    
    [[ZYHttpAPI sharedUpDownAPI]requestOrdinary:@"api/ysbt/user/profile" withParams:httpDic withSuccess:^(NSDictionary *success) {
        
        [ToolsFunction hideHttpPromptView:nil];
        
        if([[success objectForKey:HTTP_RETURN_KEY] integerValue] == 1)
        {
            NSArray * dic = [success objectForKey:HTTP_RETURN_RESULT];
            UserProfileTable * myUserProfile = [NSObject objectOfClass:[UserProfileTable getTableName] fromJSON:[dic objectAtIndex:0]];
            
            UserProfileTable * oldUserProfile = [UserProfileTable getUserProfileTableWithUID:uid];
            //保存个人信息表到数据库
            if(oldUserProfile == nil)       //本地没有则创建表，有则更新表
            {
                oldUserProfile = [[UserProfileTable alloc]init];
                oldUserProfile = myUserProfile;
                [oldUserProfile saveToDB];
            }
            else
            {
                oldUserProfile = myUserProfile;
                [oldUserProfile updateToDB];
            }
            complete(oldUserProfile);
        }
        else
        {
            if(failBlock)
            {
                failBlock();
            }
            [ZYHttpAPI analysisErrorCode:success withRequestAdd:@"api/ysbt/user/profile"];
        }
        
    } withFailure:^(NSDictionary *failure) {
        
        if(failBlock)
        {
            failBlock();
        }        
        [ToolsFunction hideHttpPromptView:nil];
        [ToolsFunction showPromptViewWithString:NSLocalizedString(@"HTTP_SERVER_ERROR", nil) background:nil timeDuration:1];
    }];
}

//获取用户性别
- (NSString *)getUserGender:(NSString *)genderID
{
    if ([genderID integerValue] == 1)
    {
        return @"男";
    }
    else if([genderID integerValue] == 2)
    {
        return @"女";
    }
    else
    {
        return @"未填写";
    }
}

@end
