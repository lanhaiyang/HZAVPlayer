//
//  HZ_AVPlayer.h
//  ZhongHangXin
//
//  Created by 何鹏 on 2017/12/7.
//  Copyright © 2017年 pingread. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZ_AVPlayerRotate.h"
#import "HZ_AVPlayerHeaderView.h"
#import "HZ_AVPlayerBottomView.h"

typedef NS_ENUM(NSInteger, HZAVPlayerLoadeState) {
    HZPlayerLoading, // 正在加载
    HZPlayerLoadFinish, // 加载完成
    HZPlayerLoadEnd, //播放结束
    HZPlayerLoadFaile,
    HZPlayerLoadSuccess
};

typedef enum : NSUInteger {
    HZAVPlayerClickHiddenHeadAndBottom,//点击时只隐藏头部和底部
    HZAVPlayerClickOnlyHiddenHead,//点击时只隐藏头部
    HZAVPlayerClickOnlyHiddenBottom,
    HZAVPlayerOnlyShowHead,//只显示头部
    HZAVPlayerOnlyShowBottom,
    HZAVPlayerShowHeadAndBottom//显示头部和底部
} HZAVPlayerHeadAndBottomState;

typedef NS_ENUM(NSInteger, HZAVPlayerFillStat) {
    HZAVPlayerResizeAspect, //在当前layer设置的范围内按比例缩放显示完整个视频
    HZAVPlayerResizeAspectFill,//按view大小填充完layer
    HZAVPlayerResize //按照view的大小拉伸 填充满layer
};

@protocol HZAVPlayerDelegate  <NSObject>

@optional

/**
 视频播放的范围

 @param minValue 最新的范围 0
 @param maxValue 最大播放秒数
 */
-(void)slideWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;


/**
 视频播放回调进度

 @param value 播放进度
 */
-(void)updateWithSlide:(CGFloat)value;


/**
 缓存进度

 @param progress 缓存进度
 */
-(void)updataCacheWithProgress:(CGFloat)progress;

/**
 视频加载状态

 @param loadState 加载状态
 @return 是否需要调用控件内部的事件 如:当在加载情况会显示加载控件 如果为NO就不会显示控件
 */
-(BOOL)loadWithState:(HZAVPlayerLoadeState)loadState;



/**
 点击底部缩放全屏按钮

 @param orientation 返回转屏方向
 */
-(void)hz_scaleActionWithOrientation:(UIInterfaceOrientation)orientation;

@end

@interface HZ_AVPlayer : HZ_AVPlayerRotate//旋转类

@property(nonatomic,copy,readonly) NSString *audioUrl;

/// 在传入view的时候设置好frame的高度
@property(nonatomic,assign) CGFloat headHeight;

/// 在传入view的时候设置好frame的高度
@property(nonatomic,assign) CGFloat bottomHeight;

@property(nonatomic,assign) HZAVPlayerHeadAndBottomState state;

/**
 懂设置自定义是默认 customHeadeView 该 playerHeaderView 无效
 播放器头部的view
 */
@property(nonatomic,strong,readonly) HZ_AVPlayerHeaderView *playerHeaderView;

/**
 懂设置自定义是默认 customBottomView 该 playerBottomView 无效
 播放器底部的view
 */
@property(nonatomic,strong,readonly) HZ_AVPlayerBottomView *playerBottomView;

///视频状态发生改变
@property(nonatomic,weak) id<HZAVPlayerDelegate> playerDelegate;

/// 在 playerWithUrl 之前使用 才会有效 默认为NO
@property(nonatomic,assign) BOOL isCache;

/// 是否要播放声音
@property(nonatomic,assign) BOOL isMute;

/// 是否循环播放
@property(nonatomic,assign) BOOL cyclePlayer;

/// 是否打印错误
@property(nonatomic,assign) BOOL isLog;

/// 是否在播放状态
@property(nonatomic,assign,readonly) BOOL isPlay;

/// 文件大小
@property(nonatomic,assign,readonly) float fileSize;

/// 填充方式
@property(nonatomic,assign) HZAVPlayerFillStat fillState;


/**
 设置头部和底部
 
 如果头部或者底部为nil 默认为控件自身的view

 @param customHeadeView 头部的view
 @param customBottomView 底部的view
 */
-(void)updateWithHeadView:(UIView *)customHeadeView bottomView:(UIView *)customBottomView;

/**
 跳到指定页面 进度

 @param second 0s - 视频总长度s
 */
-(void)seeTime:(CGFloat)second;


/**
 当播放时间与缓存时间 比是多少时才能播放 0 - 1 的小数
 当缓存时间 < cacheMaxPlay 会进入加载状态
 >1 默认为1
 <0 默认为0.1
 */
//@property(nonatomic,assign) CGFloat cacheMaxPlay;

/**
 播放的url

 @param url 播放url
 */
-(void)playerWithUrl:(NSURL *)url;


/**
 暂停
 */
-(void)pause;


/**
 停止
 */
-(void)stop;


/**
 播放
 */
-(void)play;

@end
