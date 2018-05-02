//
//  BATSelectDrugStoreViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSelectDrugStoreViewController.h"
#import "BATDrugStoreTableViewCell.h"
//工具类
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "UIScrollView+EmptyDataSet.h"
#import "BATDrugStoreModel.h"

@interface BATSelectDrugStoreViewController () <UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,copy) NSString *keyword;

@property (nonatomic,assign) double lat;

@property (nonatomic,assign) double lon;

@end

@implementation BATSelectDrugStoreViewController

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
    
    self.title = @"选择附近药店";
    
    [self.selectDrugStoreView.tableView registerNib:[UINib nibWithNibName:@"BATDrugStoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATDrugStoreTableViewCell"];
    
    //定位成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationInfo:) name:@"LOCATION_INFO" object:nil];
    //定位失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationFailure) name:@"LOCATION_FAILURE" object:nil];
    

    _pageSize = 10;
    _keyword = @"";
    _dataSource = [NSMutableArray array];
    
//    [self.selectDrugStoreView.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //发送定位的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.selectDrugStore) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    sectionView.backgroundColor = UIColorFromHEX(0xE4D268, 1);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = STRING_MID_COLOR;
    titleLabel.text = [NSString stringWithFormat:@"已选药店：%@",self.selectDrugStore];
    
    [sectionView addSubview:titleLabel];
    
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATDrugStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDrugStoreTableViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        
        BATDrugStoreData *data = [_dataSource objectAtIndex:indexPath.row];
        
        [cell.drugStoreImageView sd_setImageWithURL:[NSURL URLWithString:data.Pic] placeholderImage:[UIImage imageNamed:@"默认图"]];
        cell.nameLabel.text = data.StoreName;
        cell.addressLabel.text = [NSString stringWithFormat:@"地址：%@",data.Address];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@m",data.Distance];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataSource.count > 0) {
        
        BATDrugStoreData *data = [_dataSource objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:BATOTCSelectDrugStoreNotification object:data];
        [self.navigationController popViewControllerAnimated:YES];

    }
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无可取货药店";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20.0f], NSForegroundColorAttributeName: UIColorFromHEX(0x999999, 1)};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _keyword = textField.text;
    
    [textField resignFirstResponder];
    
    [self.selectDrugStoreView.tableView.mj_header beginRefreshing];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _keyword = @"";
    return YES;
}

#pragma mark - Net
#pragma mark - 获取附近药店
- (void)requestGetNearbyStores
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    _lat = [[userDefaults objectForKey:@"latitude"] stringValue];
//    _lon = [[userDefaults objectForKey:@"longitude"] stringValue];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageIndex) forKey:@"pageIndex"];
    [param setObject:@(_pageSize) forKey:@"pageSize"];
    [param setObject:_products forKey:@"ProductList"];
    [param setObject:@(_lat) forKey:@"Lat"];
    [param setObject:@(_lon) forKey:@"Lon"];
    [param setObject:_keyword forKey:@"StoreName"];
    
    
    [HTTPTool requestWithOTCURLString:@"/api/Drug/GetNearbyStores" parameters:param type:kPOST success:^(id responseObject) {
        
        [self.selectDrugStoreView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            [self.selectDrugStoreView.tableView reloadData];
        }];
        [self.selectDrugStoreView.tableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATDrugStoreModel *drugStoreModel = [BATDrugStoreModel mj_objectWithKeyValues:responseObject];

        [_dataSource addObjectsFromArray:drugStoreModel.Data];

        if (drugStoreModel.RecordsCount > 0) {
            self.selectDrugStoreView.tableView.mj_footer.hidden = NO;
        } else {
            self.selectDrugStoreView.tableView.mj_footer.hidden = YES;
        }

        if (_dataSource.count == drugStoreModel.RecordsCount) {
            //            [self.batCourseSearchView.tableView.mj_footer endRefreshingWithNoMoreData];
            self.selectDrugStoreView.tableView.mj_footer.hidden = YES;
        }
        
        [self.selectDrugStoreView.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self showText:error.localizedDescription];
        
        [self.selectDrugStoreView.tableView.mj_header endRefreshingWithCompletionBlock:^{
            [self.selectDrugStoreView.tableView reloadData];
        }];
        [self.selectDrugStoreView.tableView.mj_footer endRefreshing];
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
    }];
}

#pragma mark - Action

#pragma mark - Location
//定位失败
- (void)handleLocationFailure
{
    //提示开启定位
    [Tools showSettingWithTitle:@"定位服务已经关闭" message:@"请到设置->隐私->定位服务中开启健康BAT的定位服务，方便我们能准确获取您的地理位置" failure:^{

    }];

}

//定位成功
- (void)handleLocationInfo:(NSNotification *)locationNotification
{
    BMKReverseGeoCodeResult *result = locationNotification.userInfo[@"location"];
    
    if (_lon > 0 && _lat > 0) {
        return;
    }
    
    _lat = result.location.latitude;
    _lon = result.location.longitude;

    [self.selectDrugStoreView.tableView.mj_header beginRefreshing];

}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.selectDrugStoreView];
    
    WEAK_SELF(self);
    [self.selectDrugStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATSelectDrugStoreView *)selectDrugStoreView
{
    if (_selectDrugStoreView == nil) {
        _selectDrugStoreView = [[BATSelectDrugStoreView alloc] init];
        _selectDrugStoreView.tableView.delegate = self;
        _selectDrugStoreView.tableView.dataSource = self;
        _selectDrugStoreView.tableView.emptyDataSetSource = self;
        _selectDrugStoreView.tableView.emptyDataSetDelegate = self;
        _selectDrugStoreView.searchTF.delegate = self;
        
        WEAK_SELF(self);
        _selectDrugStoreView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.selectDrugStoreView.tableView.mj_footer resetNoMoreData];
            [self requestGetNearbyStores];
        }];
        
        _selectDrugStoreView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetNearbyStores];
        }];
    }
    return _selectDrugStoreView;
}

@end
