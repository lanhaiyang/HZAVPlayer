//
//  HZ_RequestTaskModel.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/5/29.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_RequestTaskModel : NSObject


@property(nonatomic,strong) NSURL *requestURL;
@property(nonatomic,strong) NSData *requestData;

@end

NS_ASSUME_NONNULL_END
