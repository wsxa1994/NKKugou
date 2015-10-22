//
//  NKLodManageCell.h
//  NKGMusicProject
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKMusicModel.h"
#import "NKLoadMusicModel.h"
@class NKLodManageCell;

@protocol NKLoadManageCellDelegate <NSObject>
@optional
-(void)loadManageCell:(NKLodManageCell*)tableViewCell btnClick:(UIButton*)btn;


@end
@interface NKLodManageCell : UITableViewCell
@property (weak, nonatomic) UILabel* musicNameLabel;

@property (weak, nonatomic)  UIButton* loadButton;
@property(nonatomic,weak)UIProgressView* progressView;


@property(nonatomic,strong)NKLoadMusicModel* model;

@property (assign,nonatomic,getter=isDownLoading) BOOL downLoading ;

+(instancetype)loadManageWithTableView:(UITableView*)tableView;

//2.属性中声明代理实例
@property (strong, nonatomic) id<NKLoadManageCellDelegate> delegate;
@end
