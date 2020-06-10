//
//  HZ_RequestTask.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/28.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_RequestTask.h"
#import "HZ_DealURLTool.h"

#define RequestTimeout 60.0

@interface HZ_RequestTask()<NSURLConnectionDataDelegate, NSURLSessionDataDelegate>

@property(nonatomic,strong) NSURLSession *session;
@property(nonatomic,strong) NSURLSessionDataTask *task;
@property(nonatomic,strong) HZ_RequestTaskModel *taskModel;

@end

@implementation HZ_RequestTask


- (instancetype)init {
    if (self = [super init]) {
        
        [self confige];
    }
    return self;
}

-(void)confige{
    
    _taskModel = [[HZ_RequestTaskModel alloc] init];
}

- (void)start {
    
    NSURL *url = [HZ_DealURLTool originalSchemeWithURL:self.requestURL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    if (self.downStartOffset > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld", self.downStartOffset, self.fileLength - 1] forHTTPHeaderField:@"Range"];
    }
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (void)setCancel:(BOOL)cancel {
    _cancel = cancel;
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate
//服务器响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (self.cancel) return;
//    NSLog(@"response: %@",response);
    completionHandler(NSURLSessionResponseAllow);
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSString * contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString * contentType = [[httpResponse allHeaderFields] objectForKey:@"Content-Type"];
    NSString * fileLength = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    self.fileLength = fileLength.integerValue > 0 ? fileLength.integerValue : response.expectedContentLength;
    
    contentType = (contentType == nil ? @"video/mp4":contentType);
    _contentType = contentType;
    _type = [[contentType componentsSeparatedByString:@"/"] lastObject];

    if ([self.delegate respondsToSelector:@selector(requestTaskWithState:requestModel:error:)]) {
        [self.delegate requestTaskWithState:HZ_RequestTaskLoading requestModel:_taskModel error:nil];
    }
    
}

//服务器返回数据 可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.cancel) return;
    
    if ([self.delegate respondsToSelector:@selector(requestTaskWithState:requestModel:error:)]) {
        _taskModel.requestData = data;
        [self.delegate requestTaskWithState:HZ_RequestTaskUpdateCache requestModel:_taskModel error:nil];
    }
    
    _cacheLength += data.length;
    
//    NSLog(@"=> %lf",((float)self.cacheLength/(float)self.fileLength) * 100);
//    NSLog(@"fileLength = %ld",_fileLength);
}

//请求完成会调用该方法，请求失败则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (self.cancel) {
        //取消下载
    }else {
        if (error) {
            
            if ([self.delegate respondsToSelector:@selector(requestTaskWithState:requestModel:error:)]) {
//                NSLog(@"网络错误 ****");
                [self.delegate requestTaskWithState:HZ_RequestTaskFailse requestModel:_taskModel error:error];
            }
        }else {
            //可以缓存则保存文件
            if ([self.delegate respondsToSelector:@selector(requestTaskWithState:requestModel:error:)]) {
                [self.delegate requestTaskWithState:HZ_RequestTaskFinishLoadingCache requestModel:_taskModel error:nil];
            }
        }
    }
}

-(void)setRequestURL:(NSURL *)requestURL{
    
    _requestURL = requestURL;
    _taskModel.requestURL = requestURL;
}

@end
