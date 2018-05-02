//
//  BATJSObject.h
//  HealthBAT_Pro
//
//  Created by KM on 16/11/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectProtocol <JSExport>

- (void)chooseImage;

- (void)chooseCamera;

- (void)exitChineseMedicine;

- (void)messageVCBackBlock;

- (void)jumpToLogin;

- (void)chooseSymptom:(NSString *)ID;

- (void)goToBatHome;

- (void)removeAnimation;

- (void)goBackDrKang:(NSString *)result;

- (void)DrKangPlayMusic:(NSString *)index;

- (void)testResult:(NSString *)resultStr;

- (void)goToHealthConsultation;


@end

@interface BATJSObject : NSObject<JSObjectProtocol>

@property (nonatomic,copy) void(^chooseImageBlock)(void);
@property (nonatomic,copy) void(^chooseCameraBlock)(void);
@property (nonatomic,copy) void(^exitChineseMedicineBlock)(void);
@property (nonatomic,copy) void(^messageVCBackVCBlock)(void);
@property (nonatomic,copy) void(^jumpToLoginBlock)(void);
@property (nonatomic,copy) void(^chooseSymptomBlock)(NSString *ID);
@property (nonatomic,copy) void(^goToBatHomeBlock)(void);
@property (nonatomic,copy) void(^removeAnimationBlock)(void);
@property (nonatomic,copy) void(^goBackDrKangBlock)(NSString *result);
@property (nonatomic,copy) void(^DrKangPlayMusicBlock)(NSString *index);
@property (nonatomic,copy) void(^testResultBlock)(NSString *resultStr);
@property (nonatomic,copy) void(^goToHealthConsultationBlock)(void);
@end
