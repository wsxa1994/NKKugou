//
//  diantai2TableViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/10/19.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "diantai2TableViewController.h"
#import "AFNetworking.h"
#import "NKMusicModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MJRefresh.h"
#import "UIAlertView+AFNetworking.h"
#import "NKPlayerTool.h"
#import "NKPlaylistTool.h"
#import "NKdiantaiChannel.h"
#import "NKDiantaiPlayTableViewCell.h"
#import "AFNetworking.h"
#import "UIProgressView+AFNetworking.h"
#import "UIView+NKMoreAttribute.h"
#import "NKLoadMusicModel.h"
@interface diantai2TableViewController ()<UITableViewDataSource,UITableViewDelegate,NKDiantaiPlayTableViewCellDelegate>{
    NSMutableArray *_diantai2MusicListArray;
    NSURLSessionDownloadTask *_downloadTask;
    

}

@end
static diantai2TableViewController * tool;
@implementation diantai2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _channel.name;
    _diantai2MusicListArray = [NSMutableArray array];
    [self setupRefresh];
    
    self.tableView. rowHeight = 60;

}
- (void)refreshAction
{
    [self webRequest];
    [self.refreshControl endRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicNotify:) name:@"playMusic" object:nil];
    
    // 音乐播放来源修改成电台
    [NKPlayerTool shareNKPlayerTool].musicSource = kmusicSourceDiantai;
    
    [self webRequest];
    
    
}

-(void)playMusicNotify:(NSNotification*)notify{
    //根据当前播放的歌曲切换到对应的cell
    //让tableview选中抹一行 具体所在行有当前歌曲决定，所在的组从0开始
    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicIndxe inSection:0];
    //切换到指定的indexpath行
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    // 音乐播放来源修改成本地
    [NKPlayerTool shareNKPlayerTool].musicSource = kmusicSourceLocal;
    //移除音乐播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)webRequest
{
//    [_diantai2MusicListArray removeAllObjects];
    //网络请求
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"app_name":@"radio_desktop_win",
                                 @"version":@100,
                                 @"channel":_channel.channel_id,
                                 @"type":@"n"
                                 
                                 };
    [manage GET:@"http://www.douban.com/j/app/radio/people" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray * tmpArray = responseObject[@"song"];
        
        [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            NKMusicModel  * model = [NKMusicModel diantaiMusicModeWithDic:dict];
            
            [_diantai2MusicListArray addObject:model];
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView  showAlertViewForRequestOperationWithErrorOnCompletion:operation delegate:self];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _diantai2MusicListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NKDiantaiPlayTableViewCell *cell = [NKDiantaiPlayTableViewCell diantaiPlayCellWithTableViewCell:tableView];
    cell.delegate = self;

    
    NKMusicModel* model =  _diantai2MusicListArray[indexPath.row];
    
    cell.model = model;
    
    
    

//    cell.textLabel.text = model.name;
//    cell.detailTextLabel.text = model.singer;
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    return cell;
    
}
-(void)downLoad:(NKMusicModel *)model{

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:model.musicURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
    
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
      
        model.musicURL = [filePath path];
        NSLog(@"url%@",model.musicURL);

    }];
          _downloadTask = downloadTask;
    NKLoadMusicModel * loadModel = [[NKLoadMusicModel alloc]init];
    loadModel.mode = model;
    loadModel.downloadTask = downloadTask;
    loadModel.manager = manager;
    //loadModel.progress = progress;
    [[NKPlaylistTool sharedNKPlaylistTool].loadMuiscList addObject:loadModel];
    
    
    

    


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList = _diantai2MusicListArray;

    [[NKPlayerTool shareNKPlayerTool]playMusic: _diantai2MusicListArray[indexPath.row]];
}

-(void)diantaiPlayCell:(NKDiantaiPlayTableViewCell *)tablrViewCell btnClick:(UIButton *)btn{

    //进行下载

    [self downLoad:tablrViewCell.model];

}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //    [_diantai2MusicListArray removeAllObjects];
    //网络请求
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"app_name":@"radio_desktop_win",
                                 @"version":@100,
                                 @"channel":_channel.channel_id,
                                 @"type":@"n"
                                 
                                 };
    [manage GET:@"http://www.douban.com/j/app/radio/people" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray * tmpArray = responseObject[@"song"];
        
        [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            NKMusicModel  * model = [NKMusicModel diantaiMusicModeWithDic:dict];
            
            [_diantai2MusicListArray addObject:model];
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView  showAlertViewForRequestOperationWithErrorOnCompletion:operation delegate:self];
    }];


    [self.tableView headerEndRefreshing];
    
}

- (void)footerRereshing
{
    NSLog(@"footerRe");
    [self.tableView footerEndRefreshing];
    
}




@end
