//
//  HZ_CacheFileManage.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/28.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_CacheFileManage : NSObject

/// 下载地址
@property(nonatomic,strong) NSURL *requestURL;


/// 设置视频格式
@property(nonatomic,strong) NSString *contentType;
/// 设置视频类型
@property(nonatomic,strong) NSString *type;
/// 设置视频大小
@property(nonatomic,assign) NSUInteger videoSize;

/**
 *  读取临时文件数据
 */
- (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;


//- (NSString *)filePathIsExist:(NSString *)fileName;


/// 把下载数据缓存起来
/// @param data 下载data
- (void)cacheWithCacheData:(NSData *)data;


/// 获得缓存文件的路径
- (NSString *)cacheTempFile;

/// 通过url获取本地缓存地址，如果返回为nil ，说明没有缓存
+ (NSString *)filePathIsExistWithURL:(NSURL *)url;

/// 删除展示缓存文件
-(BOOL)hz_removeTimeBeingFile;

@end

NS_ASSUME_NONNULL_END
