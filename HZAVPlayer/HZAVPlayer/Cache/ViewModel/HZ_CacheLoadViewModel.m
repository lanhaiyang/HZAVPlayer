//
//  HZ_CacheLoadViewModel.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/27.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_CacheLoadViewModel.h"
#import "HZ_DealVideoTool.h"
#import <CoreServices/CoreServices.h>
#import "HZ_CacheFileManage.h"

@interface HZ_CacheLoadViewModel()<HZ_RequestTaskDelegate>

@property(nonatomic,strong) NSLock *loadLock;

@property(nonatomic,strong) HZ_RequestTask *requestTask;

@property(nonatomic,strong) HZ_CacheFileManage *fileManage;

@property(nonatomic,strong,readonly) NSMutableArray<AVAssetResourceLoadingRequest *> *loadingRequestMs;

@end

@implementation HZ_CacheLoadViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self confige];
    }
    return self;
}

-(void)confige{
    
    _loadingRequestMs = [NSMutableArray array];
    _fileManage = self.fileManage;
    _loadLock = self.loadLock;
    
}

-(void)addLoadingWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    if (loadingRequest == nil) {
        return;
    }
    [self.loadingRequestMs addObject:loadingRequest];
    [_loadLock lock];
        
        //通过 loadingRequest 获得seek范围判断是否有缓存数据 ,
        [self dealIsVideoCacheWithRequest:loadingRequest];
    
    [_loadLock unlock];
}

- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    [self.loadingRequestMs removeObject:loadingRequest];
}

-(void)dealIsVideoCacheWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    if (self.requestTask) {
        
        if (loadingRequest.dataRequest.requestedOffset >= self.requestTask.downStartOffset && loadingRequest.dataRequest.requestedOffset <= (self.requestTask.downStartOffset + self.requestTask.cacheLength)) {
            
            // 存在缓存
            [self getCacheVideo];
        }else{
            
            if (self.seekRequired) {
                
                // 不存在
                [self requestVideoWithRequest:loadingRequest];
            }
        }
    }else{
        
        // 没有下载task
        [self requestVideoWithRequest:loadingRequest];
    }

}



-(void)getCacheVideo{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in _loadingRequestMs) {
        
        if ([self setLoadingRequestWithRequest:loadingRequest] == YES) {
            [arrayM addObject:loadingRequest];
        }
    }
    [self.loadingRequestMs removeObjectsInArray:[arrayM copy]];
}

-(BOOL)setLoadingRequestWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    //填充信息
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(_requestTask.contentType), NULL);
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentLength = self.requestTask.fileLength;
    
    
    //读文件，填充数据
    
    
    NSUInteger cacheLength = self.requestTask.cacheLength;
    NSUInteger requestedOffset = loadingRequest.dataRequest.requestedOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {
        requestedOffset = loadingRequest.dataRequest.currentOffset;
    }
    NSUInteger canReadLength = cacheLength - (requestedOffset - self.requestTask.downStartOffset);
    NSUInteger respondLength = MIN(canReadLength, loadingRequest.dataRequest.requestedLength);
    
//    NSLog(@"===== start =====");
//
//    NSLog(@"cacheLength = %ld",cacheLength);
//    NSLog(@"loadingRequest.dataRequest.currentOffset = %lld",loadingRequest.dataRequest.currentOffset);
//    NSLog(@"requestedOffset = %ld",requestedOffset);
//    NSLog(@"canReadLength = %ld",canReadLength);
//    NSLog(@"self.requestTask.downStartOffset = %ld",self.requestTask.downStartOffset);
//    NSLog(@"loadingRequest.dataRequest.requestedLength = %ld",loadingRequest.dataRequest.requestedLength);
//    NSLog(@"respondLength = %ld",respondLength);
//
//    NSLog(@"===== end =====");
    
    if (self.requestTask.downStartOffset > requestedOffset) {
        return NO;
    }
    NSData *data = [self.fileManage readTempFileDataWithOffset:requestedOffset - self.requestTask.downStartOffset length:respondLength];
    if (data != nil) {
        [loadingRequest.dataRequest respondWithData:data];
    }else{
        return NO;
    }
    
    //如果完全响应了所需要的数据，则完成
    NSUInteger nowendOffset = requestedOffset + canReadLength;
    NSUInteger reqEndOffset = loadingRequest.dataRequest.requestedOffset + loadingRequest.dataRequest.requestedLength;
    if (nowendOffset >= reqEndOffset) {
        [loadingRequest finishLoading];
        return YES;
    }
    return NO;
}

-(void)requestVideoWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    NSUInteger fileLength = 0;
    if (self.requestTask) {
        fileLength = self.requestTask.fileLength;
        self.requestTask.cancel = YES;
    }
    
    _requestTask = [[HZ_RequestTask alloc] init];
    _requestTask.delegate = self;
    self.requestTask.requestURL = loadingRequest.request.URL;
    self.requestTask.downStartOffset = loadingRequest.dataRequest.requestedOffset;
//    self.requestTask.cache = _isCacheFinish;
    if (fileLength > 0) {
        self.requestTask.fileLength = fileLength;
    }
    self.requestTask.delegate = self;
    [self.requestTask start];
    self.seekRequired = NO;
}

#pragma mark - HZ_RequestTaskDelegate

-(void)requestTaskWithState:(HZ_RequestTaskState)state requestModel:(HZ_RequestTaskModel *)taskModel error:(NSError *)error{
    
    if ([_delgate respondsToSelector:@selector(hz_requestTaskWithState:error:)]) {
        [_delgate hz_requestTaskWithState:state error:error];
    }
    
    switch (state) {
        case HZ_RequestTaskSuccess:{
            
        }
            break;
        case HZ_RequestTaskLoading:{
            
            
            _fileManage.contentType = _requestTask.contentType;
            _fileManage.type = _requestTask.type;
            _fileManage.videoSize = _requestTask.fileLength;
            [_fileManage hz_removeTimeBeingFile];
        }
            break;
        case HZ_RequestTaskFailse:{
            
        }
            break;
        case HZ_RequestTaskUpdateCache:{
            
            if (taskModel.requestData != nil) {
                _fileManage.requestURL = taskModel.requestURL;
                [_fileManage cacheWithCacheData:taskModel.requestData];
                [self getCacheVideo];
            }
            
        }
            break;
        case HZ_RequestTaskFinishLoadingCache:{
            
            [self getCacheVideo];
            [_fileManage cacheTempFile];//生成路径
            _isCacheFinish = YES;
            [_fileManage hz_removeTimeBeingFile];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载

- (NSUInteger)cacheLength{
    
    return _requestTask.cacheLength;
}

-(HZ_CacheFileManage *)fileManage{
    
    if (_fileManage == nil) {
        _fileManage = [[HZ_CacheFileManage alloc] init];
    }
    return _fileManage;
}


-(NSArray<AVAssetResourceLoadingRequest *> *)loadingRequests{
    
    return [_loadingRequestMs copy];
}

-(NSLock *)loadLock{
    
    if (_loadLock == nil) {
        _loadLock = [[NSLock alloc] init];
        _loadLock.name = @"com.hzAvplayer.cacheLock";
    }
    return _loadLock;
}

@end
