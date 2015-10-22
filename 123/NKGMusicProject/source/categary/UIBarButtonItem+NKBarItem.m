//
//  UIBarButtonItem+NKBarItem.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIBarButtonItem+NKBarItem.h"
#import "UIButton+MKImage.h"
@implementation UIBarButtonItem (NKBarItem)
+(instancetype)barButtonItemWithNormalImage:(NSString *)normal selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action{

    UIButton *btn = [UIButton buttonWithNormalImage:normal selectedImage:selectedImage target:target action:action];
    btn.bounds = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
@end
