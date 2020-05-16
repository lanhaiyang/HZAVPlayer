//
//  HPAVPlayerWeb.h
//  FlowerTown
//
//  Created by 何鹏 on 2018/12/13.
//  Copyright © 2018 HuaZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HPAVPlayerWebDelegate  <NSObject>

@optional


/**
 获取文件的基本信息
 
 {
    "Accept-Ranges" = bytes;
    "Access-Control-Allow-Origin" = "*";
    "Access-Control-Expose-Headers" = "X-Log, X-Reqid";
    "Access-Control-Max-Age" = 2592000;
    Age = 1;
    "Cache-Control" = "public, max-age=31536000";
    Connection = "keep-alive";
    "Content-Disposition" = "inline; filename=\"4587945932505.mp4\"";
    "Content-Length" = 1149810;  // 文件的大小
    "Content-Transfer-Encoding" = binary;
    "Content-Type" = "video/mp4"; // 文件的类型
    Date = "Fri, 05 Aug 2016 01:55:16 GMT";
    Etag = "\"Fo5QDSpIMMLcV2W2fH899FH4q********\"";
    "Last-Modified" = "Fri, 22 Jul 2016 01:46:05 GMT"; // 最近一次修改时间
    Server = nginx;
    "X-Log" = "mc.g;IO:2";
    "X-Qiniu-Zone" = 0;
    "X-Reqid" = vHoAANGi1Q6OxmcU;
    "X-Via" = "1.1 suydong34:0 (Cdn Cache Server V2.0), 1.1 yd70:4 (Cdn Cache Server V2.0)";
 }

 @param fileInformation 文件的基本信息
 @param error 是否发生错误 nil为成功
 */
-(void)targetWithFileInformation:(NSDictionary *)fileInformation error:(NSError *)error;


/**
 目标信息回调

 @param length 目标文件大小
 @param error 是否错误 nil 成功
 */
-(void)targetWithFileLength:(long long)length error:(NSError *)error;

@end

@interface HZ_AVPlayerWeb : NSObject


/**
 当 失败是否大于错误信息
 */
@property(nonatomic,assign) BOOL isLog;


/**
 是否成功回调
 */
@property(nonatomic,weak) id<HPAVPlayerWebDelegate> delegate;


/**
 获取网络文件大小

 @param url 获取的url
 */
-(void)getUrlFileLength:(NSString *)url;

@end
