//
//  NKGNewFutureViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKGNewFutureViewController.h"
#import "NKNavigationController.h"
#import "UIView+NKMoreAttribute.h"
#import "NSArray+NKPlist.h"

#define kRation 0.85
#define kStartButtonYRatio 0.66
#define kStartButtonWidthRatio 24 4/320
#define kStartButtonHeightRatio 64/568
@interface NKGNewFutureViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrowView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak,nonatomic)UIImageView *imageView;

@end

@implementation NKGNewFutureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNEWFeaturePageControl];
    //设置pagecontrol 位置
    [self setNewFeatureScrollView];
    //设置新特性view的5个界面
    
    
}

#pragma mark 设置新特性view的5个界面
-(void)setNewFeatureScrollView{
    
    //    float width = _scrowView.frame.size.width;
    //    float height = _scrowView.frame.size.height;
    NSArray *newFeature = [NSArray arrayWithPlist:@"NEWFeature.plist"];
//    NSURL * url = [[NSBundle mainBundle]URLForResource:@"NEWFeature.plist" withExtension:nil];
//    NSArray * newFeature = [NSArray arrayWithContentsOfURL:url];
    for (int i = 0; i < newFeature.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc]init];
        _imageView = imageView;
        NSString * imageStr = newFeature[i];
        [imageView setImage:[UIImage imageNamed:imageStr]];
        
        imageView.frame = CGRectMake(i * self.view.width, 0, self.view.width, self.view.height);
        
        //判断是否是新特性的最后一页，若是则添加button
        if (i == newFeature.count - 1) {
            [self addStartButton:imageView ];
        }
        
        [_scrowView addSubview:imageView];
        _scrowView.contentSize = CGSizeMake(newFeature.count * self.view.width, self.view.height);
        _scrowView.delegate = self;
        //设置scrollview 的滚动停止能自动回复
        _scrowView.pagingEnabled = YES;
        _scrowView.bounces= NO;
    }
}
#pragma mark自定义button 由button进入主页
-(void)addStartButton:(UIImageView *)imageView{
    
    float startBtnY = self.view.height *kStartButtonYRatio;
    float startBtnW = self.view.height *kStartButtonHeightRatio;
    float startBtnH = self.view.height *kStartButtonHeightRatio;
    float startBtnX = (self.view.width - startBtnW)/2;
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH)];
    
    [startBtn setImage:[UIImage imageNamed:@"introduction_enter_nomal"] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"introduction_enter_press"] forState:UIControlStateHighlighted];
    
    [imageView addSubview:startBtn];
    imageView.userInteractionEnabled = YES;
    [startBtn addTarget:self action:@selector(startMainView :) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 开始主页
-(void)startMainView :(UIButton *)starBtn{
    NSLog(@"1");
    //新特性页面跳转到首页
    //启动主页面 设置windpw的根控制器为导航控制器
    // 先找到stroyBord 通过info.plist中的main stroybord file base name
    UIStoryboard * stroyBord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //在stroybord 实例中找到navigationcontroller对应的实例
    NKNavigationController *nav = [stroyBord instantiateViewControllerWithIdentifier:@"NKNavigationController1"];
    self.view.window.rootViewController = nav;
}

#pragma mark 设置pagecontrol 位置
-(void)setNEWFeaturePageControl{
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"NEWFeature.plist" withExtension:nil];
    NSArray * newFeature = [NSArray arrayWithContentsOfURL:url];
    _pageControl.numberOfPages = newFeature.count;
    _pageControl.currentPage = 0;
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
    //    _pageControl.currentPage =  (_scrowView.contentOffset.x + (0.5*_scrowView.frame.size.width))/ _scrowView.frame.size.width;
    //
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat num = _pageControl.currentPage =  (_scrowView.contentOffset.x + (0.5*_scrowView.frame.size.width))/ _scrowView.frame.size.width;
    _pageControl.currentPage = num ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
