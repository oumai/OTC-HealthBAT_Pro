//
//  BATSportsDietView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSportsDietView.h"
#import "BATDateCollectionViewCell.h"
#import "BATSportsDietItemView.h"

@interface BATSportsDietView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *itemDataSource;

@end

@implementation BATSportsDietView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [NSMutableArray arrayWithObjects:
                       @{@"name":@"周一",@"image":@"icon-wyd"},
                       @{@"name":@"周二",@"image":@"icon-pb"},
                       @{@"name":@"周三",@"image":@"icon-wyd"},
                       @{@"name":@"周四",@"image":@"icon-ymq"},
                       @{@"name":@"周五",@"image":@"icon-wyd"},
                       @{@"name":@"周六",@"image":@"icon-pb"},
                       @{@"name":@"周日",@"image":@"icon-wyd"},nil];
        
        _itemDataSource = [NSMutableArray arrayWithObjects:
                           @{@"name":@"谷薯类",@"percent":@"52.5%",@"image":@"icon-gsl"},
                           @{@"name":@"蔬菜类",@"percent":@"5.0%",@"image":@"icon-scl"},
                           @{@"name":@"肉蛋类",@"percent":@"5.0%",@"image":@"icon-drl"},
                           @{@"name":@"水果类",@"percent":@"5.0%",@"image":@"icon-sgl"},
                           @{@"name":@"豆奶类",@"percent":@"12.5%",@"image":@"icon-dll"},
                           @{@"name":@"油脂类",@"percent":@"12.5%",@"image":@"icon-yzl"},nil];
        
        [self pageLayout];
        
        [self.collectionView registerClass:[BATDateCollectionViewCell class] forCellWithReuseIdentifier:@"BATDateCollectionViewCell"];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDateCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _dataSource[indexPath.row];
    
    NSString *name = dic[@"name"];
    NSString *image = dic[@"image"];
    
    cell.titleLabel.text = name;
    cell.imageView.image = [UIImage imageNamed:image];
    return cell;
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.collectionView];
    [self addSubview:self.dietImageView];
    [self addSubview:self.dietTitleLabel];
    
    WEAK_SELF(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
        if (iPhone5 || iPhone4) {
            make.height.mas_offset(80 * scaleValue);
        } else {
            make.height.mas_offset(80);
        }
    }];
    
    [self.dietImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(175.5 * scaleValue, 175.5 * scaleValue));
            make.top.equalTo(self.collectionView.mas_bottom).offset(30 * scaleValue);

        } else {
            make.size.mas_offset(CGSizeMake(175.5, 175.5));
            make.top.equalTo(self.collectionView.mas_bottom).offset(30);
        }
        
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.dietTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.center.equalTo(self.dietImageView);
    }];
    
    
    for (int i = 0; i < _itemDataSource.count; i++) {
        
        NSDictionary *dic = _itemDataSource[i];
        
        BATSportsDietItemView *itemView = [[BATSportsDietItemView alloc] init];
        itemView.titleLabel.text = dic[@"name"];
        itemView.percentLabel.text = dic[@"percent"];
        itemView.imageView.image = [UIImage imageNamed:dic[@"image"]];
        [self addSubview:itemView];
        
        WEAK_SELF(self);
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            
            if (i == 0 || i == 1) {
                make.top.equalTo(self.dietImageView.mas_top).offset(10);
            } else if (i == 2 || i == 3) {
                make.centerY.equalTo(self.dietImageView.mas_centerY);
            } else {
                make.bottom.equalTo(self.dietImageView.mas_bottom).offset(-10);
            }
            
            if (i % 2 == 0) {
                make.left.equalTo(self.mas_left).offset(10);
            } else {
                make.right.equalTo(self.mas_right).offset(-10);
            }
            
            if (iPhone5 || iPhone4) {
                make.size.mas_offset(CGSizeMake(80 * scaleValue, 50 *scaleValue));
            } else {
                make.size.mas_offset(CGSizeMake(80, 50));
            }
            
            
        }];
    }
}

#pragma mark - get & set
- (BATCustomCollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 7, 80);
        
        _collectionView = [[BATCustomCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}

- (UIImageView *)dietImageView
{
    if (_dietImageView == nil) {
        _dietImageView = [[UIImageView alloc] init];
        _dietImageView.image = [UIImage imageNamed:@"icon-swrl"];
    }
    return _dietImageView;
}

- (UILabel *)dietTitleLabel
{
    if (_dietTitleLabel == nil) {
        _dietTitleLabel = [[UILabel alloc] init];
        
        if (iPhone5 || iPhone4) {
            _dietTitleLabel.font = [UIFont systemFontOfSize:25*scaleValue];
        } else {
            _dietTitleLabel.font = [UIFont systemFontOfSize:25];
        }
        
        _dietTitleLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _dietTitleLabel.text = @"饮食热量";
        _dietTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_dietTitleLabel sizeToFit];
    }
    return _dietTitleLabel;
}
@end
