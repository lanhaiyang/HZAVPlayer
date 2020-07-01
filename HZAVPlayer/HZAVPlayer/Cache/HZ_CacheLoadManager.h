//
//  HZ_CacheLoadMange.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/27.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HZ_CacheVideoConfigeBase.h"

@protocol HZ_CacheLoadManagerDelegate  <NSObject>

 @optional

/// 任务下载的状态
-(void)hz_requestTaskWithState:(HZ_RequestTaskState)state error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HZ_CacheLoadManager : NSObject<AVAssetResourceLoaderDelegate>


/// 监听任务下载的状态
@property(nonatomic,weak) id<HZ_CacheLoadManagerDelegate> delegate;

//@property (nonatomic, assign) BOOL seekRequired;

/// 缓存长度
@property(nonatomic,assign,readonly) NSUInteger cacheLength;


/// 通过url获得缓存地址
/// 该类是类方法 - 不需要初始化 - 如果返回空为没有缓存
+ (NSString *)filePathIsExistWithURL:(NSURL *)url;

/// 如果用户正在滑动进度条
- (void)isSlideProgress;

/// 通过url生成 AVURLAsset 对象
- (AVURLAsset *)getURLAssetObjectWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
