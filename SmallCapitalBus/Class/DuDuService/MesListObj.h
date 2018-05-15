//
//  MesListObj.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/5/11.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MesListObj : NSObject

@property(nonatomic, strong) NSString * ack_id;         //消息序号

@property(nonatomic, strong) NSString * user_id;
@property(nonatomic, strong) NSString * user_name;
@property(nonatomic, strong) NSString * thumbnail_image_url;
@property(nonatomic, strong) NSString * src;                        //发送者
@property(nonatomic, strong) NSString * srcm;                       //发送者手机号
@property(nonatomic, strong) NSString * text;                       //消息内容
@property(nonatomic, strong) NSString * time;                       //消息时间
@property(nonatomic, strong) NSString * type;                       //消息类型
@property(nonatomic, strong) NSString * uuid;                       //UUID号


@end
