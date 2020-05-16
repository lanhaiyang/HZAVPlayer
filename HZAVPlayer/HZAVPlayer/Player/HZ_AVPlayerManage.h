//
//  HZ_AVPlayerManage.h
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HPAVPlayerLoade) {
    HPAVPlayerLoading, // 正在加载
    HPAVPlayerLoadFinish, // 加载完成
    HPAVPlayerEnd, //播放结束
    HPAVPlayerFaile,//播放失败
    HPAVPlayerSuccess,//成功播放
};

typedef NS_ENUM(NSInteger, HPTouchPlayerStyle) {
    HPTouchPlayerNone, // 轻触
    HPTouchPlayerHorizontal, // 水平滑动
    HPTouchPlayerUnknow, // 未知
};

typedef NS_ENUM(NSInteger, HPAVPlayerLayerFillStat){
    HPAVPlayerLayerResizeAspect, //在当前layer设置的范围内按比例缩放显示完整个视频
    HPAVPlayerLayerResizeAspectFill,//按view大小填充完layer
    HPAVPlayerLayerResize //按照view的大小拉伸 填充满layer
};

@protocol HPAVPlayerDelgate <NSObject>

@optional

/**
 获得当前的时间

 @param current 当前时间
 */
-(void)playerWithCurrentTimeSecond:(CGFloat)current;


/**
 获得视频总长度

 @param duration 总长度
 */
-(void)playerWithLength:(NSTimeInterval)duration;


/**
 缓冲进度

 @param duration 缓冲时间
 */
-(void)playerWithCahceDuration:(CGFloat)duration;


/**
 当播放时间与缓存时间比

 rate : 0 为还没有加载完成
 @param rate 比例
 */
-(void)playerCurrentTimeAndCacheTimeRate:(CGFloat)rate;

@optional;


/**
 播放状态

 @param loadState 状态
 */
-(void)loadWithState:(HPAVPlayerLoade)loadState;

@end

@protocol HPAVPlayerDataSource <NSObject>


/**
 进入后台
 */
-(void)enterForegroundNotification;


/**
 进入前台
 */
-(void)enterBackgroundNotification;

@end

@interface HZ_AVPlayerManage : NSObject

///是否打印
@property(nonatomic,assign) BOOL isLog;

@property(nonatomic,strong,readonly) NSString *url;

@property(nonatomic,strong,readonly) NSError *error;

/// 当前视频处于那种点击状态
@property(nonatomic,assign) HPTouchPlayerStyle touchStyle;

@property(nonatomic,assign,readonly) HPAVPlayerLoade state;

@property(nonatomic,assign,readonly) float currentPlayTime;

/// 播放长度 等待 playerWithCahceDuration 否则 为0
@property(nonatomic,assign,readonly) NSTimeInterval durationLength;

/// 操作代理
@property(nonatomic,weak) id<HPAVPlayerDelgate> delegate;

/// 进入后台代理
@property(nonatomic,weak) id<HPAVPlayerDataSource> dataSource;

/// 是否循环播放
@property(nonatomic,assign) BOOL cyclePlayer;

/// 是否在播放状态
@property(nonatomic,assign,readonly) BOOL isPlay;

///是否开启缓存模式
@property(nonatomic,assign) BOOL isCache;

/// 填充方式
@property(nonatomic,assign) HPAVPlayerLayerFillStat fillState;

/// 是否取消声音的播放
@property(nonatomic,assign) BOOL isMute;

/**
 获取当前播放的图片

 @return 返回图片
 */
- (UIImage *)thumbnailImageAtCurrentTime;

/**
 获取第一帧的图片
 
 @return 图片
 */
-(UIImage *)videoFristFrameWithImage;



/**
 获取指定帧 并设置大小
 
 @param second 第几秒
 @param size 设置为指定大小
 @return 指定帧的大小
 */
- (UIImage *)firstFrameWithSecond:(NSInteger )second imageSize:(CGSize)size;

/**
 获得声音大小

 @return 声音大小
 */
-(CGFloat )getSoundSize;


/**
 设置声音大小

 @param size 0 - 1 大小设置
 */
-(void)setSoundSize:(CGFloat)size;

/**
 *** 注意  "滑动"时使用 这个滑动时手指对控件的滑动 ***
 
 UISlide maxValue 为 播放总时长 (0s - 总长度s)
 @param second 第几秒
 */
-(void)slideUpdateChangeWithSecond:(CGFloat)second;


/**
 改变时间进度

 @param second 时间
 */
-(void)updateChangePlayeWithTimeSecond:(CGFloat)second;


/**
 滑动停止动作
 */
-(void)slideTouchWithEnd;


/**
 在哪个view播放

 @param view 显示view
 @return 当前类对象
 */
-(instancetype)initWithShowView:(UIView *)view;


/**
 更新url
 
 **** 注意 ****
 此方法为异步方法
 *************

 @param url 更新的url
 */
-(void)updateWithUrl:(NSURL *)url;


/**
 更新播放 内容的位置和长宽

 @param rect CGRect
 */
-(void)updateWithPlayerLayer:(CGRect)rect;


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
