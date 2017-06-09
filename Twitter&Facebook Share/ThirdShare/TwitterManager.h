//
//  TwitterManager.h
//  ThirdShare
//
//  Created by Johnson on 2017/6/9.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

@interface TwitterManager : NSObject

- (void)sendTweetWithText:(NSString *)text completion:(TWTRNetworkCompletion)completion;

/**
 图片只能为png jpg bmp， 一次最多4图
 */
- (void)sendTweetWithText:(NSString *)text pictures:(NSArray <NSData *> *)pictures completion:(TWTRNetworkCompletion)completion;

/**

 Resolution should be <= 1280x1080 (width x height)
 Number of frames <= 350
 Number of pixels (width * height * num_frames) <= 300 million
 Filesize <= 15Mb

 */
- (void)sendTweetWithText:(NSString *)text gif:(NSData *)gifData completion:(TWTRNetworkCompletion)completion;


/**
 
 此种方法仅支持小视频上传, 视频分辨率不能太大，支持mov mp4，其他格式待测  如果不是mp4，最终返回也会转为mp4类型
 
 https://github.com/twitterdev/large-video-upload-python/  大文件上传方案 最大支持512M，这里就不写了
 */
- (void)sendTweetWithText:(NSString *)text video:(NSData *)dataVideo MIMEType:(NSString *)MIMEType completion:(TWTRNetworkCompletion)completion;

@end
