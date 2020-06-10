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


@property(nonatomic,strong) NSURL *requestURL;


/// 视频格式
@property(nonatomic,strong) NSString *contentType;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,assign) NSUInteger videoSize;

/**
 *  读取临时文件数据
 */
- (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;


//- (NSString *)filePathIsExist:(NSString *)fileName;

- (void)cacheWithCacheData:(NSData *)data;

- (NSString *)cacheTempFile;

+ (NSString *)filePathIsExistWithURL:(NSURL *)url;

/// 删除展示缓存文件
-(BOOL)hz_removeTimeBeingFile;

@end

NS_ASSUME_NONNULL_END
