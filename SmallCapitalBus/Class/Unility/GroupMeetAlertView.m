//
//  GroupMeetAlertView.m
//  AirEmergency
//
//  Created by ZY on 2017/7/25.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import "GroupMeetAlertView.h"

@implementation GroupMeetAlertView

- (instancetype)initWithFrame:(CGRect)frame withTilte:(NSString *)tilte complete:(ClickSureBtn)complete
{
    self =[[[NSBundle mainBundle] loadNibNamed:@"GroupMeetAlertView" owner:nil options:nil] firstObject];
    if(self)
    {
        self.frame = frame;
        [self drawView:tilte complete:complete];
    }
    return self;
}

-(void)drawView:(NSString *)title complete:(ClickSureBtn)complete
{
    _clickSureBtn = complete;
    _messageLabel.text = title;
}

-(void)show
{
    self.tag = 20581;
    UIView * view = [[AppDelegate appDelegate].window viewWithTag:20581];
    if(view == nil)
    {
        [[AppDelegate appDelegate].window addSubview:self];
    }
}

- (IBAction)clickCloseBtn:(id)sender {
    //点击关闭按钮
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (IBAction)clickRejectBtn:(id)sender {
    //点击拒绝按钮
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (IBAction)clickAcceptBtn:(id)sender {
    //点击接受按钮
    if(_clickSureBtn)
    {
        _clickSureBtn();
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
