//
//  BATMyOrderViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//
static NSString *fileCellID = @"BATMyOrderCell";

#import "BATMyOrderViewController.h"
#import "BATMyOrderCell.h"
#import "BATPaidViewController.h"
#import "BATWillPayViewController.h"
#import "BATFinishedOrderViewController.h"
#import "BATOTCOrderDetailViewController.h"

@interface BATMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BATMyOrderViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    [self.view addSubview:self.tableView];
    
  
}
#pragma mark ------------------------------------------------------------------UITableViewDatasource Delegate-------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:fileCellID];
    if (nil == cell) {
        cell = [[BATMyOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fileCellID];
    }
    NSArray *iconArray = @[@"icon-dfkdd",@"icon-yfkdd",@"icon-ywcdd"];
    NSArray *titleArray = @[@"待付款订单",@"已付款订单",@"已完成订单"];
    
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:iconArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 0) {
        
        //待付款
        BATWillPayViewController*vc = [BATWillPayViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        //已付款
        BATPaidViewController*vc = [BATPaidViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        //已付款
        BATFinishedOrderViewController*vc = [BATFinishedOrderViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
    
    
   
    
}

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45.0;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[BATMyOrderCell class] forCellReuseIdentifier:fileCellID];
        
    }
    return _tableView;
}



@end

