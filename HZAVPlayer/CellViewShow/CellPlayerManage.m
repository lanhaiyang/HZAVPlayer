//
//  CellPlayerManage.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "CellPlayerManage.h"
#import <HZAVPlayer/HZ_AVPlayer.h>
#import <Masonry/Masonry.h>
#import <objc/message.h>

@interface CellPlayerManage()<HZAVPlayerDelegate>

@property(nonatomic,strong) HZ_AVPlayer *avPlayer;

@property(nonatomic,assign) HZAVPlayerHeadAndBottomState state;



@end

@implementation CellPlayerManage

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self confige];
        [self notification];
    }
    return self;
}

-(void)confige{
    
    _state = HZAVPlayerOnlyShowBottom;
}


-(void)hz_playeWithUrl:(NSString *)url crosswise:(UIView *)crosswiseView vertical:(UIView *)superView playeIndexPath:(NSIndexPath *)indexPath{
    
    _playeIndexPath = indexPath;
    
    
    [crosswiseView insertSubview:self.avPlayer atIndex:0];
    [self.avPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(crosswiseView);
    }];
    [self.avPlayer showCrosswise:self.avPlayer vertical:superView];
    [self.avPlayer playerWithUrl:[NSURL URLWithString:url]];
    _playeOldIndexPath = indexPath;
    self.avPlayer.state = _state;
    self.avPlayer.isLog = NO;
    [self.avPlayer updateWithHeadView:nil bottomView:nil];
}

//-(void)confige{
//
//    NSString *url = @"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";
//    [self.avPlayer playerWithUrl:[NSURL URLWithString:url]];
//}

/// 删除 playeOldIndexPath
-(void)hz_removeOldIndexPath{
    
    _playeOldIndexPath = nil;
}

-(void)hz_huaZhenTVScrollViewSlideBegin{
    
    if (_avPlayer.isPlay == YES) {
        [_avPlayer pause];
    }
}

-(void)hz_huaZhenTVScrollViewSlideEnd{
    
    if (_avPlayer.isPlay == NO) {
        [_avPlayer play];
        
    }
}


-(void)hz_playeStop{
    
    if (_avPlayer == nil || [HZ_AVPlayerRotate isOrientationLandscape] == YES) {
        return;
    }
    [_avPlayer stop];
    [self endFullScreen];
    [_avPlayer removeFromSuperview];
    _avPlayer = nil;
    
    [self huazhenTVPlayerStop];
}

-(void)huazhenTVPlayerStop{
    

    _playeIndexPath = nil;
}

-(void)hz_playe{
    
    [self.avPlayer play];
}

-(void)hz_pause{
    
    [self.avPlayer pause];
}

-(void) begainFullScreen
{
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    //    appDelegate.allowRotation = YES;
    
    SEL selector = NSSelectorFromString(@"setAllowRotation:");
    if ([appDelegate respondsToSelector:selector]) {
        ((void(*)(id, SEL, BOOL))objc_msgSend)(appDelegate, selector, YES);
    }
}

// 退出全屏
-(void)endFullScreen
{
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    //    appDelegate.allowRotation = NO;
    
    SEL selector = NSSelectorFromString(@"setAllowRotation:");
    if ([appDelegate respondsToSelector:selector]) {
        ((void(*)(id, SEL, BOOL))objc_msgSend)(appDelegate, selector, NO);
    }
    
    
}

-(void)notification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNotificationRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

#pragma mark - HZ_Notification

- (void)changeNotificationRotate:(NSNotification*)noti {

    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        
        self.avPlayer.cyclePlayer = NO;
        self.avPlayer.bottomHeight = 0;
        self.avPlayer.state = HZAVPlayerOnlyShowBottom;
        
    } else {
        //横屏
        self.avPlayer.cyclePlayer = NO;
        self.avPlayer.bottomHeight = 70;
        self.avPlayer.state = HZAVPlayerClickHiddenHeadAndBottom;
    }
}


#pragma mark - HPAVPlayerRotateDelegate

/**
 视频加载状态
 
 @param loadState 加载状态
 @return 是否需要调用控件内部的事件 如:当在加载情况会显示加载控件 如果为NO就不会显示控件
 */
-(BOOL)loadWithState:(HZAVPlayerLoadeState)loadState{
    
    switch (loadState) {
        case HZPlayerLoadSuccess:{
            
            [self.avPlayer play];
        }
            break;
        case HZPlayerLoadEnd:{
            
            if ([_delegate respondsToSelector:@selector(cellPlayerWithState:indexPath:)]) {
                [_delegate cellPlayerWithState:HZ_ActionUserStopCellTV indexPath:_playeIndexPath];
            }
        }
            break;
        case HZPlayerLoadFaile:{
            
            if ([_delegate respondsToSelector:@selector(cellPlayerWithState:indexPath:)]) {
                [_delegate cellPlayerWithState:HZ_ActionUserStopCellTV indexPath:_playeIndexPath];
            }
        }
            break;
        default:
            break;
    }

    return YES;
}


-(HZ_AVPlayer *)avPlayer{
    if (_avPlayer == nil) {
        _avPlayer = [[HZ_AVPlayer alloc] init];
        _avPlayer.playerDelegate = self;
        _avPlayer.fillState = HZAVPlayerResizeAspect;
        _avPlayer.rotateView.backgroundColor = [UIColor blackColor];
    }
    return _avPlayer;
}


@end
