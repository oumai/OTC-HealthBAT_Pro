//
//  HTTPTool.m
//  KMDance
//
//  Created by KM on 17/5/172017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "HTTPTool.h"

@implementation HTTPTool

+ (NetworkStatus)currentNetStatus {
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.jkbat.com"];
    
    return [reachability currentReachabilityStatus];
}


@end
