//
//  HTTPTool+BATDomainAPI.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATDomainAPI.h"
#import "BATDomainModel.h"

@implementation HTTPTool (BATDomainAPI)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
+ (void)getDomain {

#ifdef DEBUG
    //开发｀
    
    //H5
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn/" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-h5.chinacloudsites.cn/" forKey:@"AppH5DomainUrl"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.29:9999" forKey:@"AppDomainUrl"];//李秋萍

        //.net api
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-app.chinacloudsites.cn/" forKey:@"AppApiUrl"];//测试
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.65:1030" forKey:@"AppApiUrl"];//张玮
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.32.27:9998" forKey:@"AppApiUrl"];//金迪
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.83:9998" forKey:@"AppApiUrl"];//催扬
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.32.26:2020" forKey:@"AppApiUrl"];//李何苗
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.205:80" forKey:@"AppApiUrl"];//王立军
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.29:9998" forKey:@"AppApiUrl"];//李秋萍
    //培训工作室
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc013tn-api.chinacloudsites.cn/" forKey:@"AppApiYhsUrl"];//测试
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.29.99:8080" forKey:@"AppApiYhsUrl"];//黎济铭
    //OTC接口api
    [[NSUserDefaults standardUserDefaults] setValue:@"http://otc" forKey:@"OTCApiUrl"];//测试
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.32.27:9999" forKey:@"OTCApiUrl"];//金迪
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.32.26:80" forKey:@"OTCApiUrl"];//禾苗

    //java
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.181:8081" forKey:@"searchdominUrl"];//郭关荣
//    [[NSUserDefaults standardUserDefaults]setValue:@"http://10.2.21.82:8083" forKey:@"searchdominUrl"];//连自杰
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.59:8081" forKey:@"searchdominUrl"];//陈珊

    //商城
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];

    //网络医院
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tapi.kmwlyy.com:8015" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tcommonApi.kmwlyy.com:8116" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tdrugstoreapi.kmwlyy.com:9018" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tuserapi.kmwlyy.com:8119" forKey:@"kmwlyyUserApi"];

#elif TESTING
    //开发&内测

    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn/" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-h5.chinacloudsites.cn/" forKey:@"AppH5DomainUrl"];

    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-app.chinacloudsites.cn/" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc013tn-api.chinacloudsites.cn/" forKey:@"AppApiYhsUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc014tn-api.chinacloudsites.cn/" forKey:@"OTCApiUrl"];

    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tapi.kmwlyy.com:8015" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tcommonApi.kmwlyy.com:8116" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tdrugstoreapi.kmwlyy.com:9018" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tuserapi.kmwlyy.com:8119" forKey:@"kmwlyyUserApi"];
    
#elif PUBLICRELEASE
    //测试

    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-web.chinacloudsites.cn/" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-h5.chinacloudsites.cn/" forKey:@"AppH5DomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc001tn-app.chinacloudsites.cn/" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc013tn-api.chinacloudsites.cn/" forKey:@"AppApiYhsUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://hc014tn-api.chinacloudsites.cn/" forKey:@"OTCApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tapi.kmwlyy.com:8015" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tcommonApi.kmwlyy.com:8116" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tdrugstoreapi.kmwlyy.com:9018" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tuserapi.kmwlyy.com:8119" forKey:@"kmwlyyUserApi"];
    
#elif PRERELEASE
    //预发布
/*
    //azure预发布环境
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apreview.jkbat.com" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://weixin.apreview.jkbat.com" forKey:@"AppH5DomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.apreview.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.apreview.yanghushi.net" forKey:@"AppApiYhsUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apiotc.apreview.jkbat.cn" forKey:@"OTCApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.apreview.jkbat.com/" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"https://prapi.kmwlyy.com/" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://ycommonapi.kmwlyy.com/" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://prdrugstoreapi.kmwlyy.com/" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://yuserapi.kmwlyy.com/" forKey:@"kmwlyyUserApi"];
 */


    //正式（APPSTORE）
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://weixin.jkbat.com" forKey:@"AppH5DomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net/" forKey:@"AppApiYhsUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apiotc.jkbat.cn" forKey:@"OTCApiUrl"];

    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"https://api.kmwlyy.com" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://commonapi.kmwlyy.com" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://drugstoreapi.kmwlyy.com" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://userapi.kmwlyy.com" forKey:@"kmwlyyUserApi"];

#elif ENTERPRISERELEASE
    
    //企业无线发布（蒲公英）
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com/weixin/" forKey:@"AppH5DomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net/" forKey:@"AppApiYhsUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apiotc.jkbat.cn" forKey:@"OTCApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tapi.kmwlyy.com:8015" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tcommonApi.kmwlyy.com:8116" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tdrugstoreapi.kmwlyy.com:9018" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://tuserapi.kmwlyy.com:8119" forKey:@"kmwlyyUserApi"];
    
#elif RELEASE
    //正式（APPSTORE）

    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppWebDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com/weixin/" forKey:@"AppH5DomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net/" forKey:@"AppApiYhsUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://apiotc.jkbat.cn" forKey:@"OTCApiUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"https://api.kmwlyy.com" forKey:@"kmwlyyApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://commonapi.kmwlyy.com" forKey:@"kmwlyyCommonApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://drugstoreapi.kmwlyy.com" forKey:@"kmwlyyDrugstoreApi"];
    [[NSUserDefaults standardUserDefaults] setValue:@"https://userapi.kmwlyy.com" forKey:@"kmwlyyUserApi"];
    
#endif



    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com:8080" forKey:@"storedominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com:8080" forKey:@"hotquestionUrl"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [XMCenter setupConfig:^(XMConfig *config) {
//        config.generalServer = @"general server address";
//        config.generalHeaders = @{@"general-header": @"general header value"};
//        config.generalParameters = @{@"general-parameter": @"general parameter value"};
//        config.generalUserInfo = nil;
        config.callbackQueue = dispatch_get_main_queue();
        config.engine = [XMEngine sharedEngine];
#ifdef DEBUG
        config.consoleLog = YES;
#elif TESTING
        config.consoleLog = YES;
#elif PUBLICRELEASE
        config.consoleLog = NO;
#elif PRERELEASE
        config.consoleLog = YES;
#elif ENTERPRISERELEASE
        config.consoleLog = NO;
#elif RELEASE
        config.consoleLog = NO;
#endif
    }];

#ifdef RELEASE
    //正式环境
//    [HTTPTool domainRequest];
#endif
}

+ (void)domainRequest {
//    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
//    NSString * URL = @"http://www.jkbat.com/api/GetAppDominUrl";
//    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        DDLogVerbose(@"\nGET返回值---\n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        id dic = [HTTPTool responseConfiguration:responseObject];
//
//        BATDomainModel * urlModel = [BATDomainModel mj_objectWithKeyValues:dic];
//        if (urlModel.ResultCode == 0) {
//            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.appdominUrl forKey:@"appdominUrl"];
//            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.storedominUrl forKey:@"storedominUrl"];
//            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.hotquestionUrl forKey:@"hotquestionUrl"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

}

@end
