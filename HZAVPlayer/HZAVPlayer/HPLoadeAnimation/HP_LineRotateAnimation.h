//
//  PT_HPLineRotateAnimation.h
//  HPLoadeAnimation
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HP_LineRotateAnimation : UIView

@property(nonatomic,assign) CGFloat lineWidth;

@property(nonatomic,assign) CGFloat animationDuration;

@property(nonatomic,assign) CGFloat edgeSpace;

@property(nonatomic,strong) UIColor *loadColor;

-(void)updateLayout;

@end
