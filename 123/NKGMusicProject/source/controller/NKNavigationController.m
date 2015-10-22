//
//  NKNavigationController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKNavigationController.h"
#import "NKPlayBar.h"
#import "UIView+NKMoreAttribute.h"
#import "UIBarButtonItem+NKBarItem.h"
#import "NKPlayBar.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NKNavigationController ()


@end

@implementation NKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义UISegmentedcontrol
    //加载playbar  播放控制器导航控制器
    //在导航控制器下端 加一个playbar，切换到其他控制器中时也能显示
    
    [self setupPlayBar];
    //2015.9.22 自定义导航栏 begin
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"arrow-thick-left-2x"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"arrow-thick-left-2x"];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    //    2015.9.22 自定义导航栏 end
    
    
}
#pragma mark 在导航控制器下端 加一个playbar，切换到其他控制器中时也能显示

-(void)setupPlayBar{
    
    NKPlayBar *playBar = [NKPlayBar sharePlayBar];
    float w = playBar.bounds.size.width;
    float h = 44;
    float x = 0;
    float y = self.view.height -44;
    playBar.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:playBar];
    
}

//导航控制器隐藏
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if (self.topViewController != self.viewControllers[0]) {
        self.navigationBarHidden = NO;
    }
    
    
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

@end
