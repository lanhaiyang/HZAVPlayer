//
//  PT_HZEncryption.m
//  HZShoppingMall
//
//  Created by 何鹏 on 2018/12/6.
//  Copyright © 2018 何鹏. All rights reserved.
//

#import "HZ_Encryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HZ_Encryption

+ (NSString *) hz_md5:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    
    NSUInteger stringCount=16;
    
    const char *cStr = [str UTF8String];
    unsigned char result[stringCount];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *md5String=[NSMutableString string];
    
    for (int i=0; i<stringCount; i++) {
        
        [md5String appendFormat:@"%02X",result[i]];
        
    }
    
    return md5String;
}

@end
