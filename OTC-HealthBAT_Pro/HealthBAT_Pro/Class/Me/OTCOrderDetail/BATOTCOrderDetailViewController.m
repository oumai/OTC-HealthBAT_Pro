//
//  BATOTCOrderDetailViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCOrderDetailViewController.h"
#import "BATOrderStatusCell.h"
#import "BATOrderStatusSubTitleCell.h"
#import "BATOrderDetailContactInfoCell.h"
#import "BATOrderDrugStoreInfoTableViewCell.h"
#import "BATOTCOrderGoodsTableViewCell.h"
#import "BATOrderFreightTableViewCell.h"
#import "BATOrderDetailTotalPriceTableViewCell.h"
#import "BATOrderDetailInfoTableViewCell.h"
#import "BATOrderPayTableViewCell.h"
#import "BATOrderConfrimReveiceTableViewCell.h"
#import "BATOTCOrderDetailModel.h"
#import "BATOTCPayView.h"
#import "BATPayManager.h"
#import "BATSubmitOrderViewController.h"
#import "BATQRCodeManager.h"
#import "MF_Base64Additions.h"
#import "BATHomeMallNewViewController.h"

@interface BATOTCOrderDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATOTCOrderDetailModel *orderDetailModel;

/**
 支付方式view
 */
@property (nonatomic,strong) BATOTCPayView *payView;

@end

@implementation BATOTCOrderDetailViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    [self configationBackVC];
    
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderStatusCell" bundle:nil] forCellReuseIdentifier:@"BATOrderStatusCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderStatusSubTitleCell" bundle:nil] forCellReuseIdentifier:@"BATOrderStatusSubTitleCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderDetailContactInfoCell" bundle:nil] forCellReuseIdentifier:@"BATOrderDetailContactInfoCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderDrugStoreInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOrderDrugStoreInfoTableViewCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOTCOrderGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOTCOrderGoodsTableViewCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderFreightTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOrderFreightTableViewCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderDetailTotalPriceTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOrderDetailTotalPriceTableViewCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOrderDetailInfoTableViewCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderPayTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOrderPayTableViewCell"];
    [self.orderDetailView.tableView registerNib:[UINib nibWithNibName:@"BATOrderConfrimReveiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOrderConfrimReveiceTableViewCell"];
    
    [self.orderDetailView.tableView.mj_header beginRefreshing];
    
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
    if (_orderDetailModel.Data) {
        return 5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_orderDetailModel) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return 1;
        } else if (section == 2) {
            return _orderDetailModel.Data.ProductList.count;
        } else if (section == 3) {
            
            if (_orderDetailModel.Data.ReceiveMethod == BATReceiveMethod_PickUp) {
                return 1;
            }
            
            return 2;
        }
        
        if (_orderDetailModel.Data.OrderStatus == 1) {
            //1待付款，2待发货，3待收货，4待取药，5已完成、6已取消
            return 3;
        } else if (_orderDetailModel.Data.OrderStatus == 3) {
            return 5;
        } else if (_orderDetailModel.Data.OrderStatus == 6) {
            return 2;
        } else if (_orderDetailModel.Data.OrderStatus == 5) {
            if (_orderDetailModel.Data.ReceiveMethod == BATReceiveMethod_PickUp) {
                //到店取货
                return 3;
            } else {
                return 4;
            }
        }
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 2) {
        return 88;
    } else if (indexPath.section == 3) {
        return 30;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
    if (_orderDetailModel) {
        if (indexPath.section == 0) {
            //1待付款，2待发货，3待收货，4待取药，5已完成、6已取消
            if (_orderDetailModel.Data.OrderStatus == 1 || _orderDetailModel.Data.OrderStatus == 5 || _orderDetailModel.Data.OrderStatus == 6) {
                BATOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderStatusCell" forIndexPath:indexPath];
                cell.orderStatusImageView.image = [UIImage imageNamed:@"icon-ddmjfk"];
                
                if (_orderDetailModel.Data.OrderStatus == 1) {
                    cell.orderStatusLabel.text = @"等待买家付款";
                } else if (_orderDetailModel.Data.OrderStatus == 5) {
                    cell.orderStatusLabel.text = @"交易成功";
                } else if (_orderDetailModel.Data.OrderStatus == 6) {
                    cell.orderStatusLabel.text = @"交易已取消";
                }
                
                return cell;
            }
            BATOrderStatusSubTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderStatusSubTitleCell" forIndexPath:indexPath];
            cell.qrcodeImageView.image = nil;
            if (_orderDetailModel.Data.OrderStatus == 2) {
                cell.orderStatusImageView.image = [UIImage imageNamed:@"icon-mjyfk"];
                cell.OrderStatusLabel.text = @"买家已付款";
                cell.descLabel.text = @"等待卖家发货";
                
            } else if (_orderDetailModel.Data.OrderStatus == 3) {
                cell.orderStatusImageView.image = [UIImage imageNamed:@"icon-mjydqy"];
                cell.OrderStatusLabel.text = @"卖家已发货";
                cell.descLabel.text = @"等待买家收货";
            } else if (_orderDetailModel.Data.OrderStatus == 4) {
                cell.orderStatusImageView.image = [UIImage imageNamed:@"icon-mjydqy"];
                cell.OrderStatusLabel.text = @"等待买家去药店取药";
                cell.descLabel.text = [NSString stringWithFormat:@"取货码：%@",_orderDetailModel.Data.FetchCode];
                
//                NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
//                NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"]lastObject];
//
//                cell.qrcodeImageView.image = [BATQRCodeManager createQRCode:_orderNo warterImage:[UIImage imageNamed:icon]];
                
                cell.qrcodeImageView.image = _orderDetailModel.Data.qrCodeImage;
                
                [cell.qrcodeImageView bk_whenTapped:^{
                    [SJAvatarBrowser showImage:cell.qrcodeImageView isQRCode:YES];
                }];
                
            }
            
            return cell;
 
        } else if (indexPath.section == 1) {
            
            if (_orderDetailModel.Data.ReceiveMethod == BATReceiveMethod_PickUp) {
                //到店取货
                BATOrderDrugStoreInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderDrugStoreInfoTableViewCell" forIndexPath:indexPath];
                cell.addressLabel.text = [NSString stringWithFormat:@"药房地址：%@",_orderDetailModel.Data.Address];
                return cell;
                
            } else if (_orderDetailModel.Data.ReceiveMethod == BATReceiveMethod_Delivery) {
                //送货上门
                BATOrderDetailContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderDetailContactInfoCell" forIndexPath:indexPath];
                cell.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",_orderDetailModel.Data.Receiver];
                cell.phoneLabel.text = _orderDetailModel.Data.ReceiverMobile;
                cell.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",_orderDetailModel.Data.ReceiverAddress];
                return cell;
            }
            

        } else if (indexPath.section == 2) {
            BATOTCOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCOrderGoodsTableViewCell" forIndexPath:indexPath];
            
            if (_orderDetailModel.Data.ProductList.count > 0) {
                
                BATProductData *data = _orderDetailModel.Data.ProductList[indexPath.row];
                
                [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.ProductImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",data.ProductName,data.Specification];
                cell.countLabel.text = [NSString stringWithFormat:@"x%@",data.ProductNum];
                cell.descLabel.text = data.ManufactorName;
                cell.sellPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.ProductPrice];
                cell.priceLabel.text = @"";
            }
            

            return cell;
        } else if (indexPath.section == 3) {
            
            if (_orderDetailModel.Data.ReceiveMethod == BATReceiveMethod_PickUp) {
                BATOrderDetailTotalPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderDetailTotalPriceTableViewCell" forIndexPath:indexPath];
                cell.totalPriceLabel.text = [NSString stringWithFormat:@"%@元",_orderDetailModel.Data.OrderMoney];
                return cell;
            } else {
                if (indexPath.row == 0) {
                    BATOrderFreightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderFreightTableViewCell" forIndexPath:indexPath];
                    cell.freightLabel.text = [NSString stringWithFormat:@"%@元",_orderDetailModel.Data.Freight];
                    return cell;
                } else if (indexPath.row == 1) {
                    BATOrderDetailTotalPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderDetailTotalPriceTableViewCell" forIndexPath:indexPath];
                    cell.totalPriceLabel.text = [NSString stringWithFormat:@"%@元",_orderDetailModel.Data.OrderMoney];
                    return cell;
                }
            }
        } else if (indexPath.section == 4) {
            
            if (indexPath.row == [tableView numberOfRowsInSection:4] - 1) {
                
                if (_orderDetailModel.Data.OrderStatus == 1) {
                    BATOrderPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderPayTableViewCell" forIndexPath:indexPath];
                    WEAK_SELF(self);
                    [cell.cancelBtn bk_whenTapped:^{
                        STRONG_SELF(self);
                        [self requestCancel];
                    }];
                    
                    [cell.payBtn bk_whenTapped:^{
                        STRONG_SELF(self);
                        [self.payView show];
                    }];
                    
                    return cell;
                } else if (_orderDetailModel.Data.OrderStatus == 3) {
                    BATOrderConfrimReveiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderConfrimReveiceTableViewCell" forIndexPath:indexPath];
                    WEAK_SELF(self);
                    [cell.confrimReveiceBtn bk_whenTapped:^{
                        STRONG_SELF(self);
                        [self requestUpdateOrderStatus];
                    }];
                    
                    return cell;
                }
            }
            
            BATOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderDetailInfoTableViewCell" forIndexPath:indexPath];
            
            if (indexPath.row == 0) {
                cell.infoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetailModel.Data.OrderNo];
            } else if (indexPath.row == 1) {
                if (_orderDetailModel.Data.OrderStatus != 1 && _orderDetailModel.Data.OrderStatus != 6) {
                    cell.infoLabel.text = [NSString stringWithFormat:@"支付编号：%@",_orderDetailModel.Data.TradeNo];
                } else {
                    cell.infoLabel.text = [NSString stringWithFormat:@"创建时间：%@",_orderDetailModel.Data.CreatedTime];
                }
            } else if (indexPath.row == 2) {
                cell.infoLabel.text = [NSString stringWithFormat:@"创建时间：%@",_orderDetailModel.Data.CreatedTime];
            } else if (indexPath.row == 3) {
                cell.infoLabel.text = [NSString stringWithFormat:@"物流单号：%@",_orderDetailModel.Data.TrackingNumber];
            }
            
            return cell;
//        else if (indexPath.section == 4) {
//            if (indexPath.row == 0) {
//                BATOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderDetailInfoTableViewCell" forIndexPath:indexPath];
//                cell.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetailModel.Data.OrderNo];
//
//                if (_orderDetailModel.Data.OrderStatus == 1) {
//                    cell.payNoLabel.text = @"";
//                } else {
//                    cell.payNoLabel.text = [NSString stringWithFormat:@"支付编号：%@",_orderDetailModel.Data.TradeNo];
//                }
//
//                cell.createTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",_orderDetailModel.Data.CreatedTime];
//                return cell;
//            } else if (indexPath.row == [tableView numberOfRowsInSection:4] - 1) {
//
//                if (_orderDetailModel.Data.OrderStatus == 1) {
//                    BATOrderPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderPayTableViewCell" forIndexPath:indexPath];
//                    WEAK_SELF(self);
//                    [cell.cancelBtn bk_whenTapped:^{
//                        STRONG_SELF(self);
//                        [self requestCancel];
//                    }];
//
//                    [cell.payBtn bk_whenTapped:^{
//                        STRONG_SELF(self);
//                        [self.payView show];
//                    }];
//
//                    return cell;
//                } else if (_orderDetailModel.Data.OrderStatus == 3) {
//                    BATOrderConfrimReveiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOrderConfrimReveiceTableViewCell" forIndexPath:indexPath];
//                    WEAK_SELF(self);
//                    [cell.confrimReveiceBtn bk_whenTapped:^{
//                        STRONG_SELF(self);
//                        [self requestUpdateOrderStatus];
//                    }];
//
//                    return cell;
//                }
//            }
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Action
#pragma mark - 支付成功
- (void)paySuccess:(BATDoctorStudioPayType)type
{
    [self.payView hide];
    [self showProgress];
    
    [HTTPTool requestWithOTCURLString:@"/api/Pay/PaySignCheck" parameters:@{@"orderNo":self.orderNo,@"PayMethod":@(type)} type:kGET success:^(id responseObject) {
        
        [self showText:@"支付成功！"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.orderDetailView.tableView.mj_header beginRefreshing];
        });
        
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
    }];
    
    
}

- (void)confirmPayBtnAction
{
    [self.payView hide];
    if (self.payView.selectIndexPath.row == 0) {
        //支付宝支付
        [self requestAlipayFromBATAPI];
        
    } else if (self.payView.selectIndexPath.row == 1) {
        //微信支付
        [self requestWeChatPayFromBATAPI];
    } else if (self.payView.selectIndexPath.row == 2) {
        //康美支付
        [self requestKMPayFromBATAPI];
    }
}

#pragma mark - 调整返回的界面
- (void)configationBackVC
{
    //从电商入口进来的 直接返回到电商页面
    BOOL flag = NO;
    
    NSMutableArray *vcArray = [NSMutableArray array];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        [vcArray addObject:vc];
        
        if ([vc isKindOfClass:[BATHomeMallNewViewController class]]) {
            flag = YES;
            break;
        }
    }
    
    if (flag) {
        [vcArray addObject:self.navigationController.viewControllers.lastObject];
        
        self.navigationController.viewControllers = vcArray;
    } else {
        [vcArray removeAllObjects];
    }
    
}

#pragma mark - Net
#pragma mark - 获取订单详情
- (void)requestGetOrderDetail
{
    [HTTPTool requestWithOTCURLString:@"/api/order/GetOrderDetail" parameters:@{@"orderNo":_orderNo} type:kGET success:^(id responseObject) {
        
        _orderDetailModel = [BATOTCOrderDetailModel mj_objectWithKeyValues:responseObject];
        
        [self.orderDetailView.tableView reloadData];
        
        if (_orderDetailModel.Data.OrderStatus == 4) {
            //获取二维码
            [self requestGetQRCode];
        }

        [self.orderDetailView.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.orderDetailView.tableView.mj_header endRefreshing];
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 获取二维码
- (void)requestGetQRCode
{
    [HTTPTool requestWithOTCURLString:@"/api/Code/GetQRCode" parameters:@{@"code":[NSString stringWithFormat:@"BAT://batotc?code=%@&orderNo=%@",@"1231",_orderNo]} type:kGET success:^(id responseObject) {
        
        
        NSData *data = [[NSData alloc] initWithData:[NSData dataWithBase64String:[responseObject objectForKey:@"Data"]]];
        
        _orderDetailModel.Data.qrCodeImage = [UIImage imageWithData:data];
        
        [self.orderDetailView.tableView reloadData];

    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 取消订单
- (void)requestCancel
{
    [HTTPTool requestWithOTCURLString:@"/api/order/cancle" parameters:@{@"orderNo":_orderNo} type:kGET success:^(id responseObject) {
        [self.orderDetailView.tableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 确认收货
- (void)requestUpdateOrderStatus
{
    [HTTPTool requestWithOTCURLString:@"/api/order/updateOrderStatus" parameters:@{@"orderNo":_orderNo,@"status":@(5)} type:kGET success:^(id responseObject) {
        [self.orderDetailView.tableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        [self showText:error.localizedDescription];
    }];
}

#pragma mark - 微信支付

- (void)requestWeChatPayFromBATAPI
{
    WEAK_SELF(self);
    [self showProgress];
    [HTTPTool requestWithOTCURLString:[NSString stringWithFormat:@"/api/pay/WxPay?orderNo=%@&payFee=%@&trade_type=APP",_orderNo,_orderDetailModel.Data.OrderMoney] parameters:nil type:kGET success:^(id responseObject) {
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
    [HTTPTool requestWithOTCURLString:[NSString stringWithFormat:@"/api/pay/AliPay?orderNo=%@&payFee=%@",_orderNo,_orderDetailModel.Data.OrderMoney] parameters:nil type:kGET success:^(id responseObject) {
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
    
    [HTTPTool requestWithOTCURLString:[NSString stringWithFormat:@"/api/pay/KmPay?orderNo=%@&payFee=%@&returnUrl=https://www.kmpay518.com/",_orderNo,_orderDetailModel.Data.OrderMoney] parameters:nil type:kGET success:^(id responseObject) {
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
    [self.view addSubview:self.orderDetailView];
    
    WEAK_SELF(self);
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.payView];
}

#pragma mark - get & set
- (BATOTCOrderDetailView *)orderDetailView
{
    if (_orderDetailView == nil) {
        _orderDetailView = [[BATOTCOrderDetailView alloc] init];
        _orderDetailView.tableView.delegate = self;
        _orderDetailView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _orderDetailView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self requestGetOrderDetail];
        }];
    }
    return _orderDetailView;
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
        
    }
    return _payView;
}

@end
