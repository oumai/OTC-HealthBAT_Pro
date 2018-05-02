//
//  BATClockManager.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/2.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATClockManager : NSObject

+ (BATClockManager *)shared;

- (void)resetClock;

- (void)settingClock:(NSString *)title body:(NSString *)body clockTime:(NSString *)clockTime identifier:(NSString *)identifier nextDay:(BOOL)isNextDay;

- (void)removeClock:(NSArray *)identifiers;

@end
