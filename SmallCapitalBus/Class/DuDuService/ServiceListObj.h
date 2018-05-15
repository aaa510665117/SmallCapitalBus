//
//  ServiceListObj.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/5/15.
//  Copyright © 2018年 ZY. All rights reserved.
//  督督列表

#import <Foundation/Foundation.h>

@interface ServiceListObj : NSObject

@property(nonatomic, strong) NSString * actual_start_time;                          //实际开始服务时间
@property(nonatomic, strong) NSString * address;                                    //门店地址
@property(nonatomic, strong) NSString * created_at;                                 //下单时间
@property(nonatomic, strong) NSString * intend_start_time;                          //预约开始服务时间
@property(nonatomic, strong) NSString * latitude;                                   //门店纬度
@property(nonatomic, strong) NSString * longitude;                                  //门店经度
@property(nonatomic, strong) NSString * logo;                                       //门店logo
@property(nonatomic, strong) NSString * order_id;                                   //订单id
@property(nonatomic, strong) NSString * order_status;                               //0待支付 1待服务 2服务中 3已完成 4已取消
@property(nonatomic, strong) NSString * pay_time;                                   //支付时间
@property(nonatomic, strong) NSString * payed_amount;                               //支付金额
@property(nonatomic, strong) NSString * phone;                                      //门店电话
@property(nonatomic, strong) NSString * price;                                      //服务价格
@property(nonatomic, strong) NSString * report_status;                              //0 没报告 1 有报告
@property(nonatomic, strong) NSString * sex_id;                                     //0未填写 1男 2女
@property(nonatomic, strong) NSString * store_id;                                   //门店id
@property(nonatomic, strong) NSString * store_name;                                 //门店名称
@property(nonatomic, strong) NSString * thumbnail_image_url;                        //用户头像
@property(nonatomic, strong) NSString * user_id;                                    //用户ID
@property(nonatomic, strong) NSString * user_name;                                  //用户名称

@end
