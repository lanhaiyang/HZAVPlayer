//
//  HZ_CacheFileViewModel.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/6/3.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HZ_CacheFileViewModel : NSObject


/// plist文件缓存的目录
+(NSString *)plistPath;

/// 在子info中得到路径的key
+(NSString *)chileInfoPathKey;

/// 暂时缓存的目录
+ (NSString *)timeBeingCachePathWithType:(NSString *)type;

/// 缓存视频的目录
+ (NSString *)videoCacheDirectory;


/// 视频展示缓存区
+ (NSString *)videoTimeBeingCachePath;


@end

NS_ASSUME_NONNULL_END
