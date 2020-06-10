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

-(void)hz_cahceLoadWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

-(void)hz_requestTaskWithState:(HZ_RequestTaskState)state error:(NSError *)error;

@end


@interface HZ_CacheLoadViewModel : NSObject

@property(nonatomic,weak) id<HZ_CacheLoadDelegate> delgate;

@property(nonatomic,strong,readonly) NSArray<AVAssetResourceLoadingRequest *> *loadingRequests;

@property(nonatomic,strong,readonly) NSLock *loadLock;

@property(nonatomic,strong,readonly) HZ_RequestTask *requestTask;

/// 缓存长度
@property(nonatomic,assign,readonly) NSUInteger cacheLength;

@property(nonatomic,assign) BOOL isCacheFinish;

@property (atomic, assign) BOOL seekRequired; //Seek标识


-(void)addLoadingWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

@end


NS_ASSUME_NONNULL_END
