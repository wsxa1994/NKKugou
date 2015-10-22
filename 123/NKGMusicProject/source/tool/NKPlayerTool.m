//
//  NKPlayerTool.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NKPlaylistTool.h"
static NKPlayerTool *tool;
@interface NKPlayerTool(){
    AVAudioPlayer *_audioPlayer;
    MPMoviePlayerController * _player;
    
}
@end

@implementation NKPlayerTool

+(instancetype)shareNKPlayerTool{
//播放器工具实现单例，保证整个应用只有一个播放器工具
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[NKPlayerTool alloc]init];
    });
    return tool;

}
+(instancetype)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        tool = [super allocWithZone:zone];
    });
    return tool;
}
-(void)musicPlayEndAction:(NSNotification*)notify{
    NSLog(@"%@",notify);
    [self playNextMusic];

}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //进行下一首的切换
    [self playNextMusic];
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)playMusic:(NKMusicModel *)music{
    // MPMoviePlayerController
    //所有的播放音乐的处理都在此函数，就在此处更新当前播放的歌曲。
    //切记不要在什么地方点击播放，就在什么地方设置当前播放音乐，会导致
    //当前播放音乐的设置处过多，难以维护，可维护性差。
    
    //程序的健壮型，应该有义务对别人传进来的参数作判断，如果不合理的应该有相应的处理。
    if (music == nil) {
        return;
    }
    
    [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic = music;
    //注册音乐播放结束的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicPlayEndAction:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    NSURL * url ;
    if (_musicSource == kmusicSourceLocal) {
        //准备本地的播放url
        NSString* musicname = music.name;
        musicname = [musicname stringByAppendingPathExtension:@"mp3"];
        
        NSURL* localUrl = [[NSBundle mainBundle]URLForResource:musicname withExtension:nil];
        url = localUrl;
    }
    else
    {
        //准备电台的播放url
        url = [NSURL URLWithString:music.musicURL];
    }
    if (_player == nil) {
        MPMoviePlayerController* player = [[MPMoviePlayerController alloc]initWithContentURL:url];
        _player = player;
    }
    else{
        [_player setContentURL:url];
    }
    [_player play];
    //设置系统状态为播放音乐
    _status = kPlayerPlaying;
    //发送开始播放音乐的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playMusic" object:self];
}
#pragma mark 暂停音乐
-(void)pauseMusic{
    //当前播放器如果时播放状态，暂停
    //    if ([_audioPlayer isPlaying]) {
    //        [_audioPlayer pause];
    //        _status = kPlayerPause;
    //    }
    if (_status == kPlayerPlaying  ) {
        [_player pause];
        _status = kPlayerPause;
        
    }
}
#pragma mark 从暂停状态恢复播放，断点继续播放
-(void)resumeMusic{
    //当播放器不是处在播放状态时，从断点开始播放
    //    if (![_audioPlayer isPlaying]) {
    //        [_audioPlayer prepareToPlay];
    //        [_audioPlayer play];
    //        _status = kPlayerPlaying;
    //    }
    
    if (_status == kPlayerPause) {
        //  [_audioPlayer prepareToPlay];
        [_player play];
        _status = kPlayerPlaying;
    }
}
#pragma mark 播放下一曲
-(void)playNextMusic{
    [self playMusic:[NKPlaylistTool sharedNKPlaylistTool].nextPlayMusic];
}
@end

