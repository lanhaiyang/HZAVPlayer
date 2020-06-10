//
//  HZ_CacheVideoConfigeBase.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/6/8.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    HZ_RequestTaskSuccess,
    HZ_RequestTaskFailse,
    HZ_RequestTaskLoading,
    HZ_RequestTaskUpdateCache,// 缓存发生更新
    HZ_RequestTaskFinishLoadingCache
} HZ_RequestTaskState;
