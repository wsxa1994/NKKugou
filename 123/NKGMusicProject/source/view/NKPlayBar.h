//
//  NKPlayBar.h
//  NKGMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NKPlayBar;
@protocol NKPlayBarDelegate <NSObject>
//歌词索引变换时用这个代理方法，传回歌词的index

-(void)playBar:(NKPlayBar *)playBar didGeciChanged:(NSInteger)index;

@end
@interface NKPlayBar : UIView

//+(instancetype)playBar;
@property(nonatomic,weak)UILabel *singerLabel;
@property(nonatomic,weak)UILabel *musicLabel;
@property (nonatomic,weak)UIButton *btn;
@property(nonatomic,weak)UIProgressView *progess;
@property (assign,nonatomic)CGFloat curTime;
@property(nonatomic,weak)UIImageView *leftImage;
+(instancetype)sharePlayBar;
//2015-9-29歌词界面实现 begin
@property(weak,nonatomic)id<NKPlayBarDelegate>delegate;
//2015-9-29歌词界面实现 end
@end
