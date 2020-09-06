//
//  HZ_AVPlayerBottomView.h
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/8.
//  Copyright © 2017年 何鹏. All rights reserved.
//  

#import <UIKit/UIKit.h>

@protocol HZAVPlayerBottomViewDelegate <NSObject>

@optional

/// 播放事件
-(void)playerAction:(BOOL)isSelection;

/// 缩放事件
-(void)scaleAction;

/// 滑动开始改变
-(void)slideWithPointWithChange:(CGFloat)progress;

/// 滑动开始点击屏幕
-(void)slideWithPointWithDown:(CGFloat)progress;

/// 滑动手指离开屏幕
-(void)slideWithPointWithUp:(CGFloat)progress;

@end

@interface HZ_AVPlayerBottomView : UIView

+(instancetype)getPlayerBottomView;

@property(nonatomic,weak) id<HZAVPlayerBottomViewDelegate> delegate;

-(void)slideWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

-(void)updateWithSlide:(CGFloat)value;

-(void)updataCacheWithProgress:(CGFloat)progress;

/// 是否开启背景渐变
@property(nonatomic,assign) BOOL isBackgroundGradients;

@property(nonatomic,assign) BOOL playerState;
@property(nonatomic,assign) BOOL scaleState;

@property(nonatomic,strong) NSString *changeTime;
@property(nonatomic,strong) NSString *lenghtPlayer;

@property(nonatomic,strong) UIColor *progressColor;
@property(nonatomic,strong) UIImage *slideImage;

@property(nonatomic,strong) UIImage *stopImage;
@property(nonatomic,strong) UIImage *playerImage;

@property(nonatomic,strong) UIImage *scaleMaxImage;
@property(nonatomic,strong) UIImage *scaleMinImage;



@end
