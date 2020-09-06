# HZAVPlayer

## 集成过程

- 先到项目根目录，也就是(项目.xcodepro)这个目录
-  找到`HZAVPlayer/HZAVPlayer`文件

<span><div style="text-align: center;">
![Picture](https://note.youdao.com/yws/api/personal/file/WEB2caa3ea99edb4d181fb8f5e15d70de9d?method=download&shareKey=c5dd38b624b70bea07dd3dea26d3b4ca)
</div></span>

- 放在(项目.xcodepro)这个目录

<span><div style="text-align: center;">
![Picture](https://note.youdao.com/yws/api/personal/file/WEB4e6a6f077f23626836288c948feaee43?method=download&shareKey=37337a4a3b7ec1ee54c16300d7e2d53b)
</div></span>

- 修改`Podfile`

```
platform :ios, '8.0'

inhibit_all_warnings!

#解决报[Xcodeproj] Generated duplicate UUIDs:
install! 'cocoapods', :deterministic_uuids => false

# 官方
source 'https://github.com/CocoaPods/Specs.git'

target 'TestPod' do
	
	pod 'HZAVPlayer', :path => 'HZAVPlayer'

end

```

- 打开终端

```
> cd Podfile目录下
> pod install

```

- 然后打开项目后会看到`Pods/Development Pods/`目录项出现一个`HZAVPlayer`项目

<span><div style="text-align: center;">
![Picture](https://note.youdao.com/yws/api/personal/file/WEB7ee702c585799feb6f7f7b3823d29bde?method=download&shareKey=ae942343fcb138f220bd45780fe1a745)
</div></span>

- 导入框架

```objective-c
#import <HZAVPlayer/HZ_AVPlayer.h>

```


## 介绍

|播放/缓存|cell上播放|修改默认控制模块的样式|横竖屏指定控制模块隐藏|横屏|
|:--:|:--:|:--:|:--:|:--:|
|![Picture](https://note.youdao.com/yws/api/personal/file/WEB6b2e0f96ab0c8c2804ab9244887b0ee2?method=download&shareKey=88f801c87a91feb369c1de4e21f6ed90)|![Picture](https://note.youdao.com/yws/api/personal/file/WEB26bececf1ae24cd9bf6b3e3d48170bdb?method=download&shareKey=1eeba8ff15eeb422db3dd07e4d9ac695)|![Picture](https://note.youdao.com/yws/api/personal/file/WEB181ddc38e3c0d1f0a037bd78e29b007f?method=download&shareKey=4fa7b5f1b0dcec9e3fc9f4d7ac02b337)|![Picture](https://note.youdao.com/yws/api/personal/file/WEBfbd13b036198514fede18e46ba1542b5?method=download&shareKey=91f63b72f74147b10510ab1ca5aa46dc)|![Picture](https://note.youdao.com/yws/api/personal/file/WEBe35d627e1a55c0d7589d3e711d80ff7a?method=download&shareKey=bd1400a805d10ad494ef039d945f38b7)|


## 视频操作Api

### ** 设置控制模块

#### 设置控制模块的样式

```objective-c
/**
 设置头部和底部
 
 如果头部或者底部为nil 默认为控件自身的view

 @param customHeadeView 头部的view
 @param customBottomView 底部的view
 */
-(void)updateWithHeadView:(UIView *)customHeadeView bottomView:(UIView *)customBottomView;
```

#### 设置控制模块的高度

```objective-c

/// 在传入view的时候设置好frame的高度
@property(nonatomic,assign) CGFloat headHeight;

/// 在传入view的时候设置好frame的高度
@property(nonatomic,assign) CGFloat bottomHeight;

```

#### 设置控制模块显示

```objective-c

typedef enum : NSUInteger {
    HZAVPlayerClickHiddenHeadAndBottom,//点击时只隐藏头部和底部
    HZAVPlayerClickOnlyHiddenHead,//点击时只隐藏头部
    HZAVPlayerClickOnlyHiddenBottom,
    HZAVPlayerOnlyShowHead,//只显示头部
    HZAVPlayerOnlyShowBottom,
    HZAVPlayerShowHeadAndBottom//显示头部和底部
} HZAVPlayerHeadAndBottomState;

@property(nonatomic,assign) HZAVPlayerHeadAndBottomState state;

```

### 设置缓存
```objective-c

/// 在 playerWithUrl 之前使用 才会有效 默认为NO
@property(nonatomic,assign) BOOL isCache;

```

### 播放器操作接口

```objective-c
/// 是否要播放声音
@property(nonatomic,assign) BOOL isMute;

/// 是否循环播放
@property(nonatomic,assign) BOOL cyclePlayer;

/// 是否在播放状态
@property(nonatomic,assign,readonly) BOOL isPlay;

/// 文件大小
@property(nonatomic,assign,readonly) float fileSize;

/// 填充方式
@property(nonatomic,assign) HZAVPlayerFillStat fillState;

/**
 跳到指定页面 进度

 @param second 0s - 视频总长度s
 */
-(void)seeTime:(CGFloat)second;



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


```

### 播放状态监听

```objective-c

///视频状态发生改变
@property(nonatomic,weak) id<HZAVPlayerDelegate> playerDelegate;

```

- 回调api

```objective-c
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
-(void)updataCacheWitHZrogress:(CGFloat)progress;

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

```

## 旋转操作Api

```objective-c



/**
 旋转时需要 放在哪个viewshang

 @param crosswiseView 竖屏 需要显示在哪个view上
 @param verticalView 横屏 需要显示在哪个view上
 */
-(void)showCrosswise:(UIView *)crosswiseView vertical:(UIView *)verticalView;


/**
 手动横竖屏
 
 横屏: UIInterfaceOrientationLandscapeRight
 竖屏: UIInterfaceOrientationPortrait

 @param orientation 切换
 */
+ (void)forceOrientation:(UIInterfaceOrientation)orientation;


/**
 是否是横屏
 NO 为竖屏
 YES 横屏
 @return 是否是横屏状态
 */
+ (BOOL)isOrientationLandscape;


/**
 旋转view
 */
@property(nonatomic,weak,readonly) UIView *rotateView;


```
### 回调Api

```objective-c
/**
 旋转状态
 
 需要 在 rotateWithChangeRect 使用 PT_HZAVPlayer 的
 -(void)playeUpdateWithPlayerLayer:(CGRect)rect;
 
 需要 在 tapActionView 使用 PT_HZAVPlayer 的
 -(void)playeTapActionView;
 
 */
@property(nonatomic,weak) id<HZAVPlayerRotateDelegate> delegate;
```

```objective-c
@protocol HZAVPlayerRotateDelegate <NSObject>


/**
 旋转的长宽

 @param rect 返回选择的长宽
 @param rotate 旋转的状态
 */
-(void)rotateWithChangeRect:(CGRect)rect rotate:(HZAVPlayerRotateStyle)rotate;


/**
 点击播放页面
 */
-(void)tapActionView;

@end

```