//
//  HPAVPlayerWeb.m
//  FlowerTown
//
//  Created by 何鹏 on 2018/12/13.
//  Copyright © 2018 HuaZhen. All rights reserved.
//

#import "HZ_AVPlayerWeb.h"

struct delegateFlags {
    unsigned int targetWithFileLength : 1;
    unsigned int targetWithFileInformation : 1;
};

@interface HZ_AVPlayerWeb()<NSURLConnectionDataDelegate>

@property(nonatomic,assign) struct delegateFlags delegateFlags;

@property(nonatomic,strong) NSMutableURLRequest *mURLRequest;
@property(nonatomic,strong) NSURLConnection *urlConnection;

@end

@implementation HZ_AVPlayerWeb


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)getUrlFileLength:(NSString *)url {
    
    if (url == nil || url.length == 0) {
        if (_isLog == YES) {
            //NSLog(@"❌ url is nil");
        }
        return ;
    }
    
    _mURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_mURLRequest setHTTPMethod:@"HEAD"];
    _mURLRequest.timeoutInterval = 5.0;
    _urlConnection = [NSURLConnection connectionWithRequest:_mURLRequest delegate:self];
    [_urlConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSDictionary *dict = [(NSHTTPURLResponse *)response allHeaderFields];
    NSNumber *length = [dict objectForKey:@"Content-Length"];
    [connection cancel];
    
    if (_delegateFlags.targetWithFileInformation == YES) {
        [_delegate targetWithFileInformation:dict error:nil];
    }

    if (_delegateFlags.targetWithFileLength == YES) {
        [_delegate targetWithFileLength:[length longLongValue] error:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (_isLog == YES) {
        //NSLog(@"❌ 获取文件大小失败：%@",error);
    }
    
    if (_delegateFlags.targetWithFileInformation == YES) {
        [_delegate targetWithFileInformation:nil error:error];
    }
    
    if (_delegateFlags.targetWithFileLength == YES) {
        [_delegate targetWithFileLength:0 error:error];
    }
    [connection cancel];
}


#pragma mark - 懒加载

-(void)setDelegate:(id<HPAVPlayerWebDelegate>)delegate{
    
    _delegate = delegate;
    _delegateFlags.targetWithFileLength = [delegate respondsToSelector:@selector(targetWithFileLength:error:)];
    _delegateFlags.targetWithFileInformation = [delegate respondsToSelector:@selector(targetWithFileInformation:error:)];
}

@end
