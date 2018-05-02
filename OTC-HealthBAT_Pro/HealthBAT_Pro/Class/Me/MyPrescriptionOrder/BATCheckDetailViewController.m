//
//  BATCheckDetailViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCheckDetailViewController.h"
@interface BATCheckDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation BATCheckDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutPageViews];
    
    [self loadRecipeFileUrl];
}

#pragma mark UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Private
- (void)loadRecipeFileUrl {
    
    if (self.RecipeFileUrl.length == 0) {
        return;
    }
    
    [HTTPTool requestWithKmWlyyImageApiURLString:[NSString stringWithFormat:@"%@",self.RecipeFileUrl] success:^(id responseObject) {
        
//        NSLog(@"success");
        
        UIImage *image = [UIImage imageWithData:responseObject];
        
        CGSize endSize = CGSizeMake(SCREEN_WIDTH, image.size.height/image.size.width*SCREEN_WIDTH);
        
        self.scrollView.contentSize = endSize;
        self.imageView.size = endSize;
        self.imageView.image = image;

        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPageViews {
    
    self.title = @"详情";

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.scrollView addSubview:self.imageView];
}

#pragma makr - getter
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale=4.0;
        _scrollView.minimumZoomScale=0.25;

    }
    return _scrollView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end


