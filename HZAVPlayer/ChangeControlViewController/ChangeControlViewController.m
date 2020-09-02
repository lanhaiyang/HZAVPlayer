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

@interface ChangeControlViewController()<HPAVPlayerDelegate,HPAVPlayerRotateDelegate>

@property(nonatomic,strong) HZ_AVPlayer *avPlayer;

@end

@implementation ChangeControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //我们做一个仿微信小视频的样式
    
    [self layout];
    [self confige];
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
    
}

#pragma mark - HPAVPlayerRotateDelegate

/**
 旋转的长宽
 
 @param rect 返回选择的长宽
 @param rotate 旋转的状态
 */
-(void)rotateWithChangeRect:(CGRect)rect rotate:(HPAVPlayerRotateStyle)rotate{
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
-(BOOL)loadWithState:(HPAVPlayerLoadeState)loadState{
    
    switch (loadState) {
        case HPPlayerLoadSuccess:{
            
            [self.avPlayer play];
        }
            break;
        case HPPlayerLoadEnd:{
        }
            break;
        case HPPlayerLoadFaile:{
            
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
        
        _avPlayer.fillState = HPAVPlayerResizeAspect;
        _avPlayer.backgroundColor = [UIColor blackColor];
    }
    return _avPlayer;
}


@end
