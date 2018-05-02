//
//  BATMyPrescriptionVC.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//
static NSString *fileCellID = @"PrescriptionCell";
static NSString *string = @"如果我能看得见就能轻易的分辨白天黑夜，就能在人群中牵住你的手，如果我能看得见就能驾车带你到处遨游，就能轻易的从背后给你一个拥抱，如果我能看得见，";

#import "BATMyPrescriptionVC.h"
#import "BATMyPrescriptionCell.h"
#import "BATKmWlyyOPDRegisteListModel.h"//万里写model
#import "BATgetPayOPDRegisterModel.h"
#import "BATWlyyDrugDetailListModel.h"
#import "BATOTCDrugModel.h" //提交订单Model

#import "BATSubmitOrderViewController.h" //提交订单
#import "BATCheckDetailViewController.h" //查看详情

#import "BATOTCConsultListModel.h"

#import "BATPerson.h"

@interface BATMyPrescriptionVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic,strong) BATDefaultView *defaultView;
@property (nonatomic, strong) BATOTCConsultListModel *model;

@property (nonatomic, strong) NSMutableArray *diagnosisArray;
@end

@implementation BATMyPrescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];

   
    
    
    self.title = @"我的处方";
    self.dataArray = [NSMutableArray array];
    self.diagnosisArray = [NSMutableArray array];

    [self.view addSubview:self.tableView];
    
    
 
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];

    [self.tableView.mj_header beginRefreshing];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRecipeList) name:@"BAT_RefreshRecipeList_Noti" object:nil];
}

- (void)refreshRecipeList {
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ------------------------------------------------------------------UITableViewDatasource Delegate-------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATMyPrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:fileCellID];
    if (nil == cell) {
        cell = [[BATMyPrescriptionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fileCellID];
    }
    
//    BATKmWlyyOPDRegisteListData *data = self.dataArray[indexPath.row];
//    cell.model = data;
//    cell.timeLabel.text = data.OPDDate;
    cell.path = indexPath;
    
    cell.model = self.dataArray[indexPath.row];
    
    [cell setBuyButtonBlock:^(BATMyPrescriptionCell *cell, NSIndexPath *pathRows) {
        
        
        //BATKmWlyyOPDRegisteListData *data = self.dataArray[indexPath.row];
        //[self requestWithGetPayOPDRegister:model.OPDRegisterID  indexPath:indexPath.row];
        BATOTCConsultListData *data = self.dataArray[pathRows.row];
        [self buyClickWithData:data];
        
    }];
    
    [cell setCheckButtonBlock:^(BATMyPrescriptionCell *cell, NSIndexPath *pathRows) {
        
        
        BATOTCConsultListData *model = self.model.Data[pathRows.row];
        BATCheckDetailViewController *vc = [BATCheckDetailViewController new];
        vc.RecipeFileUrl = model.RecipeFileUrl;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 32+32+10+[BATMyPrescriptionCell heightForCellWithString:self.diagnosisArray[indexPath.row]] +20;
}


//购买按钮（提交订单页）
- (void)buyClickWithData:(BATOTCConsultListData *)data
{
    
    if (data.OrderNo.length > 0) {
        
        [self showErrorWithText:@"您已经购买过此处方单的药品了"];
        return;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (BATOTCConsultData *model in data.DrugInfo) {
        
        OTCSearchData *tmpData = [[OTCSearchData alloc] init];
        tmpData.ID = model.DrugID;
        tmpData.DrugName = model.DrugName;
        tmpData.Price = model.Price;
        tmpData.drugCount = model.DrugNumber;
        tmpData.Specification = model.Specification;
        tmpData.PictureUrl = model.PictureUrl;
        tmpData.ManufactorName = model.ManufactorName;
        [tmpArray addObject:tmpData];
    }
    
    
    //跳转到提交订单界面
    BATSubmitOrderViewController *vc = [BATSubmitOrderViewController new];
    vc.dataArry = tmpArray;
    vc.orderType = BATOTCOrderType_PrescriptionDrugs;//处方药
    vc.RecipeFileUrl = data.RecipeFileUrl;
    vc.RecipeID = data.ID;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)GetRecipeList
{
    
    BATPerson *person = PERSON_INFO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(person.Data.AccountID) forKey:@"accountId"];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [dict setValue:@"" forKey:@"phoneNumber"];
    
 
   
    
    [HTTPTool requestWithOTCURLString:@"/api/OtcConsult/GetRecipeList" parameters:dict type:kGET success:^(id responseObject) {

        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        
        
        self.model = [BATOTCConsultListModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:self.model.Data];
        
        
        //诊断结果放到数组里
        for (BATOTCConsultListData *data in self.model.Data) {
            [self.diagnosisArray addObject:data.Diagnosis];
        }
        
        
        
        if (self.dataArray.count >= self.model.RecordsCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        if (self.dataArray.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.defaultView showDefaultView];
    }];
}

-(UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.rowHeight = 124.0;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[BATMyPrescriptionCell class] forCellReuseIdentifier:fileCellID];
        
        
        WEAK_SELF(self);
        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            //[self requestWithWlyyRegisteRecord];
            [self GetRecipeList];
            
        }];
        _tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            //[self requestWithWlyyRegisteRecord];
            [self GetRecipeList];
            
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

/*

//获取关联的处方列表(需要传入提交订单的信息)
- (void)getRecipeFiles:(NSString *)OPDRegisterID
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:OPDRegisterID forKey:@"opdRegisterId"];
    
    [HTTPTool requestWithOTCURLString:@"/api/OtcConsult/GetRecipeFiles" parameters:dict type:kGET success:^(id responseObject) {
        
        
        BATWlyyDrugDetailListModel *model = [BATWlyyDrugDetailListModel mj_objectWithKeyValues:responseObject];
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (DetailRecipeFile *files in model.Data.RecipeFiles) {

            for (Details *detail in files.Details) {
                
                OTCSearchData *tmpData = [[OTCSearchData alloc] init];
                tmpData.ID = detail.Drug.DrugID;
                tmpData.DrugName = detail.Drug.DrugName;
                tmpData.Price = detail.Drug.UnitPrice;
                tmpData.drugCount = detail.Quantity;
                tmpData.Specification = detail.Drug.Specification;
                [tmpArray addObject:tmpData];
            }
        }
        
        //跳转到提交订单界面
        BATSubmitOrderViewController *vc = [BATSubmitOrderViewController new];
        vc.dataArry = tmpArray;
        vc.orderType = BATOTCOrderType_PrescriptionDrugs;//处方药
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
}



//获取处方单列表
- (void)requestWithWlyyRegisteRecord {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"3" forKey:@"OPDType"];
    [dict setValue:@"10" forKey:@"pageSize"];
    
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/UserOPDRegisters" parameters:dict type:kGET success:^(id responseObject) {
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        
        BATKmWlyyOPDRegisteListModel *model = [BATKmWlyyOPDRegisteListModel mj_objectWithKeyValues:responseObject];
        [self.dataArray addObjectsFromArray:model.Data];

        if (self.dataArray.count >= model.Total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        
        if (self.dataArray.count == 0) {
            [self.defaultView showDefaultView];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.defaultView showDefaultView];
    }];
}




//获取处方单购买记录（判断是否买过）
- (void)requestWithGetPayOPDRegister:(NSString *)OPDRegisterID indexPath:(NSInteger )indexP
{
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:OPDRegisterID forKey:@"OPDRegisterID"];
    [HTTPTool requestWithOTCURLString:@"/api/order/getPayOPDRegister" parameters:dict type:kGET success:^(id responseObject) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        BATgetPayOPDRegisterModel *model = [BATgetPayOPDRegisterModel mj_objectWithKeyValues:responseObject];
        
        [tempArray addObjectsFromArray:model.Data];
        [tempArray addObject:@1];
        
        
        NSLog(@"tempArray = %@",tempArray);
        NSMutableArray *numberArray = [NSMutableArray array];
        
        for (int i = 0; i<self.dataArray.count; i++)
        {
            [numberArray addObject:@(i)];
        }

        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",tempArray];
        NSArray * filter = [numberArray filteredArrayUsingPredicate:filterPredicate];
        NSLog(@"%@",filter);

        
        if ([filter containsObject:[NSNumber  numberWithInteger:indexP]] == YES ) {
            [self showText:@"已经购买过此商品"];//如果没有数据就不能点击
        }
        else
        {
            [self getRecipeFiles:OPDRegisterID]; //传预约ID
        }
        

        NSLog(@"getPayOPDRegisterresponseObject    ResultMessage= %@  ResultCode = %@  data = %@",    model.ResultMessage,model.ResultCode,model.Data);
        
    } failure:^(NSError *error) {
    }];
}
*/
@end
