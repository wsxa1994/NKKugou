//
//  bendiViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/17.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "bendiViewController.h"
#import "NKLocalTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "NSArray+NKPlist.h"
#import "NKMusicModel.h"
#import "NKPlayerTool.h"
#import "NKPlaylistTool.h"
#import "UIBarButtonItem+NKBarItem.h"
#import "NKPlayBar.h"
#import "NKEditBar.h"
#import "NKEditBarItem.h"
#import "KxMenu.h"
#import "NKGeciViewController.h"

//2015.09.22 封装播放列表工具 begin
//2015.09.22 封装播放列表工具 end
@interface bendiViewController ()<UITableViewDataSource,UITableViewDelegate,NKLocMusicTableViewCellDelegate>
{
//    AVAudioPlayer *_audioPlayer;
    //2015-09-24 自定义编辑栏 begin
    NKEditBar *_editBar;
    BOOL _isEditBarShow; //隐藏和现实editbar
    //2015-09-24 自定义编辑栏 end
    
}


//音乐music的封装
//@property (strong,nonatomic)NSMutableArray *LocMusicModelList;
//
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong,nonatomic) NSArray *localMusicList;
@property (weak,nonatomic)UIImageView *img;
@end

@implementation bendiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [img setImage:[UIImage imageNamed:@"hehe"]];
   
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _img = img;
    [self.view addSubview:img];

    img.userInteractionEnabled = YES;
    [_img addSubview:_tableView];
    [_tableView setBackgroundColor:[UIColor clearColor]];
 
    //2015.9.22 自定义导航栏 begin
    [self setupNavBar];
    //2015.9.22 自定义导航栏 end
    //    [self loadLocMusicList];
    //2015.9.23 playbar 和tableview  交互通知使用begin
    
    //注册接受新的播放歌曲的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicNotify:) name:@"playMusic" object:nil];
    //2015.9.23 playbar 和tableview  交互通知使用end
    
    //2015-09-24 自定义编辑栏 begin
    // 设置编辑栏
    [self setupEditBar];
    //2015-09-24 自定义编辑栏 end
    _tableView.separatorColor = [UIColor clearColor];
  
    
}
#pragma  mark 设置编辑栏
-(void)setupEditBar{
    NKEditBarItem *btn1 = [NKEditBarItem editBarItemWithImage:@"loop-2x" title:@"模式" target:self action:@selector(modeSel:)];
    NKEditBarItem *btn2 = [NKEditBarItem editBarItemWithImage:@"allcheck-2x" title:@"全选" target:self action:@selector(allCheck:)];
    NKEditBarItem *btn3 = [NKEditBarItem editBarItemWithImage:@"reload-2x" title:@"加载" target:self action:@selector(loadLocList)];
    NKEditBarItem *btn4 = [NKEditBarItem editBarItemWithImage:@"trash-2x" title:@"删除" target:self action:@selector(deleteList)];
    NSArray *editItems = @[btn1,btn2,btn3,btn4];
    NKEditBar *editBar = [NKEditBar editBarWithItems:editItems];
    _editBar = editBar;
    CGRect tempFrame = editBar.frame;
    tempFrame.origin.x = 0;
    tempFrame.origin.y = [UIScreen mainScreen].applicationFrame.size.height + 22;
    editBar.frame = tempFrame;
    [self.view addSubview:editBar];
    _isEditBarShow = NO;
    
}
#pragma mark 模式选择
-(void)modeSel:(UIButton *)sender{
    NSLog(@"mode sel");
    //2015-9-28 开源代码集成 begin
    [self showMenu:sender];
    //2015-9-28 开源代码集成 end
}
#pragma mark 全部选择
-(void)allCheck:(UIButton *)btn{
    NSLog(@"all check");
    //2015.9.24编辑栏子功能实现：全选 begin
    btn.selected = !btn.selected;
    
    [[NKPlaylistTool sharedNKPlaylistTool]allCheck:btn.selected];
    [_tableView reloadData];
    //2015.9.24编辑栏子功能实现：全选 end
}

#pragma mark 加载本地音乐
-(void)loadLocList{
    NSLog(@"load local music list");
    //2015-09-28 音乐模型归档 begin
    [[NKPlaylistTool sharedNKPlaylistTool]searchLocMusicList];
    [_tableView reloadData];
    //2015-09-28 音乐模型归档 end
    
}

#pragma mark 删除
-(void)deleteList{
    NSLog(@"delete selected music list");
    [[NKPlaylistTool sharedNKPlaylistTool]deleteMusicList];
    [_tableView reloadData];
}

//2015.9.23 playbar 和tableview  交互通知使用begin
-(void)playMusicNotify:(NSNotification*)notify{
    //根据当前播放的歌曲切换到对应的cell
    //让tableview选中抹一行 具体所在行有当前歌曲决定，所在的组从0开始
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicIndxe inSection:0];
    //切换到指定的indexpath行
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playMusic" object:nil];
}
//2015.9.23 playbar 和tableview  交互通知使用end
-(void)setupNavBar{
    self.navigationItem.title = @"我的音乐";
    UIBarButtonItem *editItem = [UIBarButtonItem barButtonItemWithNormalImage:@"pencil-2x" selectedImage:@"pencil-2x" target:self action:@selector(showEditBar:)];
    UIBarButtonItem *geciItem = [UIBarButtonItem barButtonItemWithNormalImage:@"musical-geci-2x" selectedImage:@"musical-geci-2x" target:self action:@selector(geciShow:)];
    NSArray *array = @[geciItem,editItem];
    self.navigationItem.rightBarButtonItems = array;

  
    
}

-(void)geciShow:(UIButton *)btn{
    [self performSegueWithIdentifier:@"togeci" sender:self];
    
}
//切换到新界面前要重写这个方法
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    segue.sourceViewController - 源控制器
//    segue.destinationViewController - 目标控制器
    NKGeciViewController *geciVC = (NKGeciViewController*)segue.destinationViewController;
    geciVC.geciName = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic.geci;
    

}
//设置editbar的初始位置
-(void)showEditBar:(UIBarButtonItem *)item{
    _isEditBarShow =! _isEditBarShow;
    if (_isEditBarShow) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect frame = _editBar.frame;
            frame.origin.y = frame.origin.y - 44;
            _editBar.frame = frame;
            [NKPlayBar sharePlayBar].hidden= YES;
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect frame = _editBar.frame;
            frame.origin.y = frame.origin.y + 44;
            _editBar.frame = frame;
        } completion:^(BOOL finished){
            
            [NKPlayBar sharePlayBar].hidden = NO;
        }];
        
    }
    
}

//2015.09.22 封装播放列表工具 begin
//-(void)loadLocMusicList
//{
    //    _localMusicList= [NSArray arrayWithPlist:@"localMusic.plist"];
    //    //给NSmutablearray初始化并分配空间
    //    _LocMusicModelList= [NSMutableArray array];
    //    for (NSDictionary * dict in _localMusicList) {
    //        //把字典转换成模型
    //        NKMusicModel * musicModel = [NKMusicModel musicModeWithDic:dict];
    //        [_LocMusicModelList addObject:musicModel];
    //    }
    //}
//懒加载
//-(NSArray *)localMusicList{
    //
    //
    //    _localMusicList = [NSArray arrayWithPlist:@"localMusic.plist"];
    //    return _localMusicList;
    //}



//2015-09-28 音乐模型归档 begin
#pragma mark 对本地音乐列表进行加载 从其所对应的归档文件中读取音乐模型
-(void)viewWillAppear:(BOOL)animated
{
    [[NKPlaylistTool sharedNKPlaylistTool]getCurPlayMusicListFromDocument:@"locMusicList.data"];
//    [[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList removeObject:[NKPlaylistTool sharedNKPlaylis];
    
}

//2015-09-28 音乐模型归档 end

    //2015.09.22 封装播放列表工具 begin
#pragma mark 若本地音乐消失 则把playbar状态显示显示
-(void)viewWillDisappear:(BOOL)animated{
    [NKPlayBar sharePlayBar].hidden = NO;
    //2015-09-28 音乐模型归档 begin
    [[NKPlaylistTool sharedNKPlaylistTool]saveCurPlayMusicListToDocument:@"locMusicList.data"];
    //2015-09-28 音乐模型归档 end

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    //1. 获取歌曲资源
    //    NSDictionary *dict = _localMusicList[indexPath.row];
    ////    NSString *dict = _localMusicList[indexPath.row];
    //    NSString *musicname = dict[@"name"];
    //    // 那么厚没有 mp3 需要进行字符串拼接
    //    musicname = [musicname stringByAppendingString:@".mp3"];
    //    //2. 播放歌曲
    //    NSURL *url = [[NSBundle mainBundle]URLForResource:musicname withExtension:nil];
    //    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //    //播放前做一个缓存
    //    [_audioPlayer prepareToPlay];
    //    [_audioPlayer play];
    
    //2015.09.22 封装播放列表工具 begin
    //2015.09.22 封装工具类 begin
    //[[NKPlayerTool shareNKPlayerTool]playMusic:_LocMusicModelList[indexPath.row]];
    //2015.09.22 封装工具类 end
    
    //通知做的
    
    [[NKPlayerTool shareNKPlayerTool] playMusic:[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[indexPath.row]];
    
    
    [NKPlayBar sharePlayBar].progess.progress = 0;
    [NKPlayBar sharePlayBar].curTime = 0;

  
    
    //单例做的：
    
    //    NKMusicModel * musicModel = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[indexPath.row];
    //    [[NKPlayerTool shareNKPlayerTool] playMusic:musicModel];
    //    [NKPlayBar sharePlayBar].singerLabel.text = musicModel.singer;
    //    [NKPlayBar sharePlayBar].musicLabel.text = musicModel.name;
    //    [NKPlayBar sharePlayBar].btn.selected = YES;
    //    NSLog(@"%@",musicModel.name);
    
    
    
    //     NKMusicModel *nextMusic = [NKPlaylistTool sharedNKPlaylistTool].nextPlayMusic;
    //
    //    [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic = nextMusic;
    //2015.09.22 封装播放列表工具 begin
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //音乐music的封装
    //    return self.LocMusicModelList.count;
    
    
    //2015.09.22 封装播放列表工具 begin
    return [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList.count;
    //2015.09.22 封装播放列表工具 end
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        //删除行的同时需要把数据模型同时删除
 
    [[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList removeObjectAtIndex:indexPath.row];
        //删除当前行的操作 不改变当前行以上的行数  但行数必须与数据模型保持一致
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NKLocalTableViewCell *cell = [NKLocalTableViewCell localTableViewCellWithTableView :tableView];
    cell.delegete = self;

    
    //    NSDictionary *musicDic = self.localMusicList[indexPath.row];
//        cell.musicNameLabel.text = musicDic[@"name"];
    cell.musicNameLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //音乐music的封装
    NKMusicModel *musicModel = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[indexPath.row];    //_LocMusicModelList[indexPath.row];
    cell.musicNameLabel.text = musicModel.name;
    
  
    cell.leftBtn.selected = musicModel.willBeDelete;
    cell.indexPath = indexPath;
    
    
    //2015 - 9 - 29自定义编辑栏 begin
    cell.rightBtn.selected = musicModel.editBarShow;
    //2015 - 9 - 29自定义编辑栏 end
    
    //2015－09-29 自定义cell编辑栏实现 begin
    //初始状态设为隐藏
    cell.editBar.hidden = !musicModel.editBarShow;
    //2015－09-29 自定义cell编辑栏实现 end
    
    return cell;
    
}

#pragma mark 本地音乐cell的代理放大，用于cell的editbar显示隐藏时更新tableview
-(void)locMusicTableViewCell:(NKLocalTableViewCell *)tableViewCell didUpdateTableView:(NSIndexPath *)indexPath{
    [_tableView reloadData];
}
#pragma mark 自定义编辑栏高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   //设置cell高度
    NKMusicModel *mode = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList[indexPath.row];
    return mode.iseditBarShow?(2*44):(44);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//2015-9-28 开源代码集成 begin
- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"全部循环"
                     image:[UIImage imageNamed:@"loop-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"随机循环"
                     image:[UIImage imageNamed:@"random-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      
      [KxMenuItem menuItem:@"顺序播放"
                     image:[UIImage imageNamed:@"seqence-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
            ];
    
//修正显示位置
    CGRect frame = sender.frame;
    frame.origin.y = self.view.frame.size.height - sender.frame.size.height;
    
    [KxMenu setTintColor:[UIColor yellowColor]];
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
//    NSLog(@"%@", sender);
    NSDictionary *dict = @{@"全部循环":@0,@"随机循环":@1,@"顺序播放":@2};
    NSInteger index = [dict[sender.title] integerValue];
    [NKPlaylistTool sharedNKPlaylistTool].playMode = (PlayMode)index;
}
//2015-9-28 开源代码集成 begin



@end
