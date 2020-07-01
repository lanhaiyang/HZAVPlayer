//
//  HZ_RequestTask.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/28.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZ_RequestTaskModel.h"
#import "HZ_CacheVideoConfigeBase.h"


@protocol HZ_RequestTaskDelegate  <NSObject>

 @optional

/// 下载任务状态
-(void)requestTaskWithState:(HZ_RequestTaskState)state requestModel:( HZ_RequestTaskModel * _Nullable )taskModel error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HZ_RequestTask : NSObject

@property(nonatomic,weak) id<HZ_RequestTaskDelegate> delegate;

/// 视频格式
@property(nonatomic,strong,readonly) NSString *contentType;
/// 视频的类型
@property(nonatomic,strong,readonly) NSString *type;

@property(nonatomic,assign,readonly) NSUInteger cacheLength;//下载完成的偏移量
@property(nonatomic,assign) NSUInteger downStartOffset;// 开始下载的偏移量
@property(nonatomic,assign) NSUInteger fileLength;// 文件大小

@property (nonatomic, strong) NSURL * requestURL; //请求网址
@property (nonatomic, assign) BOOL cancel; //是否取消请求

/**
 *  开始请求
 */
- (void)start;

@end

NS_ASSUME_NONNULL_END
