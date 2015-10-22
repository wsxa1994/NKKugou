//
//  NKLocalTableViewCell.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NKEditBar;
//2015－09-29 自定义cell编辑栏实现 begin
//通过代理实现：当点击cell右侧button时 刷新cell编辑栏高度
//3-1 声明代理 设计代理方法
//前置声明
@class  NKLocalTableViewCell;
@protocol NKLocMusicTableViewCellDelegate <NSObject>

-(void)locMusicTableViewCell:(NKLocalTableViewCell*)tableViewCell didUpdateTableView:(NSIndexPath*)indexPath;

@end
//2015－09-29 自定义cell编辑栏实现 end

@interface NKLocalTableViewCell : UITableViewCell
+(instancetype)localTableViewCellWithTableView :(UITableView *)tableView;
@property (nonatomic,weak)UILabel *musicNameLabel;
@property (nonatomic,weak)UIButton *leftBtn;
@property (nonatomic,weak)UILabel *singerLabel;
//2015-9-24 cell重复利用问题 begin
@property(strong,nonatomic)NSIndexPath *indexPath;
//@property(weak,nonatomic)UIButton *leftButton;

//2015-9-24 cell重复利用问题 end

@property (weak,nonatomic)NKEditBar *editBar;
@property (weak,nonatomic)UIButton *rightBtn;
//2015－09-29 自定义cell编辑栏实现 begin
//3-2 属性中声明代理实例
@property (weak,nonatomic)id<NKLocMusicTableViewCellDelegate>delegete;
//2015－09-29 自定义cell编辑栏实现 end
@end
