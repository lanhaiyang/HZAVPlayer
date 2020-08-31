//
//  HZ_DealVideoTool.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/27.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_DealVideoTool : NSObject

+(BOOL)isAudioForURL:(NSURL *)url;


+(BOOL)isVideoForURL:(NSURL *)url;

/// 返回视频格式
+ (CMVideoCodecType)videoCodecTypeForURL:(NSURL *)url;

+ (BOOL)isPlayerWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
