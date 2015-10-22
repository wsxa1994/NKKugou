//
//  NSArray+NKPlist.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NSArray+NKPlist.h"

@implementation NSArray (NKPlist)
+(instancetype)arrayWithPlist:(NSString *)plistname{

    NSURL *url = [[NSBundle mainBundle]URLForResource:plistname withExtension:nil];
    NSArray *array = [NSArray arrayWithContentsOfURL:url];
    return array;
}
@end
