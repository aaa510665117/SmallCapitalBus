//
//  AWCollectionViewCell.m
//  SkyHospital
//
//  Created by ZY on 15/5/15.
//  Copyright (c) 2015年 GrayWang. All rights reserved.
//

#import "AWCollectionViewCell.h"

@implementation AWCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _areaNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
        _areaNameLabel.backgroundColor = [UIColor clearColor];
        _areaNameLabel.textColor = [UIColor blackColor];
        _areaNameLabel.font = [UIFont systemFontOfSize:30];
        [self addSubview:_areaNameLabel];
    }
    return self;
}

@end
