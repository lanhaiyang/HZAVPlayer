//
//  VHScreenViewController.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/2.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "VHScreenViewController.h"
#import <HZAVPlayer/HZ_AVPlayer.h>
#import <Masonry/Masonry.h>
#import <objc/message.h>

@interface VHScreenViewController()<HZAVPlayerDelegate,HZAVPlayerRotateDelegate>

@property(nonatomic,strong) HZ_AVPlayer *avPlayer;
@property(nonatomic,assign) BOOL isRotate;
@property(nonatomic,strong) UIView *headView;

@end

@implementation VHScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatObj];
    [self layout];
    [self confige];
    [self notification];
}

-(void)creatObj{
    
    _headView = [[UIView alloc] init];
    _headView.backgroundColor = [UIColor blueColor];
    
}

-(void)notification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNotificationRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)confige{
    
    NSString *url = @"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";
    [self.avPlayer playerWithUrl:[NSURL URLWithString:url]];
}

-(void)layout{
    
    [self.view insertSubview:self.avPlayer atIndex:0];
    [self.avPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).equalTo(@64);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //横竖屏在哪个view上显示
    [self.avPlayer showCrosswise:self.avPlayer vertical:self.view];
    self.avPlayer.state = HZAVPlayerOnlyShowBottom;// 隐藏头部
    [self.avPlayer updateWithHeadView:self.headView  bottomView:nil];
    
}

#pragma mark - HZ_Notification

- (void)changeNotificationRotate:(NSNotification*)noti {

    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        
        self.avPlayer.cyclePlayer = NO;
        self.avPlayer.state = HZAVPlayerOnlyShowBottom;// 隐藏头部
        [self.avPlayer updateWithHeadView:self.headView bottomView:nil];
        
        _isRotate = NO;
    } else {
        //横屏
        self.avPlayer.cyclePlayer = NO;
        self.avPlayer.state = HZAVPlayerOnlyShowBottom;// 恢复正常
        [self.avPlayer updateWithHeadView:self.headView bottomView:nil];
        
        _isRotate = YES;
    }
}

#pragma mark - HPAVPlayerDelegate

/**
 点击底部缩放全屏按钮

 @param orientation 返回转屏方向
 */
-(void)hz_scaleActionWithOrientation:(UIInterfaceOrientation)orientation{
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight:{
            
            [self begainFullScreen];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            
            [self endFullScreen];
        }
            break;
        default:
            break;
    }
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

#pragma mark - HPAVPlayerRotateDelegate

/**
 旋转的长宽
 
 @param rect 返回选择的长宽
 @param rotate 旋转的状态
 */
-(void)rotateWithChangeRect:(CGRect)rect rotate:(HZAVPlayerRotateStyle)rotate{
    [self.avPlayer playeUpdateWithPlayerLayer:rect];
}


/**
 点击播放页面
 */
-(void)tapActionView{
    
    [self.avPlayer playeTapActionView];
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
        }
            break;
        case HZPlayerLoadFaile:{
            
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
        _avPlayer.delegate = self;//这个可以选择不用调用
        
        _avPlayer.isCache = YES; // 开启缓存
        
        _avPlayer.fillState = HZAVPlayerResizeAspect;
        _avPlayer.rotateView.backgroundColor = [UIColor blackColor];
    }
    return _avPlayer;
}
@end
