//
//  UIButton+MKImage.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MKImage)
// 按照image、名字返回设置的普通图和高亮状态
+(instancetype)buttonWithNormalImage:(NSString *)imageNormal heightedImage:(NSString *)imageHeighted target:(id)target action:(SEL)action;

+(instancetype)buttonWithNormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected target:(id)target action:(SEL)action;
@end
