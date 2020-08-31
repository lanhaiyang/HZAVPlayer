//
//  HZ_CacheFileViewModel.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/6/3.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_CacheFileViewModel.h"

@implementation HZ_CacheFileViewModel

+(NSString *)plistName{
    
    return @"VideoInfo.plist";
}

+(NSString *)chileInfoPathKey{
    
    return @"videoPath";
}

+(NSString *)plistPath{
    
    NSString *plist = [self videoCacheDirectory];
    NSString *plistPath = [plist stringByAppendingPathComponent:[HZ_CacheFileViewModel plistName]];
    return plistPath;
}


+ (NSString *)videoTimeBeingCachePath{
    
    NSString *filePath = NSHomeDirectory();
    NSString *tmpPath = [filePath stringByAppendingPathComponent:@"tmp"];
    NSString *vidoeCachePath = [tmpPath stringByAppendingPathComponent:@"VideoCache"];
    return vidoeCachePath;
}

+ (NSString *)timeBeingCachePathWithType:(NSString *)type{
    
    if (type == nil) {
        return nil;
    }
    
    NSString *chileFilePath = [HZ_CacheFileViewModel videoTimeBeingCachePath];
    NSString *videoName = [NSString stringWithFormat:@"TimeBeingCache.%@",type];
    chileFilePath = [chileFilePath stringByAppendingPathComponent:videoName];
    return chileFilePath;
}


+ (NSString *)videoCacheDirectory{
    
    NSString * folderPath = NSHomeDirectory();
    NSString *cacheFolderPath = [folderPath stringByAppendingPathComponent:@"Library"];
    cacheFolderPath = [cacheFolderPath stringByAppendingPathComponent:@"VideoCache"];
    return cacheFolderPath;
}

@end
