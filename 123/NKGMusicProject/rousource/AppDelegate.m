//
//  AppDelegate.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "AppDelegate.h"
#import "NKPlaylistTool.h"
#import "UIViewController+NKStoryBoard.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //2015.09.22 封装播放列表工具 begin
    //搜索并创建所有本地音乐列表
    [self searchAllMusicList];
    //2015.09.22 封装播放列表工具 begin
    //版本信息的判断，根据版本号启动控制器
    [self startViewControllerByVersion];
    return YES;
}

//2015.09.22 封装播放列表工具 begin
-(void)searchAllMusicList{
    //搜索并创建所有本地音乐列表
    [[NKPlaylistTool sharedNKPlaylistTool]searchLocMusicList];
}
//2015.09.22 封装播放列表工具 end





#pragma mark 根据版本号启动控制器
-(void)startViewControllerByVersion{
    //1. 取得旧版本的信息
    NSString *oldBundleVersion = [[NSUserDefaults standardUserDefaults]valueForKey:(NSString *)kCFBundleVersionKey];
    
    
    //2. 取得新版本信息
    NSDictionary *infonDict = [[NSBundle mainBundle]infoDictionary];
    NSString *bundleVersion = [infonDict objectForKey:(NSString *)kCFBundleVersionKey];
    
    
    //3. 若有变化则启动新特性界面，否则启动主页面
    if ( ![oldBundleVersion isEqualToString:bundleVersion]) {
        //启动新特性页面
        
        UIViewController *newFeature = [UIViewController viewControllerWithStroyBoardID:@"NKGNewFutureViewController1" ];
        self.window.rootViewController = newFeature;
        [[NSUserDefaults standardUserDefaults]setValue:bundleVersion forKey:(NSString*)kCFBundleVersionKey];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        UIViewController *newFeature = [UIViewController viewControllerWithStroyBoardID:@"NKNavigationController1" ];
        self.window.rootViewController = newFeature;
        [[NSUserDefaults standardUserDefaults]setValue:bundleVersion forKey:(NSString*)kCFBundleVersionKey];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //启动主页面
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
 
    [[NKPlaylistTool sharedNKPlaylistTool]saveCurPlayMusicListToDocument:@"locMusicList.data"];
    //2015-09-28 音乐模型归档 end

    

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
