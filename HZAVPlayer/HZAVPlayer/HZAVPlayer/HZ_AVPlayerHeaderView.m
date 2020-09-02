//
//  HZ_AVPlayerHeaderView.m
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HZ_AVPlayerHeaderView.h"



@interface HZ_AVPlayerHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *playerName;


@end

@implementation HZ_AVPlayerHeaderView

+(instancetype)getPlayerHeaderView{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"HZAVPlayerBundles" ofType:@"bundle"]];
    HZ_AVPlayerHeaderView *headerView = [bundle loadNibNamed:@"HZ_AVPlayerHeaderView" owner:nil options:nil].lastObject;
//    HZ_AVPlayerHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:
//                                        NSStringFromClass([self class]) owner:nil options:nil ].lastObject;
    
    [headerView action];
    
    return headerView;
}

-(void)action{
    
    [_backBtn addTarget:self
                 action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backAction:(UIButton *)back{
    
    if ([self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
    
}


#pragma mark - 懒加载

-(void)setTitle:(NSString *)title{
    
    _title = title;
    _playerName.text = title;
    
}

-(void)setBackImage:(UIImage *)backImage{
    
    _backImage = backImage;
    [_backBtn setImage:backImage forState:UIControlStateNormal];
    
}


@end
