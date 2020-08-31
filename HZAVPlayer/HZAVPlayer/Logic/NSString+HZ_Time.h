//
//  NSString+HPTime.h
//  PT_HPAVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (HZ_Time)


/**
 时间戳转 -> 00:00:00

 @param second 秒
 @return 返回时间根系
 */
+ (NSString *)convertTime:(CGFloat)second;

@end
