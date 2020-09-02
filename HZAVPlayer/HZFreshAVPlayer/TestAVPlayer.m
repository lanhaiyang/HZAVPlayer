//
//  TestAVPlayer.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "TestAVPlayer.h"
#import "HZ_AVPlayerManage.h"
#import "NSString+HZ_Time.h"
#import <AVFoundation/AVFoundation.h>
#import "HP_LineRotateAnimation.h"
#import "HZ_AVPlayerLogic.h"
#import "HZ_AVPlayerWeb.h"

@interface TestAVPlayer()<HPAVPlayerDelgate,HPAVPlayerWebDelegate>

@property(nonatomic,strong) UIView *playerView;//播放使用的View

@property(nonatomic,strong) HZ_AVPlayerManage *playerManage;
@property(nonatomic,strong) HP_LineRotateAnimation *lineLoadAnimation;
@property(nonatomic,strong) HZ_AVPlayerWeb *playerWeb;

@property(nonatomic,strong) UIView *customHeadeView;
@property(nonatomic,strong) UIView *customBottomView;
@property(nonatomic,assign) BOOL isHandOpenPlaye;



@end

@implementation TestAVPlayer

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatObj];
        [self confige];
    }
    return self;
}

-(void)creatObj{
    
    
    _playerManage = [[HZ_AVPlayerManage alloc] initWithShowView:self.playerView];
    _playerManage.delegate = self;
    _playerManage.isCache = NO;
    
    [self addSubview:self.playerView];
    [self addSubview:self.contentView];
    [self insertSubview:self.playerView atIndex:0];
}

-(void)confige{
    

    //静音状态下播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    _cacheMaxPlay = 0;
}
#pragma mark - HPAVPlayerWebDelegate

-(void)targetWithFileLength:(long long)length error:(NSError *)error{
    
    if (error != nil || length == 0) {
//        [self loadWithState:HPAVPlayerFaile];
        return;
    }
    _fileSize = [HZ_AVPlayerLogic changeMbWithFileLengthKb:length];
}


#pragma mark - HPAVPlayerDelgate

-(void)playerWithCurrentTimeSecond:(CGFloat)current{

//    if (_playerBottomView != nil) {
//        _playerBottomView.changeTime = [NSString convertTime:current];
//        [_playerBottomView updateWithSlide:current];
//    }
//
//    if ([_playerDelegate respondsToSelector:@selector(updateWithSlide:)]) {
//        [_playerDelegate updateWithSlide:current];
//    }
    
}

-(void)playerWithLength:(NSTimeInterval)duration{
    
//    if (_playerBottomView != nil) {
//        [_playerBottomView slideWithMinValue:0 maxValue:duration];
//        _playerBottomView.lenghtPlayer = [NSString convertTime:duration];
//    }
//
//    if ([_playerDelegate respondsToSelector:@selector(slideWithMinValue:maxValue:)]) {
//        [_playerDelegate slideWithMinValue:0 maxValue:duration];
//    }
}

-(void)playerWithCahceDuration:(CGFloat)duration{
    
//    if (_playerBottomView != nil) {
//        [_playerBottomView updataCacheWithProgress:duration];
//    }
//    if ([_playerDelegate respondsToSelector:@selector(updataCacheWithProgress:)]) {
//        [_playerDelegate updataCacheWithProgress:duration];
//    }
//
//    if(duration == 1){
//        [self loadWithState:HPAVPlayerLoadFinish];
//    }
}

-(void)playerCurrentTimeIsNeedLoading:(BOOL)isLoading{
    
//    if (_playerBottomView.playerState == NO && isLoading == NO) {
//        //        [_playerManage play];
//        [self loadWithState:HPAVPlayerLoadFinish];
//    }
//    else if(isLoading == NO){
//        [self loadWithState:HPAVPlayerLoadFinish];
//    }
//    else if(isLoading == YES){
//        [self loadWithState:HPAVPlayerLoading];
//        //        [self pause];
//        [self privatePause];
//    }
}

-(void)seeTime:(CGFloat)second{
    if (second < 0) {
        second = 0;
    }
    
    [_playerManage updateChangePlayeWithTimeSecond:second];
}

#pragma mark - 懒加载

-(HZ_AVPlayerWeb *)playerWeb{
    
    if (_playerWeb == nil) {
        _playerWeb = [[HZ_AVPlayerWeb alloc] init];
        _playerWeb.delegate = self;
    }
    return _playerWeb;
}
@end
