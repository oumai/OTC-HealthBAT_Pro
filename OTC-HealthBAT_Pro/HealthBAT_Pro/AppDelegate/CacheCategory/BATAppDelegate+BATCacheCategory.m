//
//  BATAppDelegate+BATCacheCategory.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/12017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATCacheCategory.h"
#import "SDURLCache.h"
#import "BATLoginModel.h"

@implementation BATAppDelegate (BATCacheCategory)

- (void)bat_cache {

    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*10   // 1MB mem cache
                                                         diskCapacity:1024*1024*50 // 5MB disk cache
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];


//    //国医馆缓存
//
//    BATLoginModel *login = LOGIN_INFO;
//
//    NSString *url_1 = [NSString stringWithFormat:@"%@/app/ChatInterface?accountId=%ld&chanelId=89b74a07d8884994b8b75580847eaf2e&message=1&token=%@",APP_WEB_DOMAIN_URL,(long)login.Data.ID,LOCAL_TOKEN];
//
//    NSArray *array = @[url_1];
//    for (NSString * url in array) {
//
////        [HTTPTool baseRequestWithURLString:url HTTPHeader:nil parameters:nil type:kGET success:^(id responseObject) {
////
////        } failure:^(NSError *error) {
////
////        }];
//    }
}
@end
