//
//  BATMacro.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATMacro_h
#define BATMacro_h

//本地错误日志
#define locationErrorData [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ErrorData.plist"]

//引入地区信息
#import "BATLocalDataSourceMacro.h"

//引入通知宏定义
#import "BATNotificationMacro.h"

//引入公用枚举定义
#import "BATEnumMacro.h"

//健康BAT的App Store的ID
#define BAT_OTC_APPSTORE_ID @"1297134315"
//养护师App Store的ID
#define YHS_APPSTORE_ID @"1253389488"

//微信appid
#define WeChatAppId @"wx5206758fb1f9e563"
//#define WeChatAppId @"wxe604d9160748549a"
//#define WeChatAppId @"wx7833444576404bcb"
//#define WeChatAppId @"wxaa5abc4bab9b7859"

//BAT声网 appId
#ifdef ENTERPRISERELEASE
    #define AgoraAppId @"764a4f09065d453e9f21727a241db460"
#elif RELEASE
    #define AgoraAppId @"764a4f09065d453e9f21727a241db460"
#elif PRERELEASE
    #define AgoraAppId @"764a4f09065d453e9f21727a241db460"
#else
    #define AgoraAppId @"1a1a51431ae040ef8b02ee4dd7a5ba82"
#endif


//网络
#define APP_WEB_DOMAIN_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppWebDomainUrl"]//WEB域名
#define APP_H5_DOMAIN_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppH5DomainUrl"]//H5域名

#define APP_API_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppApiUrl"]//API
#define MAINTENANCE_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"AppApiYhsUrl"]//养护师API
#define OTC_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"OTCApiUrl"]//OTC_API

#define SEARCH_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"searchdominUrl"]//搜索域名
#define MALL_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"malldomainUrl"]//搜索域名

#define KM_WLYY_API [[NSUserDefaults standardUserDefaults] valueForKey:@"kmwlyyApi"]//网络医院api
#define KM_WLYY_COMMON_API [[NSUserDefaults standardUserDefaults] valueForKey:@"kmwlyyCommonApi"]//网络医院通用api
#define KM_WLYY_DRUGSTORE_API [[NSUserDefaults standardUserDefaults] valueForKey:@"kmwlyyDrugstoreApi"]//网络医院药店api
#define KM_WLYY_USER_API [[NSUserDefaults standardUserDefaults] valueForKey:@"kmwlyyUserApi"]//网络医院用户api

#define LOCAL_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"]//存入本地的token

#define STORE_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"storedominUrl"]//商城域名--废弃
#define HOT_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"hotquestionUrl"]//热门话题域名--废弃

//登录
#define LOGIN_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"LoginStation"]//登录状态

//网络状态
#define NET_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"netStatus"]//有无网络

//请求状态
#define RESQUEST_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"resquestStatus"]//请求成功还是失败

//地理位置
#define LOCATION_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"LOCATION_STATION"]//地理位置定位状态

#define SET_LOGIN_STATION(bool) [[NSUserDefaults standardUserDefaults] setBool:bool forKey:@"LoginStation"];[[NSUserDefaults standardUserDefaults] synchronize];//改变登录状态
#define PRESENT_LOGIN_VC [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]] animated:YES completion:nil];//弹出登录界面

//TIM登录
#define LOGIN_TIM_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"LoginTIMStation"]//TIM登录状态
#define SET_LOGIN_TIM_STATION(bool) [[NSUserDefaults standardUserDefaults] setBool:bool forKey:@"LoginTIMStation"];[[NSUserDefaults standardUserDefaults] synchronize];//改变TIM登录状态

#define ServiceName @"com.KmHealthBAT.app"//保存密码的标示


#define kKMHealthCloudKey @"kKMHealthCloudKey"//联合登录key

//导航首页缩放系数
#define scaleValue (3.0f / 4.0f)
#define scale6pValue (4.0f / 5.0f)

//蓝色
#define BASE_COLOR UIColorFromHEX(0x0182eb, 1)
//背景灰色
#define BASE_BACKGROUND_COLOR UIColorFromHEX(0xf5f5f5, 1)
//文字灰色
#define STRING_DARK_COLOR UIColorFromHEX(0x333333, 1)
#define STRING_MID_COLOR UIColorFromHEX(0x666666, 1)
#define STRING_LIGHT_COLOR UIColorFromHEX(0x999999, 1)
//渐变色
#define START_COLOR UIColorFromHEX(0x29ccbf, 1)
#define END_COLOR UIColorFromHEX(0x6ccc56, 1)
//分割线颜色
#define BASE_LINECOLOR UIColorFromHEX(0xe0e0e0, 1)
//辅助色
#define SUB_RED_COLOR UIColorFromHEX(0xff4343, 1)
#define SUB_ORIGIN_COLOR UIColorFromHEX(0xfc9f26, 1)

//160地理数据地址
#define location160Data @"Documents/areaList.data"//每次清空
//科室本地数据
#define locationDepartmentData @"Documents/departmentList.data"//每次清空
//融云用户数据
#define locationRongCloudUserData @"Documents/rongCloudUserData"


//全局开关
#define CANCONSULT [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanConsult"] boolValue]
#define CANREGISTER [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanRegister"] boolValue]
#define CANVISITSHOP [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanVisitShop"] boolValue]

//个人定位坐标系
#define LONGITUDE   [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue]
#define LATITUDE [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue]
//登录信息
#define LOGIN_INFO [NSKeyedUnarchiver unarchiveObjectWithFile: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"]]
//个人信息
#define PERSON_INFO [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"]]
//云通信信息
#define LOGIN_TIM_INFO [NSKeyedUnarchiver unarchiveObjectWithFile: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TIMData.data"]]

//生成随机数
#define RANDNUMBERS         [[NSUserDefaults standardUserDefaults] setObject:[Tools randomArray] forKey:@"RANDNUMBERS"];  [[NSUserDefaults standardUserDefaults] synchronize];

//全局宏

#define BAT_NO_DATA @"暂时没有数据"
#define BAT_NO_NETWORK @"呜呜呜，断网啦"


#define BAT_KANGDOCTOR_FIRSTMESSAGE @"你好，我是康博士\n有什么需要我帮助的嘛？关于快速查病、预约挂号、咨询医生都可以找我了解\n除此之外，我还很会聊天的哟！"

#endif /* BATMacro_h */
