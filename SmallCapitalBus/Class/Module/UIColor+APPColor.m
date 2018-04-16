//
//  UIColor+APPColor.m
//  AirEmergency
//
//  Created by ZY on 2017/1/23.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import "UIColor+APPColor.h"

@implementation UIColor (APPColor)

+(UIColor *)appColor
{
    return [UIColor colorWithRed:0.867 green:0.251 blue:0.231 alpha:1.000];
}

+(UIColor *)appSecondColor
{
    return [UIColor colorWithRed:244/255.0 green:88/255.0 blue:85/255.0 alpha:1.0];
}

+(UIColor *)navigationColor
{
    return [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.000];
}

+(UIColor *)navigationTitleColor
{
    return [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
}

+(UIColor *)navigationBackTitleColor
{
    return [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
}

+(UIColor *)tabBarTitleNormalColor
{
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.000];
}

+(UIColor *)tabBarTitleSelectColor
{
    return [UIColor colorWithRed:244/255.0 green:88/255.0 blue:85/255.0 alpha:1.000];
}

+(UIColor *)tabBarBackgroundColor
{
    return [UIColor whiteColor];
}

@end
