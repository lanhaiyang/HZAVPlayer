//
//  HZ_AVCacheProgress.h
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayerItem;
@class AVPlayer;

@interface HZ_AVCacheProgress : NSObject


/**
 获取当前视频播放进度

 @param playerItem AVPlayerItem 类
 @return 播放进度
 */
+(CGFloat)getCurrentPlayTime:(AVPlayerItem *)playerItem;

/**
 获得播放时长

 @param playerItem AVPlayerItem 类
 @return 播放时长
 */
+(NSTimeInterval)getPlayerWithLength:(AVPlayerItem *)playerItem;


/**
 获得缓存时长

 @param player AVPlayer 类型
 @return 缓存时长
 */
+ (NSTimeInterval)cahceWithAvailableDuration:(AVPlayer *)player;

@end
