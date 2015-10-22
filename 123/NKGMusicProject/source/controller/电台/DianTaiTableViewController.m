//
//  DianTaiTableViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/10/19.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "DianTaiTableViewController.h"
#import "AFNetworking.h"
#import "NKMusicModel.h"
#import "diantai2TableViewController.h"
#import "NKdiantaiChannel.h"
#define  kChannelURL @"http://www.douban.com/j/app/radio/channels"
@interface DianTaiTableViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *_channels;


}


@end

@implementation DianTaiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电台";
    
    _channels = [NSMutableArray array];
    
    // UIRefreshControl
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    //网络请求
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    [manage GET:kChannelURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject[@"channels"]);
        //tmpArray 全部频道
        NSArray * tmpArray = responseObject[@"channels"];
        
        [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            NKdiantaiChannel * channel = [NKdiantaiChannel diantaiChannelWithDictionary:dict];
            
            [_channels addObject:channel];
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _channels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"diantai";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NKdiantaiChannel* channel =  _channels[indexPath.row];
    
    
    cell.textLabel.text = channel.name;
//    cell.detailTextLabel.text = channel.channel_id;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到某个电台播放页面
    [self performSegueWithIdentifier:@"diantai2" sender:_channels[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NKdiantaiChannel *channel = sender;
    //titile
    diantai2TableViewController * vc =  segue.destinationViewController;
    
    vc.channel = channel;
}


@end
