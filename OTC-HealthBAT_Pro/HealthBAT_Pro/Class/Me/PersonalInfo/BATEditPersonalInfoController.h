//
//  BATEditPersonalInfoController.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditType) {
    kEditUserName = 1,    //昵称
    kEditSignature = 2,  //签名
    kEditPastHistory = 3,  //已往病史
    kEditAllergyHistory = 4, // 过敏病史
    kEditHereditaryDisease = 5,  //遗传病史
};

@protocol BATEditPersonalInfoControllerDelegate <NSObject>

- (void)editPersonalInfoControllerDoneButtonDidClick:(NSString *)content editType:(EditType )editType;

@end

@interface BATEditPersonalInfoController : UIViewController
/** textView占位文字 */
@property (nonatomic, strong) NSString *placehoder;
/** 最大输入限制 */
@property (nonatomic, assign) NSInteger maxInputLimit;
/** 内容是否可以为空 */
@property (nonatomic, assign ) BOOL  contentNil;
/** 内容 */
@property (nonatomic, strong) NSString *textViewText;
/** <#属性描述#> */
@property (nonatomic ,assign) EditType editType;

/** delegate属性 */
@property (nonatomic, weak) id <BATEditPersonalInfoControllerDelegate>delegate;
@end
