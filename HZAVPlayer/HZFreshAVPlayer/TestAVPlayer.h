//
//  TestAVPlayer.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface TestAVPlayer : UIView

@property(nonatomic,strong,readonly) UIView *contentView;//播放控制View

/// 文件大小
@property(nonatomic,assign,readonly) float fileSize;


@end

NS_ASSUME_NONNULL_END
