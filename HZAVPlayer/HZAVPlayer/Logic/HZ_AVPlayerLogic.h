//
//  HPAVPlayerLogic.h
//  PT_HPAVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZ_AVPlayerLogic : NSObject

/**
 居中函数

 @param rect 相对view
 @param size 需要在相对view上显示 的view
 @return 返回居中的位置
 */
+(CGRect)centreWithRect:(CGRect)rect relative:(CGSize)size;


/**
 目标文件大小由kb转Mb

 @param kbLength 目标文件kb
 @return 转为Mb
 */
+(CGFloat)changeMbWithFileLengthKb:(long long)kbLength;

@end
