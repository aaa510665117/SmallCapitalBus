//
//  GroupMeetAlertView.h
//  AirEmergency
//
//  Created by ZY on 2017/7/25.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickSureBtn)(void);

@interface GroupMeetAlertView : UIView


@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property(nonatomic, copy)ClickSureBtn clickSureBtn;
//点击确定调用方法
- (instancetype)initWithFrame:(CGRect)frame withTilte:(NSString *)tilte complete:(ClickSureBtn)complete;

-(void)show;

@end
