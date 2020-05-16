//
//  VideoLoadManager.m
//  AVPlayerController
//
//  Created by hailong9 on 16/12/27.
//  Copyright © 2016年 hailong9. All rights reserved.
//

#import "HZ_TVideoLoadManager.h"
#import "HZ_TVideoFileManager.h"
#import <libkern/OSAtomic.h>
#import "HZ_TVideoDownOperation.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation HZ_TVideoLoadManager
{
    NSUInteger _fileLength;
    NSUInteger _cancelLength;
    HZ_TVideoFileManager* _fileManager;
    NSMutableArray* _requestArr;
    NSLock *_oslock ;
    NSData* resourceData;
    NSDictionary* _httpHeader;
}



- (instancetype)initWithFileName:(NSString*)fileName
{
    self = [super init];
    _fileManager = [[HZ_TVideoFileManager alloc]initWithFileName:fileName];
     _requestArr = [NSMutableArray arrayWithCapacity:0];
     _oslock = [[NSLock alloc] init];
    return self;
}

+ (NSString*)decodeDownLoadUrl:(NSString*)url
{
    return [NSString stringWithFormat:@"http%@",url];
}
+ (NSString*)encryptionDownLoadUrl:(NSString *)url
{
    if ([url hasPrefix:@"http"]) {
        return [url substringFromIndex:4];
    }
    return nil;
}

- (void)cancelDownLoad{
    [_oslock lock];
    for (HZ_TVideoDownQueue* temp in _requestArr) {
        AVAssetResourceLoadingRequest * compare = [temp assetResource];
        if (compare.isCancelled == NO && compare.isFinished == NO) {
             [compare finishLoadingWithError:nil];
        }
        [temp cancelDownLoad];
    }
    [_requestArr removeAllObjects];
    [_oslock unlock];
}

- (BOOL)netWorkError
{
    [_oslock lock];
    for (HZ_TVideoDownQueue* temp in _requestArr) {
        if (temp.isNetworkError == YES) {
            [_oslock unlock];
            return YES;
        }
    }
    [_oslock unlock];
    return NO;
}
#if 1
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
//    //NSLog(@"loadingRequest %ld-%ld ", loadingRequest.dataRequest.requestedOffset,loadingRequest.dataRequest.requestedLength+loadingRequest.dataRequest.requestedOffset-1);
    [self checkResourceLoader];
    if (loadingRequest.contentInformationRequest) {
        CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(@"video/mp4"), NULL);
        loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    }
    
    [_oslock lock];
    if ([_fileManager getFileLength] != 0 )  {
        
        if (loadingRequest.dataRequest.requestedLength == 2) {
            
            loadingRequest.contentInformationRequest.contentLength = [_fileManager getFileLength];
            NSData* data =  [_fileManager readTempFileDataWithOffset:0 length:2];
            [loadingRequest.dataRequest respondWithData:data];
            [loadingRequest finishLoading];
            [_oslock unlock];
            return true;
        }
    }
    
    NSString* downUrl = [HZ_TVideoLoadManager decodeDownLoadUrl:loadingRequest.request.URL.absoluteString];
    HZ_TVideoDownQueue* downLoad = [[HZ_TVideoDownQueue alloc]initWithFileManager:_fileManager WithLoadingRequest:loadingRequest loadingUrl:[NSURL URLWithString:downUrl] withHttpHead:_httpHeader];
    downLoad.delegate = self;
    [_requestArr addObject:downLoad];
    [_oslock unlock];
    return YES;
 }


#else

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    //NSLog(@"loadingRequest %ld-%ld  toend %d", loadingRequest.dataRequest.requestedOffset,loadingRequest.dataRequest.requestedLength+loadingRequest.dataRequest.requestedOffset-1,loadingRequest.dataRequest.requestsAllDataToEndOfResource);
   
    [self checkResourceLoader];
     CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(@"video/mp4"), NULL);
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = NO;
    //exist video cache
    if ([_fileManager getFileLength] != 0 )  {
        
        if (loadingRequest.dataRequest.requestedLength == 2) {
            
            loadingRequest.contentInformationRequest.contentLength = [_fileManager getFileLength];
            NSData* data =  [_fileManager readTempFileDataWithOffset:0 length:2];
            [loadingRequest.dataRequest respondWithData:data];
            [loadingRequest finishLoading];
            
        }
        else if(_downLoad &&(loadingRequest.dataRequest.requestedOffset == 0 || loadingRequest.dataRequest.requestedOffset == 2))
        {
            _downLoad.assetResource = loadingRequest;
        }
        else
        {
            
            if (_downLoad) {
                [_downLoad videoLoaderSychronizeProcessToConfigure];
                [_downLoad cancel];
                _downLoad = nil;
            }

            OSSpinLockLock(&oslock);
            NSString* downUrl = [VideoLoadManager decodeDownLoadUrl:loadingRequest.request.URL.absoluteString];
            VideoDownQueue* downLoad = [[VideoDownQueue alloc]initWithFileManager:_fileManager WithLoadingRequest:loadingRequest loadingUrl:[NSURL URLWithString:downUrl]];
            [_requestArr addObject:downLoad];
            OSSpinLockUnlock(&oslock);

        }
         return true;
    }

    if (loadingRequest.dataRequest.requestedOffset == 0 || loadingRequest.dataRequest.requestedOffset == 2) {
        
            NSString* downUrl = [VideoLoadManager decodeDownLoadUrl:loadingRequest.request.URL.absoluteString];
            _downLoad = [[VideoLoader alloc]initWithUrl:[NSURL URLWithString:downUrl] withRange:NSMakeRange(loadingRequest.dataRequest.requestedOffset, loadingRequest.dataRequest.requestedLength)];
            _downLoad.assetResource = loadingRequest;
            _downLoad.fileManager = _fileManager;
            [_downLoad start];
        return true;
    }
    
    return true;
}

#endif

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
//    //NSLog(@"didCancelLoadingRequest  %ld-%ld",loadingRequest.dataRequest.requestedOffset,loadingRequest.dataRequest.requestedOffset+loadingRequest.dataRequest.requestedLength-1);
    [_oslock lock];
        NSMutableArray* removeAr = [NSMutableArray arrayWithCapacity:0];
        for (HZ_TVideoDownQueue* temp in _requestArr) {
            AVAssetResourceLoadingRequest * compare = [temp assetResource] ;
            if (compare == loadingRequest || compare.isFinished) {
                [temp cancelDownLoad];
                [removeAr addObject:temp];
            }
        }
        [_requestArr removeObjectsInArray:removeAr];
    [_oslock unlock];
}


- (void)checkResourceLoader
{
    [_oslock lock];
    NSMutableArray* removeAr = [NSMutableArray arrayWithCapacity:0];
    for (HZ_TVideoDownQueue* temp in _requestArr) {
        AVAssetResourceLoadingRequest * compare = [temp assetResource] ;
        if (compare.isCancelled || compare.isFinished) {
             [removeAr addObject:temp];
            [temp cancelDownLoad];
            [temp sychronizeProcessToConfigure];
        } else {
//            [compare finishLoadingWithError:nil];
        }
    }
    [_requestArr removeObjectsInArray:removeAr];
    [_oslock unlock];

}


- (void)setHTTPHeaderField:(NSDictionary *)header{
    _httpHeader = header;
}

#pragma mark -DownloadQueue delegate

- (void)loadNetError:(HZ_TVideoDownQueue *)downQueue{
    if ([self.delegate respondsToSelector:@selector(requestNetError)]) {
        [self.delegate requestNetError];
    }
}

- (void)dealloc{
    
}

@end
