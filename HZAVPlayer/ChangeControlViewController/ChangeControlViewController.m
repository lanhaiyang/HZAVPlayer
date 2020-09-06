//
//  ChangeControlViewController.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "ChangeControlViewController.h"
#import <HZAVPlayer/HZ_AVPlayer.h>
#import <Masonry/Masonry.h>
#import "BackgroundBottomView.h"
#import "NSString+HZ_Time.h"

@interface ChangeControlViewController()<HZAVPlayerDelegate,HZAVPlayerRotateDelegate,HZAVPlayerBottomViewDelegate>

@property(nonatomic,strong) HZ_AVPlayer *avPlayer;
@property(nonatomic,strong) BackgroundBottomView *bottomView;

@end

@implementation ChangeControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //我们做一个仿微信小视频的样式
    
    [self layout];
    [self confige];
    [self action];
}

-(void)action{
    
    __weak typeof(self) weakSelf = self;
    [self.bottomView.functionView functionBackAcitonWithBlock:^{
       
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)confige{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZAVPlayerBundles" ofType:@"bundle"]];
    UIImage *stop = [UIImage imageNamed:@"HZPlayer_pause@2x.png" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *player = [UIImage imageNamed:@"HZPlayer_play@2x.png" inBundle:bundle compatibleWithTraitCollection:nil];
    self.bottomView.bottomView.stopImage = stop;
    self.bottomView.bottomView.playerImage = player;
    
    NSString *url = @"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";
    [self.avPlayer playerWithUrl:[NSURL URLWithString:url]];
}

-(void)layout{
    
    [self.view insertSubview:self.avPlayer atIndex:0];
    [self.avPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).equalTo(@64);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.avPlayer.bottomHeight = 100;
    self.avPlayer.headHeight = 0.01;
    [self.avPlayer updateWithHeadView:[UIView new] bottomView:self.bottomView];//底部控制块修改样式
    
    //横竖屏在哪个view上显示
    [self.avPlayer showCrosswise:self.avPlayer vertical:self.view];
    

}

#pragma mark - HPAVPlayerBottomViewDelegate

-(void)playerAction:(BOOL)isSelection{
    
    if (isSelection == YES) {// 播放 -> 暂停
        
        [self.avPlayer pause];
    }else{
        
        [self.avPlayer play];
    }
}

-(void)slideWithPointWithChange:(CGFloat)progress{
    
    _bottomView.bottomView.changeTime = [NSString convertTime:progress];
}

-(void)slideWithPointWithDown:(CGFloat)progress{
    
    [_avPlayer pause];
    _bottomView.bottomView.playerState = YES;
}

-(void)slideWithPointWithUp:(CGFloat)progress{
    
    [_avPlayer seeTime:progress];
    [_avPlayer play];
    _bottomView.bottomView.playerState = NO;
}

#pragma mark - HPAVPlayerDelegate

/**
 视频播放的范围

 @param minValue 最新的范围 0
 @param maxValue 最大播放秒数
 */
-(void)slideWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue{
    
    _bottomView.bottomView.lenghtPlayer = [NSString convertTime:maxValue];
    [self.bottomView.bottomView slideWithMinValue:minValue maxValue:maxValue];
}


/**
 视频播放回调进度

 @param value 播放进度
 */
-(void)updateWithSlide:(CGFloat)value{
    
    self.bottomView.bottomView.changeTime = [NSString convertTime:value];
    [self.bottomView.bottomView updateWithSlide:value];
}


/**
 缓存进度

 @param progress 缓存进度
 */
-(void)updataCacheWithProgress:(CGFloat)progress{
    
    [self.bottomView.bottomView updataCacheWithProgress:progress];
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

-(BackgroundBottomView *)bottomView{
    
    if (_bottomView == nil) {
        _bottomView = [[BackgroundBottomView alloc] init];
        _bottomView.bottomView.delegate = self;
    }
    return _bottomView;
}

@end
