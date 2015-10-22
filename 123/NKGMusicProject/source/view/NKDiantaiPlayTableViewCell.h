//
//  NKDiantaiPlayTableViewCell.h
//  NKGMusicProject
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class diantai2TableViewController;
@class NKDiantaiPlayTableViewCell;
@class NKMusicModel;

@protocol NKDiantaiPlayTableViewCellDelegate <NSObject>

@optional

-(void)diantaiPlayCell:(NKDiantaiPlayTableViewCell *)tablrViewCell btnClick:(UIButton *)btn;
@end


@interface NKDiantaiPlayTableViewCell : UITableViewCell
@property(weak,nonatomic)UILabel *musicNameLabel;
@property(weak,nonatomic)UILabel *singerLabel;
@property(weak,nonatomic)UIButton *loadBtnClick;
@property(weak,nonatomic)UIImageView *imgView;

@property(strong,nonatomic)NKMusicModel *model;



@property(strong,nonatomic)id<NKDiantaiPlayTableViewCellDelegate>delegate;
+(instancetype)diantaiPlayCellWithTableViewCell:(UITableView*)tableView;
@end