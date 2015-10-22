//
//  NKDownLoadTableViewController.m
//  NKGMusicProject
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKDownLoadTableViewController.h"
#import "NKPlayerTool.h"
#import "NKPlaylistTool.h"
#import "NKLodManageCell.h"
#import "NKLoadMusicModel.h"
#import "UIProgressView+AFNetworking.h"


@interface NKDownLoadTableViewController ()<NKLoadManageCellDelegate>

@end

@implementation NKDownLoadTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];

}




#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [NKPlaylistTool sharedNKPlaylistTool].loadMuiscList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    NKLodManageCell * cell = [NKLodManageCell  loadManageWithTableView:tableView];
    NKLoadMusicModel *model =  [NKPlaylistTool sharedNKPlaylistTool].loadMuiscList[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
//下载 暂停
static NSData * loadData;
- (void)loadManageCell:(NKLodManageCell *)tableViewCell btnClick:(UIButton *)btn
{
    tableViewCell.downLoading = !tableViewCell.downLoading;
    if ( tableViewCell.isDownLoading == YES) {
        [tableViewCell.model.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSLog(@"pause");
            loadData = resumeData;
            // NSLog(@"%@",resumeData);
            
        }];
        
    }
    else
    {
        NSLog(@"resume");
        // NSLog(@"%@",loadData);
        //   NSProgress * progress = [[NSProgress alloc]init];;
        tableViewCell.model.downloadTask =
        [tableViewCell.model.manager downloadTaskWithResumeData:loadData progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            tableViewCell.model.mode.musicURL = [filePath path];
            
        }];
        
        [tableViewCell.progressView setProgressWithDownloadProgressOfTask:tableViewCell.model.downloadTask animated:YES];
        [tableViewCell.model.downloadTask resume];
    }
}




@end
