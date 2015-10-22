//
//  NKMusicModel.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKMusicModel.h"
//2015-09-28 音乐模型归档 begin
#define keyName         @"name"
#define keySinger       @"singer"
#define keyTime         @"time"
#define keyIndex        @"idnex"
#define keyWillBeDelete @"willBeDelete"
#define keyEditBarShow  @"editBarShow"

#define keyGeci         @"geci"


//2015-09-28 音乐模型归档 end
@implementation NKMusicModel
// 音乐model的封装
// 音乐管理 模型＋工具
// 一个歌曲给封装成模型
// 播放器
+(instancetype)musicModeWithDic:(NSDictionary *)dict{
    NKMusicModel *model = [[NKMusicModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}


+(instancetype)WebMusicModeWithDic:(NSDictionary *)dic{
    NKMusicModel *model = [[NKMusicModel alloc]init];
//    NSLog(@"title is %@",dict[@"title"]);
//    NSLog(@"attrs is %@",dict[@"attrs"][@"singer"][0]);
//    NSLog(@"image is %@",dict[@"image"]);
    
    model.name = dic[@"title"];
    model.singer = dic[@"attrs"][@"singer"][0];
    model.imgURL = dic[@"image"];
    
    
    
    return model;
}
+(instancetype)diantaiMusicModeWithDic:(NSDictionary *)dic{
    NKMusicModel *model = [[NKMusicModel alloc]init ];
    model.name = dic[@"title"];
    model.imgURL = dic[@"picture"];
    model.singer = dic[@"artist"];
    model.musicURL = dic[@"url"];
    model.time = dic[@"length"];
    return model;
}


//2015-09-28 音乐模型归档 begin
//解挡 重写initwithcoder 从文件中利用nskeryunachiver读取对象数据 还原是需要调用
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:keyName];
        _singer = [aDecoder decodeObjectForKey:keySinger];

        _time = [aDecoder decodeObjectForKey:keyTime];
        _index = [aDecoder decodeObjectForKey:keyIndex];

        _willBeDelete = [aDecoder decodeObjectForKey:keyWillBeDelete];
//       _editBarShow = [aDecoder decodeObjectForKey:keyEditBarShow];
        _geci = [aDecoder decodeObjectForKey:keyGeci];

        
    }
    return self;
}
//归档 重写endcodeWithCoder 把对象进行归档 将数据存储到文件中
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:keyName];
    [aCoder encodeObject:_singer forKey:keySinger];
    [aCoder encodeObject:_time forKey:keyTime];
    [aCoder encodeObject:_index forKey:keyIndex];
    [aCoder encodeBool:_willBeDelete forKey:keyWillBeDelete];
    [aCoder encodeObject:_geci forKey:keyGeci];
}


//2015-09-28 音乐模型归档 end
@end
