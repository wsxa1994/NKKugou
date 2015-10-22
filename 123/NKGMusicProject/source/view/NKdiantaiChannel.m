//
//  NKdiantaiChannel.m
//  NKGMusicProject
//
//  Created by neuedu on 15/10/20.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NKdiantaiChannel.h"

@implementation NKdiantaiChannel
+ (instancetype)diantaiChannelWithDictionary:(NSDictionary *)dict
{
    NKdiantaiChannel * channel = [[NKdiantaiChannel alloc]init];
    
    ;
    channel.channel_id = [NSString stringWithFormat:@"%@", dict[@"channel_id"]];
    channel.name = dict[@"name"];
    return channel;
}
@end
