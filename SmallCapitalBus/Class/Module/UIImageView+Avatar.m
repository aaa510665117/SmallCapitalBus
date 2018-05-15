//
//  UIImageView+Avatar.m
//  SkyEmergency
//
//  Created by ZY on 15/10/27.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "UIImageView+Avatar.h"
#import "UserProfileTable.h"
#import "SEUpDownAPI.h"

@implementation UIImageView (Avatar)

//获取用户头像缩略图
-(void)getAvatarThumbnailWithUid:(NSString *)uid withPav:(NSString *)pav
{
    self.image = [UIImage imageNamed:@"avatar_default_user"];

    // 判断路径是否存在，如果不存在则建立目录
    NSFileManager *managerDir = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [managerDir fileExistsAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] isDirectory:&isDirectory])
    {
        [managerDir createDirectoryAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
    [temp setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    [temp setValue:uid forKey:@"uid"];
    [temp setValue:@"1" forKey:@"flag"];    //缩略图
    
    __weak typeof(self) weakSelf = self;
    [[SEUpDownAPI sharedManager] addDownloadPOSTForURL:@"" isRefreshCache:NO parameters:temp saveFileName:^NSString *{

        return [NSString stringWithFormat:@"%@/%@_%@_thumbnail.jpg",[NSString userAvatarImagePath],uid,pav];

    } completionHandler:^(NSData *fileData, NSURL *filePath, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR:%@", error.description);
        }
        else
        {
            UIImage *image = [UIImage imageWithData: fileData];
            if(image.size.width ==0 || image.size.height == 0)
            {
                weakSelf.image = [UIImage imageNamed:@"avatar_default_user"];
            }
            else
            {
                weakSelf.image = image;
            }
        }
    }];
}

/**
 *  获取用户头像缩略图class
 *
 *  @param uid
 */
+(void)getAvatarThumbnailWithUidClass:(NSString *)uid withPav:(NSString *)pav complete:(void (^)(UIImage *avatar))complete
{
    // 判断路径是否存在，如果不存在则建立目录
    NSFileManager *managerDir = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [managerDir fileExistsAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] isDirectory:&isDirectory])
    {
        [managerDir createDirectoryAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
    [temp setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    [temp setValue:uid forKey:@"uid"];
    [temp setValue:@"1" forKey:@"flag"];    //缩略图
    
    [[SEUpDownAPI sharedManager] addDownloadPOSTForURL:@"" isRefreshCache:NO parameters:temp saveFileName:^NSString *{

        return [NSString stringWithFormat:@"%@/%@_%@_thumbnail.jpg",[NSString userAvatarImagePath],uid,pav];

    } completionHandler:^(NSData *fileData, NSURL *filePath, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR:%@", error.description);
        }
        else
        {
            UIImage *image = [UIImage imageWithData: fileData];
            if(image.size.width ==0 || image.size.height == 0)
            {
                image = [UIImage imageNamed:@"avatar_default_user"];
                complete(image);
            }
            else
            {
                image = image;
                complete(image);
            }
        }
    }];
}

//获取用户头像大图
-(void)getAvatarBigWithUid:(NSString *)uid withPav:(NSString *)pav
{
    // 判断路径是否存在，如果不存在则建立目录
    NSFileManager *managerDir = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [managerDir fileExistsAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] isDirectory:&isDirectory])
    {
        [managerDir createDirectoryAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
    [temp setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    [temp setValue:uid forKey:@"uid"];
    [temp setValue:@"2" forKey:@"flag"];    //大图
    
    __weak typeof(self) weakSelf = self;
    [[SEUpDownAPI sharedManager] addDownloadPOSTForURL:@"" isRefreshCache:NO parameters:temp saveFileName:^NSString *{

        return [NSString stringWithFormat:@"%@/%@_%@.jpg",[NSString userAvatarImagePath],uid,pav];

    } completionHandler:^(NSData *fileData, NSURL * filePath, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR:%@", error.description);
        }
        else
        {
            UIImage *image = [UIImage imageWithData: fileData];
            if(image.size.width ==0 || image.size.height == 0)
            {
                image = [UIImage imageNamed:@"avatar_default_user"];
                weakSelf.image = image;
            }
            else
            {
                weakSelf.image = image;
            }
        }
    }];
}

/**
 *  获取用户头像大图
 */
+(void)getAvatarBigWithUidClass:(NSString *)uid withPav:(NSString *)pav complete:(void (^)(UIImage *avatar))complete
{
    // 判断路径是否存在，如果不存在则建立目录
    NSFileManager *managerDir = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [managerDir fileExistsAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] isDirectory:&isDirectory])
    {
        [managerDir createDirectoryAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSMutableDictionary * temp = [[NSMutableDictionary alloc]init];
    [temp setValue:[AppDelegate appDelegate].userProfile.userSession forKey:@"ss"];
    [temp setValue:uid forKey:@"uid"];
    [temp setValue:@"2" forKey:@"flag"];    //大图
    
    [[SEUpDownAPI sharedManager] addDownloadPOSTForURL:@"" isRefreshCache:NO parameters:temp saveFileName:^NSString *{

        return [NSString stringWithFormat:@"%@/%@_%@.jpg",[NSString userAvatarImagePath],uid,pav];

    } completionHandler:^(NSData *fileData, NSURL *filePath, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR:%@", error.description);
        }
        else
        {
            UIImage *image = [UIImage imageWithData: fileData];
            image = image;
            complete(image);
        }
    }];
}

//根据头像URL获取用户头像
-(void)getAvatarThumbnailWithURL:(NSString *)url
{
    self.image = [UIImage imageNamed:@"avatar_default_user"];

    if([url isEqualToString:@""])
    {
        return;
    }
    
    // 判断路径是否存在，如果不存在则建立目录
    NSFileManager *managerDir = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [managerDir fileExistsAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] isDirectory:&isDirectory])
    {
        [managerDir createDirectoryAtPath:[NSString stringWithFormat:@"%@/AvatarImage",[NSString imageDefultDirectory]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    [[SEUpDownAPI sharedManager] addDownloadGETForURL:url isRefreshCache:NO saveFileName:^NSString *{
        
        //替换掉字符串中的@"/"   为了不产生文件目录的错误识别
        NSString * userPhoto = [url stringByReplacingOccurrencesOfString:@"/" withString:@""];
        return [NSString stringWithFormat:@"%@/%@.jpg",[NSString userAvatarImagePath],userPhoto];
        
    } completionHandler:^(NSData *fileData, NSURL *filePath, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR:%@", error.description);
        }
        else
        {
            UIImage *image = [UIImage imageWithData: fileData];
            if(image.size.width ==0 || image.size.height == 0)
            {
                weakSelf.image = [UIImage imageNamed:@"avatar_default_user"];
            }
            else
            {
                weakSelf.image = image;
            }
        }
    }];
}

@end
