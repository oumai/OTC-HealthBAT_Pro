//
//  MedicallyExaminedViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/23.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreCameraDetection.h"
#import "KMUIViewController.h"
#import "BATGraditorButton.h"
@class HeartBackgroundView;
@class HeartLive;

@interface MedicallyExaminedViewController : KMUIViewController<CoreCameraDetectionDelegate>
{
    CoreCameraDetection *coreCameraDetection;
    HeartBackgroundView *LPressureView;
    HeartBackgroundView *HPressureView;
    HeartBackgroundView *bloodOxygenView;
    HeartBackgroundView *HeartRateView;
    
    UILabel *LPressureLabel;
    UILabel *HPressureLabel;
    UILabel *bloodOxygenLabel;
    UILabel *heartRateLabel;
    
    UILabel *hudLabel;
    HeartLive *examinedValueLive;
    BATGraditorButton *startExaminedButton;
    NSTimer *examinedTimer;
    NSTimer *examinedLiveTimer;
    
    NSMutableArray *examinedArray;
    NSInteger xCoordinateExaminedInMoniter;
    NSInteger currntTimer;
    BOOL onceMEHelpPage;
    
    NSInteger netHeartRateValue;
    NSInteger netSPValue;
    NSInteger netDPValue;
    NSInteger netBloodOxygenValue;
    BOOL souceDataError;
    
}

@end
