//
//  HZ_CacheVideoConfigeBase.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/6/8.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    HZ_RequestTaskSuccess,// 任务请求成功
    HZ_RequestTaskFailse,// 任务请求失败
    HZ_RequestTaskLoading,// 任务正在加载
    HZ_RequestTaskUpdateCache,// 缓存发生更新
    HZ_RequestTaskFinishLoadingCache// 下载完成，缓存data
} HZ_RequestTaskState;
