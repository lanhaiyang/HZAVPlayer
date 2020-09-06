//
//  PT_HPAVPlayerRotate.h
//  PT_HPAVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HZAVPlayerRotateStyle) {
    HZCrosswise, // 横屏
    HZvertical, // 竖屏
};

typedef NS_ENUM(NSInteger, HPAVPlayerPowersStyle) {
    HZAVShowHeight,//高优先级
    HZAVShowMiddle,//中优先级
    HZAVShowLow//低优先级
};

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

@interface HZ_AVPlayerRotate : UIView


/**
 空方法用于父类的实现
 
 当调用 delegate时
 需要 在 -(void)rotateWithChangeRect:(CGRect)rect rotate:(HPAVPlayerRotateStyle)rotate;
 中调用给方法

 @param rect 方法返回的rect
 */
-(void)playeUpdateWithPlayerLayer:(CGRect)rect;

/**
 空方法用于父类的实现
 
 当调用 delegate时
 需要 在 -(void)tapActionView;
 中调用给方法
 
 */
-(void)playeTapActionView;


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


/**
 旋转状态
 
 需要 在 rotateWithChangeRect 使用 PT_HPAVPlayer 的
 -(void)playeUpdateWithPlayerLayer:(CGRect)rect;
 
 需要 在 tapActionView 使用 PT_HPAVPlayer 的
 -(void)playeTapActionView;
 
 */
@property(nonatomic,weak) id<HZAVPlayerRotateDelegate> delegate;

@end
