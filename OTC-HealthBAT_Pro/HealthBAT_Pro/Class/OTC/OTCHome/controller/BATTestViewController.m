//
//  BATTestViewController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTestViewController.h"
#import "BATOTCProductView.h"
@interface BATTestViewController ()

@end

@implementation BATTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BATOTCProductView *testView = [[BATOTCProductView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 300)];
    [self.view addSubview:testView];
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
