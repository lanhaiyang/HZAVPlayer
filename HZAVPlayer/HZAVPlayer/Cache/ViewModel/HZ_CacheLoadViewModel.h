//
//  HZ_CacheLoadViewModel.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/27.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HZ_CacheVideoConfigeBase.h"

// requestTask
#import "HZ_RequestTask.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HZ_CacheLoadDelegate  <NSObject>

 @optional

/// 预留接口 暂时没有使用
-(void)hz_cahceLoadWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

/// 任务请求状态
-(void)hz_requestTaskWithState:(HZ_RequestTaskState)state error:(NSError *)error;

@end


@interface HZ_CacheLoadViewModel : NSObject


/// 获取任务下载状态
@property(nonatomic,weak) id<HZ_CacheLoadDelegate> delgate;

/// 任务下载队列
@property(nonatomic,strong,readonly) NSArray<AVAssetResourceLoadingRequest *> *loadingRequests;

/// 加载锁
@property(nonatomic,strong,readonly) NSLock *loadLock;

/// 当前正在请求的任务
@property(nonatomic,strong,readonly) HZ_RequestTask *requestTask;

/// 缓存长度
@property(nonatomic,assign,readonly) NSUInteger cacheLength;

/// 是否缓存完成
@property(nonatomic,assign) BOOL isCacheFinish;

/// Seek标识 主要表示是否正在拖动
@property (atomic, assign) BOOL seekRequired;

/// 有下载任务
-(void)addLoadingWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

/// 下载完成时，把下载任务删除
- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

@end


NS_ASSUME_NONNULL_END
