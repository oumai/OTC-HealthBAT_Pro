//
//  SJAvatarBrowser.h
//  zhitu
//
//  Created by 陈少杰 QQ：417365260 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJAvatarBrowser : NSObject<UIScrollViewDelegate>

/**
 浏览头像

 @param avatarImageView 头像所在的imageView
 @param isQRCode 是否是二维码
 */
+(void)showImage:(UIImageView *)avatarImageView isQRCode:(BOOL)isQRCode;

@end
