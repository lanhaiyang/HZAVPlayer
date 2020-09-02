//
//  PT_HZEncryption.h
//  HZShoppingMall
//
//  Created by 何鹏 on 2018/12/6.
//  Copyright © 2018 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZ_Encryption : NSObject

/**
 md5加密
 
 @param str 加密的明文
 @return 密文
 */
+ (NSString *) hz_md5:(NSString *)str;

@end
