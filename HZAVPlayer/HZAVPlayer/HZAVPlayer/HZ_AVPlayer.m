//
//  HZ_AVPlayer.m
//  ZhongHangXin
//
//  Created by 何鹏 on 2017/12/7.
//  Copyright © 2017年 pingread. All rights reserved.
//

#import "HZ_AVPlayer.h"
#import "HZ_AVPlayerManage.h"
#import "NSString+HZ_Time.h"
#import <AVFoundation/AVFoundation.h>
#import "HP_LineRotateAnimation.h"
#import "HZ_AVPlayerLogic.h"
#import "HZ_AVPlayerWeb.h"

@interface HZ_AVPlayer()<HZAVPlayerRotateDelegate,HZAVPlayerDelgate,HPAVPlayerHeaderViewDelegate,HZAVPlayerBottomViewDelegate,HPAVPlayerWebDelegate>

@property(nonatomic,strong) HZ_AVPlayerManage *playerManage;

@property(nonatomic,strong) HP_LineRotateAnimation *lineLoadAnimation;

@property(nonatomic,strong) HZ_AVPlayerWeb *playerWeb;

@property(nonatomic,strong) UIView *customHeadeView;

@property(nonatomic,strong) UIView *customBottomView;

@property(nonatomic,assign) BOOL isHandOpenPlaye;

/// 在传入view的时候设置好frame的高度
//@property(nonatomic,assign) CGFloat headHeight;
//
///// 在传入view的时候设置好frame的高度
//@property(nonatomic,assign) CGFloat bottomHeight;

@end

@implementation HZ_AVPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layout];
        [self confige];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self layout];
    
}

-(void)confige{
    

    //静音状态下播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    _cacheMaxPlay = 0;
}

-(void)layout{
    
    _playerManage = [[HZ_AVPlayerManage alloc] initWithShowView:self.rotateView];
    _playerManage.delegate = self;
    _playerManage.isCache = NO;
    self.delegate = self;
    
    _playerHeaderView = [HZ_AVPlayerHeaderView getPlayerHeaderView];
    _playerHeaderView.delegate = self;
    _customHeadeView = _playerHeaderView;
    
    _playerBottomView = [HZ_AVPlayerBottomView getPlayerBottomView];
    _playerBottomView.delegate = self;
    _customBottomView = _playerBottomView;
    
}

-(void)updateWithHeadView:(UIView *)customHeadeView bottomView:(UIView *)customBottomView{
    
    if (customHeadeView == nil) {
        [_customHeadeView removeFromSuperview];
        _customHeadeView = nil;
        _customHeadeView = _playerHeaderView;
        _playerHeaderView.hidden = NO;
    }else{
        [_customHeadeView removeFromSuperview];
        _customHeadeView = nil;
        [_playerHeaderView removeFromSuperview];
        _customHeadeView = customHeadeView;
        if (customHeadeView.bounds.size.height == 0) {
            _headHeight = self.headHeight;
        }
        else if(_headHeight == 0){
            _headHeight = customHeadeView.bounds.size.height;
        }
    }
    
    if (customBottomView == nil) {
        [_customBottomView removeFromSuperview];
        _customBottomView = nil;
        _customBottomView = _playerBottomView;
        _playerBottomView.hidden = NO;
    }
    else{
        [_customBottomView removeFromSuperview];
        _customBottomView = nil;
        [_playerBottomView removeFromSuperview];
        _customBottomView = customBottomView;
        if (customBottomView.bounds.size.height == 0) {
            _bottomHeight = self.bottomHeight;
        }
        else if(_bottomHeight == 0){
            _bottomHeight = customBottomView.bounds.size.height;
        }
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    if (self.bounds.size.width == _customHeadeView.bounds.size.width && _customBottomView.bounds.size.height == self.bottomHeight) {
//        return;
//    }
    
    switch (_state) {
        case HZAVPlayerOnlyShowHead:
        {
            [_customBottomView removeFromSuperview];
            _customBottomView.hidden = YES;
            _customHeadeView.hidden = NO;
            _customHeadeView.frame = CGRectMake(0, 0, self.rotateView.bounds.size.width, self.headHeight);
            [self.rotateView addSubview:_customHeadeView];
        }
            break;
        case HZAVPlayerOnlyShowBottom:
        {
            [_customHeadeView removeFromSuperview];
            _customHeadeView.hidden = YES;
            _customBottomView.hidden = NO;
            CGFloat y = self.rotateView.bounds.size.height - self.bottomHeight;
            _customBottomView.frame = CGRectMake(0, y, self.rotateView.bounds.size.width, self.bottomHeight);
            [self.rotateView.superview addSubview:_customBottomView];
        }
            break;
        case HZAVPlayerShowHeadAndBottom:
        case HZAVPlayerClickOnlyHiddenHead:
        case HZAVPlayerClickOnlyHiddenBottom:
        case HZAVPlayerClickHiddenHeadAndBottom:{
            _customHeadeView.frame = CGRectMake(0, 0, self.rotateView.bounds.size.width, self.headHeight);
            
            CGFloat y = self.rotateView.bounds.size.height - self.bottomHeight;
            _customBottomView.frame = CGRectMake(0, y, self.rotateView.bounds.size.width, self.bottomHeight);
            _customHeadeView.hidden = NO;
            _customBottomView.hidden = NO;
            [self.rotateView addSubview:_customHeadeView];
            [self.rotateView addSubview:_customBottomView];
        }
            break;
        default:
            break;
    }
    
    self.lineLoadAnimation.frame = [HZ_AVPlayerLogic centreWithRect:self.rotateView.bounds relative:CGSizeMake(50, 50)];
    [_lineLoadAnimation updateLayout];
    
}

-(void)playerWithUrl:(NSURL *)url{
    
    _audioUrl = url.absoluteString;
    
    [_playerManage updateWithUrl:url];
    [self.playerWeb getUrlFileLength:url.absoluteString];
    if (_playerManage.isPlay == NO) {
        [self.rotateView.superview addSubview:self.lineLoadAnimation];
    }
}

#pragma mark - HPAVPlayerWebDelegate

-(void)targetWithFileLength:(long long)length error:(NSError *)error{
    
    if (error != nil || length == 0) {
//        [self loadWithState:HPAVPlayerFaile];
        return;
    }
    _fileSize = [HZ_AVPlayerLogic changeMbWithFileLengthKb:length];
}

#pragma mark - HPAVPlayerRotateDelegate

-(void)rotateWithChangeRect:(CGRect)rect rotate:(HZAVPlayerRotateStyle)rotate{
    
    [self playeUpdateWithPlayerLayer:rect];
    
}

-(void)tapActionView{

    [self playeTapActionView];
}


-(void)playeUpdateWithPlayerLayer:(CGRect)rect{
    
    [_playerManage updateWithPlayerLayer:rect];
}

-(void)playeTapActionView{
    
    CGFloat y = self.rotateView.bounds.size.height - self.bottomHeight;
    switch (_state) {
        case HZAVPlayerClickOnlyHiddenHead:
        {
            if (_customHeadeView.frame.origin.y == 0) {
                [self hiddeWithHeaderAndBottom];
            }
            else{
                [self showWithHeaderAndBottom];
            }
        }
            break;
        case HZAVPlayerClickOnlyHiddenBottom:
        {
            if (_customBottomView.frame.origin.y == y) {
                [self hiddeWithHeaderAndBottom];
            }
            else{
                [self showWithHeaderAndBottom];
            }
        }
            break;
        case HZAVPlayerClickHiddenHeadAndBottom:
        {
            if (_customHeadeView.frame.origin.y == 0) {
                [self hiddeWithHeaderAndBottom];
            }
            else{
                [self showWithHeaderAndBottom];
            }
        }
            break;
        case HZAVPlayerOnlyShowBottom:{
            
            if (_customBottomView.frame.origin.y == y) {
                [self showWithHeaderAndBottom];
            }
            else{
                [self hiddeWithHeaderAndBottom];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - HPAVPlayerDelgate

-(void)playerWithCurrentTimeSecond:(CGFloat)current{

    if (_playerBottomView != nil) {
        _playerBottomView.changeTime = [NSString convertTime:current];
        [_playerBottomView updateWithSlide:current];
    }
    
    if ([_playerDelegate respondsToSelector:@selector(updateWithSlide:)]) {
        [_playerDelegate updateWithSlide:current];
    }
    
}

-(void)playerWithLength:(NSTimeInterval)duration{
    
    if (_playerBottomView != nil) {
        [_playerBottomView slideWithMinValue:0 maxValue:duration];
        _playerBottomView.lenghtPlayer = [NSString convertTime:duration];
    }
    
    if ([_playerDelegate respondsToSelector:@selector(slideWithMinValue:maxValue:)]) {
        [_playerDelegate slideWithMinValue:0 maxValue:duration];
    }
}

-(void)playerWithCahceDuration:(CGFloat)duration{
    
    if (_playerBottomView != nil) {
        [_playerBottomView updataCacheWithProgress:duration];
    }
    if ([_playerDelegate respondsToSelector:@selector(updataCacheWithProgress:)]) {
        [_playerDelegate updataCacheWithProgress:duration];
    }
    
    if(duration == 1){
        [self loadWithState:HZAVPlayerLoadFinish];
    }
}

//-(void)playerCurrentTimeAndCacheTimeRate:(CGFloat)rate{
//    if (_playerBottomView.playerState == NO && rate >= _cacheMaxPlay) {
////        [_playerManage play];
//        [self loadWithState:HPAVPlayerLoadFinish];
//    }
//    else if(rate >= _cacheMaxPlay){
//        [self loadWithState:HPAVPlayerLoadFinish];
//    }
//    else if(rate < _cacheMaxPlay){
//        [self loadWithState:HPAVPlayerLoading];
////        [self pause];
//        [self privatePause];
//    }
//
//}

-(void)playerCurrentTimeIsNeedLoading:(BOOL)isLoading{
    
    if (_playerBottomView.playerState == NO && isLoading == NO) {
        //        [_playerManage play];
        [self loadWithState:HZAVPlayerLoadFinish];
    }
    else if(isLoading == NO){
        [self loadWithState:HZAVPlayerLoadFinish];
    }
    else if(isLoading == YES){
        [self loadWithState:HZAVPlayerLoading];
        //        [self pause];
        [self privatePause];
    }
}

-(void)seeTime:(CGFloat)second{
    if (second < 0) {
        second = 0;
    }
    
    [_playerManage updateChangePlayeWithTimeSecond:second];
//    [_playerManage slideTouchWithEnd];
}

#pragma mark - HPAVPlayerHeaderViewDelegate

-(void)backAction{
    
    
}

#pragma mark - HPAVPlayerBottomViewDelegate

-(void)playerAction:(BOOL)isSelection{
    
    if (isSelection == YES) {
        [self pause];
    }
    else{
        [self play];
    }
    
}

-(void)scaleAction{
    
    if ([HZ_AVPlayerRotate isOrientationLandscape] == NO) {
        if ([_playerDelegate respondsToSelector:@selector(hz_scaleActionWithOrientation:)]) {
            [_playerDelegate hz_scaleActionWithOrientation:UIInterfaceOrientationLandscapeRight];
        }
        [HZ_AVPlayerRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else{
        if ([_playerDelegate respondsToSelector:@selector(hz_scaleActionWithOrientation:)]) {
            [_playerDelegate hz_scaleActionWithOrientation:UIInterfaceOrientationPortrait];
        }
        [HZ_AVPlayerRotate forceOrientation:UIInterfaceOrientationPortrait];
    }
}

-(void)slideWithPointWithChange:(CGFloat)second{
    
    _playerBottomView.changeTime = [NSString convertTime:second];
    [_playerManage slideUpdateChangeWithSecond:second];
}

-(void)slideWithPointWithDown:(CGFloat)progress{
    
    [self privatePause];
}

-(void)slideWithPointWithUp:(CGFloat)progress{
    _playerBottomView.playerState = NO;
    [_playerManage slideTouchWithEnd];
}

-(void)loadWithState:(HZAVPlayerLoade)loadState{
    
    BOOL state = YES;
    if ([_playerDelegate respondsToSelector:@selector(loadWithState:)]) {
        state = [_playerDelegate loadWithState:(int)loadState];
    }
    
    if (state == NO) {//取消系统的加载
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (loadState == HZAVPlayerLoading) {
            
            [self.rotateView.superview addSubview:self.lineLoadAnimation];
            
        }else if(loadState == HZAVPlayerLoadFinish){
            
            if (self.isHandOpenPlaye == YES) {//外部播放
                [self privatePlay];
            }
            [self.lineLoadAnimation removeFromSuperview];
        }
        else if(loadState == HZPlayerLoadEnd){
            
            self.playerBottomView.playerState = YES;
            [self.lineLoadAnimation removeFromSuperview];
        }
        else if (loadState == HZAVPlayerFaile){
            [self.lineLoadAnimation removeFromSuperview];
        }
    });
    
}

-(void)play{
    
    _isHandOpenPlaye = YES;//外部调用播放
    [self privatePlay];
}

-(void)privatePlay{
    
    _playerBottomView.playerState = NO;
    [_playerManage play];
}

-(void)pause{
    
    _isHandOpenPlaye = NO;//外部调用暂停
    [self privatePause];
}

-(void)privatePause{
    
    _playerBottomView.playerState = YES;
    [_playerManage pause];
}

-(void)stop{
    _isHandOpenPlaye = NO;//外部调用暂停
    [_playerManage stop];
    
}

//-(void)setCacheMaxPlay:(CGFloat)cacheMaxPlay{
//    
//    _cacheMaxPlay = cacheMaxPlay;
//    
//    if (cacheMaxPlay > 1) {
//        cacheMaxPlay = 1;
//    }
//    else if(cacheMaxPlay < 0){
//        cacheMaxPlay = 0.1;
//    }
//    
//}

#pragma mark - 处理点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _playerManage.touchStyle = HZTouchPlayerNone;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_playerManage.touchStyle == HZTouchPlayerNone) {
        //可以做横竖屏设置
        
    }
}

-(void)hiddeWithHeaderAndBottom{
    
    CGFloat y = self.rotateView.bounds.size.height - self.bottomHeight;
    
    switch (_state) {
        case HZAVPlayerOnlyShowHead:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customBottomView.frame = CGRectMake(0, y+self.bottomHeight, self.rotateView.bounds.size.width, self.bottomHeight);
                             }];
        }
            break;
        case HZAVPlayerOnlyShowBottom:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customHeadeView.frame = CGRectMake(0, -self.headHeight, self.rotateView.bounds.size.width, self.headHeight);
                             }];
        }
            break;
        case HZAVPlayerShowHeadAndBottom:
        {
            
        }
            break;
        case HZAVPlayerClickOnlyHiddenHead:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customHeadeView.frame = CGRectMake(0, -self.headHeight, self.rotateView.bounds.size.width, self.headHeight);
                             }];
        }
            break;
        case HZAVPlayerClickOnlyHiddenBottom:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customBottomView.frame = CGRectMake(0, y+self.bottomHeight, self.rotateView.bounds.size.width, self.bottomHeight);
                             }];
        }
            break;
        case HZAVPlayerClickHiddenHeadAndBottom:
        {
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customHeadeView.frame = CGRectMake(0, -self.headHeight, self.rotateView.bounds.size.width, self.headHeight);
                                 self.customBottomView.frame = CGRectMake(0, y+self.bottomHeight, self.rotateView.bounds.size.width, self.bottomHeight);
                             }];
        }
            break;
        default:
            break;
    }
    
}

-(void)showWithHeaderAndBottom{
    
    CGFloat y = self.rotateView.bounds.size.height - self.bottomHeight;
    
    switch (_state) {
        case HZAVPlayerOnlyShowHead:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customBottomView.frame = CGRectMake(0, -self.bottomHeight, self.rotateView.bounds.size.width, self.bottomHeight);
                             }];
        }
            break;
        case HZAVPlayerOnlyShowBottom:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customHeadeView.frame = CGRectMake(0, 0, self.rotateView.bounds.size.width, self.headHeight);
                             }];
        }
            break;
        case HZAVPlayerShowHeadAndBottom:
        {
            
        }
            break;
        case HZAVPlayerClickOnlyHiddenHead:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customHeadeView.frame = CGRectMake(0, 0, self.rotateView.bounds.size.width, self.headHeight);
                             }];
        }
            break;
        case HZAVPlayerClickOnlyHiddenBottom:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customBottomView.frame = CGRectMake(0, y, self.rotateView.bounds.size.width, self.bottomHeight);
                             }];
        }
            break;
        case HZAVPlayerClickHiddenHeadAndBottom:
        {
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 self.customHeadeView.frame = CGRectMake(0, 0, self.rotateView.bounds.size.width, self.headHeight);
                                 self.customBottomView.frame = CGRectMake(0, y, self.rotateView.bounds.size.width, self.bottomHeight);
                             }];
        }
            break;
        default:
            break;
    }
    
}

-(BOOL)isPlay{
    return self.playerManage.isPlay;
}

-(void)setCyclePlayer:(BOOL)cyclePlayer{
    _cyclePlayer = cyclePlayer;
    _playerManage.cyclePlayer = cyclePlayer;
}

-(void)setIsMute:(BOOL)isMute{
    _isMute = isMute;
    _playerManage.isMute = isMute;
}

-(void)setIsCache:(BOOL)isCache{
    
    _isCache = isCache;
    _playerManage.isCache = isCache;
}

#pragma mark - 懒加载


-(void)setFillState:(HZAVPlayerFillStat)fillState{
    
    _fillState = fillState;
    self.playerManage.fillState = (int)fillState;
}

-(void)setIsLog:(BOOL)isLog{
    _isLog = isLog;
    self.playerManage.isLog = isLog;
    self.playerWeb.isLog = isLog;
}

-(CGFloat)headHeight{
    
    if (_headHeight == 0) {
        return 30;
    }
    return _headHeight;
}

-(HZ_AVPlayerWeb *)playerWeb{
    
    if (_playerWeb == nil) {
        _playerWeb = [[HZ_AVPlayerWeb alloc] init];
        _playerWeb.delegate = self;
    }
    return _playerWeb;
}

-(CGFloat)bottomHeight{
    
    if (_bottomHeight == 0) {
        return 35;
    }
    return _bottomHeight;
}

-(HP_LineRotateAnimation *)lineLoadAnimation{
    
    if (_lineLoadAnimation == nil) {
        _lineLoadAnimation = [[HP_LineRotateAnimation alloc] init];
        _lineLoadAnimation.edgeSpace = 10;
    }
    return _lineLoadAnimation;
}


@end

