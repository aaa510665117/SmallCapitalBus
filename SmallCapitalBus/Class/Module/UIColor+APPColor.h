//
//  UIColor+APPColor.h
//  AirEmergency
//
//  Created by ZY on 2017/1/23.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (APPColor)

/**
 APP主色调
 */
+ (UIColor *)appColor;

/**
 APP副色调  偏红色
 */
+ (UIColor *)appSecondColor;

/**
 导航栏颜色
 */
+ (UIColor *)navigationColor;

/**
 导航栏文字颜色
 */
+ (UIColor *)navigationTitleColor;

/**
 导航栏返回按钮文字颜色
 */
+ (UIColor *)navigationBackTitleColor;

/**
 tabBar未选中文字颜色
 */
+ (UIColor *)tabBarTitleNormalColor;

/**
 tabBar选中文字颜色
 */
+ (UIColor *)tabBarTitleSelectColor;

/**
 tabBar背景颜色
 */
+ (UIColor *)tabBarBackgroundColor;

@end
