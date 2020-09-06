//
//  TVBottomSlideView.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/2.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HZAVPlayer/HZ_AVPlayerBottomView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVBottomSlideView : UIView


@property(nonatomic,weak) id<HZAVPlayerBottomViewDelegate> delegate;

@property(nonatomic,strong) UIColor *progressColor;
@property(nonatomic,strong) UIImage *slideImage;

-(void)slideWithMinValue:(CGFloat)minValue maxValue:(NSTimeInterval)maxValue;

-(void)updateWithSlide:(CGFloat)value;

-(void)updataCacheWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
