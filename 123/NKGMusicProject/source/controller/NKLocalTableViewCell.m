//
//  NKLocalTableViewCell.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKLocalTableViewCell.h"
#import "UIButton+MKImage.h"
#import "UIView+NKMoreAttribute.h"
#import "NKPlaylistTool.h"
#import "NKMusicModel.h"
#import "NKEditBarItem.h"
#import "NKEditBar.h"
@implementation NKLocalTableViewCell
- (void)awakeFromNib {
    // Initialization code
}


+(instancetype)localTableViewCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"NKLocalTableViewCell1";
    NKLocalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NKLocalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
//自定义 cell 需要重写由于使用了initwithstyle

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setuoContenView];
    }
    return self;
}
#pragma mark 自定义caontentview
-(void)setuoContenView{
    
    
    UIButton *leftBtn = [UIButton buttonWithNormalImage:@"all_favorite_btn_check_on_default" selectedImage:@"all_favorite_btn_check_on_pressed" target:self action:@selector(leftBtnClick:)] ;
    _leftBtn = leftBtn;
    leftBtn.frame = CGRectMake(0, 0,self.height, self.height) ;
    [self.contentView addSubview:leftBtn];
    //2015-9-24 cell重复利用问题 begin
//    _leftButton = leftBtn;
    //2015-9-24 cell重复利用问题 end
    
    //2 label 负责显示歌名歌手
    UILabel *singerLabel = [[UILabel alloc]init];
    singerLabel.frame = CGRectMake(leftBtn.right, 0, self.width - 2*(leftBtn.width) ,self.height);
    [self.contentView addSubview:singerLabel];
    _musicNameLabel = singerLabel;
    
    //3 button 负责下拉菜单 两种状态
    UIButton *rightBtn = [UIButton buttonWithNormalImage:@"arrow_down" selectedImage:@"arrow_up" target:self action:@selector(rightBtnClick:)] ;
    
    rightBtn.frame = CGRectMake(self.width - self.height, 0,self.height, self.height) ;
    //    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:rightBtn];

    [self setupEditBar];
    
}
#pragma  mark 设置编辑栏
-(void)setupEditBar{
    NKEditBarItem *btn1 = [NKEditBarItem editBarItemWithImage:@"heart-2x" title:@"我喜欢" target:self action:@selector(myLoveList)];
    NKEditBarItem *btn2 = [NKEditBarItem editBarItemWithImage:@"allcheck-2x" title:@"收藏" target:self action:@selector(saveList)];

    NKEditBarItem *btn3 = [NKEditBarItem editBarItemWithImage:@"trash-2x" title:@"删除" target:self action:@selector(deleteMusic)];

    NKEditBarItem *btn4 = [NKEditBarItem editBarItemWithImage:@"info-2x" title:@"信息" target:self action:@selector(showInfo)];

    NSArray *editItems = @[btn1,btn2,btn3,btn4];
    NKEditBar *editBar = [NKEditBar editBarWithItems:editItems];
    _editBar = editBar;
    editBar.frame = CGRectMake(0, _leftBtn.bottom, self.width, self.height);
    [self.contentView addSubview:editBar];
}
#pragma mark 将对应歌曲添加到我喜欢列表
-(void)myLoveList{
    NSLog(@"my Love List");
}
#pragma mark 将对应歌曲添加到收藏列表
-(void)saveList{
    NSLog(@"save List");
}
#pragma mark 将对应歌曲添加到删除列表
-(void)deleteMusic{
    
    NKMusicModel *mode = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[_indexPath.row];
    [[NKPlaylistTool sharedNKPlaylistTool]deleteOneMusicFromLocList:mode];
    if ([_delegete respondsToSelector:@selector(locMusicTableViewCell:didUpdateTableView:)]) {
        [_delegete locMusicTableViewCell:self didUpdateTableView:_indexPath];
    }
  
    NSLog(@"delete Music");
}
#pragma mark 显示歌曲信息
-(void)showInfo{
    NSLog(@"show Info");
    NKMusicModel *mode = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[_indexPath.row];
    NSMutableString *infoStr = [NSMutableString string ];
    [infoStr appendString:mode.name];
    [infoStr appendString:@"\n"];
    [infoStr appendString:mode.singer];
    [infoStr appendString:@"\n"];
    [infoStr appendString:mode.time];
    
    UIAlertView *infoView = [[UIAlertView alloc]initWithTitle:@"歌曲信息" message:infoStr delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [infoView show];
    

    
    
}
#pragma mark 响应左侧按钮响应函数
-(void)leftBtnClick:(UIButton*)btn{
    NSLog(@"adssad");
    btn.selected =! btn.selected;
    //2015-9-24 cell重复利用问题 begin
    NKMusicModel *mode = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[_indexPath.row];
    mode.willBeDelete = btn.selected;
    //2015-9-24 cell重复利用问题 end
    
}
#pragma mark 响应右侧按钮响应函数

-(void)rightBtnClick:(UIButton*)btn{
    NSLog(@"adssad");
    NKMusicModel *mode = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[_indexPath.row];
    mode.editBarShow = btn.selected;
    btn.selected =! btn.selected;
    _editBar.hidden = !_editBar.hidden;
    //2015－09-29 自定义cell编辑栏实现 begin
    //3-3 根据具体条件调用代理方法
    if ([_delegete respondsToSelector:@selector(locMusicTableViewCell:didUpdateTableView:)]) {
        [_delegete locMusicTableViewCell:self didUpdateTableView:_indexPath];
    }
    //2015－09-29 自定义cell编辑栏实现 end
    

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
