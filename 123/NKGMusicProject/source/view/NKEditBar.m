//
//  NKEditBar.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/24.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKEditBar.h"
#import "UIView+NKMoreAttribute.h"
@implementation NKEditBar

//2015-09-24 自定义编辑栏 begin
// 具备可重用性和自适应性 （buttonitem的个数可变）
+(instancetype)editBarWithItems:(NSArray *)items{
    NKEditBar *editBar = [[NKEditBar alloc]init];
    editBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width,44);
//    editBar.bounds = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width,44);
  [editBar setupItems:items];
    editBar.alpha = 0.8;
    return editBar;
}
#pragma mark 设置BarItem的个数，数量由用户指定

-(void)setupItems:(NSArray*)items{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w =self.width/items.count;
    CGFloat h = 44;
    for (int i = 0; i < items.count; i++) {
        x = i*w;
        UIButton *btn = items[i];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, w, h);
        [self addSubview:btn];
    }
}
//2015-09-24 自定义编辑栏 end

@end
