//
//  HZ_AVPlayerManage.m
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HZ_AVPlayerManage.h"
#import <AVFoundation/AVFoundation.h>
#import "HZ_AVCacheProgress.h"
#import "HZ_TVideoLoadManager.h"
#import "HZ_TVideoFileManager.h"
#import "HZ_Encryption.h"
#import "HZ_AVPlayerItem.h"

@interface HZ_AVPlayerManage()<VideoLoadManagerProtocol,HZ_AVPlayerItemObserverDelegate>

@property(nonatomic,strong) HZ_AVPlayerItem *playerItem;
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerLayer *playerLayer;
@property(nonatomic,strong) HZ_TVideoLoadManager *videoLoader;

@property(nonatomic,assign) float currentPlayTime;

@property(nonatomic,strong) id playTimeObserver;
//@property(nonatomic,assign) BOOL isIntoBackground;

@property(nonatomic,assign) BOOL isSliding;//是否在滑动

@property(nonatomic,weak) UIView *superView;

@property(nonatomic,assign) BOOL isPlay;
@property(nonatomic,assign) BOOL isObserver;
@property(nonatomic,assign) CGRect updateRect;

@property(nonatomic,strong) dispatch_queue_t playeQueue;
@property(nonatomic,strong) NSError *error;
@property(nonatomic,strong) NSString *url;

@end

@implementation HZ_AVPlayerManage

-(instancetype)initWithShowView:(UIView *)view{
    
    if (self = [super init]) {
        
        [self confige];
        _superView = view;
    }
    return self;
}

-(void)confige{
    
    _fillState = HPAVPlayerLayerResizeAspectFill;
}

-(void)updateWithPlayerLayer:(CGRect)rect{
    
    _updateRect = rect;
    _playerLayer.frame = rect;
    
}

-(void)updateWithUrl:(NSURL *)url{
    if ((url == nil || [_url containsString:url.absoluteString] || [_url isEqualToString:url.absoluteString]) && self.player != nil) {
        return;
    }
    
    [self initAVElements:url.absoluteString videoName:[HZ_Encryption hz_md5:url.absoluteString]];
    
//    [_player play]; //测试
    
}

-(CGFloat )getSoundSize{
    
    return _player.volume;
}

-(void)setSoundSize:(CGFloat)size{
    
    _player.volume = size;
    
}

-(void)slideUpdateChangeWithSecond:(CGFloat)second{
    
    _isSliding = YES;
//    NSLog(@"正在滑动");
    [self updateChangePlayeWithTimeSecond:second];
}

-(void)updateChangePlayeWithTimeSecond:(CGFloat)second{
    
    [_playerItem cancelPendingSeeks];
    //    [self pause];
    // 跳转到拖拽秒处
    //    CGFloat fps = [[[_playerItem.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
    CMTime changedTime = CMTimeMakeWithSeconds(second, 1000);
    if (changedTime.timescale < 0) {
        return;
    }
    _currentPlayTime = second;
    [_player seekToTime:changedTime toleranceBefore:CMTimeMake(1, 1000)
         toleranceAfter:CMTimeMake(1, 1000)];
}

-(void)slideTouchWithEnd{
    [self play];
    _isSliding = NO;
//    NSLog(@"滑动结束");
}


-(void)play{
    if (_isPlay == YES) {
        return;
    }
    [_player play];
    _isPlay = YES;
}

-(void)pause{
    if (_isPlay == NO) {
        return;
    }
    [_player pause];
    _isPlay = NO;
}

-(void)stop{
    [_player pause];
    [self removeObserveAndNOtification];
    [self reset];
    _isPlay = NO;
}

- (void)reset
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.videoLoader cancelDownLoad];
        self.videoLoader = nil;
        [self.playerItem.asset cancelLoading];
    });
    
    AVURLAsset* temp = (AVURLAsset*)self.playerItem.asset;
    [temp.resourceLoader setDelegate:nil queue:nil];
    if ([NSThread isMainThread] == NO) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.playerLayer  setPlayer:nil];
        });
    }else{
        [self.playerLayer setPlayer:nil];
    }
    
    self.player = nil;
    
}

-(UIImage *)videoFristFrameWithImage{
    
    AVAssetImageGenerator *imageGrnerator = [[AVAssetImageGenerator alloc] initWithAsset:_playerItem.asset];
    imageGrnerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [imageGrnerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
    
}

- (UIImage *)thumbnailImageAtCurrentTime {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_playerItem.asset];
    CMTime expectedTime = _playerItem.currentTime;
    CGImageRef cgImage = NULL;
    
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    
    if (!cgImage) {
        imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

- (UIImage *)firstFrameWithSecond:(NSInteger )second imageSize:(CGSize)size
{
    // 获取视频第一帧
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_playerItem.asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(second, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return [self videoFristFrameWithImage];
}


/**
 *  添加观察者 、通知 、监听播放进度
 */
- (void)addObserverAndNotification {
//    if (_isObserver == YES) {
//        return;
//    }
//    _isObserver = YES;
//    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性， 一共有三种属性
//    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 观察缓冲进度
//
//    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
//
//
    [self monitoringPlayback:_playerItem]; // 监听播放
    [self addNotification]; // 添加通知
}

// 观察播放进度
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self)WeakSelf = self;
    if (_playTimeObserver != nil) {
        return;
    }
    // 播放进度, 每秒执行2次， CMTime 为2分之一秒
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        NSLog(@"test 1");
        BOOL endState = NO;
        __typeof__(WeakSelf) StrongSelf = WeakSelf;
        
        if (StrongSelf.playerItem == nil || StrongSelf.playerItem.error != nil) {
            if (StrongSelf.isLog == YES) {
                NSLog(@"❌ Discover playerItem is nil or error");
            }
            return;
        }

        if (StrongSelf.touchStyle != HPTouchPlayerHorizontal) {

            CGFloat endTime = [HZ_AVCacheProgress getPlayerWithLength:StrongSelf.playerItem];
            if (StrongSelf.currentPlayTime >= endTime - 0.2 && endState == NO) {
                endState = YES;
                [StrongSelf pause];
                [StrongSelf playbackFinished];
//                NSLog(@"===> pause");
                return ;
            }

            if (StrongSelf.currentPlayTime == 0 && StrongSelf.isPlay == NO) {
                endState = NO;
            }

            // 更新slider, 如果正在滑动则不更新
            if (StrongSelf.isSliding == NO && [StrongSelf.delegate respondsToSelector:@selector(playerWithCurrentTimeSecond:)]) {
                // 当前播放秒
                StrongSelf.currentPlayTime = CMTimeGetSeconds(time);
                [StrongSelf.delegate playerWithCurrentTimeSecond:StrongSelf.currentPlayTime];
//                StrongSelf.isPlay = YES;
            }
        } else {
            return;
        }
    }];
}


- (void)playbackFinished{
    if (_isLog == YES) {
        //NSLog(@"视频播放完成通知");
    }
//    _playerItem = [notification object];
    // 是否无限循环
    
    __weak typeof(self) weakSelf = self;
    if (_cyclePlayer == NO) {
        [_playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
//            weakSelf.currentPlayTime = 0;
            [self updateChangePlayeWithTimeSecond:0];
            [weakSelf pause];
        }]; // 跳转到初始
    }
    else{
        [_playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
//            weakSelf.currentPlayTime = 0;
            [self updateChangePlayeWithTimeSecond:0];
            [weakSelf play];
        }];
    }
    
    [self loadWithState:HPAVPlayerEnd];
}


-(void)setCahceDuration:(NSTimeInterval)cacheTime playerLength:(CGFloat)totalDuration{
    
    float cacheTimeRate = cacheTime / totalDuration;
    if ([self.delegate respondsToSelector:@selector(playerWithCahceDuration:)]) {
        
        [self.delegate playerWithCahceDuration:cacheTimeRate];
    }
    
    float currentRate=self.currentPlayTime/[HZ_AVCacheProgress getPlayerWithLength:_playerItem];
    
    if (currentRate < 0) {
        currentRate = 0;
    }
    
//    float currentAndCacheRate = cacheTimeRate - currentRate;
//    float currentAndCacheRate = self.currentPlayTime/cacheTime;
//
//    if (currentAndCacheRate > 1) {
//        currentAndCacheRate = 0;//缓冲还没准备好
//    }
    
    float currentAndCacheTimeRate = cacheTime - self.currentPlayTime;
    
    if (currentAndCacheTimeRate <= 0) {
        // 播放超过缓存
        currentAndCacheTimeRate = 0;
    }
    else if(currentAndCacheTimeRate > 0){
        
//        currentAndCacheTimeRate = self.currentPlayTime/cacheTime;
        currentAndCacheTimeRate = cacheTime/self.durationLength;
        if (cacheTime >= self.durationLength) {
            //加载完所有
            currentAndCacheTimeRate = 1;
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(playerCurrentTimeAndCacheTimeRate:)]) {
        
        [self.delegate playerCurrentTimeAndCacheTimeRate:currentAndCacheTimeRate];
        
    }
    
}

-(void)setMaxDuration{
    
    //准备播放
    if ([self.delegate respondsToSelector:@selector(playerWithLength:)]) {
        _durationLength = [HZ_AVCacheProgress getPlayerWithLength:_playerItem];
        [self.delegate playerWithLength:_durationLength];
    }
}

#pragma mark - 缓存

- (void)initAVElements:(NSString *)url videoName:(NSString *)videoName {

    [self playerStatusStartLoading];
    dispatch_async(self.playeQueue, ^{
        
        if (self.isCache == YES) {
            AVURLAsset *videoAsset = [self generateAVURLAssetUrl:url videoName:videoName];
            if (videoAsset == nil){
                self.error = [NSError errorWithDomain:NSURLErrorDomain code:121 userInfo:@{NSLocalizedDescriptionKey:@"AVURLAsset is nil can url Analytical problem"}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self playerStatusOccureError];
                });
                return;
            }
            self.playerItem = [HZ_AVPlayerItem hz_playerItemWithAsset:videoAsset];
            self.playerItem.hz_observer = self;
        }
        else{
            self.playerItem = [HZ_AVPlayerItem hz_initWithURL:[NSURL URLWithString:url]];
            self.playerItem.hz_observer = self;
        }
        
        if (self.player == nil) {
            self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//            if([[UIDevice currentDevice] systemVersion].intValue>=10){
//            //      增加下面这行可以解决iOS10兼容性问题了
//                self.player.automaticallyWaitsToMinimizeStalling = NO;
//                [self.player playImmediatelyAtRate:1];
//                self.playerItem.preferredForwardBufferDuration = 1;
//            }
            self.playerLayer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.superView.layer addSublayer:self.playerLayer];
            });
            self.player.muted = self.isMute;
            self.url = url;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self removeObserveAndNOtification];
//            [self playerStatusLoadFinish];
            [self addObserverAndNotification]; // 添加观察者，发布通知
            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        });
    });
    
}

- (AVURLAsset *)generateAVURLAssetUrl:(NSString *)url videoName:(NSString *)videoName
{
    AVURLAsset *videoAsset = nil;
    if ([url containsString:@".m3u8"]) {
        videoAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:url]];
        return videoAsset;
    }
    if ( [HZ_TVideoFileManager hasFinishedVideoCache:videoName]) {  //区分 直播和 点播
        videoAsset = [AVURLAsset assetWithURL:[HZ_TVideoFileManager cacheFileExistsWithName:videoName]];
    } else  {
        videoAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[HZ_TVideoLoadManager encryptionDownLoadUrl:url]]  options:nil];
        _videoLoader = [[HZ_TVideoLoadManager alloc]initWithFileName:videoName];
        _videoLoader.delegate = self;
        [videoAsset.resourceLoader setDelegate:_videoLoader queue:dispatch_get_global_queue(0, 0)];
    }
    return videoAsset;
}

-(void)playerStatusStartLoading{
    
    [self loadWithState:HPAVPlayerLoading];
}

-(void)playerStatusOccureError{
    
    [self loadWithState:HPAVPlayerFaile];
}

-(void)playerStatusSuccess{
    
    [self loadWithState:HPAVPlayerSuccess];
}

-(void)playerStatusLoadFinish{
    
    [self loadWithState:HPAVPlayerLoadFinish];
}

-(void)loadWithState:(HPAVPlayerLoade)loadState{
    
    if ([self.delegate respondsToSelector:@selector(loadWithState:)]) {
        _state = loadState;
        [self.delegate loadWithState:loadState];
    }
}

#pragma mark - Load manager

- (void)requestNetError{
    //    //NSLog(@"downLoad net work error");

    [_videoLoader cancelDownLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"AVPlayerStatusFailed");
        _error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Error down url"}];
        [self playerStatusOccureError];
//        [self reset];
//        if ([self.delegate respondsToSelector:@selector(loadWithState:)]) {
//
//            [self.delegate loadWithState:HPLoadFinish];
//        }
    });
}

#pragma mark - HZ_AVPlayerItemObserverDelegate

-(void)hz_playerItemObserverWithState:(HZ_AVPlayerOberverState)state{
    
    switch (state) {
        case HZ_AVPlayerOberverReadyToPlay:{
            
            [self setMaxDuration];
            [self playerStatusSuccess];
        }
            break;
        case HZ_AVPlayerOberverFailed:{
            
            _error = _playerItem.error;
            [self playerStatusOccureError];
            [self pause];
        }
            break;
        case HZ_AVPlayerOberverUnknown:{
            
            _error = _playerItem.error;
            [self playerStatusOccureError];
            [self pause];
        }
            break;
        case HZ_AVPlayerOberverTimeRanges:{

            NSTimeInterval timeInterval = [HZ_AVCacheProgress cahceWithAvailableDuration:_player]; // 缓冲时间
            [self setCahceDuration:timeInterval playerLength:_playerItem.totalDuration];
        }
            break;
        case HZ_AVPlayerOberverLikelyToKeepUp:{
            
            BOOL isKeepup = _playerItem.playbackLikelyToKeepUp;
            if (isKeepup == NO) {
                if ( [_videoLoader netWorkError]) {
                    _error = [NSError errorWithDomain:NSURLErrorDomain code:121 userInfo:@{NSLocalizedDescriptionKey:@"Error netWork Error"}];
                    [_playerItem.asset cancelLoading];
                    [self playerStatusOccureError];
                } else {
                    [self playerStatusStartLoading];
                }
            }
        }
            break;
        case HZ_AVPlayerOberverBufferEmpty:{
            
            [self playerStatusStartLoading];
        }
            break;
        default:
            break;
    }
}

#pragma mark-
#pragma mark 添加通知
- (void)addNotification {
    // 播放完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)enterForegroundNotification{
    
    if ([self.dataSource respondsToSelector:@selector(enterForegroundNotification)]) {
        [self.dataSource enterForegroundNotification];
    }
}

-(void)enterBackgroundNotification{
    
    if ([self.dataSource respondsToSelector:@selector(enterBackgroundNotification)]) {
        [self.dataSource enterBackgroundNotification];
    }
}

- (void)dealloc {
    [self removeObserveAndNOtification];
//    [_player removeTimeObserver:_playTimeObserver]; // 移除playTimeObserver
}

- (void)removeObserveAndNOtification {
//    if (_isObserver == YES) {
//        _isObserver = NO;
////        [_playerItem removeObserver:self forKeyPath:@"status"];
////        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
////        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
////        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
//        [_player replaceCurrentItemWithPlayerItem:nil];
//
//        [_player removeTimeObserver:_playTimeObserver];
//        _playTimeObserver = nil;
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
    if (_playTimeObserver == nil) {
        return;
    }
    
    [_player replaceCurrentItemWithPlayerItem:nil];
    
    [_player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    _url = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


#pragma mark - 懒加载

-(void)setFillState:(HPAVPlayerLayerFillStat)fillState{
    
    _fillState = fillState;
    switch (fillState) {
        case HPAVPlayerLayerResizeAspect:
        {
            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
            break;
        case HPAVPlayerLayerResizeAspectFill:
        {
            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }
            break;
        case HPAVPlayerLayerResize:
        {
            _playerLayer.videoGravity = AVLayerVideoGravityResize;
        }
            break;
        default:
            break;
    }
    
}

-(void)setIsMute:(BOOL)isMute{
    _isMute = isMute;
    self.player.muted = _isMute;
}

//-(AVPlayer *)player{
//
//    if (_player == nil) {
//        _player = [[AVPlayer alloc] init];
//    }
//    return _player;
//
//}


-(dispatch_queue_t)playeQueue{
    
    if (_playeQueue == nil) {
        _playeQueue = dispatch_queue_create("com.huazhen.avplayerManage", DISPATCH_QUEUE_SERIAL);
    }
    return _playeQueue;
}

-(AVPlayerLayer *)playerLayer{
    
    if (_playerLayer == nil) {
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = _updateRect;
        /*
         AVLayerVideoGravityResizeAspect
         AVLayerVideoGravityResizeAspectFill
         AVLayerVideoGravityResize

         */
        self.fillState = _fillState;
//        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self clearLayers];
        
    }
    return _playerLayer;
}

-(BOOL)isPlay{
    
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }else{
        return _isPlay;
    }
}

-(void)clearLayers{
    if (self.superView == nil) {
        return;
    }
    for (CALayer *layer in self.superView.layer.sublayers) {
        if ([layer class] == [AVPlayerLayer class]) {
            [layer removeFromSuperlayer];
        }
    }
}

@end
