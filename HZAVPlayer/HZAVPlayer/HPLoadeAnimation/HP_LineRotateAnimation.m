//
//  PT_HPLineRotateAnimation.m
//  HPLoadeAnimation
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HP_LineRotateAnimation.h"

@interface HP_LineRotateAnimation()

@property(nonatomic,strong) CAShapeLayer *bottomShapeLayer;
@property(nonatomic,strong) CAShapeLayer *ovalShapeLayer;
@property(nonatomic,strong) CAAnimationGroup *animationGroup ;

@end

@implementation HP_LineRotateAnimation

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self defineProperty];
        [self creat];
        [self layout];
        [self animation];
        
    }
    return self;
}

-(void)defineProperty{
    
    self.lineWidth = 3;
    self.animationDuration = 1;
    self.edgeSpace = 20;
    
}

-(void)creat{
    
    _bottomShapeLayer = [CAShapeLayer layer];
    
    _ovalShapeLayer = [CAShapeLayer layer];
    
    _animationGroup = [CAAnimationGroup animation];
}

-(void)updateLayout{
    
    [self layout];
}

-(void )layout{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    CGFloat x = self.edgeSpace;
    CGFloat y = self.edgeSpace;
    CGFloat width = self.bounds.size.width - 2 * self.edgeSpace;
    CGRect centreRect = CGRectMake(x, y, width, width);
    
    /// 底部的灰色layer
    UIBezierPath *bottomPath = [UIBezierPath
                                bezierPathWithRoundedRect:centreRect cornerRadius:self.bounds.size.width - self.lineWidth];
    
    bottomPath.lineCapStyle = kCGLineCapRound;
    _bottomShapeLayer.strokeColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    _bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _bottomShapeLayer.lineWidth = self.lineWidth;
    _bottomShapeLayer.path = bottomPath.CGPath;
    
    [self.layer addSublayer:_bottomShapeLayer];
    
    
    /// 橘黄色的layer
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRoundedRect:centreRect cornerRadius:self.bounds.size.width - self.lineWidth];
    ovalPath.lineCapStyle = kCGLineCapRound;
    _ovalShapeLayer.strokeColor = self.loadColor.CGColor;
    _ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _ovalShapeLayer.lineWidth = self.lineWidth;
    _ovalShapeLayer.path = ovalPath.CGPath;
    
    [self.layer addSublayer:_ovalShapeLayer];
}

-(void)animation{
    
    /// 起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1.0);
    
    /// 终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    
    /// 组合动画
    _animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    _animationGroup.duration = self.animationDuration;
    _animationGroup.repeatCount = CGFLOAT_MAX;
    _animationGroup.fillMode = kCAFillModeForwards;
    _animationGroup.removedOnCompletion = NO;
    [_ovalShapeLayer addAnimation:_animationGroup forKey:nil];
    
}

-(UIColor *)loadColor{
    
    if (_loadColor == nil) {
        return [UIColor whiteColor];
    }
    return _loadColor;
}

@end
