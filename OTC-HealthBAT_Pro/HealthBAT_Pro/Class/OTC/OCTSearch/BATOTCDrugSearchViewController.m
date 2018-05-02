//
//  BATOTCDrugSearchViewController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCDrugSearchViewController.h"
#import "BATShoppingTrolleyView.h"
#import "BATOTCDrugCellTableViewCell.h"
#import "BATOTCDrugModel.h"
#import "BATSubmitOrderViewController.h"
#import "BATOTCProductView.h"

@interface BATOTCDrugSearchViewController ()<UITableViewDelegate,UITableViewDataSource,BATShoppingTrolleyViewDelegate,BATOTCDrugCellTableViewCellDelegate,UITextFieldDelegate,BATOTCProductViewDelegate>

@property (nonatomic,strong) UITableView *searchTab;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) BATShoppingTrolleyView *shoppingView;

@property (nonatomic,strong) NSMutableArray *dataArry;

@property (nonatomic,strong) BATOTCDrugModel *model;

@property (nonatomic,assign) CGFloat totalPrice;

@property (nonatomic,assign) NSInteger totalCount;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) NSInteger height;

@property (nonatomic,strong) BATOTCProductView *shoppingCar;

@property (nonatomic,strong) UIView *blackBackView;

@property (nonatomic,strong) UIView *topBlackView;

@property (nonatomic,strong) BATDefaultView             *defaultView;

@end

@implementation BATOTCDrugSearchViewController

- (void)dealloc {
    
      [self.topBlackView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title = @"搜索";
    self.dataArry = [NSMutableArray array];
    [self.view addSubview:self.searchTab];
    
     self.topBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
     self.topBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
     self.topBlackView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.topBlackView];

    UIView *textFiledBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    textFiledBackView.backgroundColor = [UIColor whiteColor];
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = @"搜药名";
    textField.font = [UIFont systemFontOfSize:15];
    [textFiledBackView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(textFiledBackView.mas_centerY);
        make.left.equalTo(textFiledBackView.mas_left).offset(10);
        make.right.equalTo(textFiledBackView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        
    }];
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.frame = CGRectMake(0, 0, 22, 14);
    textField.leftView=image;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    textField.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
    textField.returnKeyType = UIReturnKeySearch;
    textField.text = self.searchTitle;
    [textFiledBackView setBottomBorderWithColor:UIColorFromRGB(246, 246, 246, 1) width:SCREEN_WIDTH height:0];
    [self.view addSubview:textFiledBackView];
    
    self.blackBackView = [[UIView alloc]initWithFrame:CGRectMake(0,-64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.blackBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.blackBackView.hidden = YES;
    self.blackBackView.userInteractionEnabled = YES;
     WEAK_SELF(self);
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
        
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
   
    
    [self getSearchDrugData];
    
    NSMutableArray *maindata =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];

    
    if (maindata.count >0) {
        for (OTCSearchData *data in maindata) {
            if (data.isSelect) {
                if (data.drugCount >0) {
                    self.totalCount += data.drugCount;
                    self.totalPrice += data.drugCount * [data.Price floatValue];
                }
            }
            
        }
        self.shoppingView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice];
        [self.shoppingView.countBtn setTitle:[NSString stringWithFormat:@"结算 (%zd)",self.totalCount] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.top.equalTo(textFiledBackView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getSearchDrugData {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [dict setValue:self.searchTitle forKey:@"condition"];
    [dict setValue:@"true" forKey:@"isOtc"];
    
    [HTTPTool requestWithOTCURLString:@"/api/OtcConsult/QueryRecipeDrug" parameters:dict type:kGET success:^(id responseObject) {
        
        
        [self.searchTab.mj_header endRefreshing];
        [self.searchTab.mj_footer endRefreshing];
        
        self.model = [BATOTCDrugModel mj_objectWithKeyValues:responseObject];
        
        if (self.currentPage == 0) {
            [self.dataArry removeAllObjects];
        }
        
         NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
        for (OTCSearchData *holeData in data) {
            for (OTCSearchData *newData in self.model.Data) {
                if ([newData.ID isEqualToString:holeData.ID]) {
                    newData.drugCount = holeData.drugCount;
                    break;
                }
            }
        }
        
        [self.dataArry addObjectsFromArray:self.model.Data];
        
        if (self.dataArry.count == 0) {
             [self.defaultView showDefaultView];
             self.defaultView.reloadButton.hidden = YES;
        }else {
            self.defaultView.hidden = YES;
        }
        
        if (self.model.RecordsCount == self.dataArry.count) {
            self.searchTab.mj_footer.hidden = YES;
        }else {
            self.searchTab.mj_footer.hidden = NO;
        }
        [self.searchTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        BATOTCDrugCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATOTCDrugCellTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.rowPath = indexPath;
        cell.delegate = self;
        if (self.dataArry.count>0) {
            cell.drugModel = self.dataArry[indexPath.row];
        }
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
    
}

#pragma mark - BATOTCDrugCellTableViewCellDelegate
//增加
- (void)BATOTCDrugCellTableViewCellDelegateWithAddActionRowPaht:(NSIndexPath *)rowPath cell:(BATOTCDrugCellTableViewCell *)cell {
    
    
    self.totalCount = 0;
    self.totalPrice = 0.0;
    
    OTCSearchData *SearchData = self.dataArry[rowPath.row];
    SearchData.drugCount +=1;
    SearchData.isSelect = YES;
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
    
    [self.searchTab reloadData];
}
//减少
-(void)BATOTCDrugCellTableViewCellDelegateWithReduceActionRowPaht:(NSIndexPath *)rowPath cell:(BATOTCDrugCellTableViewCell *)cell {
    
    self.totalCount = 0;
    self.totalPrice = 0.0;
    
    OTCSearchData *searchData = self.dataArry[rowPath.row];
    searchData.drugCount -=1;
    if(searchData.drugCount <=0){
        searchData.drugCount = 0;
        searchData.isSelect = NO;
    }
    
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
        if ([checkData.ID isEqualToString:searchData.ID]) {
            checkData.drugCount = searchData.drugCount;
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
    
    [self.searchTab reloadData];
}

#pragma mark - BATShoppingTrolleyViewDelegate
-(void)BATShoppingTrolleyViewCountAcion {
    
//    NSMutableArray *tempData = [NSMutableArray array];
//    for (OTCSearchData *data in self.dataArry) {
//        if (data.drugCount >0) {
//            [tempData addObject:data];
//        }
//    }
    NSMutableArray *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrugModel.data"]];
    
//    NSMutableArray *data3 = [NSMutableArray array];
//    for (OTCSearchData *data0 in data) {
//        BOOL isTheSame = NO;
//        for (OTCSearchData *data1 in tempData) {
//            if ([data0.ID isEqualToString:data1.ID]) {
//                isTheSame = YES;
//            }
//        }
//        if (!isTheSame) {
//            [data3 addObject:data0];
//        }
//    }
//    [tempData addObjectsFromArray:data3];
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
        
//        for (OTCSearchData *modelData in self.dataArry) {
//            for (OTCSearchData *mainData in data) {
//                if ([modelData.ID isEqualToString:mainData.ID]) {
//                    modelData.drugCount = mainData.drugCount;
//                }
//            }
//        }
        
        [self.searchTab reloadData];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.shoppingCar.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, self.height);
        }];
        self.isOpen = !self.isOpen;
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
    
    
    for (OTCSearchData *mainData in data) {
        if (mainData.isSelect) {
            self.totalCount += mainData.drugCount;
            if (mainData.drugCount >0) {
                self.totalPrice += mainData.drugCount * [mainData.Price floatValue];
            }
        }
    }
    
    for (OTCSearchData *checkData in self.dataArry) {
        if ([checkData.ID isEqualToString:model.ID]) {
            checkData.drugCount = model.drugCount;
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
     [self.searchTab reloadData];
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
     [self.searchTab reloadData];
}


#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length >0 && [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0) {
    self.currentPage = 0;
    self.searchTitle = textField.text;
    [self getSearchDrugData];
    }
    return YES;
    
}


#pragma mark - Lazy Load
- (UITableView *)searchTab {
    
    if (!_searchTab) {
        _searchTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50 - 64 - 50) style:UITableViewStylePlain];
        _searchTab.delegate = self;
        _searchTab.dataSource = self;
        [_searchTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_searchTab registerNib:[UINib nibWithNibName:@"BATOTCDrugCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATOTCDrugCellTableViewCell"];
        [_searchTab registerNib:[UINib nibWithNibName:@"BATSearchFiledCell" bundle:nil] forCellReuseIdentifier:@"BATSearchFiledCell"];
        _searchTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        WEAK_SELF(self);
        _searchTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self getSearchDrugData];
        }];
        _searchTab.mj_footer.hidden = YES;
    }
    
    return _searchTab;
}

- (BATOTCProductView *)shoppingCar {
    
    if (!_shoppingCar) {
        _shoppingCar = [[BATOTCProductView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _shoppingCar.delegate = self;
    }
    return _shoppingCar;
    
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        _defaultView.reloadButton.hidden = YES;
    }
    return _defaultView;
}
@end
