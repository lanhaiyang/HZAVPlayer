//
//  HZ_AVPlayerHeaderView.h
//  HZ_AVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HPAVPlayerHeaderViewDelegate <NSObject>

@optional

-(void)backAction;

@end

@interface HZ_AVPlayerHeaderView : UIView

+(instancetype)getPlayerHeaderView;

@property(nonatomic,weak) id<HPAVPlayerHeaderViewDelegate> delegate;

@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) UIImage *backImage;

@end
