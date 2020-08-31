//
//  HPAVPlayerLogic.m
//  PT_HPAVPlayer
//
//  Created by 何鹏 on 2017/12/9.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HZ_AVPlayerLogic.h"

@implementation HZ_AVPlayerLogic

+(CGRect)centreWithRect:(CGRect)rect relative:(CGSize)size{
    
    CGFloat x = rect.size.width/2 - size.width/2;
    CGFloat y = rect.size.height/2 - size.height/2;
    
   return  CGRectMake(x, y, size.width, size.height);
}

+(CGFloat)changeMbWithFileLengthKb:(long long)kbLength{
    
    if (kbLength == 0) {
        return 0;
    }
    
    float kb = kbLength/1024.0;
    kb = kb /1024.0;
    
    return kb;
}

@end
