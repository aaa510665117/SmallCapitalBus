//
//  UIImageView+Avatar.h
//  SkyEmergency
//
//  Created by ZY on 15/10/27.
//  Copyright © 2015年 ZY. All rights reserved.
//  用户头像扩展类

#import <Foundation/Foundation.h>

@interface UIImageView (Avatar)

#pragma mark ************************PAV获取用户头像**************************

/**
 *  获取用户头像缩略图(含pav)
 *
 *  @param uid
 *  @param pav
 */
-(void)getAvatarThumbnailWithUid:(NSString *)uid withPav:(NSString *)pav;

/**
 *  获取用户头像缩略图class(含pav)
 *
 *  @param uid
 *  @param pav
 */
+(void)getAvatarThumbnailWithUidClass:(NSString *)uid withPav:(NSString *)pav complete:(void (^)(UIImage *avatar))complete;

/**
 *  获取用户头像大图(含pav)
 */
-(void)getAvatarBigWithUid:(NSString *)uid withPav:(NSString *)pav;

/**
 *  获取用户头像大图(含pav)
 */
+(void)getAvatarBigWithUidClass:(NSString *)uid withPav:(NSString *)pav complete:(void (^)(UIImage *avatar))complete;

#pragma mark ************************URL获取用户头像**************************
//根据头像URL获取用户头像
-(void)getAvatarThumbnailWithURL:(NSString *)url;

@end
