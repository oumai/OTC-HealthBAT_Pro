//
//  BATSubmitOrderViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSubmitOrderViewController.h"
#import "BATOTCOrderGoodsTableViewCell.h"
#import "BATOTCOrderTitleCell.h"
#import "BATOTCOrderReceiptTypeTableViewCell.h"
#import "BATOTCOrderReceiptUserInfoCell.h"
#import "BATOTCOrderDrugStoreAddressCell.h"
#import "BATOTCOrderFreightTableViewCell.h"
#import "BATAddressListViewController.h"
#import "BATSelectDrugStoreViewController.h"
#import "BATAddressModel.h"
#import "BATDrugStoreModel.h"
#import "BATOTCPayView.h"
#import "BATAppDelegate.h"
#import "BATPayManager.h"
#import "BATOTCOrderDetailViewController.h"
#import "BATOTCOrderModuleSettingModel.h"

@interface BATSubmitOrderViewController () <UITableViewDelegate,UITableViewDataSource>

/**
 是否到药店取货
 */
@property (nonatomic,assign) BOOL isPickUp;

/**
 是否送货上门
 */
@property (nonatomic,assign) BOOL isDelivery;

/**
 收货方式
 */
@property (nonatomic,assign) BATReceiveMethod receiveMethod;

/**
 收货人
 */
@property (nonatomic,strong) BATAddressData *addressData;

/**
 药店
 */
@property (nonatomic,strong) BATDrugStoreData *drugStoreData;

/**
 运费
 */
@property (nonatomic,assign) double freight;

/**
 合计总价
 */
@property (nonatomic,assign) double totalPrice;

/**
 货品Id集合
 */
@property (nonatomic,copy) NSMutableArray *products;

/**
 支付方式view
 */
@property (nonatomic,strong) BATOTCPayView *payView;

/**
 订单号
 */
@property (nonatomic,strong) NSString *orderNo;

@property (nonatomic,strong) BATOTCOrderModuleSettingModel *moduleSettingModel;

@end

@implementation BATSubmitOrderViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提交订单";
    
    [self.submitOrderView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderGoodsTableViewCell"];
    [self.submitOrderView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderTitleCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderTitleCell"];
    [self.submitOrderView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderReceiptTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderReceiptTypeTableViewCell"];
    [self.submitOrderView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderDrugStoreAddressCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderDrugStoreAddressCell"];
    [self.submitOrderView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderReceiptUserInfoCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderReceiptUserInfoCell"];
    [self.submitOrderView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderFreightTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderFreightTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectReceiptUser:) name:BATOTCSelectReceiptUserNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDrugStore:) name:BATOTCSelectDrugStoreNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:BATPayCancelNotification object:nil];
    
    [self requestGetModuleSetting];
    
    _isPickUp = NO;
    _isDelivery = NO;
    
    _freight = 0.00;
    
    [self calcTotalPrice];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.moduleSettingModel) {
        
        if (!self.moduleSettingModel.Data.IsCanBuy) {
            return 1;
        } else {
            if (self.moduleSettingModel.Data.IsPickUpInStore || self.moduleSettingModel.Data.IsHomeDelivery) {
                return 2;
            } else if (!self.moduleSettingModel.Data.IsPickUpInStore && !self.moduleSettingModel.Data.IsHomeDelivery) {
                return 1;
            }
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArry.count;
    }
    
    if (self.moduleSettingModel.Data.IsPickUpInStore && self.moduleSettingModel.Data.IsHomeDelivery) {
        
        if ((!_isDelivery && !_isPickUp) || _isPickUp) {
            return 4;
        } else if (_isDelivery) {
            return 5;
        }
        
    } else {
        if (self.moduleSettingModel.Data.IsPickUpInStore) {
            
            if (_isPickUp) {
                return 3;
            } else {
                return 2;
            }
            
        } else if (self.moduleSettingModel.Data.IsHomeDelivery) {
            if (_isDelivery) {
                return 4;
            } else {
                return 3;
            }
        }
    }
    
    
//    if ((!_isDelivery && !_isPickUp) || _isPickUp) {
//        return 4;
//    } else if (_isDelivery) {
//        return 5;
//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    }
    return UITableViewAutomaticDimension;;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = BASE_BACKGROUND_COLOR;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = BASE_BACKGROUND_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        BATOTCOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderGoodsTableViewCell" forIndexPath:indexPath];
        
        if (self.dataArry.count > 0) {
            
            OTCSearchData *data = self.dataArry[indexPath.row];
            
            
            [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.PictureUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",data.DrugName,data.Specification];
            cell.countLabel.text = [NSString stringWithFormat:@"x%ld",(long)data.drugCount];
            cell.descLabel.text = data.ManufactorName;
            cell.sellPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.Price];
            cell.priceLabel.text = @"";
            
        }

        return cell;
    }
    
    if (indexPath.row == 0) {
        
        BATOTCOrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderTitleCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"收货方式";
        return cell;
        
    } else if (indexPath.row == 1) {
        
        BATOTCOrderReceiptTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptTypeTableViewCell" forIndexPath:indexPath];
        
        if (self.moduleSettingModel.Data.IsPickUpInStore || !self.moduleSettingModel.Data.IsHomeDelivery) {
            cell.titleLabel.text = @"到药店取货";
            cell.selectButton.selected = _isPickUp;
            cell.accessoryType = _isPickUp ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        } else if (self.moduleSettingModel.Data.IsHomeDelivery || !self.moduleSettingModel.Data.IsPickUpInStore) {
            cell.titleLabel.text = @"送货上门";
            cell.selectButton.selected = _isDelivery;
            cell.accessoryType = _isDelivery ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
        
    } else if (indexPath.row == 2) {
        
        if (self.moduleSettingModel.Data.IsPickUpInStore && self.moduleSettingModel.Data.IsHomeDelivery) {
            
            if (_isPickUp) {
                BATOTCOrderDrugStoreAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderDrugStoreAddressCell" forIndexPath:indexPath];
                if (_drugStoreData) {
                    cell.shopAddressLabel.text = _drugStoreData.Address;
                }
                return cell;
            } else {
                BATOTCOrderReceiptTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptTypeTableViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"送货上门";
                cell.selectButton.selected = _isDelivery;
                cell.accessoryType = _isDelivery ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        } else if (self.moduleSettingModel.Data.IsPickUpInStore && !self.moduleSettingModel.Data.IsHomeDelivery) {
            if (_isPickUp) {
                BATOTCOrderDrugStoreAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderDrugStoreAddressCell" forIndexPath:indexPath];
                if (_drugStoreData) {
                    cell.shopAddressLabel.text = _drugStoreData.Address;
                }
                return cell;
            }
        } else if (self.moduleSettingModel.Data.IsHomeDelivery && !self.moduleSettingModel.Data.IsPickUpInStore) {
            if (_isDelivery) {
                BATOTCOrderReceiptUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptUserInfoCell" forIndexPath:indexPath];
                
                if (_addressData) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",_addressData.Name];
                    cell.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_addressData.Phone];
                    cell.addressLabel.text = [NSString stringWithFormat:@"地址：%@%@%@",[_addressData.NamePath stringByReplacingOccurrencesOfString:@"^" withString:@""], _addressData.Address, _addressData.DoorNo];
                }
                return cell;
            } else {
                BATOTCOrderFreightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderFreightTableViewCell" forIndexPath:indexPath];
                cell.freightLabel.text = [NSString stringWithFormat:@"%.2f元",_freight];
                return cell;
            }
        }
        
//        if (_isPickUp) {
//            BATOTCOrderDrugStoreAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderDrugStoreAddressCell" forIndexPath:indexPath];
//            if (_drugStoreData) {
//                cell.shopAddressLabel.text = _drugStoreData.Address;
//            }
//            return cell;
//        } else {
//            BATOTCOrderReceiptTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptTypeTableViewCell" forIndexPath:indexPath];
//            cell.titleLabel.text = @"送货上门";
//            cell.selectButton.selected = _isDelivery;
//            cell.accessoryType = _isDelivery ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
//            return cell;
//        }
        
    } else if (indexPath.row == 3) {
        
        if (self.moduleSettingModel.Data.IsHomeDelivery && self.moduleSettingModel.Data.IsPickUpInStore) {
            if (_isDelivery) {
                BATOTCOrderReceiptUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptUserInfoCell" forIndexPath:indexPath];
                
                if (_addressData) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",_addressData.Name];
                    cell.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_addressData.Phone];
                    cell.addressLabel.text = [NSString stringWithFormat:@"地址：%@%@%@",[_addressData.NamePath stringByReplacingOccurrencesOfString:@"^" withString:@""], _addressData.Address, _addressData.DoorNo];
                }
                return cell;
            } else if (_isPickUp) {
                BATOTCOrderReceiptTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptTypeTableViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"送货上门";
                cell.selectButton.selected = _isDelivery;
                return cell;
            } else if (!_isDelivery && !_isPickUp){
                BATOTCOrderFreightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderFreightTableViewCell" forIndexPath:indexPath];
                cell.freightLabel.text = [NSString stringWithFormat:@"%.2f元",_freight];
                return cell;
            }
        } else if (self.moduleSettingModel.Data.IsHomeDelivery) {
            BATOTCOrderFreightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderFreightTableViewCell" forIndexPath:indexPath];
            cell.freightLabel.text = [NSString stringWithFormat:@"%.2f元",_freight];
            return cell;
        }
        
//        if (_isDelivery) {
//            BATOTCOrderReceiptUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptUserInfoCell" forIndexPath:indexPath];
//
//            if (_addressData) {
//                cell.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",_addressData.Name];
//                cell.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_addressData.Phone];
//                cell.addressLabel.text = [NSString stringWithFormat:@"地址：%@%@%@",[_addressData.NamePath stringByReplacingOccurrencesOfString:@"^" withString:@""], _addressData.Address, _addressData.DoorNo];
//            }
//            return cell;
//        } else if (_isPickUp) {
//            BATOTCOrderReceiptTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderReceiptTypeTableViewCell" forIndexPath:indexPath];
//            cell.titleLabel.text = @"送货上门";
//            cell.selectButton.selected = _isDelivery;
//            return cell;
//        } else if (!_isDelivery && !_isPickUp){
//            BATOTCOrderFreightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderFreightTableViewCell" forIndexPath:indexPath];
//            cell.freightLabel.text = [NSString stringWithFormat:@"%.2f元",_freight];
//            return cell;
//        }
        
    } else if (indexPath.row == 4) {
        BATOTCOrderFreightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderFreightTableViewCell" forIndexPath:indexPath];
        cell.freightLabel.text = [NSString stringWithFormat:@"%.2f元",_freight];
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        
        if (self.moduleSettingModel.Data.IsPickUpInStore && self.moduleSettingModel.Data.IsHomeDelivery) {
            if (indexPath.row == 1) {
                //选择药店
                BATSelectDrugStoreViewController *selectDrugStoreVC = [[BATSelectDrugStoreViewController alloc] init];
                selectDrugStoreVC.products = self.products;
                selectDrugStoreVC.selectDrugStore = _drugStoreData.StoreName;
                selectDrugStoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:selectDrugStoreVC animated:YES];
                
            }
            
            if (!_isDelivery && !_isPickUp) {
                if (indexPath.row == 2) {
                    //选择收货人
                    BATAddressListViewController *addressListVC = [[BATAddressListViewController alloc] init];
                    addressListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:addressListVC animated:YES];
                }
                
            } else if (_isPickUp) {
                
                if (indexPath.row == 2) {
                    //选择药店
                    BATSelectDrugStoreViewController *selectDrugStoreVC = [[BATSelectDrugStoreViewController alloc] init];
                    selectDrugStoreVC.products = self.products;
                    selectDrugStoreVC.selectDrugStore = _drugStoreData.StoreName;
                    selectDrugStoreVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:selectDrugStoreVC animated:YES];
                    
                } else if (indexPath.row == 3) {
                    //选择收货人
                    BATAddressListViewController *addressListVC = [[BATAddressListViewController alloc] init];
                    addressListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:addressListVC animated:YES];
                    
                }
                
            } else if (_isDelivery) {
                
                if (indexPath.row == 2 || indexPath.row == 3) {
                    //选择收货人
                    BATAddressListViewController *addressListVC = [[BATAddressListViewController alloc] init];
                    addressListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:addressListVC animated:YES];
                }
                
            }
        } else if (self.moduleSettingModel.Data.IsPickUpInStore && !self.moduleSettingModel.Data.IsHomeDelivery) {
            
            if (indexPath.row == 1) {
                //选择药店
                BATSelectDrugStoreViewController *selectDrugStoreVC = [[BATSelectDrugStoreViewController alloc] init];
                selectDrugStoreVC.products = self.products;
                selectDrugStoreVC.selectDrugStore = _drugStoreData.StoreName;
                selectDrugStoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:selectDrugStoreVC animated:YES];
                
            } else if (indexPath.row == 2) {
                if (_isPickUp) {
                    //选择药店
                    BATSelectDrugStoreViewController *selectDrugStoreVC = [[BATSelectDrugStoreViewController alloc] init];
                    selectDrugStoreVC.products = self.products;
                    selectDrugStoreVC.selectDrugStore = _drugStoreData.StoreName;
                    selectDrugStoreVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:selectDrugStoreVC animated:YES];
                }
            }
        } else if (!self.moduleSettingModel.Data.IsPickUpInStore && self.moduleSettingModel.Data.IsHomeDelivery) {
            if (indexPath.row == 1) {
                //选择收货人
                BATAddressListViewController *addressListVC = [[BATAddressListViewController alloc] init];
                addressListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressListVC animated:YES];
                
            } else if (indexPath.row == 2) {
                
                if (_isDelivery) {
                    //选择药店
                    //选择收货人
                    BATAddressListViewController *addressListVC = [[BATAddressListViewController alloc] init];
                    addressListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:addressListVC animated:YES];
                }
            }
        }
        

        
        [tableView reloadData];
    }
    
}


#pragma mark - Action
#pragma mark - 选择收货人
- (void)selectReceiptUser:(NSNotification *)notif
{
    _isDelivery = YES;
    _isPickUp = NO;
    
    _receiveMethod = BATReceiveMethod_Delivery;
    
    _addressData = (BATAddressData *)[notif object];
    _drugStoreData = nil;
    
    [self requestGetFreight];
    
    [self.submitOrderView.tableView reloadData];
}

#pragma mark - 选择药店
- (void)selectDrugStore:(NSNotification *)notif
{
    _isDelivery = NO;
    _isPickUp = YES;
    
    _receiveMethod = BATReceiveMethod_PickUp;
    
    _drugStoreData = (BATDrugStoreData *)[notif object];
    _addressData = nil;
    
    [self calcTotalPrice];
    
    [self.submitOrderView.tableView reloadData];
}

#pragma mark - 计算总价
- (void)calcTotalPrice
{
    
    _totalPrice = 0.00;
    
    for (OTCSearchData *data in self.dataArry) {
        _totalPrice = _totalPrice + [data.Price doubleValue] * data.drugCount;
    }
    
    if (_isDelivery) {
        //送货上门
         _totalPrice = _totalPrice + _freight;
    }

    self.submitOrderView.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f元",_totalPrice];
}

#pragma mark - 支付成功
- (void)paySuccess:(BATDoctorStudioPayType)type
{
    [self.payView hide];
    [self showProgress];
    
    [HTTPTool requestWithOTCURLString:@"/api/Pay/PaySignCheck" parameters:@{@"orderNo":self.orderNo,@"PayMethod":@(type)} type:kGET success:^(id responseObject) {
        
        [self showText:@"支付成功！"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BATOTCOrderDetailViewController *orderDetailVC = [[BATOTCOrderDetailViewController alloc] init];
            orderDetailVC.orderNo = _orderNo;
            orderDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        });

        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 支付取消
- (void)payCancel
{
    
    WEAK_SELF(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG_SELF(self);
        [self.payView hide];
        
        //清空购物车
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
        [NSKeyedArchiver archiveRootObject:[NSMutableArray array] toFile:file];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BATOTCOrderDetailViewController *orderDetailVC = [[BATOTCOrderDetailViewController alloc] init];
            orderDetailVC.orderNo = _orderNo;
            orderDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        });
    });
    

}

- (void)confirmPayBtnAction
{
    if (self.payView.selectIndexPath.row == 0) {
        //支付宝支付
        [self requestAlipayFromBATAPI];
        
    } else if (self.payView.selectIndexPath.row == 1) {
        //微信支付
        [self requestWeChatPayFromBATAPI];
    } else if (self.payView.selectIndexPath.row == 2) {
        //康美支付
        
        if (![KMTPayApi isKMTPayInstalled]) {
            [self.payView hide];
        }
        
        [self requestKMPayFromBATAPI];
    }
}

#pragma mark - Net

#pragma mark - 获取功能可用配置
- (void)requestGetModuleSetting
{
    
    [self showProgress];
    
    [HTTPTool requestWithOTCURLString:@"/api/account/GetModuleSetting" parameters:nil type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        self.moduleSettingModel = [BATOTCOrderModuleSettingModel mj_objectWithKeyValues:responseObject];
        
        //测试用
//        self.moduleSettingModel.Data.IsCanBuy = YES;
//        self.moduleSettingModel.Data.IsPickUpInStore = YES;
//        self.moduleSettingModel.Data.IsHomeDelivery = YES;
        
        if (!self.moduleSettingModel.Data.IsCanBuy) {
            self.submitOrderView.footView.hidden = YES;
        } else {
            self.submitOrderView.footView.hidden = NO;
        }
        
        [self.submitOrderView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 提交订单
- (void)requestSubmitOrder
{
    
    if (!_isPickUp && !_isDelivery) {
        [self showText:@"请选择收货方式"];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    
    [self showProgressWithText:@"正在提交订单..."];
    //发送通知刷新处方单列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BAT_RefreshRecipeList_Noti" object:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_orderType) forKey:@"OrderType"];
    [param setObject:[NSString stringWithFormat:@"%.2f",_totalPrice] forKey:@"OrderMoney"];
    [param setObject:[NSString stringWithFormat:@"%.2f",_freight] forKey:@"Freight"];
    [param setObject:@(_receiveMethod) forKey:@"ReceiveMethod"];
    
    if (_receiveMethod == BATReceiveMethod_Delivery) {
        [param setObject:_addressData.Name forKey:@"Receiver"];
        [param setObject:_addressData.Phone forKey:@"ReceiverMobile"];
        [param setObject:[NSString stringWithFormat:@"%@%@%@",[_addressData.NamePath stringByReplacingOccurrencesOfString:@"^" withString:@""], _addressData.Address, _addressData.DoorNo] forKey:@"ReceiverAddress"];
    } else {
        [param setObject:_drugStoreData.ID forKey:@"DrugStoreID"];
    }
    
    NSMutableArray *productList = [NSMutableArray array];
    
    for (OTCSearchData *data in self.dataArry) {
        
        [productList addObject:@{
                                 @"ProductID":data.ID,
                                 @"ProductName":data.DrugName,
                                 @"ProductNum":@(data.drugCount),
                                 @"ProductImage":data.PictureUrl,
                                 @"ProductPrice":data.Price,
                                 @"Specification":data.Specification,
                                 @"ManufactorName":data.ManufactorName,
                                 }];
        
    }
    
    [param setObject:productList forKey:@"ProductList"];
    
    if (self.Symptom.length > 0) {
        
        [param setObject:self.Symptom forKey:@"Symptom"];
    }
    
    if (self.RecipeFileUrl.length > 0) {
        [param setObject:self.RecipeFileUrl forKey:@"RecipeFileUrl"];
    }
    
    if (self.RecipeID.length > 0) {
        [param setObject:self.RecipeID forKey:@"RecipeID"];
    }
    
    [HTTPTool requestWithOTCURLString:@"/api/order/commit" parameters:param type:kPOST success:^(id responseObject) {
        
        self.view.userInteractionEnabled = YES;
        [self showText:@"提交订单成功！"];
        
        //清空购物车
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
        [NSKeyedArchiver archiveRootObject:[NSMutableArray array] toFile:file];
        
        _orderNo = [responseObject objectForKey:@"Data"];
        
        [self.payView show];
        
    } failure:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self showText:error.localizedDescription];
    }];
}

- (void)requestGetFreight
{
    [HTTPTool requestWithOTCURLString:@"/api/order/freight" parameters:nil type:kGET success:^(id responseObject) {

        _freight = [[responseObject objectForKey:@"Data"] doubleValue];
        
        [self calcTotalPrice];
        
        [self.submitOrderView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 微信支付

- (void)requestWeChatPayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithOTCURLString:[NSString stringWithFormat:@"/api/pay/WxPay?orderNo=%@&payFee=%.2f&trade_type=APP",_orderNo,_totalPrice] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_WeChat orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccess:BATDoctorStudioPayType_WXPay];
            }
        }];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
}


#pragma mark - 支付宝支付

- (void)requestAlipayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithOTCURLString:[NSString stringWithFormat:@"/api/pay/AliPay?orderNo=%@&payFee=%.2f",_orderNo,_totalPrice] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [self dismissProgress];
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_Alipay orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccess:BATDoctorStudioPayType_ALiPay];
            }
        }];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 康美支付
- (void)requestKMPayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    
    [HTTPTool requestWithOTCURLString:[NSString stringWithFormat:@"/api/pay/KmPay?orderNo=%@&payFee=%.2f&returnUrl=https://www.kmpay518.com/",_orderNo,_totalPrice] parameters:nil type:kGET success:^(id responseObject) {
        STRONG_SELF(self);
        [self dismissProgress];
        
        [[BATPayManager shareManager] pay:responseObject payType:BATPayType_KMPay orderNo:_orderNo complete:^(BOOL isSuccess) {
            DDLogWarn(@"支付验证回调");
            [self dismissProgress];
            if (isSuccess) {
                //支付成功
                [self paySuccess:BATDoctorStudioPayType_KMPay];
            }
        }];
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.submitOrderView];
    
    WEAK_SELF(self);
    [self.submitOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.payView];
}

#pragma mark - get & set
- (BATSubmitOrderView *)submitOrderView
{
    if (_submitOrderView == nil) {
        _submitOrderView = [[BATSubmitOrderView alloc] init];
        _submitOrderView.tableView.delegate = self;
        _submitOrderView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        [_submitOrderView.submitButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self requestSubmitOrder];
        }];
    }
    return _submitOrderView;
}

- (BATOTCPayView *)payView
{
    if (_payView == nil) {
        _payView = [[BATOTCPayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        WEAK_SELF(self);
        [_payView.confirmPayBtn bk_whenTapped:^{
            STRONG_SELF(self);
            [self confirmPayBtnAction];
        }];
        
        _payView.controlBlock = ^{
            STRONG_SELF(self);
            BATOTCOrderDetailViewController *orderDetailVC = [[BATOTCOrderDetailViewController alloc] init];
            orderDetailVC.orderNo = self.orderNo;
            orderDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        };
        
    }
    return _payView;
}

#pragma mark - 获得货品id集合
- (NSMutableArray *)products
{
    if (_products == nil) {
        _products = [NSMutableArray array];
        for (OTCSearchData *data in self.dataArry) {
            [_products addObject:@{@"ProductID":data.ID,@"ProductNum":@(data.drugCount)}];
        }
    }
    return _products;
}

@end
