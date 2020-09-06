//
//  TVBottomView.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import <HZAVPlayer/HZ_AVPlayerBottomView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVBottomView : UIView

//+(instancetype)getPlayerBottomView;

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

//@property(nonatomic,strong) UIImage *scaleMaxImage;
//@property(nonatomic,strong) UIImage *scaleMinImage;

@end

NS_ASSUME_NONNULL_END
