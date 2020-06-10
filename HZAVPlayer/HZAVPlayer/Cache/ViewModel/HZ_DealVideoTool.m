//
//  HZ_DealVideoTool.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/27.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_DealVideoTool.h"

@implementation HZ_DealVideoTool


+(BOOL)isAudioForURL:(NSURL *)url{
    
        if (url == nil) {
        return NO;
    }
    //判断是不是有音频轨道
    return [self isFormatForURL:url mediaType:AVMediaTypeAudio];
}


+(BOOL)isVideoForURL:(NSURL *)url{
    
    if (url == nil) {
        return NO;
    }
    //判断是不是有视频轨道
    return [self isFormatForURL:url mediaType:AVMediaTypeVideo];
}

+(BOOL)isFormatForURL:(NSURL *)url mediaType:(AVMediaType)mediaType{
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *tracks = [asset tracksWithMediaType:mediaType];
    //
    BOOL hasVideoTrack = [tracks count] > 0;
    return hasVideoTrack;
}

///  CMVideoCodecType  编码器的类型
+ (CMVideoCodecType)videoCodecTypeForURL:(NSURL *)url {
    
    AVURLAsset *videoAsset = (AVURLAsset *)[AVURLAsset URLAssetWithURL:url
                               options:nil];
    NSArray *videoAssetTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoAssetTrack = videoAssetTracks.firstObject;
    
    CMFormatDescriptionRef desc = (__bridge CMFormatDescriptionRef)videoAssetTrack.formatDescriptions.firstObject;
    CMVideoCodecType codec = CMVideoFormatDescriptionGetCodecType(desc);
    
    return codec;
}

+ (BOOL)isPlayerWithURL:(NSURL *)url{
    
    if (url == nil) {
        return NO;
    }
    AVAsset *videoAsset = [AVAsset assetWithURL:url];
    return videoAsset.isPlayable;
}


@end
