//
//  BackgroundBottomView.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/2.
//  Copyright © 2020 何鹏. All rights reserved.
//  我以微信小视频的样式来做

#import <UIKit/UIKit.h>
#import "TVBottomView.h"
#import "FunctionBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundBottomView : UIView

@property(nonatomic,strong,readonly) TVBottomView *bottomView;

@property(nonatomic,strong,readonly) FunctionBottomView *functionView;
@end

NS_ASSUME_NONNULL_END
