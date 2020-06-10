//
//  HZ_CacheFileManage.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/28.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_CacheFileManage.h"
#import "ViewModel/HPCache.h"
#import "HZ_CacheFileViewModel.h"
#import <AVFoundation/AVFoundation.h>

@interface HZ_CacheFileManage()

@property(nonatomic,strong) NSFileManager *fileMange;
@property(nonatomic,strong) HZ_CacheFileViewModel *cacheFileViewModel;

@end

@implementation HZ_CacheFileManage

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self confige];
    }
    return self;
}

-(void)confige{

    _fileMange = self.fileMange;
}


/// 目录是否存在 - 如果不存在是否创建
/// @param filePath 查找的目录
/// @param isCreat 是否创建目录
-(NSString *)isExistWithPath:(NSString *)filePath isCreatePath:(BOOL)isCreat{
    
    if ([_fileMange fileExistsAtPath:filePath] == NO) {
        
        if (isCreat == NO) {
            return nil;
        }
        BOOL success = NO;
        
        
        if (filePath.lastPathComponent.pathExtension.length != 0) {//获取文件最后文件的后缀名
            // 有后缀
            NSString *creatPath = [filePath stringByDeletingLastPathComponent];//删除最后一个目录
            [_fileMange createDirectoryAtPath:creatPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if (filePath.lastPathComponent.pathExtension.length == 0) {// 没有后缀
            // 创建目录
            success = [_fileMange createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            // 创建文件 如：plist，mp4
            success = [_fileMange createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        if (success == NO) {
            return nil;
        }
    }
    return filePath;
}

-(NSString *)getCachePath{
    
    NSString *cacheFileName = [HPCache md5:_requestURL.absoluteString];//key
    
    if (cacheFileName == nil) {
        return nil;
    }

    NSString *plistPath = [HZ_CacheFileViewModel plistPath];
    plistPath = [self isExistWithPath:plistPath isCreatePath:YES];
    
    if (plistPath == nil) {
        return nil;
    }
    
    NSDictionary * mainInfo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary * chileInfo = [mainInfo objectForKey:cacheFileName];
    
    return [chileInfo objectForKey:[HZ_CacheFileViewModel chileInfoPathKey]];
}

- (void)cacheWithContentType:(NSString *)contentType videoType:(NSString *)type videoCachePath:(NSString *)videoCachePath{
    
    if (contentType == nil || type == nil || videoCachePath == nil) {
        return;
    }
    
    NSString *cacheFileName = [HPCache md5:_requestURL.absoluteString];
    NSString *plistPath = [HZ_CacheFileViewModel plistPath];
    plistPath = [self isExistWithPath:plistPath isCreatePath:YES];
    
    if (plistPath == nil || cacheFileName == nil) {
        return ;
    }
    
    NSMutableDictionary * mainInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (mainInfo == nil) {
        mainInfo = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *chileInfo = [NSMutableDictionary dictionary];
    
    NSString *fileName = [videoCachePath lastPathComponent] == nil ? @"" : [videoCachePath lastPathComponent];
    [chileInfo setObject:fileName forKey:[HZ_CacheFileViewModel chileInfoPathKey]];
    [chileInfo setObject:contentType forKey:@"contentType"];
    [chileInfo setObject:type forKey:@"type"];
    [chileInfo setObject:@(_videoSize) forKey:@"videoSize"];
    [chileInfo setObject:[HPCache getNowTimeTimestamp] forKey:@"cacheTime"];
    
    [mainInfo setValue:chileInfo forKey:cacheFileName];
    [[mainInfo copy] writeToFile:plistPath atomically:YES];

    
}



- (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length{


    NSString *filePath = [HZ_CacheFileViewModel timeBeingCachePathWithType:_type];
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    [handle seekToFileOffset:offset];
    return [handle readDataOfLength:length];
}

- (void)cacheWithCacheData:(NSData *)data{

    NSString *filePath = [HZ_CacheFileViewModel timeBeingCachePathWithType:_type];
    filePath = [self isExistWithPath:filePath isCreatePath:YES];
    
    NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [handle seekToEndOfFile];
    [handle writeData:data];
}


-(BOOL)hz_removeTimeBeingFile{
    
    NSString *filePath = [HZ_CacheFileViewModel videoTimeBeingCachePath];
    NSError *error = nil;
    BOOL success = [_fileMange removeItemAtPath:filePath error:&error];
    if (success == YES) {
        return YES;
    }
    return NO;
}


- (NSString *)cacheTempFile {
    
    NSString *cacheFileName = [HPCache md5:_requestURL.absoluteString];
    
    if (cacheFileName.length == 0) {
        return nil;
    }
    
    NSString *cacheFolderPath = [HZ_CacheFileViewModel videoCacheDirectory];
    cacheFolderPath = [self isExistWithPath:cacheFolderPath isCreatePath:YES];
    NSString *filePath=[HZ_CacheFileViewModel timeBeingCachePathWithType:_type];
    
    cacheFolderPath = [NSString stringWithFormat:@"%@/%@.%@",cacheFolderPath,cacheFileName,_type];
    
    
    if ([_fileMange fileExistsAtPath:cacheFolderPath] == YES) {
        [_fileMange removeItemAtPath:cacheFolderPath error:nil];
    }
    
    BOOL success = [_fileMange copyItemAtPath:filePath toPath:cacheFolderPath error:nil];
    
    if (success == YES) {
        
        [self cacheWithContentType:_contentType videoType:_type videoCachePath:cacheFolderPath];
        return cacheFolderPath;
    }
    return nil;
}

- (NSString *)filePathIsExist {
    NSString *cacheFileName = [HPCache md5:_requestURL.absoluteString];
    
    if (cacheFileName.length == 0) {
        return nil;
    }
    
    return [HPCache filePathIsExist:cacheFileName];
}


+ (NSString *)filePathIsExistWithURL:(NSURL *)url{
    
    if (url == nil) {
        return nil;
    }
    NSString *cacheFileName = [HPCache md5:url.absoluteString];
    
    if (cacheFileName.length == 0) {
        return nil;
    }
    
    NSString *plistPath = [HZ_CacheFileViewModel plistPath];
    
    if (plistPath == nil) {
        return nil;
    }
    
    NSDictionary * mainInfo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *chileInfo = [mainInfo objectForKey:cacheFileName];
    NSString *fileName = [chileInfo objectForKey:[HZ_CacheFileViewModel chileInfoPathKey]];
    if (fileName == nil) {
        return nil;
    }
    NSString *libPath = [HZ_CacheFileViewModel videoCacheDirectory];// 在模拟器目录是动态的
    NSString *cacheFolderPath = [libPath stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFolderPath] == NO) {
        
        return nil;
    }
    
    return cacheFolderPath;
}


#pragma mark - 懒加载

-(NSFileManager *)fileMange{
    
    if (_fileMange == nil) {
        
        _fileMange = [NSFileManager defaultManager];
    }
    return _fileMange;
}

-(HZ_CacheFileViewModel *)cacheFileViewModel{
    
    if (_cacheFileViewModel == nil) {
        _cacheFileViewModel = [[HZ_CacheFileViewModel alloc] init];
    }
    return _cacheFileViewModel;
}

@end
