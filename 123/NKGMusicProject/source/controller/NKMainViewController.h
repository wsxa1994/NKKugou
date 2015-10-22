//
//  NKMainViewController.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKMainViewController : UIViewController
@property(nonatomic,strong) NSArray *myMusicListArray;
@property (nonatomic,weak)UITableViewCell *curselCell;//用于设置队选中的cell变色;
@end
