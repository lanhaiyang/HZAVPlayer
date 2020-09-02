//
//  HZ_CacheLoadMange.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/27.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_CacheLoadManager.h"

// viewModel
#import "HZ_CacheLoadViewModel.h"
#import "HZ_CacheFileManage.h"
#import "HZ_DealURLTool.h"


@interface HZ_CacheLoadManager()<HZ_CacheLoadDelegate>

@property(nonatomic,strong) HZ_CacheLoadViewModel *loadViewModel;

@end

@implementation HZ_CacheLoadManager

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self confige];
    }
    return self;
}

-(void)confige{
    
    _loadViewModel = self.loadViewModel;
}

#pragma mark - AVAssetResourceLoaderDelegate

///要求加载资源的代理方法
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    [_loadViewModel addLoadingWithRequest:loadingRequest];
    return YES;
}



///取消加载资源的代理方法
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    [_loadViewModel removeLoadingRequest:loadingRequest];
}

+ (NSString *)filePathIsExistWithURL:(NSURL *)url{
    
    if (url == nil) {
        return nil;
    }
    url = [HZ_DealURLTool customSchemeWithURL:url];
    return [HZ_CacheFileManage filePathIsExistWithURL:url];
}

-(AVURLAsset *)getURLAssetObjectWithURL:(NSURL *)url{
    
    if (url == nil) {
        return nil;
    }
    url = [HZ_DealURLTool customSchemeWithURL:url];
    AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    return urlAsset;
}

- (void)isSlideProgress{
    
    _loadViewModel.seekRequired = YES;
}

#pragma mark - HZ_CacheLoadDelegate

-(void)hz_cahceLoadWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    
}

-(void)hz_requestTaskWithState:(HZ_RequestTaskState)state error:(NSError *)error{
    
    if ([_delegate respondsToSelector:@selector(hz_requestTaskWithState:error:)]) {
        [_delegate hz_requestTaskWithState:state error:error];
    }
}

#pragma mark - 懒加载

-(NSUInteger)cacheLength{
    
    return _loadViewModel.cacheLength;
}

//-(void)setSeekRequired:(BOOL)seekRequired{
//
//    _seekRequired = seekRequired;
//    _loadViewModel.seekRequired = seekRequired;
//}


-(HZ_CacheLoadViewModel *)loadViewModel{
    
    if (_loadViewModel == nil) {
        _loadViewModel = [[HZ_CacheLoadViewModel alloc] init];
        _loadViewModel.delgate = self;
    }
    return _loadViewModel;
}

@end


