//
//  HttpConfig.h
//  SmallCapitalBus
//
//  Created by ZY on 2018/4/16.
//  Copyright © 2018年 ZY. All rights reserved.
//

#ifndef HttpConfig_h
#define HttpConfig_h

//-----------------------------------------服务器配置部分------------------------------------------------//

#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)  //无网

#ifdef DEBUG // 是Debug版本（开发版本）

#define DEFAULT_SEHTTP_ADDRESS @"http://firstaid.kospital.com"   //http://firstaid.kospital.com   http://210.14.72.52
#define SEHTTP_PORT            @"80"
#define SEHTTP_REALM           @"firstaid"
#define SEHTTP_VERSION         @"1.0"

#else        // 是Release版本（发布版本）

#define DEFAULT_SEHTTP_ADDRESS @"http://firstaid.kospital.com"
#define SEHTTP_PORT            @"80"
#define SEHTTP_REALM           @"firstaid"
#define SEHTTP_VERSION         @"1.0"

#endif      // END

// YiXin Mobile Auto LoginCS/GetMyProfile Mode
enum _auto_login_cs_mode {
    AUTO_NONE = 0, // 不做任何登录
    AUTO_LOGIN_CS = 1, // Auto Login CS
    AUTO_GET_MY_PROFILE = 2 // Auto Get My Profile
};

#define HTTP_RETURN_KEY         @"code"                 //服务器返回Key关键字
#define HTTP_RETURN_MSG         @"msg"                  //服务器返回状态码内容
#define HTTP_RETURN_RESULT      @"result"               //服务器返回json体Key关键字

//-----------------------------------------服务器配置部分end------------------------------------------------//

#endif /* HttpConfig_h */
