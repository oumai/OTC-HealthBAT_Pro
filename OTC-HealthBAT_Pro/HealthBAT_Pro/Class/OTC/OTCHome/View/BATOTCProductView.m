//
//  BATOTCProductView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCProductView.h"
#import "BATSelectProductCell.h"
@interface BATOTCProductView()<UITableViewDelegate,UITableViewDataSource,BATSelectProductCellDelegate>

@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation BATOTCProductView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setShoppingData:(NSMutableArray *)shoppingData {
    
    _shoppingData = shoppingData;
    [self.product reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.data = [NSMutableArray array];
        self.product  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.product.delegate = self;
        self.product.dataSource = self;
        [self.product registerNib:[UINib nibWithNibName:@"BATSelectProductCell" bundle:nil] forCellReuseIdentifier:@"BATSelectProductCell"];
        [self.product setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:self.product];
        
        [self.product mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
            
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.shoppingData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATSelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSelectProductCell"];
    cell.delegate = self;
    cell.rowPath = indexPath;
    if (self.shoppingData.count >0) {
        cell.drugModel = self.shoppingData[indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 34)];
    titleLb.backgroundColor = [UIColor whiteColor];
    titleLb.text = @"  已选商品";
    titleLb.textColor = UIColorFromRGB(51, 51, 51, 1);
    titleLb.font = [UIFont systemFontOfSize:15];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(224, 224, 224, 1);
    [titleLb addSubview:lineView];
    return titleLb;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OTCSearchData *data = self.shoppingData[indexPath.row];
    data.isSelect = !data.isSelect;
    if ([self.delegate respondsToSelector:@selector(BATOTCProductViewDelegateWithModel:)]) {
        [self.delegate BATOTCProductViewDelegateWithModel:data];
    }
    [self.product reloadData];
    
}

#pragma mark - BATSelectProductCellDelegate
- (void)BATSelectProductCellDelegateWithAddActionRowPaht:(NSIndexPath *)rowPath cell:(BATSelectProductCell *)cell {
    
    NSLog(@"BATSelectProductCellDelegateWithAddActionRowPaht");
     OTCSearchData *data = self.shoppingData[rowPath.row];
    data.drugCount +=1;
    [self.product reloadData];
    if ([self.delegate respondsToSelector:@selector(BATOTCProductViewAddActionDelegateWithModel:)]) {
        [self.delegate BATOTCProductViewAddActionDelegateWithModel:data];
    }
    
}

- (void)BATSelectProductCellDelegateWithReduceActionRowPaht:(NSIndexPath *)rowPath cell:(BATSelectProductCell *)cell {
    
     OTCSearchData *data = self.shoppingData[rowPath.row];
    if (data.drugCount <=0) {
        data.drugCount = 0;
    }else {
        data.drugCount -=1;
    }
    [self.shoppingData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCSearchData *data = obj;
        if (data.drugCount == 0) {
            [_shoppingData removeObjectAtIndex:idx];
        }
    }];
    [self.product reloadData];
    if ([self.delegate respondsToSelector:@selector(BATOTCProductViewReduceActionDelegateWithModel:)]) {
        [self.delegate BATOTCProductViewReduceActionDelegateWithModel:data];
    }
    NSLog(@"BATSelectProductCellDelegateWithReduceActionRowPaht");
}

@end
