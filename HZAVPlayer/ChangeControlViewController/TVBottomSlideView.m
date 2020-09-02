//
//  TVBottomSlideView.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/2.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "TVBottomSlideView.h"
#import <Masonry/Masonry.h>

@interface TVBottomSlideView()

@property (strong, nonatomic)  UISlider *playerProgress;
@property (strong, nonatomic)  UIProgressView *cacheProgress;


@end

@implementation TVBottomSlideView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self confige];
        [self layout];
        [self action];
    }
    return self;
}

-(void)action{
    
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithChange:) forControlEvents:UIControlEventValueChanged];
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithDown:) forControlEvents:UIControlEventTouchDown];
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithUp:) forControlEvents:UIControlEventTouchUpInside];
    [_playerProgress addTarget:self
                        action:@selector(slideProgressWithUp:) forControlEvents:UIControlEventTouchUpOutside];
}

-(void)confige{
    self.backgroundColor = [UIColor clearColor];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZAVPlayerBundles" ofType:@"bundle"]];
    UIImage *image = [UIImage imageNamed:@"HZPlayer_Icmpv_thumb_light@2x.png" inBundle:bundle compatibleWithTraitCollection:nil];
    self.slideImage = image;
    
}

-(void)layout{
    
    [self addSubview:self.cacheProgress];
    [self.cacheProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@2);
    }];
    
    [self addSubview:self.playerProgress];
    [self.playerProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.height.equalTo(@31);
        make.left.right.equalTo(self);
    }];
    

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

-(void)slideWithMinValue:(CGFloat)minValue maxValue:(NSTimeInterval)maxValue{
    
    _playerProgress.minimumValue = minValue;
    _playerProgress.maximumValue = maxValue;
    
}

-(void)updateWithSlide:(CGFloat)value{
    
    _playerProgress.value = value;
}


-(void)updataCacheWithProgress:(CGFloat)progress{
    
    [_cacheProgress setProgress:progress animated:YES];
    
}


#pragma mark - 懒加载



-(void)setProgressColor:(UIColor *)progressColor{
    
    _progressColor = progressColor;
    _playerProgress.tintColor = progressColor;
    
}

-(void)setSlideImage:(UIImage *)slideImage{
    
    _slideImage = slideImage;
    [self.playerProgress setThumbImage:slideImage forState:(UIControlStateNormal)];
    
}

-(UISlider *)playerProgress{
    
    if (_playerProgress == nil) {
        _playerProgress = [[UISlider alloc] init];
        _playerProgress.minimumTrackTintColor = [UIColor whiteColor];
        _playerProgress.maximumTrackTintColor = [UIColor clearColor];
        _playerProgress.backgroundColor = [UIColor clearColor];
    }
    return _playerProgress;
}

-(UIProgressView *)cacheProgress{
    
    if (_cacheProgress == nil) {
        _cacheProgress = [[UIProgressView alloc] init];
        _cacheProgress.tintColor = [UIColor whiteColor];
        _cacheProgress.backgroundColor = [UIColor grayColor];
        
    }
    return _cacheProgress;
}

@end
