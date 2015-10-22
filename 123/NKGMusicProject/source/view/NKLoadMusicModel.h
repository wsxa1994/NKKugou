//
//  NKLoadMusicModel.h
//  NKGMusicProject
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"
#import "AFNetworking.h"
@interface NKLoadMusicModel : NSObject
@property(nonatomic,strong)NKMusicModel *mode;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask ;
@property(nonatomic,strong)AFURLSessionManager *manager;

@end
