//
//  BATOTCMainViewController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCMainViewController.h"
#import "BATOTCDrugCellTableViewCell.h"
#import "BATOTCDrugModel.h"
#import "BATShoppingTrolleyView.h"
#import "BATOTCSelectTypeCell.h"
#import "BATSearchFiledCell.h"
#import "BATSubmitOrderViewController.h"
#import "MedicallyExaminedViewController.h"
#import "BATOTCDrugSearchViewController.h"
#import "BATOTCProductView.h"
#import "BATMedicineWebViewController.h"
#import "BATFibonacciResultViewController.h"

@interface BATOTCMainViewController ()<UITableViewDelegate,UITableViewDataSource,BATOTCDrugCellTableViewCellDelegate,BATShoppingTrolleyViewDelegate,BATOTCSelectTypeCellDelegate,BATSearchFiledCellDelegate,BATOTCProductViewDelegate>

@property (nonatomic,strong) UITableView *resultTab;

@property (nonatomic,strong) BATOTCDrugModel *model;

@property (nonatomic,strong) BATShoppingTrolleyView *shoppingView;

@property(nonatomic,strong) NSString *tags;

@property (nonatomic,assign) CGFloat totalPrice;

@property (nonatomic,assign) NSInteger totalCount;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray *dataArry;

@property (nonatomic,strong) BATOTCProductView *shoppingCar;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) NSInteger height;

@property (nonatomic,strong) UIView *blackBackView;

@property (nonatomic,strong) UIView *topBlackView;

@end

@implementation BATOTCMainViewController

- (void)dealloc {
      [self.topBlackView removeFromSuperview];
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:[NSMutableArray array] toFile:file];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.totalCount = 0;
    self.totalPrice = 0.0;
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    for (OTCSearchData *tempData in self.dataArry) {
        for (OTCSearchData *unData in data) {
            if ([tempData.ID isEqualToString:unData.ID]) {
                tempData.drugCount = unData.drugCount;
            }
        }
    }
    
    for (OTCSearchData *emunData in self.dataArry) {
        bool isTheSame = NO;
        for (OTCSearchData *equalData in data) {
            if ([emunData.ID isEqualToString:equalData.ID]) {
                isTheSame = YES;
                break;
            }
        }
        if (!isTheSame) {
            emunData.drugCount = 0;
        }
    }
    
        for (OTCSearchData *searchData in data) {
            if (searchData.drugCount >0) {
                if (searchData.isSelect) {
                    self.totalCount += searchData.drugCount;
                    self.totalPrice += searchData.drugCount * [searchData.Price floatValue];
                }
               
            }
        }
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
        
    self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
   
    [self.resultTab reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF(self);
    self.title = @"非处方药";
    self.dataArry =  [NSMutableArray array];
    [self.view addSubview:self.resultTab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);

    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
        if (data == nil) {
            data = [NSMutableArray array];
        }
        if (data.count != 0) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已添加的药品未结算，退出后将会被清空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction * goOnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
                [NSKeyedArchiver archiveRootObject:[NSMutableArray array] toFile:file];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            [alert addAction:okAction];
            [alert addAction:goOnAction];
            
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        STRONG_SELF(self);
//    }];
    
    self.topBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    self.topBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.topBlackView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.topBlackView];
    
    self.blackBackView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.blackBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.blackBackView.hidden = YES;
    self.blackBackView.userInteractionEnabled = YES;
    [self.blackBackView bk_whenTapped:^{
        STRONG_SELF(self);
        [self BATShoppingTrolleyViewShoppingCarAction];
    }];
    [self.view addSubview:self.blackBackView];
    
    [self.view addSubview:self.shoppingCar];
    
    self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"BATShoppingTrolleyView" owner:self options:nil] lastObject];
    self.shoppingView.delegate = self;
    [self.view addSubview:self.shoppingView];
    [self.shoppingView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self getOTCDrugListRequest];
}

- (void)getOTCDrugListRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [dict setValue:@"" forKey:@"condition"];
    [dict setValue:@"true" forKey:@"isOtc"];
    
    [HTTPTool requestWithOTCURLString:@"/api/OtcConsult/QueryRecipeDrug" parameters:dict type:kGET success:^(id responseObject) {
        
        
        [self.resultTab.mj_header endRefreshing];
        [self.resultTab.mj_footer endRefreshing];
        
        self.model = [BATOTCDrugModel mj_objectWithKeyValues:responseObject];
        
        if (self.currentPage == 0) {
            [self.dataArry removeAllObjects];
        }
        [self.dataArry addObjectsFromArray:self.model.Data];
        
        if (self.dataArry.count == self.model.RecordsCount) {
            _resultTab.mj_footer.hidden = YES;
        }else {
            
            _resultTab.mj_footer.hidden = NO;
        }
        
        [self.resultTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 90;
    }else {
        
        if (indexPath.row == 0) {
            return 51;
        }else {
            
            return 83;
        }
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else {
        
        return self.dataArry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        BATOTCDrugCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCDrugCellTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.rowPath = indexPath;
        cell.delegate = self;
        if (self.dataArry.count>0) {
            cell.drugModel = self.dataArry[indexPath.row];
        }
        return cell;
    }else {
        
        if (indexPath.row == 0) {
            BATSearchFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSearchFiledCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.delegate = self;
            return cell;
        }
        BATOTCSelectTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCSelectTypeCell"];
        typeCell.delegate = self;
        [typeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return typeCell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 10;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
        backView.backgroundColor = UIColorFromRGB(245, 245, 245, 1);
        
        return backView;
    }
    
    return nil;
    
}

#pragma mark - BATOTCDrugCellTableViewCellDelegate
//增加
- (void)BATOTCDrugCellTableViewCellDelegateWithAddActionRowPaht:(NSIndexPath *)rowPath cell:(BATOTCDrugCellTableViewCell *)cell {
    
    OTCSearchData *SearchData = self.dataArry[rowPath.row];
    SearchData.drugCount += 1;
    SearchData.isSelect = YES;

    self.totalCount = 0;
    self.totalPrice = 0.0;
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    if (data == nil) {
        data = [NSMutableArray array];
    }
    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if (data.drugCount >0) {
            [tempData addObject:data];
        }
    }
    for (int i=0; i<tempData.count; i++) {
        OTCSearchData *mainData = tempData[i];
        BOOL isTheSame = NO;
        for (int j=0; j<data.count; j++) {
            OTCSearchData *changeData = data[j];
            if ([mainData.ID isEqualToString:changeData.ID]) {
                changeData.drugCount = mainData.drugCount;
                isTheSame = YES;
                break;
            }
            
        }
        if (!isTheSame) {
            [data addObject:mainData];
        }
    }
    
    for (OTCSearchData *checkData in data) {
        if ([checkData.ID isEqualToString:SearchData.ID]) {
            checkData.drugCount = SearchData.drugCount;
            checkData.isSelect = YES;
        }
    }
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:data toFile:file];
    
    for (OTCSearchData *mainData in data) {
        if (mainData.isSelect) {
            self.totalCount += mainData.drugCount;
            if (mainData.drugCount >0) {
                self.totalPrice += mainData.drugCount * [mainData.Price floatValue];
            }
        }
    }
    
    if(self.totalCount <=0){
        
        self.totalCount = 0;
        [self.shoppingView.countBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.shoppingView.priceLb.text = @"¥0.00";
    }else {
        self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
    }
    [self.resultTab reloadRowsAtIndexPaths:@[rowPath] withRowAnimation:UITableViewRowAnimationNone];
}
//减少
-(void)BATOTCDrugCellTableViewCellDelegateWithReduceActionRowPaht:(NSIndexPath *)rowPath cell:(BATOTCDrugCellTableViewCell *)cell {

    OTCSearchData *SearchData = self.dataArry[rowPath.row];
    SearchData.drugCount -=1;
    if(SearchData.drugCount <=0){
        SearchData.drugCount = 0;
        SearchData.isSelect = NO;
    }

    self.totalCount = 0;
    self.totalPrice = 0.0;
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if (data.drugCount >0) {
            data.isSelect = YES;
            [tempData addObject:data];
        }
    }
    for (int i=0; i<tempData.count; i++) {
        OTCSearchData *mainData = tempData[i];
        BOOL isTheSame = NO;
        for (int j=0; j<data.count; j++) {
            OTCSearchData *changeData = data[j];
            if ([mainData.ID isEqualToString:changeData.ID]) {
                mainData.isSelect = YES;
                 changeData.drugCount = mainData.drugCount;
                isTheSame = YES;
                break;
            }
            
        }
        if (!isTheSame) {
            [data addObject:mainData];
        }
    }
    
    for (OTCSearchData *checkData in data) {
        if ([checkData.ID isEqualToString:SearchData.ID]) {
            checkData.drugCount = SearchData.drugCount;
        }
    }
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        OTCSearchData *tempSearchData = obj;
        if (tempSearchData.drugCount == 0) {
            [data removeObjectAtIndex:idx];
        }
    }];
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:data toFile:file];
    
    
    for (OTCSearchData *mainData in data) {
        if (mainData.isSelect) {
            self.totalCount += mainData.drugCount;
            if (mainData.drugCount >0) {
                self.totalPrice += mainData.drugCount * [mainData.Price floatValue];
            }
        }
    }
    
    if(self.totalCount <=0){
        
        self.totalCount = 0;
        [self.shoppingView.countBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.shoppingView.priceLb.text = @"¥0.00";
    }else {
        self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
    }
    [self.resultTab reloadRowsAtIndexPaths:@[rowPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - BATShoppingTrolleyViewDelegate
-(void)BATShoppingTrolleyViewCountAcion {
    
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
//    NSMutableArray *tempData = [NSMutableArray array];
//    for (OTCSearchData *data in self.dataArry) {
//        if (data.drugCount >0) {
//            data.isSelect = YES;
//            [tempData addObject:data];
//        }
//    }
//    for (int i=0; i<tempData.count; i++) {
//        OTCSearchData *mainData = tempData[i];
//        BOOL isTheSame = NO;
//        for (int j=0; j<data.count; j++) {
//            OTCSearchData *changeData = data[j];
//            if ([mainData.ID isEqualToString:changeData.ID]) {
//                 changeData.drugCount = mainData.drugCount;
//                isTheSame = YES;
//                break;
//            }
//            
//        }
//        if (!isTheSame) {
//            [data addObject:mainData];
//        }
//    }
//    
//    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
//    [NSKeyedArchiver archiveRootObject:data toFile:file];
    
    
    if (data.count == 0) {
        [self showText:@"没有添加商品"];
        return;
    }
    
    BOOL isPush = NO;
    for (OTCSearchData *selectData in data) {
        if (selectData.isSelect) {
            isPush = YES;
            break;
        }
    }
    if (!isPush) {
        [self showText:@"没有选中商品"];
        return;
    }
    
    
    if (self.isOpen) {
        self.topBlackView.hidden = YES;
        self.blackBackView.hidden = YES;
        [self BATShoppingTrolleyViewShoppingCarAction];
    }
    
     BATSubmitOrderViewController *subminVC = [[BATSubmitOrderViewController alloc]init];
    
    NSMutableArray *contData = [NSMutableArray array];
    for (OTCSearchData *tempCountData in data) {
        if (tempCountData.isSelect) {
            [contData addObject:tempCountData];
        }
    }
    subminVC.dataArry = contData;
    subminVC.orderType = BATOTCOrderType_NonPrescriptionDrugs;
    [self.navigationController pushViewController:subminVC animated:YES];
    
}

-(void)BATShoppingTrolleyViewShoppingCarAction {
 
    if (!self.isOpen) {
        
        NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];

        
        NSMutableArray *tempData = [NSMutableArray array];
        for (OTCSearchData *data in self.dataArry) {
            if (data.drugCount >0) {
                [tempData addObject:data];
            }
        }
        for (int i=0; i<tempData.count; i++) {
            OTCSearchData *mainData = tempData[i];
            BOOL isTheSame = NO;
            for (int j=0; j<data.count; j++) {
                OTCSearchData *changeData = data[j];
                if ([mainData.ID isEqualToString:changeData.ID]) {
                    changeData.drugCount = mainData.drugCount;
                    isTheSame = YES;
                    break;
                }
                
            }
            if (!isTheSame) {
                [data addObject:mainData];
            }
        }
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            OTCSearchData *removeData = obj;
            if (removeData.drugCount == 0) {
                [data removeObject:removeData];
            }
        }];
        
        
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
        [NSKeyedArchiver archiveRootObject:data toFile:file];
    
        
        
        
        
        self.shoppingCar.shoppingData = data;
        
        if (data.count>4) {
            self.height = 4*90 +34;
        }else {
        self.height = data.count * 90 + 34;
        }
        self.blackBackView.hidden = NO;
        self.topBlackView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.shoppingCar.frame = CGRectMake(0, SCREEN_HEIGHT- 50 -self.height-64, SCREEN_WIDTH, self.height);
        }];
        self.isOpen = !self.isOpen;
    }else {
        self.blackBackView.hidden = YES;
        self.topBlackView.hidden = YES;
    [self.resultTab reloadData];
        
        NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
        
        for (OTCSearchData *modelData in self.dataArry) {
            for (OTCSearchData *mainData in data) {
                if ([modelData.ID isEqualToString:mainData.ID]) {
                    modelData.drugCount = mainData.drugCount;
                    if (mainData.drugCount == 0) {
                        modelData.isSelect = NO;
                    }
                }
            }
        }
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            OTCSearchData *searchData = obj;
            
                if (searchData.drugCount == 0) {
                    [data removeObject:searchData];
                }
            
            
        }];
        
        
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
        [NSKeyedArchiver archiveRootObject:data toFile:file];
        
       
        
      
        [self.resultTab reloadData];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.shoppingCar.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, self.height);
        }];
        self.isOpen = !self.isOpen;
    }
    
}

#pragma mark - BATOTCSelectTypeCellDelegate
- (void)BATOTCSelectTypeCellDelegateLeftClickAction {

    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if (data.drugCount >0) {
            [tempData addObject:data];
        }
    }

    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    NSMutableArray *data3 = [NSMutableArray array];
    for (OTCSearchData *data0 in data) {
        BOOL isTheSame = NO;
        for (OTCSearchData *data1 in tempData) {
            if ([data0.ID isEqualToString:data1.ID]) {
                isTheSame = YES;
                break;
            }
        }
        if (!isTheSame) {
            [data3 addObject:data0];
        }
    }
    [tempData addObjectsFromArray:data3];
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:tempData toFile:file];

    MedicallyExaminedViewController *medicallyVC = [[MedicallyExaminedViewController alloc]init];
    [self.navigationController pushViewController:medicallyVC animated:YES];
}

- (void)BATOTCSelectTypeCellDelegateRightClickAction {
    
    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if (data.drugCount >0) {
            [tempData addObject:data];
        }
    }
    
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    NSMutableArray *data3 = [NSMutableArray array];
    for (OTCSearchData *data0 in data) {
        BOOL isTheSame = NO;
        for (OTCSearchData *data1 in tempData) {
            if ([data0.ID isEqualToString:data1.ID]) {
                isTheSame = YES;
                break;
            }
        }
        if (!isTheSame) {
            [data3 addObject:data0];
        }
    }
    [tempData addObjectsFromArray:data3];
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:tempData toFile:file];
    
    BATMedicineWebViewController *medicineVC = [[BATMedicineWebViewController alloc]init];
    [self.navigationController pushViewController:medicineVC animated:YES];
}

#pragma mark - BATSearchFiledCellDelegate
- (void)textfileShouldReturnWithText:(NSString *)content textField:(UITextField *)searchField{
    

    if (content.length >0 && [[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0) {
        
        NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
        
        NSMutableArray *tempData = [NSMutableArray array];
        for (OTCSearchData *data in self.dataArry) {
            if (data.drugCount >0) {
                data.isSelect = YES;
                [tempData addObject:data];
            }
        }
        for (int i=0; i<tempData.count; i++) {
            OTCSearchData *mainData = tempData[i];
            BOOL isTheSame = NO;
            for (int j=0; j<data.count; j++) {
                OTCSearchData *changeData = data[j];
                if ([mainData.ID isEqualToString:changeData.ID]) {
                     changeData.drugCount = mainData.drugCount;
                    isTheSame = YES;
                    break;
                }
                
            }
            if (!isTheSame) {
                [data addObject:mainData];
            }
        }
        
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
        [NSKeyedArchiver archiveRootObject:data toFile:file];
        
        searchField.text = @"";
        
        BATOTCDrugSearchViewController *searchVC = [[BATOTCDrugSearchViewController alloc]init];
        searchVC.searchTitle = content;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    
}

#pragma mark - BATOTCProductViewDelegate
- (void)BATOTCProductViewDelegateWithModel:(OTCSearchData *)model {
    
    self.totalCount = 0;
    self.totalPrice = 0.0;
    
    
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if ([data.ID isEqualToString:model.ID]) {
            data.isSelect = model.isSelect;
        }
        if (data.drugCount >0) {
            [tempData addObject:data];
        }
    }
    for (int i=0; i<tempData.count; i++) {
        OTCSearchData *mainData = tempData[i];
        BOOL isTheSame = NO;
        for (int j=0; j<data.count; j++) {
            OTCSearchData *changeData = data[j];
            if ([mainData.ID isEqualToString:changeData.ID]) {
                changeData.drugCount = mainData.drugCount;
                isTheSame = YES;
                break;
            }
            
        }
        if (!isTheSame) {
            [data addObject:mainData];
        }
    }
    
    for (OTCSearchData *tempData in data) {
        if ([tempData.ID isEqualToString:model.ID]) {
            tempData.isSelect = model.isSelect;
        }
    }
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:data toFile:file];
    
    for (OTCSearchData *data1 in data) {
        if (data1.isSelect) {
            self.totalCount += data1.drugCount;
            if (data1.drugCount >0) {
                self.totalPrice += data1.drugCount * [data1.Price floatValue];
            }
        }
    }
    
    if(self.totalCount <=0){
        
        self.totalCount = 0;
        [self.shoppingView.countBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.shoppingView.priceLb.text = @"¥0.00";
    }else {
        self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
    }
    
}

- (void)BATOTCProductViewAddActionDelegateWithModel:(OTCSearchData *)model {
    
    self.totalCount = 0;
    self.totalPrice = 0.0;
    
    
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if (data.drugCount >0) {
            [tempData addObject:data];
        }
    }
    for (int i=0; i<tempData.count; i++) {
        OTCSearchData *mainData = tempData[i];
        BOOL isTheSame = NO;
        for (int j=0; j<data.count; j++) {
            OTCSearchData *changeData = data[j];
            if ([mainData.ID isEqualToString:changeData.ID]) {
                changeData.drugCount = mainData.drugCount;
                isTheSame = YES;
                break;
            }
            
        }
        if (!isTheSame) {
            [data addObject:mainData];
        }
    }
    
    for (OTCSearchData *checkData in data) {
        if ([checkData.ID isEqualToString:model.ID]) {
            checkData.drugCount = model.drugCount;
        }
    }
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:data toFile:file];
    
    for (OTCSearchData *checkData in self.model.Data) {
        if ([checkData.ID isEqualToString:model.ID]) {
            checkData.drugCount = model.drugCount;
        }
    }
    
    
    for (OTCSearchData *mainData in data) {
        if (mainData.isSelect) {
            self.totalCount += mainData.drugCount;
            if (mainData.drugCount >0) {
                self.totalPrice += mainData.drugCount * [mainData.Price floatValue];
            }
        }
    }
    
    if(self.totalCount <=0){
        
        self.totalCount = 0;
        [self.shoppingView.countBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.shoppingView.priceLb.text = @"¥0.00";
    }else {
        self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
    }
    [self.resultTab reloadData];
}

- (void)BATOTCProductViewReduceActionDelegateWithModel:(OTCSearchData *)model {
    

    
    self.totalCount = 0;
    self.totalPrice = 0.0;
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
    NSMutableArray *tempData = [NSMutableArray array];
    for (OTCSearchData *data in self.dataArry) {
        if (data.drugCount >0) {
            [tempData addObject:data];
        }
    }
    for (int i=0; i<tempData.count; i++) {
        OTCSearchData *mainData = tempData[i];
        BOOL isTheSame = NO;
        for (int j=0; j<data.count; j++) {
            OTCSearchData *changeData = data[j];
            if ([mainData.ID isEqualToString:changeData.ID]) {
                changeData.drugCount = mainData.drugCount;
                isTheSame = YES;
                break;
            }
            
        }
        if (!isTheSame) {
            [data addObject:mainData];
        }
    }
    
    for (OTCSearchData *checkData in data) {
        if ([checkData.ID isEqualToString:model.ID]) {
            checkData.drugCount = model.drugCount;
            if (model.drugCount == 0) {
                checkData.isSelect = NO;
            }
        }
    }
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        OTCSearchData *tempdata = obj;
        if (tempdata.drugCount == 0) {
            [data removeObjectAtIndex:idx];
        }
    }];
    
    if (data.count>4) {
        self.height = 4*90 +34;
    }else {
        self.height = data.count * 90 + 34;
    }
    self.shoppingCar.frame = CGRectMake(0, SCREEN_HEIGHT- 50 -self.height-64, SCREEN_WIDTH, self.height);
    if (data.count == 0) {
        
        if (self.isOpen) {
            [self BATShoppingTrolleyViewShoppingCarAction];
        }
    
    }
    
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"];
    [NSKeyedArchiver archiveRootObject:data toFile:file];
    
    for (OTCSearchData *checkData in self.dataArry) {
        if ([checkData.ID isEqualToString:model.ID]) {
            checkData.drugCount = model.drugCount;
        }
    }
    
    
    for (OTCSearchData *mainData in data) {
        if (mainData.isSelect) {
            self.totalCount += mainData.drugCount;
            if (mainData.drugCount >0) {
                self.totalPrice += mainData.drugCount * [mainData.Price floatValue];
            }
        }
    }
    
    if(self.totalCount <=0){
        
        self.totalCount = 0;
        [self.shoppingView.countBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.shoppingView.priceLb.text = @"¥0.00";
    }else {
        self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
    }
    
     [self.resultTab reloadData];
    
}

#pragma mark - Lazy Load

- (BATOTCProductView *)shoppingCar {
    
    if (!_shoppingCar) {
        _shoppingCar = [[BATOTCProductView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _shoppingCar.delegate = self;
    }
    return _shoppingCar;
    
}
- (UITableView *)resultTab {
    
    if (!_resultTab) {
        _resultTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50 - 64) style:UITableViewStylePlain];
        _resultTab.delegate = self;
        _resultTab.dataSource = self;
        [_resultTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_resultTab registerNib:[UINib nibWithNibName:@"BATOTCDrugCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOTCDrugCellTableViewCell"];
        [_resultTab registerNib:[UINib nibWithNibName:@"BATOTCSelectTypeCell" bundle:nil] forCellReuseIdentifier:@"BATOTCSelectTypeCell"];
        [_resultTab registerNib:[UINib nibWithNibName:@"BATSearchFiledCell" bundle:nil] forCellReuseIdentifier:@"BATSearchFiledCell"];
        _resultTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        WEAK_SELF(self);
//        _resultTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            STRONG_SELF(self);
//            self.currentPage = 0;
//            [self getOTCDrugListRequest];
//        }];
        _resultTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self getOTCDrugListRequest];
        }];
        
        _resultTab.mj_footer.hidden = YES;
    }
    
    return _resultTab;
}
@end
