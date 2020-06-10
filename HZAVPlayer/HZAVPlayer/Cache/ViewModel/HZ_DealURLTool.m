//
//  HZ_DealURLTool.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/29.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_DealURLTool.h"

@implementation HZ_DealURLTool

+ (NSURL *)customSchemeWithURL:(NSURL *)url {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

+ (NSURL *)originalSchemeWithURL:(NSURL *)url {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}

@end
