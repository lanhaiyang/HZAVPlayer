//
//  HZ_AVPlayerItem.h
//  HPLoadeAnimation
//
//  Created by 何鹏 on 2019/4/25.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HZ_AVPlayerOberverReadyToPlay,//加载成功
    HZ_AVPlayerOberverFailed,
    HZ_AVPlayerOberverUnknown,//未知的错误
    HZ_AVPlayerOberverDuration,
    HZ_AVPlayerOberverPresentationSize,//获得视频尺寸
    HZ_AVPlayerOberverTimeRanges,//获取时间范围
    HZ_AVPlayerOberverBufferEmpty,//缓存状态
    HZ_AVPlayerOberverLikelyToKeepUp,//加载状态结束
} HZ_AVPlayerOberverState;


@protocol HZ_AVPlayerItemObserverDelegate  <NSObject>

 @optional

-(void)hz_playerItemObserverWithState:(HZ_AVPlayerOberverState)state;

@end

@interface HZ_AVPlayerItem : AVPlayerItem

@property(nonatomic,weak) id<HZ_AVPlayerItemObserverDelegate> hz_observer;

///总时间
@property(nonatomic,assign) CGFloat totalDuration;

@property(nonatomic,strong,readonly) NSError *itemError;

+(instancetype)hz_playerItemWithAsset:(AVAsset *)asset;

+(instancetype)hz_initWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
