//
//  BATPaidChildViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//
static NSString *fileCellID = @"BATPaidCell";

#import "BATDaiQuYaoViewController.h"
#import "BATPaidCell.h"
#import "BATMyOrderModel.h"
#import "PharmacyOrderListModel.h"
#import "BATOTCOrderDetailViewController.h"

@interface BATDaiQuYaoViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATDaiQuYaoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getOTCOrderListRequest
{
    //1待付款，2待发货，3待收货，4待取药，5已完成、6已取消
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [dict setObject:@"4" forKey:@"orderStatus"];
    [HTTPTool requestWithOTCURLString:@"/api/order/GetOrderList" parameters:dict type:kGET success:^(id responseObject) {
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        
        PharmacyOrderListModel * model = [PharmacyOrderListModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:model.Data];

        
        if (self.dataArray.count >= model.RecordsCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.dataArray.count == 0) {
            [self.defaultView showDefaultView];
            _defaultView.reloadButton.hidden = YES;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.defaultView showDefaultView];
    }];
    
    
}
#pragma mark ------------------------------------------------------------------UITableViewDatasource Delegate-------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATPaidCell *cell = [tableView dequeueReusableCellWithIdentifier:fileCellID];
    if (nil == cell) {
        cell = [[BATPaidCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fileCellID];
    }
    cell.drugListData = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTCDrugListData *model = self.dataArray[indexPath.row];
    BATOTCOrderDetailViewController *vc = [BATOTCOrderDetailViewController new];
    vc.orderNo = model.OrderNo;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 122;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[BATPaidCell class] forCellReuseIdentifier:fileCellID];
        
        
        WEAK_SELF(self);
        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self getOTCOrderListRequest];
        }];
        _tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self getOTCOrderListRequest];
        }];
    }
    return _tableView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            
            [self.tableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}

@end

