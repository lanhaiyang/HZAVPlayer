//
//  HZ_AVPlayerItem.m
//  HPLoadeAnimation
//
//  Created by 何鹏 on 2019/4/25.
//

#import "HZ_AVPlayerItem.h"
#import "HZ_AVCacheProgress.h"

@implementation HZ_AVPlayerItem


+(instancetype)hz_playerItemWithAsset:(AVAsset *)asset{
    HZ_AVPlayerItem *avPlayerItem = [HZ_AVPlayerItem playerItemWithAsset:asset];
    [avPlayerItem addObserverAndNotification];
    return avPlayerItem;
}

+(instancetype)hz_initWithURL:(NSURL *)URL{
    
    HZ_AVPlayerItem *avPlayerItem = [[HZ_AVPlayerItem alloc] initWithURL:URL];
    [avPlayerItem addObserverAndNotification];
    return avPlayerItem;
}

/**
 *  添加观察者 、通知 、监听播放进度
 */
- (void)addObserverAndNotification {

    [self addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性， 一共有三种属性
    [self addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 观察缓冲进度
    
    [self addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserveAndNOtification {
    [self removeObserver:self forKeyPath:@"status"];
    [self removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self removeObserver:self forKeyPath:@"duration"];
    [self removeObserver:self forKeyPath:@"presentationSize"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] intValue]; // 获取更改后的状态
        
        if (status == AVPlayerItemStatusUnknown) {
            
            if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
                [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverUnknown];
            }
        }else if (status == AVPlayerStatusReadyToPlay) {
            
            if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
                [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverReadyToPlay];
            }
        } else if (status == AVPlayerStatusFailed) {
            //NSLog(@"AVPlayerStatusFailed");
            _itemError = self.error;
            if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
//                [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverFailed];
            }
        } else {
            //NSLog(@"AVPlayerStatusUnknown");
            _itemError = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Error status Equal AVPlayerStatusUnknown"}];
            if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
                [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverUnknown];
            }

        }
        
    }else if ([keyPath isEqualToString:@"duration"]){
        
        if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
            [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverDuration];
        }
    }else if ([keyPath isEqualToString:@"presentationSize"]){
        
        if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
            [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverPresentationSize];
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {

        
        CGFloat totalDuration = CMTimeGetSeconds(self.duration); // 总时间
        if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
            _totalDuration = totalDuration;
            [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverTimeRanges];
        }
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {

        //缓存状态
        if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
            [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverBufferEmpty];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        if ([_hz_observer respondsToSelector:@selector(hz_playerItemObserverWithState:)]) {
            [_hz_observer hz_playerItemObserverWithState:HZ_AVPlayerOberverLikelyToKeepUp];
        }
    }
}

-(void)dealloc{
    [self removeObserveAndNOtification];
}

@end
