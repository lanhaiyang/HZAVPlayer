//
//  BackgroundBottomView.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/2.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "BackgroundBottomView.h"

#import <Masonry/Masonry.h>

@interface BackgroundBottomView()

@property(nonatomic,strong) UIView *gradView;

@end

@implementation BackgroundBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self layout];
        [self changeAlpha];
    }
    return self;
}

-(void)changeAlpha{
    _gradView = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:_gradView atIndex:0];
    
    self.backgroundColor = [UIColor clearColor];
    _gradView.backgroundColor = [UIColor blackColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    

    _gradView.frame = self.bounds;
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0.3 alpha:0.4] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       nil];
    [gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [gradLayer setStartPoint:CGPointMake(0.5f, 1.0f)];
    [gradLayer setEndPoint:CGPointMake(0.5f, 0.0f)];
    
    [gradLayer setFrame:self.bounds];
    
    [self.gradView.layer setMask:gradLayer];
}

-(void)layout{
    
    _bottomView = [[TVBottomView alloc] init];
    _functionView = [[FunctionBottomView alloc] init];
    
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    [self addSubview:_functionView];
    [_functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.bottomView.mas_bottom);
    }];
}



@end
