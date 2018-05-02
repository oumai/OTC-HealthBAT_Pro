//
//  BATRoundGuideViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/8/292017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRoundGuideViewController.h"

//#import "BATGoHomeView.h"
#import "BATRoundHeaderView.h"
#import "BATRoundContentView.h"
#import "BATRoundSearchView.h"

#import "BATPerson.h"

#import "BATSearchViewController.h"
#import "BATHomeMallViewController.h"
#import "BATMyFindViewController.h"
#import "BATDoctorListViewController.h"
#import "BATTraditionMedicineHumanUIViewController.h"
#import "BATAlbumListViewController.h"
#import "BATHealthDocumentsViewController.h"
#import "BATDrKangViewController.h"
#import "BATHomeHealthNewsListViewController.h"
#import "BATSearchViewController.h"

#import "IQKeyboardManager.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define DIST(pointA,pointB) sqrtf((pointA.x-pointB.x)*(pointA.x-pointB.x)+(pointA.y-pointB.y)*(pointA.y-pointB.y))
#define MENURADIUS 0.5 * SCREENWIDTH
#define PROPORTION 1.2         //中心圆直径与菜单变长的比例

#define MENUITEMWIDTH 70
#define MENUITEMHEIGHT 70


@interface BATRoundGuideViewController ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) BATRoundContentView *content;
@property (nonatomic, strong) NSMutableArray <UIView *> *viewArray;
@property (nonatomic, strong) UIImageView *circleView;
//@property (nonatomic, strong) UIButton *jkdaBtn;
@property (nonatomic, strong) BATRoundHeaderView *headerView;
//@property (nonatomic, strong) BATGoHomeView *gohomeView;
@property (nonatomic, strong) UIImageView *DrKangView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) BATRoundSearchView *roundSearchView;
@property (nonatomic, strong) NSArray <NSString *> *imageNameArray_Selected;
@property (nonatomic, strong) NSArray <NSString *> *imageNameArray_Normal;

@end

CGPoint beginPoint;
CGPoint orgin;
CGFloat a;
CGFloat b;
CGFloat c;

@implementation BATRoundGuideViewController

- (void)dealloc {
    
    DDLogDebug(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _imageNameArray_Selected = @[@"icon-p-ss",@"icon-p-ds",@"icon-p-sq",@"icon-p-zx",@"icon-p-yl",@"icon-p-sp1",@"icon-p-ysgzs",@"icon-p-ys",@"icon-p-yn",@"icon-p-gyg"];
    _imageNameArray_Normal = @[@"icon-ss",@"icon-ds",@"icon-sq",@"icon-zx",@"icon-yl",@"icon-sp1",@"icon-ysgzs",@"icon-ys",@"icon-yn",@"icon-gyg"];
    
    NSArray <NSString *> *imageTitleArray = @[@"搜索",
                                              @"电商",
                                              @"社区",
                                              @"资讯",
                                              @"医疗",
                                              @"视频",
                                              @"医生工作室",
                                              @"养生",
                                              @"养老",
                                              @"国医馆",
                                              ];
    
//    NSArray <NSString *> *imageTitleArray = @[@"搜索\nsearch",
//                                              @"电商\nonline retailer",
//                                              @"社区\ncommunity",
//                                              @"资讯\ninformation",
//                                              @"医疗\nmedical treatment",
//                                              @"视频\nvideo",
//                                              @"医生工作室\ndoctor clinic",
//                                              @"养生\nheath cultivation",
//                                              @"养老\nprovide for the elderly",
//                                              @"国医馆\nChinese Medical Center",
//                                              ];
    
//    WEAK_SELF(self);
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        STRONG_SELF(self);
//        [self layoutSubviews];
//    }];
    
    [self layoutSubviews];
    
    [self rotationCircleCenter:CGPointMake(MENURADIUS, MENURADIUS) ContentRadius:MENURADIUS ImageNameArray:_imageNameArray_Normal ImageTitleArray:imageTitleArray];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
//    if (LOGIN_STATION) {
    
    WEAK_SELF(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG_SELF(self);
        BATPerson *person = PERSON_INFO;
        [self.headerView.headerView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"personCenter_user_icon"]];
        self.headerView.nameLabel.text = person.Data.UserName;
    });
    

//        self.headerView.hidden = NO;
//    } else {
//        self.headerView.hidden = YES;
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.roundSearchView.searchTextField resignFirstResponder];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

#pragma mark - animation
- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point {
    CGFloat dist = DIST(point, center);
    return (dist <= radius);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    beginPoint = [[touches anyObject] locationInView:self.view];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    orgin = CGPointMake(0.5 * SCREENWIDTH, MENURADIUS + 0.17 * SCREENHEIGHT);
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if ([self touchPointInsideCircle:orgin radius:MENURADIUS targetPoint:currentPoint]) {
        b = DIST(beginPoint, orgin);
        c = DIST(currentPoint, orgin);
        a = DIST(beginPoint, currentPoint);
        CGFloat angleBegin = atan2(beginPoint.y-orgin.y, beginPoint.x-orgin.x);
        CGFloat angleAfter = atan2(currentPoint.y-orgin.y, currentPoint.x-orgin.x);
        CGFloat angle = angleAfter-angleBegin;
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _content.transform = CGAffineTransformRotate(_content.transform, angle);
            _circleView.transform = CGAffineTransformRotate(_circleView.transform, -angle);
            
            for (int i = 0; i < _viewArray.count; i++) {
                
                _viewArray[i].transform = CGAffineTransformRotate(_viewArray[i].transform, -angle);
                
                UIView *view = _viewArray[i];
                
                CGPoint point = [_content convertPoint:view.center toView:self.view];
                
                if (point.x < 0) {
                    view.alpha = 0.5f;
                } else {
                    view.alpha = 1.0f;
                }
                
            }
        } completion:nil];
        

        beginPoint = currentPoint;
    }
}

#pragma mark - private
- (void)rotationCircleCenter:(CGPoint)contentOrgin ContentRadius:(CGFloat)contentRadius ImageNameArray:(NSArray <NSString *>*)imageNameArray ImageTitleArray:(NSArray <NSString *>*)imageTitleArray {
    
    _viewArray = [NSMutableArray array];
    for (int i = 0; i < imageNameArray.count; i++) {
        
        CGFloat x = contentRadius*sin(M_PI*2/imageNameArray.count*i);
        CGFloat y = contentRadius*cos(M_PI*2/imageNameArray.count*i);
        
        // (1 - PROPORTION) * contentRadius
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(contentRadius + 0.5 * (1 + PROPORTION) * x - 0.5 * MENUITEMWIDTH, contentRadius - 0.5 * (1 + PROPORTION) * y - 0.5 * MENUITEMHEIGHT, MENUITEMWIDTH, MENUITEMHEIGHT)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MENUITEMWIDTH, MENUITEMHEIGHT)];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        imageView.tag = i + 100;
        
//        UILabel *imageTitle = [[UILabel alloc] initWithFrame:CGRectMake(MENUITEMWIDTH, 0, 180, MENUITEMHEIGHT)];
//        imageTitle.numberOfLines = 2;
//        
//        NSString *text = imageTitleArray[i];
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
//        
//        NSRange range = [text rangeOfString:@"\n"];
//        
//        [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21]} range:NSMakeRange(0, range.location)];
//        [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(range.location, text.length - range.location)];
//
//        imageTitle.attributedText = string;
//        imageTitle.textAlignment = NSTextAlignmentLeft;
//        imageTitle.textColor = UIColorFromHEX(0xcfffff, 1);
        
        UILabel *imageTitle = [[UILabel alloc] initWithFrame:CGRectMake(MENUITEMWIDTH, 0, 180, MENUITEMHEIGHT)];
        imageTitle.text = imageTitleArray[i];
        
        if (iPhone5 || iPhone4) {
            imageTitle.font = [UIFont systemFontOfSize:21 * scaleValue];

        } else {
            imageTitle.font = [UIFont systemFontOfSize:21];

        }
        
        imageTitle.textAlignment = NSTextAlignmentLeft;
        imageTitle.textColor = UIColorFromHEX(0xcfffff, 1);
        
        [view addSubview:imageView];
        [view addSubview:imageTitle];
        
        WEAK_SELF(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            STRONG_SELF(self);
            [self resetMenuState:i];
            switch (i) {
                case 0:
                {
                    //搜索
                    BATSearchViewController *searchVC = [[BATSearchViewController alloc] init];
                    searchVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchVC animated:YES];
                }
                    break;
                case 1:
                {
                    //电商
                    if (!CANVISITSHOP) {
                        
                        [self showText:@"各位客官,今日特价商品已抢完..."];
                        return ;
                    }
                    BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
                    homeMallVC.url = @"http://m.km1818.com/bat/rcxyzd.html";
                    homeMallVC.title = @"大药房";
                    homeMallVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:homeMallVC animated:YES];
                    
                }
                    break;
                case 2:
                {
                    //社区
                    //发现
                    BATMyFindViewController *findVC = [[BATMyFindViewController alloc]init];
                    findVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:findVC animated:YES];
                }
                    break;
                case 3:
                {
                    //资讯
//                    [self showText:@"敬请期待"];
                    
                    BATHomeHealthNewsListViewController *newsListVC = [[BATHomeHealthNewsListViewController alloc] init];
                    newsListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:newsListVC animated:YES];
                    
                }
                    break;
                case 4:
                {
                    
                    //医疗
                    [self dismissViewControllerAnimated:NO completion:nil];
//                    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
//                    [tabBarController setSelectedIndex:3];
                    
                    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.rootTabBarController setSelectedIndex:3];
                    
                    UINavigationController *navVC = appDelegate.rootTabBarController.selectedViewController;
                    navVC.viewControllers[0].isFromRoundGuide = YES;
                    
                    //                    BATConsultationIndexViewController *consultationIndexVC = (BATConsultationIndexViewController *)navVC.viewControllers[0];
                    //                    consultationIndexVC.isFromRoundGuide = YES;
                }
                    break;
                case 5:
                {
                    //视频
//                    BATAlbumListViewController *albumVc = [[BATAlbumListViewController alloc]init];
//                    albumVc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:albumVc animated:YES];
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
//                    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
//                    [tabBarController setSelectedIndex:1];
                    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.rootTabBarController setSelectedIndex:1];
                    
                    UINavigationController *navVC = appDelegate.rootTabBarController.selectedViewController;
                    navVC.viewControllers[0].isFromRoundGuide = YES;

                }
                    break;
                case 6:
                {
                    //医生工作室
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    BATDoctorListViewController *doctorListVC = [[BATDoctorListViewController alloc] init];
                    doctorListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:doctorListVC animated:YES];
                }
                    break;
                case 7:
                {
                    //养生
                    [self showText:@"敬请期待"];
                }
                    break;
                case 8:
                {
                    //养老
                    [self showText:@"敬请期待"];
                }
                    break;
                case 9:
                {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC;
                        return;
                    }
                    //国医馆
                    BATTraditionMedicineHumanUIViewController *humanVC = [[BATTraditionMedicineHumanUIViewController alloc] init];
                    humanVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:humanVC animated:YES];
                }
                    break;
            }
        }];
        [view addGestureRecognizer:tap];
        
        [_content addSubview:view];
        [_viewArray addObject:view];
    }
}

#pragma mark - Action
- (void)resetMenuState:(NSInteger)index
{
    for (int i = 0; i < _imageNameArray_Normal.count; i++) {
        UIView *view = _viewArray[i];
        UIImageView *imageView = [view viewWithTag:i + 100];
        imageView.image = [UIImage imageNamed:[_imageNameArray_Normal objectAtIndex:i]];
        if (i == index) {
            imageView.image = [UIImage imageNamed:[_imageNameArray_Selected objectAtIndex:i]];
        }
    }
}

#pragma mark - layout
- (void)layoutSubviews {
    
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.content];
//    [self.view addSubview:self.jkdaBtn];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.roundSearchView];
    [self.view addSubview:self.headerView];
//    [self.view addSubview:self.gohomeView];
    [self.view addSubview:self.DrKangView];
    
    WEAK_SELF(self);
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];

//    [self.jkdaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@10);
//        make.bottom.equalTo(@-15);
//    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(@10);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
        make.size.mas_offset(CGSizeMake(28, 28));
    }];
    
    [self.roundSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
        make.right.equalTo(self.headerView.mas_left).offset(-5);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.height.mas_offset(28);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
//    [self.gohomeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.right.equalTo(@-10);
//        make.centerY.equalTo(self.jkdaBtn.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(85, 20));
//    }];
    

}

#pragma mark - getter
- (UIImageView *)bgImage {
    
    if (!_bgImage) {
        
        _bgImage = [[UIImageView alloc] init];
        _bgImage.userInteractionEnabled = YES;
        _bgImage.image = [UIImage imageNamed:@"bg"];
    }
    return _bgImage;
}

- (UIView *)content {
    
    if (!_content) {
        
        _content = [[BATRoundContentView alloc] initWithFrame:CGRectMake(-(SCREENWIDTH*0.5)+60, 0.27 * SCREENHEIGHT, SCREENWIDTH, SCREENWIDTH)];
        _content.userInteractionEnabled = YES;
    }
    return _content;
}

//- (UIButton *)jkdaBtn {
//    
//    if (!_jkdaBtn) {
//        
//        _jkdaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_jkdaBtn setImage:[UIImage imageNamed:@"btn-jkda"] forState:UIControlStateNormal];
//        [_jkdaBtn sizeToFit];
//        
//        WEAK_SELF(self);
//        [_jkdaBtn bk_whenTapped:^{
//            STRONG_SELF(self);
//            
//            if (!LOGIN_STATION) {
//                PRESENT_LOGIN_VC;
//                return;
//            } else {
//                [self dismissViewControllerAnimated:NO completion:nil];
//                UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
//                [tabBarController setSelectedIndex:2];
//                
//                UINavigationController *navVC = tabBarController.selectedViewController;
//                navVC.viewControllers[0].isFromRoundGuide = YES;
//                
//                //            BATHealthDocumentsViewController *healthDocumentsVC = (BATHealthDocumentsViewController *)navVC.viewControllers[0];
//                //            healthDocumentsVC.isFromRoundGuide = YES;
//            }
//            
//
//            
//        }];
//    }
//    return _jkdaBtn;
//}

- (BATRoundSearchView *)roundSearchView
{
    if (_roundSearchView == nil) {
        _roundSearchView = [[BATRoundSearchView alloc] init];
        WEAK_SELF(self);
        _roundSearchView.roundSearchBlock = ^(NSString *keyword) {
            STRONG_SELF(self);
            
            if (keyword.length > 0) {
                BATSearchViewController *searchVC = [[BATSearchViewController alloc] init];
                searchVC.key = keyword;
                searchVC.isFromHome = YES;
                searchVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:searchVC animated:YES];
            } else {
                [self showText:@"请输入关键字"];
                [self.roundSearchView.searchTextField resignFirstResponder];
            }
            

            
        };
    }
    return _roundSearchView;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icon-logo"];
    }
    return _iconImageView;
}

- (BATRoundHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[BATRoundHeaderView alloc] initWithFrame:CGRectZero];
//        _headerView.hidden = YES;
        
        WEAK_SELF(self);
        [_headerView bk_whenTapped:^{
            STRONG_SELF(self);
            
            [self dismissViewControllerAnimated:NO completion:nil];
//            UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
//            [tabBarController setSelectedIndex:4];
            
            BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.rootTabBarController setSelectedIndex:4];
            
            UINavigationController *navVC = appDelegate.rootTabBarController.selectedViewController;
            navVC.viewControllers[0].isFromRoundGuide = YES;
            
//            BATMeViewController *meVC = (BATMeViewController *)navVC.viewControllers[0];
//            meVC.isFromRoundGuide = YES;
            
        }];
    }
    return _headerView;
}

//- (BATGoHomeView *)gohomeView {
//    
//    if (!_gohomeView) {
//        
//        _gohomeView = [[BATGoHomeView alloc] initWithFrame:CGRectZero];
//        
//        WEAK_SELF(self);
//        [_gohomeView setTapped:^{
//            STRONG_SELF(self);
//            [self dismissViewControllerAnimated:NO completion:nil];
//            
//            UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
//            [tabBarController setSelectedIndex:0];
//            
//            UINavigationController *navVC = tabBarController.selectedViewController;
//            navVC.viewControllers[0].isFromRoundGuide = YES;
//            
////            BATHomeViewController *homeVC = (BATHomeViewController *)navVC.viewControllers[0];
////            homeVC.isFromRoundGuide = YES;
//            
//        }];
//    }
//    return _gohomeView;
//}

- (UIImageView *)DrKangView {
    
    if (!_DrKangView) {
        
        _DrKangView = [[UIImageView alloc] init];
        _DrKangView.center = CGPointMake((SCREEN_WIDTH*0.4)/396.0*416 / 2, self.content.center.y);
        //396 × 416
        _DrKangView.bounds = CGRectMake(0, 0, (SCREEN_WIDTH*0.4), (SCREEN_WIDTH*0.4)/396.0*416);
        
        _DrKangView.contentMode = UIViewContentModeScaleToFill;
        _DrKangView.userInteractionEnabled = YES;
        
        WEAK_SELF(self);
        [_DrKangView bk_whenTapped:^{
            STRONG_SELF(self);
            BATDrKangViewController *kangDoctorVC = [[BATDrKangViewController alloc] init];
            kangDoctorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:kangDoctorVC animated:YES];
        }];
    }
    return _DrKangView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
