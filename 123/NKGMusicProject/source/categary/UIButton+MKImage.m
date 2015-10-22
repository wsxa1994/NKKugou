//
//  UIButton+MKImage.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIButton+MKImage.h"

@implementation UIButton (MKImage)

+(instancetype)buttonWithNormalImage:(NSString *)imageNormal heightedImage:(NSString *)imageHeighted target:(id)target action:(SEL)action{

    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageHeighted] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//选中

+(instancetype)buttonWithNormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}



@end
