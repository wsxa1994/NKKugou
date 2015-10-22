//
//  NKMusicModel.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <Foundation/Foundation.h>
//2015-09-28 音乐模型归档 begin
// 1. 想把自定义的对象进行归档首先遵循nsccoding 协议
@interface NKMusicModel : NSObject<NSCoding>
// 音乐model的封装
+(instancetype)musicModeWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *index;
@property(nonatomic,copy)NSString *singer;
@property (nonatomic,copy)NSString *geci;
//2015-9--24 编辑栏子功能实现 全选 begin
@property (nonatomic,assign,getter=iswillBeDelete)BOOL willBeDelete;
//2015-9--24 编辑栏子功能实现 全选 end
//2015-9-29 自定义cell编辑栏 begin
@property (assign,nonatomic,getter=iseditBarShow)BOOL editBarShow;
//imgUrl
//
@property(copy,nonatomic)NSString *imgURL;
+(instancetype)WebMusicModeWithDic:(NSDictionary *)dic;


//电台1
@property(copy,nonatomic)NSString *musicURL;
+(instancetype)diantaiMusicModeWithDic:(NSDictionary *)dic;







@end
