//
//  NKPlaylistTool.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKPlaylistTool.h"
#import "NSArray+NKPlist.h"
#import "NKMusicModel.h"
static NKPlaylistTool *tool;
@implementation NKPlaylistTool
//2015.09.22 封装播放列表工具 begin
#pragma mark 单例
+(instancetype)sharedNKPlaylistTool{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[NKPlaylistTool alloc]init];
    });
    return tool;
  
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}
#pragma mark 搜索本地音乐列表
-(void)searchLocMusicList{
    NSMutableArray * allLocmusicList = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithPlist:@"localMusic.plist"];
    //plist中的数组转换成模型
    for (int i = 0; i < array.count; i++) {
        NKMusicModel *mode = [NKMusicModel musicModeWithDic:array[i]];
        [allLocmusicList addObject:mode];
    }
    _curPlayMusicList = allLocmusicList;
}
#pragma mark 下一首歌曲
-(NKMusicModel *)nextPlayMusic{
    NKMusicModel *nextMusic= nil;
    //容错处理
    if (_curPlayMusicList.count == 0) {
        return nil;
    }
    switch (_playMode) {
        case kPlayModeAllLoop:
            nextMusic = [self allLoopNextMusic];
            break;
            case kPlayModeAllRandom:
            nextMusic = [self randomNextMusic];
            break;
            case kPlayModeSequence:
            nextMusic = [self sequenceNextMusic];
            break;
            
        default:
            break;
    }
//    if (_curPlayMusic == nil) {
//        if (_curPlayMusicList == 0) {
//            return nil;
//        }
//        else{
//            nextMusic = _curPlayMusicList[0];
//        }
//    }
//    else{
//        if (_curPlayMusicList.count == 1) {
//            nextMusic = _curPlayMusic;
//        }
//        else{
//            //定位当前和曲在数组中的位置
//            NSInteger curIndex = [_curPlayMusicList indexOfObject:_curPlayMusic];
//            if (curIndex + 1 <_curPlayMusicList.count - 1) {
//                nextMusic = _curPlayMusicList[curIndex +1 ];
//            }
//            else{
//                nextMusic = _curPlayMusicList[0];
//            }
//        }
//    }
    _nextPlayMusic = nextMusic;
    return _nextPlayMusic;
}

#pragma mark 取得并修改当前歌曲
-(NKMusicModel *)curPlayMusic{
    if (_curPlayMusic == nil) {
        _curPlayMusic = self.nextPlayMusic;
    }
    return _curPlayMusic;
    

}
#pragma  mark 当前播放音乐在总列表中间的位置
-(NSInteger)curPlayMusicIndxe{
    //1.取得整个音乐列表
    NSArray *allListArray = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList;
    //2. 取得到当前音乐
    NKMusicModel *curMusic = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusic;
    //3. 利用当前音乐定位当前音乐在整个播放列表的位置
    NSInteger row = [allListArray indexOfObject:curMusic];

    return row;
}
//2015.09.22 封装播放列表工具 end
//2015-9--24 编辑栏子功能实现 全选 begin
#pragma mark 全选或不全选
-(void)allCheck:(BOOL)allCheck{
   NSArray *alllist = [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList ;
    for (NKMusicModel *mode in alllist) {
        mode.willBeDelete = allCheck;
    }
}
#pragma mark 删除列表中选中项
-(void)deleteMusicList{
    NSArray *alllist = [[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList copy];
    for (NKMusicModel *mode in alllist) {
        if (mode.willBeDelete == YES) {
            [[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList removeObject:mode];
        }
    }

}
//2015-9--24 编辑栏子功能实现 全选 end

//2015-09-28 音乐模型归档 begin

#pragma mark 将当前音乐列表归档到文件中
-(void)saveCurPlayMusicListToDocument:(NSString *)fileName{
    //判断Document 路径下是否有本地音乐播放列表文件locMusicList.Data
    //若果有盖文件则从文件中读取数据，否则”加载“所有的音乐
    
    //读取音乐列表
   NSArray *allLocMusicList = [[NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList mutableCopy];
    //读取路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *locMusicListFile = [documentPath stringByAppendingPathComponent:fileName];
    //将本地音乐列表归档到locMusicListFile中  这个文件位于sandBox的Document路径
    [NSKeyedArchiver archiveRootObject:allLocMusicList toFile:locMusicListFile];
}
#pragma mark 从音乐列表归档到文件 读取当前播放列表
-(void)getCurPlayMusicListFromDocument:(NSString *)fileName{
    //判断Document 路径下是否有本地音乐播放列表文件locMusicList.Data
    //若果有盖文件则从文件中读取数据，否则”加载“所有的音乐
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
//    NSLog(@"document path is :%@",documentPath);
    NSString *locMusicListFile = [documentPath stringByAppendingPathComponent:fileName];
    //查找 看钢材存储的路径是否存在   
    if ([[NSFileManager defaultManager]fileExistsAtPath:locMusicListFile]) {
        NSArray* locMusicList =[NSKeyedUnarchiver unarchiveObjectWithFile:locMusicListFile];
        [NKPlaylistTool sharedNKPlaylistTool].curPlayMusicList = [locMusicList mutableCopy];
     
    }
    else{
        [[NKPlaylistTool sharedNKPlaylistTool] searchLocMusicList];
    }

}



//2015-09-28 音乐模型归档 end

//2015 - 09 - 29 开源框架集成 播放模式实现 begin
// 默认播放模式 ：全部播放模式
-(instancetype)init{
    if (self = [super init]) {
        _playMode = kPlayModeAllLoop;
            _allLocMusicList = [NSMutableArray array];
            _loadMuiscList = [NSMutableArray array];
    }
    return self;

}
#pragma  mark 全部循环的模式下取得下一首歌曲
-(NKMusicModel *)allLoopNextMusic{
    NKMusicModel *nextMusic = nil;
        if (_curPlayMusic == nil) {
            nextMusic = _curPlayMusicList[0];

        }
        else{
            if (_curPlayMusicList.count == 1) {
                nextMusic = _curPlayMusic;
            }
            else{
                //定位当前和曲在数组中的位置
                NSInteger curIndex = [_curPlayMusicList indexOfObject:_curPlayMusic];
                if (curIndex + 1 <=_curPlayMusicList.count-1 ) {
                    nextMusic = _curPlayMusicList[curIndex +1 ];
                }
                else{
                    nextMusic = _curPlayMusicList[0];
                }
            }
        }
    return nextMusic;
}
#pragma  mark 随机循环的模式下取得下一首歌曲
-(NKMusicModel *)randomNextMusic{
    //随机  mo
       NKMusicModel *nextMusic = nil;
    NSInteger randomIndex = arc4random()%_curPlayMusicList.count;
    nextMusic = _curPlayMusicList[randomIndex];
    return nextMusic;
}

#pragma  mark 顺序循环的模式下取得下一首歌曲
-(NKMusicModel *)sequenceNextMusic{
    NKMusicModel *nextMusic = nil;
        if (_curPlayMusic == nil) {
            nextMusic = _curPlayMusicList[0];
      
        }
        else{
            if (_curPlayMusicList.count == 1) {
                nextMusic = _curPlayMusic;
            }
            else{
                //定位当前和曲在数组中的位置
                NSInteger curIndex = [_curPlayMusicList indexOfObject:_curPlayMusic];
                if (curIndex + 1 <_curPlayMusicList.count - 1) {
                    nextMusic = _curPlayMusicList[curIndex +1 ];
                }
                else{
                    nextMusic = nil;
                }
            }
        }
    
    return nextMusic;
}
//2015 - 09 - 29 开源框架集成 播放模式实现 end
//2015-9-29 歌词界面实现 begin

#pragma mark  删除
-(void)deleteOneMusicFromLocList:(NKMusicModel *)music{
    [_curPlayMusicList removeObject:music];
}
-(NSDictionary *)curGeciDict{
    //解析歌词
    NSURL *geciUrl = [[NSBundle mainBundle]URLForResource: _curPlayMusic.geci withExtension:nil];
    NSString *geciStr = [NSString stringWithContentsOfURL:geciUrl encoding:NSUTF8StringEncoding error:nil];
    //每一条数据的分隔符石“\n”
    NSArray * geciArray = [geciStr componentsSeparatedByString:@"\n"];
//    NSLog(@"gecistr is %@,geciStr length is %li",geciArray,geciArray.count);
    
    NSMutableArray *realGeciArray = [NSMutableArray array];
    NSMutableArray *timeGeciArray = [NSMutableArray array];
    
    for (NSString *str in geciArray) {
        //对每一行，分隔符时“[”和"]"
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
        NSArray *oneLineArray = [str componentsSeparatedByCharactersInSet:set];
        if (oneLineArray.count == 1) {
            [realGeciArray addObject:@""];
        }else{
            [realGeciArray addObject:oneLineArray[2]];
            [timeGeciArray addObject:oneLineArray[1]];
        }
    }
//    NSLog(@"timeArray is %@",timeGeciArray);
    NSDictionary *curGeciDict = @{@"time":timeGeciArray,@"real":realGeciArray};
    return curGeciDict;
}
//2015-9-29 歌词界面实现 end
@end
