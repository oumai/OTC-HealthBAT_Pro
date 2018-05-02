//
//  BATAppDelegate+BATTalkingDataCategory.m
//  HealthBAT_Pro
//
//  Created by four on 16/11/3.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATTalkingDataCategory.h"

@implementation BATAppDelegate (BATTalkingDataCategory)

- (void)bat_registerTalkingData{

    // App ID: 在 App Analytics 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
    // 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
#ifdef ENTERPRISERELEASE
    [TalkingData sessionStarted:@"890C59BBE18C4E52A012B87C331ED386" withChannelId:@"iOS-PGY"];
#elif RELEASE
    [TalkingData sessionStarted:@"890C59BBE18C4E52A012B87C331ED386" withChannelId:@"iOS-AppStore"];
#else
    [TalkingData sessionStarted:@"890C59BBE18C4E52A012B87C331ED386" withChannelId:@"iOS-TEST"];
#endif

    [TalkingData setExceptionReportEnabled:YES];

    
}

@end
