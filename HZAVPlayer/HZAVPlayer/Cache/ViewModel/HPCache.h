//
//  HPCache.h
//  HPCache
//
//  Created by 何鹏 on 17/4/23.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HPCacehObject [HPCache sharedCache]

#define ManageSaveTime @"HP_ManageSaveTime"
#define ManageSaveIsDeletStatus @"HP_ManageSaveIsDeletStatus"
#define ManageSaveFile_KeyFileName_ValueFileSize @"HP_ManageSaveFile_KeyFileName_ValueFileSize"
#define ManageSaveFile_KeyFileName_ValueFileSaveTime @"HP_ManageSaveFile_KeyFileName_ValueFileSaveTime"

@interface HPCache : NSObject

@property(nonatomic,strong) NSUserDefaults *cacheFileInformation;


@property(nonatomic,strong,readonly) dispatch_queue_t cacheQueu;

/**
 当前对象单例

 @return 当前对象
 */
+ (instancetype)sharedCache;


/**
 删除所有缓存

 @param time 删除最大时间范围
 */
+(void)setCacheFileTime:(NSUInteger)time;

/**
 对字符串进行MD5加密(保证同一个文件唯一性)

 @param str 字符串
 @return 加密内容
 */
+ (NSString *) md5:(NSString *)str;


/**
 获取缓存路径

 @return 缓存路径
 */
+(NSString *)getCachePath;


/**
 获得缓存路径

 @param urlStr 缓存名
 @return 缓存路径
 */
+(NSString *)cachePathWithUrl:(NSString *)urlStr;



/// 文件路劲是否存在
/// @param fileName 文件名
+(NSString *)filePathIsExist:(NSString *)fileName;

/**
 缓存对象

 @param data 缓存数据
 @param cacheName 文件的名字
 */
+(BOOL)cacheWithObj:(NSData *)data cacheName:(NSString *)cacheName;


/**
 删除文件

 @param fileName 删除文件的名字
 @return 是否成功
 */
+(BOOL)removeFile:(NSString *)fileName;


/**
 创建文件夹

 @param fileName 文件夹名字
 @param path 在哪个路径创建
 @return YES 为创建成功 NO 为创建失败
 */
+(BOOL)creatFile:(NSString *)fileName creatWithPath:(NSString *)path;


/**
 file文件夹下的文件

 @param fileName 文件夹名
 @return 返回子文件名数组
 */
+(NSArray *)chileFileWithfielName:(NSString *)fileName;

/**
 读取缓存对象

 @param cacheName 缓存路径
 @return 缓存对象
 */
+(NSData *)readWithcacheName:(NSString *)cacheName;


/// 获得某个区域的数据
/// @param cacheName 缓存名
/// @param offset 偏移位置
/// @param length 偏移长度
+ (NSData *)readWithcacheName:(NSString *)cacheName tempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;


/**
 获取指定文件大小

 @param fileName 指定文件
 @return 文件大小
 */
+ (unsigned long long)fileSizeWithFileName:(NSString *)fileName;


/**
 获取当前时间

 @return 当前时间
 */
+(NSString *)getNowTimeTimestamp;

@end
