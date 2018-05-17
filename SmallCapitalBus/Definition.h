//
//  Definition.h
//  SkyEmergency
//
//  Created by ZY on 15/9/6.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#ifndef SmallCapitalBus_Definition_h
#define SmallCapitalBus_Definition_h

//-----------------------------------------APP配置部分------------------------------------------------//
//大屏适配屏幕宽度比例
#define BOUNDSIZE_RETIO_WIDTH UISCREEN_BOUNDS_SIZE.width/375
//大屏适配屏幕高度比例
#define BOUNDSIZE_RETIO_HEIGH UISCREEN_BOUNDS_SIZE.height/667

#pragma mark Library目录下的文件夹
#define LIBRARY_PLIST_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/PlistFile"]
// 保存所有用户的个人信息文件
#define ALL_USER_PROFILES_INFO		@"all_user_profiles_info.plist"
// 保存wizard显示情况的文件
#define SHOW_WIZARD_INFO			@"show_wziard_info.plist"

#define UISCREEN_BOUNDS_SIZE      [UIScreen mainScreen].bounds.size // 屏幕的物理尺寸
#define UISCREEN_RESOLUTION_SIZE  [UIScreen mainScreen].preferredMode.size // 屏幕的分辨率(Pixels)

#pragma mark 提示窗口使用
#define PROMPT_WAITING_VIEW_TAG             1102                //提示view 遮罩层TAG

#define MAMAP_KEY @"a2146087ec08f1570439c05d6949d57d"           //高德地图

#define KSCRASH_KEY @"1be0a9a113d59037222232cec4dde541"         //KSCrash

#define UMENG_KEY @"57738dab67e58e6c7a00364e"                   //友盟统计

#define WHCATE_APPID @"wxde708b9bc09959c2"                      //微信AppID
#define WHCATE_SECRET @"77b82daa68d03302fe8ff07562add2de"       //微信secret
#define SESSION @"RpPUjl7yNKTAVisj7544mFTAvolQaeop"

//-----------------------------------------APP配置部分end------------------------------------------------//

//-----------------------------------------推送部分------------------------------------------------//
// Push Server(按位操作)
#define PUSH_SERVER_APNS    (1<<0) // 1 - APNS - Apple Push Server

#pragma mark -
#pragma mark 通知的宏定义

#define LOCAL_NOTIFICATION_KEY       @"HealthTip"                                  // 空中急救本地通知提醒Key

#pragma mark -
#pragma mark 通知事件宏定义

#define ALERT_PUSH_NOTIFICATIONS_TAG		1007	// 提示用户开启推送通知

// JSON字符串使用Key字符串
#define MSG_JSON_KEY_SENDTIME			@"time"  // send time
#define MSG_JSON_KEY_LATITUDE           @"latitude" //latitude
#define MSG_JSON_KEY_LONGITUDE          @"longitude" //longitude
#define MSG_JSON_KEY_MSGSRCM			@"srcm" // phone number
#define MSG_JSON_KEY_MSGSRC             @"src"    // user ID
#define MSG_JSON_KEY_MSGPAV             @"pav"    // user pav
#define MSG_JSON_KEY_MESSAGEID			@"uuid"      // message id
#define MSG_JSON_KEY_RS					@"rs"      // rs server
#define MSG_JSON_KEY_FT                 @"ft" // 操作类型
#define MSG_JSON_KEY_PAV                @"pav" // 头像版本号
#define MSG_JSON_KEY_USER_NAME          @"name" // 用户的名字
#define MSG_JSON_KEY_USER_IMAGE         @"img_url" // 用户的头像
#define MSG_JSON_KEY_CT                 @"ct"      // 内容
#define MSG_JSON_KEY_CONTENT            @"content" // 内容
#define MSG_JSON_KEY_ORDER_OT           @"ot"
#define MSG_JSON_KEY_RSID               @"rsid" //急救现场ID
#define MSG_JSON_KEY_MCID               @"mcid" //急救现场主评论ID
#define MSG_JSON_KEY_IVID               @"ivid" //志愿者邀请记录ID
#define MSG_JSON_KEY_ACTIVITYID         @"activity_id"   //志愿者活动邀请活动ID
#define MSG_JSON_KEY_OID                @"oid"   //志愿者活动邀请活动ID
#define MSG_JSON_KEY_GMACTID            @"act_id"  //群聚活动ID

//-----------------------------------------推送部分end------------------------------------------------//

//-----------------------------------------会话------------------------------------------------//

#define PUSH_MSG_TYPE_MMS       @"MMS" // MMS（Multimedia Message）多媒体短信包括的媒体格式有：文字（带表情）/语音/图片/视频/文件，在发送和显示时，都是逐条来进行。对于文字信息，直接封装到消息中。对于其他二进制格式的数据，放到HTTP服务器上，在消息中，只保存消息id，然后接收方通过消息id进行检索。MMS消息格式：{“type”:”MMS”,”mime”:”text/plain”, “src”:”24001234”, “srcm”:”15012345678”,“text”:”text%20message%20with%20emotions”,“filename”:”abc.jpg”,”size”:20123,“duration”:120,“id”:”31000001-1307519957-26”,”time”:1317915830}

#define PUSH_MSG_TYPE_MMG		@"MMG" // MMG（MMS  in Group）群消息（MMG）{“type”:”MMG”,”mime”:”text/plain”,“src”:”24001234”, “srcm”:”15012345678”,”gt”:”1”,”group”=”1307519957”,“text”:”text%20message%20with%20emotions”,”filename”:”abc.jpg”,“size”:20123,”duration”:120,”id”=”30000002-1307519957-26”,“time”=1307519957}

//MIME规范定义的type/subtype非常多，本应用用到的有：
#define MESSAGE_MIMETYPE_TEXT        @"text"       // text/plain (纯文本，文字消息。后面的text部分即为文字正文)
#define MESSAGE_MIMETYPE_IMAGE       @"image"      // image/png/jpeg (图片。后面的thumburl部分为缩略图，url为完整图片)
#define MESSAGE_MIMETYPE_AUDIO       @"audio"      // audio/amr/mp3 (语音短信。后面的url部分即为短信内容的URL地址)
#define MESSAGE_MIMETYPE_APPLICATION @"application"// application/pdf/msword/octet-stream (文件。后面的url部分为文件地址)
#define MESSAGE_MIMETYPE_VIDEO       @"video"      // video/mpeg/avi/asf/mov (视频片段。后面的thumburl部分为缩略图，url部分为视频地址)
#define MESSAGE_MIMETYPE_STICKER     @"sticker"    // sticker/stk/ani (大的贴图或者多帧的动画图片)
#define MESSAGE_MIMETYPE_LINK        @"link"       // link/touch (位置信息)
#define MESSAGE_MIMETYPE_SOS         @"sos"        // sos/nearby (附近的人急救信息)

//-----------------------------------------会话end------------------------------------------------//

//-----------------------------------------网页连接部分------------------------------------------------//

#define REGISTER_SERVICE_HTML           @"innerweb/agreement/first_aid_service_agreement.php"       //空中急救注册服务协议

#define EMERGENCY_ACTIVITY_HTML         @"innerweb/firstaid_active/huodong.html"                    //空中急救软件活动web

#define EMERGENCY_INTEGRAL_HTML         @"innerweb/integral/index.php?ss="                          //空中急救任务积分web

#define EMERGENCY_KNOWLEGGE_HTML        @"innerweb/firstaid_knowledge/index.html"                   //急救知识web页面

#define EMERGENCY_PlanB                 @"innerweb/ergency_action/emergency_action.php?ss="         //365应急预案web

#define EMERGENCY_RESCUE_PACKAGE        @"innerweb/ergency_action/rescue_package.php?ss="           //车载道路救援包

#define EmerGency_EQUIP                 @"innerweb/ergency_action/emergency_equipment.php?ss="      //急救装备web

#define LS_PACKAGEGOOD                  @"innerweb/packageGoods/package.php?ss="                    //稻草包

#define LS_GIFTS                        @"innerweb/packageGoods/receive.php?ss="                    //稻草垛

#define EMERGENCY_LIST                  @"innerweb/activity/public_list.php?ss="                    //公益活动列表

#define EMERGENCY_COOPERATION           @"innerweb/cooperation/cooperation.php?ss="                 //公益活动合作机构

#define EMERGENCY_KIND                  @"innerweb/kind/kind.php?ss="                               //公益活动善有善报

#define PAY_SUCCESS_JUMPHTML            @"innerweb/packageGoods/records.php?ss="                    //到草包支付成功跳转界面

#define PAY_SUCCESS_ACTION              @"innerweb/ergency_action/emergency_action.php?ss="         //安全定制支付成功跳转界面

#define PAY_SUCCESS_EQUIP               @"innerweb/ergency_action/order_manage.php?oid=1&ss="       //急救装备支付成功跳转界面

#define EMERGENCY_VOLUNTEER             @"innerweb/volunteer/vlt.php?ss="                           //公益志愿者省份统计

#define EMERGENCY_VOLUNTEER_VLTFORM     @"innerweb/volunteer/vltform.php?ss="                       //申请志愿者页面

#define INTEGRAL_SHOP_HTML              @"login_credits_shop.php?ss="                               //积分商城

#define HOW_GET_CREADIT_HTML            @"innerweb/integral/earn_points.html?ss="                   //积分商城如何赚取积分

#define ORGANIZATION_APPLY_HTML         @"innerweb/cooperation/organization_apply.php?ss="          //创建机构

#define ORGANIZATION_DETAIL_HTML        @"innerweb/cooperation/orgDetail.php?ss="                   //机构详情

#define VOLUNTEER_GRADE_HTML            @"innerweb/volunteer_grade_system/grade_rule.html"          //等级说明

#define VOLUNTEER_MANUL_HTML            @"innerweb/vol_manul"                                       //志愿者注册守则

#define KNIGHT_CERTI_HTML               @"innerweb/Knight/Knight_certi.php?ss="                     //骑士认证等级说明

#define SCENE_DETAIL_SHARE_HTML         @"innerweb/witness/index.php?rsid="                         //急救现场分享

#define ACTIVITY_DETAIL_SHARE_HTML      @"innerweb/activity_detail/index.php?id="                   //志愿者活动分享

#define FIRSTAID_ACTIVE_AGREEMENT_HTML  @"innerweb/agreement/first_aid_active_agreement.php"        //志愿者活动发布协议

#define KCLINIC_BEMEMBER_HTML           @"http://apiv3.kospital.com/innerweb/clinic/kclinic/bemember.php?fx=1&from=singlemessage&isappinstalled=0"        //空中诊所链接

//-----------------------------------------网页连接部分End------------------------------------------------//

#endif
