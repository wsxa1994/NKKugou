//
//  NKPlaylistTool.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"
typedef enum {
    kPlayModeAllLoop = 0,
    kPlayModeAllRandom,
    kPlayModeSequence
    
}PlayMode;
@interface NKPlaylistTool : NSObject
//2015.09.22 封装播放列表工具 begin
+(instancetype)sharedNKPlaylistTool;

//本地音乐播放列表管理
//1. 搜索本地音乐列表
-(void)searchLocMusicList;
//2. 创建本地音乐列表
-(void)loadLocMusicList;
//3. 从本地音乐列表删除一首歌
-(void)deleteOneMusicFromLocList:(NKMusicModel *)music;
//4. 清空本地音乐列表
-(void)deleteMusicList;
//5. 取得修改当前歌曲的ID
@property(nonatomic,strong)NKMusicModel *curPlayMusic;
//6. 取得下一首歌曲 ID
@property(nonatomic,strong)NKMusicModel *nextPlayMusic;
//7. 取得本地音乐所有播放列表
@property(strong,nonatomic)NSMutableArray *curPlayMusicList;
//2015.09.22 封装播放列表工具 end

//2015.9.23 playbar 和tableview  交互通知使用begin

//2015.9.23 playbar 和tableview  交互通知使用end
@property (assign,nonatomic)NSInteger curPlayMusicIndxe;


//2015-9--24 编辑栏子功能实现 全选 begin
  //9.全选或全不选
-(void)allCheck:(BOOL)allCheck;
//2015-9--24 编辑栏子功能实现 全选 end

@property (strong, nonatomic) NSMutableArray* allLocMusicList;
//2015-09-28 音乐模型归档 begin
//将音乐列表归档到文件中
-(void)saveCurPlayMusicListToDocument:(NSString *)fileName;
//从音乐列表归档文件中 读取当前播放列表
-(void)getCurPlayMusicListFromDocument:(NSString *)fileName;

-(void)getLoadPlayMusicListFromDocument:(NSString *)fileName;
-(void)saveLoadPlayMusicListToDocument:(NSString *)fileName;

//2015-09-28 音乐模型归档 end
//2015-9-28 开源代码集成 begin

@property (assign,nonatomic)PlayMode playMode;

//2015-9-28 开源代码集成 end

//2015-9-29 歌词界面实现 begin
@property (strong,nonatomic,readonly) NSDictionary *curGeciDict;
//2015-9-29 歌词界面实现 end
@property (strong, nonatomic) NSMutableArray* loadMuiscList;



@end
