//
//  BATQRCodeManager.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATQRCodeManager : NSObject

/**
 生成二维码

 @param string 数据
 @param warterImage 水印log
 @return 二维码
 */
+ (id)createQRCode:(NSString *)string warterImage:(UIImage *)warterImage;

@end
