//
//  FunctionBottomView.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/2.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "FunctionBottomView.h"
#import <Masonry/Masonry.h>

@interface FunctionBottomView()

@property(nonatomic,strong) UIButton *deleBtn;

@property(nonatomic,strong) void(^backAction)(void);

@end

@implementation FunctionBottomView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self confige];
        [self layout];
    }
    return self;
}

-(void)confige{
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)layout{
    
    [self addSubview:self.deleBtn];
    [self.deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).equalTo(@15);
        make.height.equalTo(@30);
    }];
}

-(void)action{
    
    if (_backAction != nil) {
        _backAction();
    }
}

-(void)functionBackAcitonWithBlock:(void(^)(void))backAction{
    
    _backAction = backAction;
}

#pragma mark - 懒加载

-(UIButton *)deleBtn{
    
    if (_deleBtn == nil) {
        _deleBtn = [[UIButton alloc] init];
        [_deleBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_deleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        _deleBtn.backgroundColor = [UIColor clearColor];
    }
    return _deleBtn;
}

@end
