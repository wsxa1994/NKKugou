//
//  NKPlayerTool.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"
typedef enum{
    kPlayerLoaded = 0,
     kPlayerPause,
     kPlayerPlaying

}PlayStatus;
//本地音乐  和  电台音乐
typedef enum musicSource{
    kmusicSourceLocal,
    kmusicSourceDiantai
}MusicSource;

@interface NKPlayerTool : NSObject
//封装工具类
//创建工具单例
+(instancetype)shareNKPlayerTool;
//播放音乐
-(void)playMusic:(NKMusicModel *)music;
//暂停音乐
-(void)pauseMusic;
//播放下一曲歌曲
-(void)playNextMusic;
//从暂停状态恢复 断点继续播放
-(void)resumeMusic;
//判断状态
@property (assign,nonatomic)PlayStatus status;
@property(assign,nonatomic)MusicSource musicSource;
@end
