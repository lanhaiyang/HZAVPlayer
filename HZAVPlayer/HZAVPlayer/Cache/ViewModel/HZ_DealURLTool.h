//
//  HZ_DealURLTool.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/29.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_DealURLTool : NSObject


+ (NSURL *)customSchemeWithURL:(NSURL *)url;

+ (NSURL *)originalSchemeWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
