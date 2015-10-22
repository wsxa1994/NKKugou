//
//  NKPlayBar.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKPlayBar.h"
#import "UIView+NKMoreAttribute.h"
#import "UIButton+MKImage.h"
#import "NKPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import "NKMusicModel.h"
#import "NSArray+NKPlist.h"
#import "NKPlaylistTool.h"
#import "diantai2TableViewController.h"
#import "UIImageView+WebCache.h"
//2015.9.23 音乐播放标签同步 begin




//static CGFloat curTime = 0;
static CGFloat totalTime = 0;
//2015.9.23 音乐播放标签同步 end
static NKPlayBar *playBar;
//2015-9-29歌词界面实现 begin
static NSInteger geciIndex = 0;
//2015-9-29歌词界面实现 end

#define screenWidth [UIScreen mainScreen].applicationFrame.size.width
#define screenHeight [UIScreen mainScreen].applicationFrame.size.height
#define  KImageWidthRation 44/320
#define  KImageHeightRation 44/568
@interface NKPlayBar (){
    
    //    NKMusicModel *_defaultMusic;
    //2015.9.23 音乐播放标签同步 begin
    
    //2015.9.23 音乐播放标签同步 end
    
    
    //2015-9-29歌词界面实现 begin
    NSArray *_timeArray;
    
    //2015-9-29歌词界面实现 end
    
}
@end

@implementation NKPlayBar

+(instancetype)sharePlayBar{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playBar = [[NKPlayBar alloc]init];
        //        NKPlayBar *playBar = [NKPlayBar sharePlayBar];
        playBar.bounds = CGRectMake(0, 0, screenWidth, screenHeight *KImageHeightRation);
        //        UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        //        [window addSubview:playBar];
        
    });
    return playBar;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playBar = [super allocWithZone:zone];
    });
    return playBar;
}
//+(instancetype)playBar{
    //    NKPlayBar *playBar = [[NKPlayBar alloc]init];
    //    NKPlayBar *playBar = [NKPlayBar sharePlayBar];
    //    playBar.bounds = CGRectMake(0, 0, screenWidth, screenHeight *KImageHeightRation);
    //    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    [window addSubview:playBar];
    //    return playBar;
//}
-(instancetype)init{
    
    if (self = [super init]) {
        //加载子控件
        [self setupSubViews];
        
    }
    //2015.9.23 音乐播放标签同步 begin
    //注册接受playmusic播放音乐的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivePlayMusicNotify:) name:@"playMusic" object:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    //2015.9.23 音乐播放标签同步 end
    
    
    

    return self;
}



//2015.9.23 音乐播放标签同步 begin
#pragma mark 接受playMusic通知更新歌曲信息


-(void)receivePlayMusicNotify:(NSNotification *)notify{
    [self updataMusicInfoLabel];
    //2015-9-29歌词界面实现 begin
    _timeArray = [[NSArray alloc]init];
    _timeArray = [NKPlaylistTool sharedNKPlaylistTool].curGeciDict[@"time"];
    geciIndex = 0;
    //2015-9-29歌词界面实现 end
}


// 通知之后删除 否则会有内存泄漏
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"playMusic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playDiantaiMusic" object:nil];

}

#pragma mark 时间进度条处理
-(void)timeTick{
    if ([NKPlayerTool shareNKPlayerTool].status == kPlayerPlaying) {
        _curTime += 0.01;
        _progess.progress = _curTime/totalTime;
        totalTime = [[NKPlaylistTool sharedNKPlaylistTool].curPlayMusic.time floatValue ];
//        if (totalTime != 0) {
//            _progess.progress = curTime/totalTime;
//        }
      

        NSString *curTimeMinuteStr = [NSString stringWithFormat:@"%02i",(int)_curTime/60];
        NSString *curSecondStr = [NSString stringWithFormat:@"%05.2f",_curTime - [curTimeMinuteStr intValue]*60];
        NSString *curTimeStr = [NSString stringWithFormat:@"%@:%@",curTimeMinuteStr,curSecondStr];
//        NSLog(@"timeArray.count is %li",_timeArray.count);
        if (geciIndex < _timeArray.count) {
//            NSLog(@"geci delegate neyer:");
            if ([curTimeStr isEqualToString:_timeArray[geciIndex]]) {
//                NSLog(@"match line number is :%li",geciIndex);
                if ([_delegate respondsToSelector:@selector(playBar:didGeciChanged:)]) {
                    [_delegate playBar:self didGeciChanged:geciIndex];
                }
                geciIndex++;
            }
       
  
        }
    }
   
        
    }





#pragma mark 更新歌曲信息label
-(void)updataMusicInfoLabel{

    _musicLabel.text = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic.name;
    _singerLabel.text = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic.singer;
    NKMusicModel *model = [[NKMusicModel alloc]init];
    NSURL *url = [NSURL URLWithString:model.imgURL];
    
    [_leftImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];


    _btn.selected = YES;
}
//2015.9.23 音乐播放标签同步 end



#pragma mark  加载子控件
-(void)setupSubViews{
    //播放空间的基本属性
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 1;
    //1. 左边图标
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth *KImageWidthRation, screenHeight *KImageHeightRation)];
    [leftImage setImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    _leftImage = leftImage;
    [self addSubview:leftImage];
    
    //2. 进度条
    UIProgressView *progess = [[UIProgressView alloc]initWithFrame:CGRectMake(leftImage.right +2, 3, screenWidth - leftImage.width,2)];
    progess.progressViewStyle = UIProgressViewStyleDefault;
    progess.progressTintColor = [UIColor yellowColor];
    progess.backgroundColor = [UIColor blackColor];
    _progess = progess;
    [self addSubview:progess];
    
    //3. 下一曲
    float nextBtnH = leftImage.height - progess.height - 3;
    float nextBtnW = nextBtnH;
    float nextBtnX = screenWidth -nextBtnW;
    float nextBtnY = progess.bottom +3;
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(nextBtnX, nextBtnY, nextBtnW, nextBtnH)];
    [nextBtn setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(playNextMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    //4. 播放
    float playBtnH = nextBtn.height;
    float playBtnW = nextBtn.width;
    float playBtnX = nextBtn.left - playBtnW -3;
    float playBtnY = nextBtn.top;
    
//    NKMusicModel *curMusic = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic;
    
    
    UIButton *playBtn =  [UIButton buttonWithNormalImage:@"play_play" selectedImage:@"play_stop" target:self action:@selector(playMusic:)];
    playBtn.frame = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH);
    _btn = playBtn;
    [self addSubview:playBtn];
    
    //歌曲坐标
    UILabel *musicLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftImage.right, progess.bottom +3,screenWidth- leftImage.width- 2* (playBtn.width) - 3,18)];
    _musicLabel = musicLabel;
    musicLabel.text = @"歌手 － 歌曲";
    musicLabel.textColor = [UIColor whiteColor];
    [self addSubview:musicLabel];
    
    //6. label
    
    UILabel *singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftImage.right, musicLabel.bottom - 3, screenWidth - 2*nextBtn.width - 3, musicLabel.bottom)];
    _singerLabel = singerLabel;
    singerLabel.text = @"歌手";
    singerLabel.font = [UIFont systemFontOfSize:13];
    singerLabel.textColor = [UIColor whiteColor];
    [self addSubview:singerLabel];
    
    //封装工具类
    
    //获取默认的播放歌曲
    //    NSArray *array = [NSArray arrayWithPlist:@"localMusic.plist"];
    //    NSDictionary *dict = array[0];
    //    NKMusicModel *mode = [NKMusicModel musicModeWithDic:dict];
    //
    //    _defaultMusic = mode;
    
    
}


#pragma mark 播放下一曲
-(void)playNextMusic :(UIButton *)btn{
    NSLog(@"play next music");
    
    [[NKPlayerTool shareNKPlayerTool] playMusic:[NKPlaylistTool sharedNKPlaylistTool].nextPlayMusic];

    
    //    NKMusicModel *nextMusic = [NKPlaylistTool sharedNKPlaylistTool].nextPlayMusic;
    //    [[NKPlayerTool shareNKPlayerTool]playNextMusic];
    //    _musicLabel.text =nextMusic.name;
    //    _singerLabel.text = nextMusic.singer;
    //
    //    _btn.selected = YES;
    _curTime = 0;
    //     [[NKPlayerTool shareNKPlayerTool] playMusic:nextMusic];
    //
}

#pragma mark 播放音乐
-(void)playMusic:(UIButton *)btn{
    if ([NKPlayerTool shareNKPlayerTool].status == kPlayerPlaying) {
        [[NKPlayerTool shareNKPlayerTool]pauseMusic];
    }
    else{
        if ([NKPlayerTool shareNKPlayerTool].status == kPlayerPause) {
            [[NKPlayerTool shareNKPlayerTool]resumeMusic];
        }
        else{
            [[NKPlayerTool shareNKPlayerTool]playMusic:[NKPlaylistTool sharedNKPlaylistTool].curPlayMusic];
        }
     
    }
    
    btn.selected =!btn.selected;
    
}



@end
