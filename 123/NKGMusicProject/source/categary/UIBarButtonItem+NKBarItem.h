//
//  UIBarButtonItem+NKBarItem.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NKBarItem)
//2015 -09 -22 自定义导航栏 begin
+(instancetype)barButtonItemWithNormalImage:(NSString *)normal selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action;
//2015 -09 -22 自定义导航栏 end
@end
