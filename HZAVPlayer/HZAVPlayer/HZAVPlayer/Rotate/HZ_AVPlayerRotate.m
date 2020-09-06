//
//  HZ_AVPlayerRotate.m
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HZ_AVPlayerRotate.h"

@interface HZ_AVPlayerRotate()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIView *mainView;

@property(nonatomic,weak) UIView *crosswiseView;
@property(nonatomic,weak) UIView *verticalView;

@property(nonatomic,strong) UIView *backgroundView;

@end

@implementation HZ_AVPlayerRotate

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self superLayout];
        [self gesture];
    }
    return self;
}

-(void)didMoveToWindow{
    [super didMoveToWindow];
    [self changeRotate];
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    [self superLayout];
    [self gesture];
}

-(void)superLayout{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZAVPlayerBundles" ofType:@"bundle"]];
    _mainView = [bundle loadNibNamed:@"HZ_AVPlayerRotate" owner:nil options:nil].lastObject;
//    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"HZ_AVPlayerRotate" owner:self options:nil] lastObject];
    _rotateView = _mainView;
    _rotateView.layer.masksToBounds = YES;
    
    
    [self addSubview:_rotateView];
    
}

-(void)playeUpdateWithPlayerLayer:(CGRect)rect{}

-(void)playeTapActionView{}

-(void)showCrosswise:(UIView *)crosswiseView vertical:(UIView *)verticalView{
    
    self.crosswiseView = crosswiseView;
    self.verticalView = verticalView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    NSLog(@"w = %lf , h = %lf",self.rotateView.bounds.size.width,self.rotateView.bounds.size.height);
    if (self.rotateView.bounds.size.width == 0 && self.rotateView.bounds.size.height == 0) {
        return;
    }
    
    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) {
        if ([self.delegate respondsToSelector:@selector(rotateWithChangeRect:rotate:)]) {
            [self.delegate rotateWithChangeRect:self.bounds rotate:HZvertical];
        }
        
    }else{
        if ([self.delegate respondsToSelector:@selector(rotateWithChangeRect:rotate:)]) {
            [self.delegate rotateWithChangeRect:self.verticalView.window.bounds rotate:HZCrosswise];
        }
    }
}

-(void)gesture{
    
    UITapGestureRecognizer * privateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    privateLetterTap.delegate = self;
    [_rotateView addGestureRecognizer:privateLetterTap];
    
}

- (void)tapAvatarView: (UITapGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(tapActionView)]) {
        [self.delegate tapActionView];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 判断是不是UIButton的类
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UISlider class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - 横竖屏


-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self changeRotate];
    
}

-(void)changeRotate{
    
    // 横竖屏判断
    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) { // 竖屏
        //NSLog(@"<>竖屏");
        
        [self.crosswiseView insertSubview:_rotateView atIndex:0];
        [UIView animateWithDuration:0.25 animations:^{
            self.rotateView.transform = CGAffineTransformMakeRotation(0);
            self.rotateView.frame = self.crosswiseView.bounds;
        }];
        
        
    } else { // 横屏
        //NSLog(@"<>横屏");
        
        [self.verticalView.window addSubview:_rotateView];
        [UIView animateWithDuration:0.25 animations:^{
            self.rotateView.transform = CGAffineTransformMakeRotation(0);
            self.rotateView.frame = self.verticalView.window.bounds;
        }];
        
        
    }
//    NSLog(@"w = %lf , h = %lf",self.rotateView.bounds.size.width,self.rotateView.bounds.size.height);
}

+ (void)forceOrientation:(UIInterfaceOrientation)orientation {
    // setOrientation: 私有方法强制横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (BOOL)isOrientationLandscape {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 懒加载

-(UIView *)backgroundView{
    
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

@end
