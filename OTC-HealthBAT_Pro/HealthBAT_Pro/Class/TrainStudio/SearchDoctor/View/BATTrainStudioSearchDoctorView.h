//
//  BATTrainStudioSearchDoctorView.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTrainStudioSearchDoctorView : UIView

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,copy)   void(^cancelBtnClickBlock)(void);

@end