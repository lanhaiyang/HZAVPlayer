//
//  HPCache.m
//  HPCache
//
//  Created by 何鹏 on 17/4/23.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface HPCache ()

@property(nonatomic,strong) NSMutableDictionary<NSString *,NSNumber *> *fileSizeNiformation;
@property(nonatomic,strong) NSMutableDictionary<NSString *,NSString *> *fileCreatTimeNiformation;

@property(nonatomic,strong) dispatch_queue_t cacheQueu;

@end

@implementation HPCache

+ (instancetype)sharedCache {
    static dispatch_once_t once;
    static HPCache *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        instance.cacheQueu=dispatch_queue_create("HPCache.queue.cache", NULL);
    });
    return instance;
}

-(NSUserDefaults *)cacheFileInformation
{
    if (_cacheFileInformation==nil) {
        _cacheFileInformation=[[NSUserDefaults alloc] init];
    }
    return _cacheFileInformation;
}

-(NSMutableDictionary<NSString *,NSNumber *> *)fileSizeNiformation
{
    if (_fileSizeNiformation==nil) {
        _fileSizeNiformation=[NSMutableDictionary dictionary];
    }
    return _fileSizeNiformation;
}

-(NSMutableDictionary<NSString *,NSString *> *)fileCreatTimeNiformation
{
    if (_fileCreatTimeNiformation==nil) {
        _fileCreatTimeNiformation=[NSMutableDictionary dictionary];
    }
    return _fileCreatTimeNiformation;
}

+(void)setCacheFileTime:(NSUInteger)time
{
    
    id cacheStatu=[HPCacehObject.cacheFileInformation objectForKey:ManageSaveIsDeletStatus];
    
    if (cacheStatu==nil) {
        [HPCacehObject.cacheFileInformation setInteger:[[self getNowTimeTimestamp] integerValue] forKey:ManageSaveTime];
        [HPCacehObject.cacheFileInformation setBool:YES forKey:ManageSaveIsDeletStatus];
        
    }
    else
    {
        NSUInteger saveTime=[HPCacehObject.cacheFileInformation integerForKey:ManageSaveTime];
        NSUInteger currentTime=[[self getNowTimeTimestamp] integerValue];
        
        NSUInteger space=currentTime-saveTime;
        
        if (space>time) {
            
            [self deleAllCacheFile:^(BOOL status) {
                
                [HPCacehObject.cacheFileInformation removeObjectForKey:ManageSaveTime];
                [HPCacehObject.cacheFileInformation setBool:NO forKey:ManageSaveIsDeletStatus];
                
            }];
            
        }
    }
}

+(void)deleAllCacheFile:(void(^)(BOOL status))deleBlock;
{
    NSDictionary *dicFile=[HPCacehObject.cacheFileInformation objectForKey:ManageSaveFile_KeyFileName_ValueFileSaveTime];
    
    NSArray *arrayFileName=dicFile.allKeys;
    
    dispatch_async(HPCacehObject.cacheQueu, ^{
        for (int i=0; i<arrayFileName.count; i++) {
            
            NSString *fileName=arrayFileName[i];
            [self removeFile:fileName];
            
        }
        
        if (deleBlock!=nil) {
            deleBlock(YES);
        }
    });
}

+ (NSString *) md5:(NSString *)str
{
    if (str.length == 0) {
        return nil;
    }
    NSUInteger stringCount=16;
    
    const char *cStr = [str UTF8String];
    unsigned char result[stringCount];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *md5String=[NSMutableString string];
    
    for (int i=0; i<stringCount; i++) {
        
        [md5String appendFormat:@"%02X",result[i]];
        
    }
    
    return md5String;
}

+(NSString *)getCachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 拼接一个文件在沙盒的全路径
 */
+(NSString *)cachePathWithUrl:(NSString *)urlStr
{  // 将图片网址名作为作为最后一项
    // 1. 获得缓存的路径
    NSString *cachePath = [self getCachePath];
    
    if([cachePath rangeOfString:cachePath].location==NSNotFound)//_roaldSearchText
    {
        return urlStr;
    }
    
    // 2. 把路径根urlStr拼接起来
    return [NSString stringWithFormat:@"%@/%@",cachePath,urlStr];
}

+(BOOL)cacheWithObj:(NSData *)data cacheName:(NSString *)cacheName {
    if(cacheName==nil) {
        return NO;
    }
    
    NSString *filePath=[self cachePathWithUrl:cacheName];
    
    BOOL addFile=[data writeToFile:filePath atomically:YES];
    
    if (addFile==YES) {
        unsigned long long fileSize=[self fileSizeWithFileName:cacheName];
        [HPCacehObject.fileSizeNiformation setObject:@(fileSize) forKey:cacheName];
        [HPCacehObject.cacheFileInformation setObject:HPCacehObject.fileSizeNiformation forKey:ManageSaveFile_KeyFileName_ValueFileSize];
    }
    
    return addFile;
}


+(BOOL)creatFile:(NSString *)fileName creatWithPath:(NSString *)path
{
    
    if (fileName==nil) {
        return NO;
    }
    NSString *creatPath=[NSString stringWithFormat:@"%@/%@",path,fileName];
    if ([self fileExist:creatPath]==NO) {
        
        NSFileManager *fileManage=[[NSFileManager alloc] init];
        
        BOOL creatFile=[fileManage createDirectoryAtPath:creatPath
                             withIntermediateDirectories:YES
                                              attributes:nil error:nil];
        
        if (creatFile==YES) {
         
            [HPCacehObject.fileCreatTimeNiformation setObject:[self getNowTimeTimestamp] forKey:fileName];
            [HPCacehObject.cacheFileInformation setObject:HPCacehObject.fileCreatTimeNiformation forKey:ManageSaveFile_KeyFileName_ValueFileSaveTime];
        }
        
        return creatFile;
    }
    
    return NO;
    
}

+(BOOL)removeFile:(NSString *)fileName {
    if (fileName==nil) {
        return NO;
    }
    NSString *filePath=[self cachePathWithUrl:fileName];
    if ([self fileExist:filePath]==YES) {
        
        BOOL deleFile=[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        
        if (deleFile==YES) {
            HPCacehObject.fileCreatTimeNiformation=[HPCacehObject.cacheFileInformation objectForKey:ManageSaveFile_KeyFileName_ValueFileSaveTime];
            [HPCacehObject.fileCreatTimeNiformation removeObjectForKey:fileName];
        }
        
        return deleFile;
        
    }
    
    return YES;
}

+(NSArray *)chileFileWithfielName:(NSString *)fileName{
    NSString *filePath=[self cachePathWithUrl:fileName];
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
}


+(BOOL)fileExist:(NSString *)cachePath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        
        return NO;
    }
    
    return YES;
}

+(NSString *)filePathIsExist:(NSString *)fileName {
    if (fileName==nil) {
        return nil;
    }
    NSString *filePath=[self cachePathWithUrl:fileName];
    if ([self fileExist:filePath]==YES) {
        
        return fileName;
        
    }
    
    return nil;
}

+(NSData *)readWithcacheName:(NSString *)cacheName{
    NSString *dataPath = [self cachePathWithUrl:cacheName];
    // 读取data
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSData *data=[NSData dataWithContentsOfFile:dataPath options:NSDataReadingMappedIfSafe error:nil];
    
    return data;
}

+ (NSData *)readWithcacheName:(NSString *)cacheName tempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length {
    
    NSString *dataPath = [self cachePathWithUrl:cacheName];
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:dataPath];
    [handle seekToFileOffset:offset];
    return [handle readDataOfLength:length];
}

+ (unsigned long long)fileSizeWithFileName:(NSString *)fileName{
    NSString *cahePathe=[self cachePathWithUrl:fileName];
    // 总大小
    unsigned long long size = 0;
    
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 是否为文件夹
    BOOL isDirectory = NO;
    
    // 路径是否存在
    BOOL exists = [mgr fileExistsAtPath:cahePathe isDirectory:&isDirectory];
    if (!exists) return size;
    
    if (isDirectory) { // 文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:cahePathe];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [cahePathe stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else { // 文件
        size = [mgr attributesOfItemAtPath:cahePathe error:nil].fileSize;
    }
    
    return size;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

@end
