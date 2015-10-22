//
//  UIViewController+NKStoryBoard.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/17.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIViewController+NKStoryBoard.h"

@implementation UIViewController (NKStoryBoard)
+(instancetype)viewControllerWithStroyBoardID:(NSString *)storyBoardID{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:storyBoardID];
    return vc;
    
}
@end
