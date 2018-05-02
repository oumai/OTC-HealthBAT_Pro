//
//  BATAddressListViewController.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddressListViewController.h"
#import "BATAddressListTableViewCell.h"
#import "BATAddressModel.h"
//#import "BATAddressDetailViewController.h"
#import "BATAddressManageViewController.h"
#import "BATModifyAddressViewController.h"
#import "BATGraditorButton.h"

@interface BATAddressListViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BATGraditorButton *manageButton;

@end

@implementation BATAddressListViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    self.addressListView.tableView.delegate = nil;
    self.addressListView.tableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    [self pageLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择收货地址";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:BATRefreshAddressNotification object:nil];
    
    _dataSource = [NSMutableArray array];
    
    [self.addressListView.tableView registerNib:[UINib nibWithNibName:@"BATAddressListTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATAddressListTableViewCell"];
  
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.manageButton]];
    
    [self.addressListView.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self requestGetAllAddressList];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATAddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddressListTableViewCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        BATAddressData *am = [_dataSource objectAtIndex:indexPath.row];

        cell.nameLabel.text = am.Name;
        cell.phoneLabel.text = am.Phone;

        NSString *address = @"";

        if (am.IsDefault) {
            
            NSString *defaultAdd = @"[默认地址]";
            
            address = [NSString stringWithFormat:@"%@收货地址：%@%@%@",defaultAdd,[am.NamePath stringByReplacingOccurrencesOfString:@"^" withString:@""], am.Address, am.DoorNo];

            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:address];

            [string setAttributes:@{NSForegroundColorAttributeName:UIColorFromHEX(0xff7200, 1)} range:NSMakeRange(0, defaultAdd.length)];

            cell.addressLabel.attributedText = string;

        } else {
            address = [NSString stringWithFormat:@"收货地址：%@%@%@",[am.NamePath stringByReplacingOccurrencesOfString:@"^" withString:@""], am.Address, am.DoorNo];
            cell.addressLabel.text = address;
        }
    }

    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataSource.count > 0) {
        BATAddressData *am = [_dataSource objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BATOTCSelectReceiptUserNotification object:am];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

#pragma mark - Action
#pragma mark 添加新地址
- (void)addNewAddressBtnAction:(UIButton *)button
{
    BATModifyAddressViewController *modifyAddressVC = [[BATModifyAddressViewController alloc] init];
    modifyAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modifyAddressVC animated:YES];
}

#pragma mark - 修改或添加地址后刷新地址列表
- (void)refreshData
{
    [self.addressListView.tableView.mj_header beginRefreshing];
}

#pragma mark - NET
#pragma mark - 接口获取地址列表
- (void)requestGetAllAddressList
{
    [HTTPTool requestWithOTCURLString:@"/api/custom/GetContactInfoList" parameters:nil type:kGET success:^(id responseObject) {
        BATAddressModel *addressModel = [BATAddressModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:addressModel.Data];

        [self.addressListView.tableView reloadData];
        
        [self.addressListView.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [self.addressListView.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.addressListView];

    
    WEAK_SELF(self);
    [self.addressListView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATGraditorButton *)manageButton
{
    if (_manageButton == nil) {
        _manageButton = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _manageButton.enablehollowOut = YES;
        [_manageButton setGradientColors:@[START_COLOR,END_COLOR]];
        _manageButton.enbleGraditor = YES;
        _manageButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_manageButton sizeToFit];
        [_manageButton setTitle:@"管理" forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_manageButton bk_whenTapped:^{
            STRONG_SELF(self);
            
            BATAddressManageViewController *addressManageVC = [[BATAddressManageViewController alloc] init];
            addressManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressManageVC animated:YES];
            
        }];

    }
    return _manageButton;
}

- (BATAddressListView *)addressListView
{
    if (_addressListView == nil) {
        _addressListView = [[BATAddressListView alloc] init];
        _addressListView.tableView.delegate = self;
        _addressListView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _addressListView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self requestGetAllAddressList];
        }];
        
        [_addressListView.addNewAddressButton addTarget:self action:@selector(addNewAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressListView;
}

@end
