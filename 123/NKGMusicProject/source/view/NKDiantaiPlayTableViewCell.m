//
//  NKDiantaiPlayTableViewCell.m
//  NKGMusicProject
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKDiantaiPlayTableViewCell.h"
#import "diantai2TableViewController.h"
#import "NKMusicModel.h"
#import "UIImageView+WebCache.h"
@implementation NKDiantaiPlayTableViewCell

+(instancetype)diantaiPlayCellWithTableViewCell:(UITableView *)tableView{
    static NSString *ID = @"NKLocalTableViewCell1";
    NKDiantaiPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NKDiantaiPlayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setuoContenView];
    }
    return self;
}
#pragma mark 自定义caontentview
-(void)setuoContenView{
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"下载" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor greenColor]];
    [button addTarget:self action:@selector(loadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    _loadBtnClick = button;
  
    
    //2 label 负责显示歌名歌手
    UILabel *singerLabel = [[UILabel alloc]init];
    [self.contentView addSubview:singerLabel];
    singerLabel.font = [UIFont systemFontOfSize:13];
    _singerLabel = singerLabel;

    
    
    //3 button 负责下拉菜单 两种状态
    UILabel *musicLabelLabel = [[UILabel alloc]init];
    musicLabelLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:musicLabelLabel];
    _musicNameLabel = musicLabelLabel;
    
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [self.contentView addSubview:imgView];
    _imgView = imgView;
    
}
-(void)loadBtnClick:(UIButton*)btn{
    if ([_delegate respondsToSelector:@selector(diantaiPlayCell:btnClick:)]) {
        [_delegate diantaiPlayCell:self btnClick:btn];
    }

    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _imgView.frame = CGRectMake(0, 0, 44, 44);
    _musicNameLabel.frame = CGRectMake(50, 0, 300, 22);
    _singerLabel.frame = CGRectMake(50, 23, 300, 22);
    _loadBtnClick.frame = CGRectMake(260, 10,70, 20);
    

}

-(void)setModel:(NKMusicModel *)model{

    _model = model;
    _musicNameLabel.text = model.name;
    _singerLabel.text = model.singer;
    NSURL * url = [NSURL URLWithString:model.imgURL];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    
    

}




@end
