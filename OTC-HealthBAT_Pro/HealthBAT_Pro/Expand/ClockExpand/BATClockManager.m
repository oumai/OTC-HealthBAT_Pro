//
//  BATClockManager.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/2.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATClockManager.h"
#import "BATMyProgrammesModel.h"
#import "BATProgramDetailModel.h"

@implementation BATClockManager

+ (BATClockManager *)shared
{
    static BATClockManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BATClockManager alloc] init];
    });
    return instance;
}

- (void)resetClock
{
    //防止未清成功
    [self removeClock:nil];

    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetMyProgrammes" parameters:@{@"pageIndex":@(0),@"pageSize":@(NSIntegerMax)} type:kGET success:^(id responseObject) {
        
        BATMyProgrammesModel *myProgrammesModel = [BATMyProgrammesModel mj_objectWithKeyValues:responseObject];
        
        for (ProgrammesData *program in myProgrammesModel.Data) {
//            if (program.IsFlag) {
                for (BATProgramItem *programItem in program.ProgrammeLst) {
                    [self settingClock:programItem.Title body:programItem.ResultDesc clockTime:programItem.JobTime identifier:[NSString stringWithFormat:@"template_%ld_%ld",(long)program.ID,(long)programItem.ID] nextDay:program.IsSecondDayOpenclock];
                }
//            }
        }

    } failure:^(NSError *error) {
        
    }];
}

- (NSTimeInterval)changeSecond:(NSString *)time
{
    
    NSArray *times = [time componentsSeparatedByString:@":"];
    NSInteger hour = [[times objectAtIndex:0] integerValue];
    NSInteger minute = [[times objectAtIndex:1] integerValue];
    
    if (hour - 8 > 0) {
        return (hour - 8) * 60 * 60 + minute * 60;
    } else if (hour - 8 < 0) {
        return (24 - 8 + hour) * 60 * 60 + minute * 60;
    } else {
        
        NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
        
        NSDateComponents *components = [calender components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
        
        if (minute > [components minute]) {
            return minute * 60;
        } else {
            return 24 * 60 * 60 + minute * 60;
        }
    }
    
}

- (void)settingClock:(NSString *)title body:(NSString *)body clockTime:(NSString *)clockTime identifier:(NSString *)identifier nextDay:(BOOL)isNextDay
{
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
//    content.title = title;
    
    if (body.length <= 0) {
        content.body = title;
    } else {
        content.body = [NSString stringWithFormat:@"%@：%@",title,body];
    }
    content.userInfo = @{@"identifier":identifier,@"title":title,@"body":body};
    
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    trigger.repeat = YES;
    if (IS_IOS10) {
        //MARK: 新要求是所有新加入方案的闹钟都是第二天才响
        NSArray *times = [clockTime componentsSeparatedByString:@":"];
        
        NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
        
        if (isNextDay) {
            components.day += 1;
        }
        
        components.hour = [[times objectAtIndex:0] integerValue];
        components.minute = [[times objectAtIndex:1] integerValue];
        
        
        trigger.dateComponents = components; // iOS10以上有效
    }
    else {
        
        NSArray *times = [clockTime componentsSeparatedByString:@":"];
        NSInteger hour = [[times objectAtIndex:0] integerValue];
        NSInteger minute = [[times objectAtIndex:1] integerValue];
        
        NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
        
        NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];

        DDLogDebug(@"hour %ld,minute %ld,second %ld",(long)[components hour],(long)[components minute],(long)[components second]);
        
        if (isNextDay) {
            
            components.day += 1;
            components.hour = hour;
            components.minute = minute;
            
        } else {
            
            if ([components hour] > hour) {
                components.day += 1;
                components.hour = hour;
                components.minute = minute;
            } else if ([components minute] > minute && [components hour] == hour) {
                components.day += 1;
                components.hour = hour;
                components.minute = minute;
            } else {
                components.hour = hour;
                components.minute = minute;
            }

        }
        
        trigger.fireDate = [calender dateFromComponents:components]; // iOS10以下有效
        
        
        
//        trigger.fireDate = [NSDate dateWithTimeIntervalSinceNow:-[self changeSecond:clockTime]]; // iOS10以下有效

    }
    
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.content = content;
    request.trigger = trigger;
    request.requestIdentifier = identifier;
    
    request.completionHandler = ^(id result) {
        DDLogDebug(@"%@", result); // iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil;iOS10以下成功result为UILocalNotification对象，失败则result为nil
    };
    [JPUSHService addNotification:request];
}

- (void)removeClock:(NSArray *)identifiers
{
    JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
    identifier.identifiers = identifiers;
    [JPUSHService removeNotification:identifier];
}

@end
