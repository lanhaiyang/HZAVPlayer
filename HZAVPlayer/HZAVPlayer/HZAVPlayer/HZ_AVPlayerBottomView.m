//
//  HZ_AVPlayerBottomView.m
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/8.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HZ_AVPlayerBottomView.h"

@interface HZ_AVPlayerBottomView()

@property (weak, nonatomic) IBOutlet UIButton *playerBtn;
@property (weak, nonatomic) IBOutlet UILabel *playerTime;
@property (weak, nonatomic) IBOutlet UISlider *playerProgress;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIButton *scaleBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;

@property(nonatomic,strong) UIView *gradView;

@end

@implementation HZ_AVPlayerBottomView

+(instancetype)getPlayerBottomView{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZAVPlayerBundles" ofType:@"bundle"]];
    HZ_AVPlayerBottomView *bottomView = [bundle loadNibNamed:@"HZ_AVPlayerBottomView" owner:nil options:nil].lastObject;
//    HZ_AVPlayerBottomView *bottomView = [[NSBundle mainBundle] loadNibNamed:
//                                        NSStringFromClass([self class]) owner:nil options:nil ].lastObject;
    [bottomView layout];
    [bottomView action];
    [bottomView changeAlpha];
    return bottomView;
}

-(void)changeAlpha{
    _gradView = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:_gradView atIndex:0];
    
    self.backgroundColor = [UIColor clearColor];
    _gradView.backgroundColor = [UIColor blackColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_isBackgroundGradients == NO) {
        _gradView.hidden = YES;
        return;
    }else{
        _gradView.hidden = NO;
    }
    _gradView.frame = self.bounds;
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0.3 alpha:0.4] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       nil];
    [_gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [_gradLayer setStartPoint:CGPointMake(0.5f, 1.0f)];
    [_gradLayer setEndPoint:CGPointMake(0.5f, 0.0f)];
    
    [_gradLayer setFrame:self.bounds];
    
    [self.gradView.layer setMask:_gradLayer];
}

-(void)updateWithSlide:(CGFloat)value{
    
    _playerProgress.value = value;
}

-(void)layout{
    
    _isBackgroundGradients = YES;
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZAVPlayerBundles" ofType:@"bundle"]];
    UIImage *image = [UIImage imageNamed:@"HZPlayer_Icmpv_thumb_light@2x.png" inBundle:bundle compatibleWithTraitCollection:nil];
    self.slideImage = image;
    
}

-(void)action{
    
    [_playerBtn addTarget:self
                   action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scaleBtn addTarget:self
                  action:@selector(scaleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithChange:) forControlEvents:UIControlEventValueChanged];
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithDown:) forControlEvents:UIControlEventTouchDown];
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithUp:) forControlEvents:UIControlEventTouchUpInside];
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithUp:) forControlEvents:UIControlEventTouchUpOutside];
    
}

-(void)slideProgressWithChange:(UISlider *)slide{
    if ([self.delegate respondsToSelector:@selector(slideWithPointWithChange:)]) {
        [self.delegate slideWithPointWithChange:slide.value];
    }
}

-(void)slideProgressWithDown:(UISlider *)slide{
    if ([self.delegate respondsToSelector:@selector(slideWithPointWithDown:)]) {
        [self.delegate slideWithPointWithDown:slide.value];
    }
}

-(void)slideProgressWithUp:(UISlider *)slide{
    if ([self.delegate respondsToSelector:@selector(slideWithPointWithUp:)]) {
        [self.delegate slideWithPointWithUp:slide.value];
    }
}

-(void)playerAction:(UIButton *)button{
    
    button.selected = !button.selected;
    self.playerState = button.selected;
    if ([self.delegate respondsToSelector:@selector(playerAction:)]) {
        [self.delegate playerAction:button.selected];
    }
}

-(void)scaleAction:(UIButton *)button{
    
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(scaleAction)]) {
        [self.delegate scaleAction];
    }
}


-(void)slideWithMinValue:(CGFloat)minValue maxValue:(NSTimeInterval)maxValue{
    
    _playerProgress.minimumValue = minValue;
    _playerProgress.maximumValue = maxValue;
    
}


-(void)updataCacheWithProgress:(CGFloat)progress{
    
    [_cacheProgress setProgress:progress animated:YES];
    
}

#pragma mark - 懒加载

-(void)setScaleState:(BOOL)scaleState{
    _scaleState = scaleState;
    _scaleBtn.selected = scaleState;
}

-(void)setPlayerState:(BOOL)playerState{
    _playerState = playerState;
    _playerBtn.selected = playerState;
    
}

-(void)setChangeTime:(NSString *)changeTime{
    
    _changeTime = changeTime;
    _playerTime.text = changeTime;
    
}

-(void)setLenghtPlayer:(NSString *)lenghtPlayer{
    
    _lenghtPlayer = lenghtPlayer;
    _endTime.text = lenghtPlayer;
}

-(void)setProgressColor:(UIColor *)progressColor{
    
    _progressColor = progressColor;
    _playerProgress.tintColor = progressColor;
    
}

-(void)setSlideImage:(UIImage *)slideImage{
    
    _slideImage = slideImage;
    [self.playerProgress setThumbImage:slideImage forState:(UIControlStateNormal)];
    
}

-(void)setStopImage:(UIImage *)stopImage{
    
    _stopImage = stopImage;
    [_playerBtn setImage:stopImage forState:UIControlStateNormal];
    
}

-(void)setPlayerImage:(UIImage *)playerImage{
    
    _playerImage = playerImage;
    [_playerBtn setImage:playerImage forState:UIControlStateSelected];
}


-(void)setScaleMaxImage:(UIImage *)scaleMaxImage{
    
    _scaleMaxImage = scaleMaxImage;
    [_scaleBtn setImage:scaleMaxImage forState:UIControlStateNormal];
}

-(void)setScaleMinImage:(UIImage *)scaleMinImage{
    
    _scaleMinImage = scaleMinImage;
    [_scaleBtn setImage:scaleMinImage forState:UIControlStateSelected];
}


@end
