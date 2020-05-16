//
//  HZ_AVCacheProgress.m
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HZ_AVCacheProgress.h"
#import <AVFoundation/AVFoundation.h>

@implementation HZ_AVCacheProgress

+(CGFloat)getCurrentPlayTime:(AVPlayerItem *)playerItem{

    return (double)playerItem.currentTime.value/ playerItem.currentTime.timescale;
}

+(NSTimeInterval)getPlayerWithLength:(AVPlayerItem *)playerItem{

    CMTime cmtime = playerItem.asset.duration;
    if (cmtime.timescale == 0) {
        return 0;
    }
    int seconds = (int)cmtime.value/cmtime.timescale;
//    CMTime duration1 = playerItem.duration;

//    return  CMTimeGetSeconds(duration1);
    return seconds;
}

// 计算缓冲进度
+ (NSTimeInterval)cahceWithAvailableDuration:(AVPlayer *)player {
    NSArray *loadedTimeRanges = [[player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    
    return result;
}


@end
