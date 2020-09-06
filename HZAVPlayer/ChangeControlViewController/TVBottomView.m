//
//  TVBottomView.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "TVBottomView.h"
#import "TVBottomSlideView.h"
#import "TVBottomSlideView.h"
#import <Masonry/Masonry.h>

@interface TVBottomView()

@property(nonatomic,strong) TVBottomSlideView *slideView;
@property (strong, nonatomic)  UIButton *playerBtn;
@property (strong, nonatomic)  UILabel *playerTime;
@property (strong, nonatomic)  UILabel *endTime;
//@property (strong, nonatomic)  UIButton *scaleBtn;

@end

@implementation TVBottomView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self confige];
        [self layout];
        [self action];
    }
    return self;
}


-(void)confige{
    
    self.backgroundColor = [UIColor clearColor];
    self.playerBtn.backgroundColor = [UIColor clearColor];
    self.playerTime.backgroundColor = [UIColor clearColor];
    self.endTime.backgroundColor = [UIColor clearColor];
}

-(void)layout{
    
    [self addSubview:self.playerBtn];
    [self addSubview:self.playerTime];
    [self addSubview:self.slideView];
    [self addSubview:self.endTime];
    [self.playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).equalTo(@5);
        make.right.equalTo(self.playerTime.mas_left).equalTo(@-5);
        make.width.equalTo(@46);
    }];

    [self.playerTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.width.lessThanOrEqualTo(@100);
        make.right.equalTo(self.slideView.mas_left).equalTo(@-5);
    }];
    
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@32);
        make.centerY.equalTo(self);
        make.right.equalTo(self.endTime.mas_left).equalTo(@-5);
    }];
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).equalTo(@-5);
    }];
}

-(void)action{
    
    [_playerBtn addTarget:self
                   action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    [_scaleBtn addTarget:self
//                  action:@selector(scaleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

-(void)updateWithSlide:(CGFloat)value{
    
    [self.slideView updateWithSlide:value];
}


-(void)slideWithMinValue:(CGFloat)minValue maxValue:(NSTimeInterval)maxValue{
    
    [self.slideView slideWithMinValue:minValue maxValue:maxValue];
}


-(void)updataCacheWithProgress:(CGFloat)progress{
    
    [self.slideView updataCacheWithProgress:progress];
}

#pragma mark - 懒加载



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



-(void)setStopImage:(UIImage *)stopImage{
    
    _stopImage = stopImage;
    [_playerBtn setImage:stopImage forState:UIControlStateNormal];
    
}

-(void)setPlayerImage:(UIImage *)playerImage{
    
    _playerImage = playerImage;
    [_playerBtn setImage:playerImage forState:UIControlStateSelected];
}

#pragma mark - 懒加载

-(UIButton *)playerBtn{
    
    if (_playerBtn == nil) {
        _playerBtn = [[UIButton alloc] init];
    }
    return _playerBtn;
}

- (UILabel *)playerTime{
    
    if (_playerTime == nil) {
        _playerTime = [[UILabel alloc] init];
        _playerTime.text = @"00:00";
        _playerTime.textColor = [UIColor whiteColor];
    }
    return _playerTime;
}

-(UILabel *)endTime{
    
    if (_endTime == nil) {
        _endTime = [[UILabel alloc] init];
        _endTime.text = @"00:00";
        _endTime.textColor = [UIColor whiteColor];
    }
    return _endTime;
}

-(TVBottomSlideView *)slideView{
    
    if (_slideView == nil) {
        _slideView = [[TVBottomSlideView alloc] init];
    }
    return _slideView;
}

-(void)setDelegate:(id<HZAVPlayerBottomViewDelegate>)delegate{
    
    _delegate = delegate;
    self.slideView.delegate = delegate;
}

@end
