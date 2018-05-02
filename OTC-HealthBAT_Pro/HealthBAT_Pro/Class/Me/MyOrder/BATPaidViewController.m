//
//  BATPaidViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPaidViewController.h"
#import "HMSegmentedControl.h"
#import "UIColor+Gradient.h"

#import "BATDaiQuYaoViewController.h"
#import "BATDaiShouHuoViewController.h"
#import "BATDaiFaHuoViewController.h"


@interface BATPaidViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
/** UIScrollView */
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentController;/** 分段控制器 */
@end

@implementation BATPaidViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已付款";
    [self addChildVc];
    [self.view addSubview:self.segmentController];
    [self.view addSubview:self.bgScrollView];

    
}

#pragma mark - private
/**
 添加子控制器
 */
- (void)addChildVc{
    
    BATDaiQuYaoViewController * VC1 = [[BATDaiQuYaoViewController alloc] init];
    VC1.view.frame = CGRectMake(0, 0, self.bgScrollView.frame.size.width, self.bgScrollView.frame.size.height);
    
    BATDaiShouHuoViewController *VC2 = [[BATDaiShouHuoViewController alloc] init];
    VC2.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.bgScrollView.frame.size.width, self.bgScrollView.frame.size.height);
    
    BATDaiFaHuoViewController * VC3 = [[BATDaiFaHuoViewController alloc] init];
    VC3.view.frame = CGRectMake(SCREEN_WIDTH *2, 0, self.bgScrollView.frame.size.width, self.bgScrollView.frame.size.height);

    
    
    [self addChildViewController:VC1];
    [self addChildViewController:VC2];
    [self addChildViewController:VC3];
    
    [self.bgScrollView addSubview:VC1.view];
    [self.bgScrollView addSubview:VC2.view];
    [self.bgScrollView addSubview:VC3.view];
    
    //主动调用显示第一个子控制器 View
    //[self scrollViewDidEndScrollingAnimation:self.bgScrollView];
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtr{

    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*segmentCtr.selectedSegmentIndex, 0) animated:YES];

    //1待付款，2待发货，3待收货，4待取药，5已完成、6已取消
    //待取药
    if (segmentCtr.selectedSegmentIndex == 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"BATOTCChoosePaidChild"];
    }//待收货
    else if (segmentCtr.selectedSegmentIndex == 1 )
    {
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"BATOTCChoosePaidChild"];

    }
    //待发货
    else if (segmentCtr.selectedSegmentIndex == 2)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"BATOTCChoosePaidChild"];

    }
}
- (HMSegmentedControl *)segmentController{
    if (!_segmentController) {
        
        
        
        _segmentController = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
        
        //设置底部下划线的高度
        _segmentController.selectionIndicatorHeight = 2;
        
        //设置底部下划线的颜色
        _segmentController.selectionIndicatorColor = UIColorFromHEX(0x29ccbf, 1);
        
        //设置边框
        _segmentController.layer.borderColor = UIColorFromHEX(0xe0e0e0, 1).CGColor;
        _segmentController.layer.borderWidth = 0.5;
        _segmentController.layer.masksToBounds = YES;
        
        //设置分段控制器标题
        _segmentController.sectionTitles = @[@"待取药",@"待收货",@"待发货"];

        //设置底下的线和文字一样大
        _segmentController.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //设置线的位置
        _segmentController.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        //设置文字颜色及字体
        _segmentController.titleTextAttributes = @{NSForegroundColorAttributeName : UIColorFromHEX(0x333333, 1),
                                                   NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentController.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:15],
                                                           NSFontAttributeName :[UIFont systemFontOfSize:15]};
        
        //添加点击事件
        [_segmentController addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentController;
}
- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentController.frame) , SCREEN_WIDTH, SCREEN_HEIGHT   - CGRectGetHeight(self.segmentController.frame)  - 64 )];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        //        _bgScrollView.contentSize = CGSizeMake(8 * SCREEN_WIDTH, 0);
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        [_bgScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 0)];

    }
    return _bgScrollView;
}

#pragma mark - UIScrolllViewDelegate
/**
 * 滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    if (willShowChildVc.isViewLoaded) return;
    
    willShowChildVc.view.frame = scrollView.bounds;
    willShowChildVc.view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:willShowChildVc.view];
}
/**
 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //添加子控制器 view
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentController setSelectedSegmentIndex:page animated:YES];
}
/**
 拖动结束，手从屏幕上抬起的一刹那，会执行这个方法,防止用户刚好拖到边界停止
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
@end
