//
//  singerViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/10/19.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "singerViewController.h"
#import "AFNetworking.h"
#import "NKMusicModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#define kSearchMusicURL @"https://api.douban.com/v2/music/search"
@interface singerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray * _webMusicListArray;
    NSString *_searchtext;


}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation singerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"歌手";
    _webMusicListArray = [NSMutableArray array];
    [self setupRefresh];
    _searchtext = @"刘德华";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _webMusicListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"geshou";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //UI  下拉上拉刷新 必须用tableView
    //
    
    //data
    NKMusicModel *model = _webMusicListArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.singer;
    NSURL * url = [NSURL URLWithString:model.imgURL];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];


    
    //设置 cell
    
    return cell;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchtext = searchBar.text;

    AFHTTPRequestOperationManager *manage = [[AFHTTPRequestOperationManager alloc]init];
    NSString *start = [NSString stringWithFormat:@"%li",_webMusicListArray.count];
    NSDictionary *paramenters = @{ @"q":searchBar.text,
                                   @"start":start,
                                   @"count":@1
                                   };
    [manage GET:kSearchMusicURL parameters:paramenters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject[@"musics"]);
        NSArray *tempArray = responseObject[@"musics"];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL *stop) {
             NSLog(@"%@",responseObject[@"musics"]);

//        NSLog(@"title is %@",dict[@"title"]);
        //NSLog(@"attrs is %@",dict[@"attrs"][@"singer"][0]);
//        NSLog(@"image is %@",dict[@"image"]);
        //网络音乐模型
            NKMusicModel *model = [NKMusicModel WebMusicModeWithDic:dict];
            [_webMusicListArray addObject:model];

        }];
        //刷新tableView
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
}
/**
 *  集成刷新控件
 */
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
    AFHTTPRequestOperationManager *manage = [[AFHTTPRequestOperationManager alloc]init];
    NSString *start = [NSString stringWithFormat:@"%li",_webMusicListArray.count];
    NSDictionary *paramenters = @{ @"q":_searchtext,
                                   @"start":start,
                                   @"count":@5
                                   };
    [manage GET:kSearchMusicURL parameters:paramenters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@",responseObject[@"musics"]);
        NSArray *tempArray = responseObject[@"musics"];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL *stop) {
                    NSLog(@"title is %@",dict[@"title"]);
            //        NSLog(@"attrs is %@",dict[@"attrs"][@"singer"][0]);
            //        NSLog(@"image is %@",dict[@"image"]);
            //网络音乐模型
            NKMusicModel *model = [NKMusicModel WebMusicModeWithDic:dict];
            [_webMusicListArray addObject:model];
            
        }];
        //刷新tableView
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

    NSLog(@"headerRe");
        [self.tableView headerEndRefreshing];

}

- (void)footerRereshing
{
    NSLog(@"footerRe");
        [self.tableView footerEndRefreshing];

}




@end
