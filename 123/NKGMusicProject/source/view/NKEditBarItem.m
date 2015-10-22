//
//  NKEditBarItem.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/24.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKEditBarItem.h"

@implementation NKEditBarItem

+(instancetype)editBarItemWithImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action{

    NKEditBarItem *item = [[NKEditBarItem alloc]init];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    item.titleLabel.textAlignment = NSTextAlignmentCenter;
    item.titleLabel.font = [UIFont systemFontOfSize:15];
    
    item.imageView.contentMode = UIViewContentModeCenter;
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

#pragma mark 自定义button title 的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height/4;
    CGFloat x = 0;
    CGFloat y = contentRect.size.height *3/4 - 5;
    CGRect rect = CGRectMake(x, y, w, h);
    return rect;

}
#pragma mark 自定义button image 的位置

-(CGRect)imageRectForContentRect:(CGRect)contentRect{

    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height *3/4 - 2;
    CGFloat x = 0;
    CGFloat y = 0;
    CGRect rect = CGRectMake(x, y, w, h);
    return rect;
}
@end
