//
//  BATHomeMallNewViewController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeMallNewViewController.h"
#import "BATOTCMainViewController.h"
#import "BATQuickConsultationViewController.h"
#import "BATHomeMalMainlView.h"
@interface BATHomeMallNewViewController ()

@end

@implementation BATHomeMallNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"健康商城";
    self.view.backgroundColor = [UIColor whiteColor];
    WEAK_SELF(self);
    BATHomeMalMainlView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"BATHomeMalMainlView" owner:self options:nil
                                  ]lastObject];
    mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
    
    [mainView setLeftImageBlock:^{
        STRONG_SELF(self);
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        BATQuickConsultationViewController *quickVC = [[BATQuickConsultationViewController alloc]init];
        [self.navigationController pushViewController:quickVC animated:YES];
    }];
    
    [mainView setRightImageBlock:^{
        STRONG_SELF(self);
        if (!LOGIN_STATION) {
            PRESENT_LOGIN_VC;
            return;
        }
        BATOTCMainViewController *otcVC = [[BATOTCMainViewController alloc]init];
        [self.navigationController pushViewController:otcVC animated:YES];
    }];
    
    [self.view addSubview:mainView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
