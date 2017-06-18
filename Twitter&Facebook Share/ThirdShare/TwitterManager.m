//
//  TwitterManager.m
//  ThirdShare
//
//  Created by Johnson on 2017/6/9.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "TwitterManager.h"
#import <TwitterCore/TwitterCore.h>
#import <Fabric/Fabric.h>

NSString *kTwiterAppKey                   = @"KMJq3P036rhiKcbMFGYitzVKr";
NSString *kTwiterAppSecret                = @"z73F3nGkbnmJyItYHu4osmRZgWjAQB599vL7kZ6JR7xaG6H7gV";

typedef NS_ENUM(NSInteger, FileType)
{
    FileTypeJpg                     = 255216,
    FileTypeGif                     = 7173,
    FileTypeBmp                     = 6677,
    FileTypePng                     = 13780,
    FileTypeSwf                     = 6787,
    FileTypeExe                     = 7790,
    FileTypeRar                     = 8297,
    FileTypeZip                     = 8075,
    FileType7z                      = 55122,
    FileTypeXml                     = 6063,
    FileTypeHtml                    = 6033,
    FileTypeAspx                    = 239187,
    FileTypeCs                      = 117115,
    FileTypeJs                      = 119105,
    FileTypeTxt                     = 102100,
    FileTypeSql                     = 255254,
};


NSString * const kSendTweetURL                              = @"https://api.twitter.com/1.1/statuses/update.json";
NSString * const kUploadMediaURL                            = @"https://upload.twitter.com/1.1/media/upload.json";

@implementation TwitterManager

FileType file_type_number(NSData *data)
{
    int char1 = 0 ,char2 = 0 ;
    
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    
    return [[NSString stringWithFormat:@"%d%d",char1, char2] integerValue];
}




+ (void)load
{
    [[Twitter sharedInstance] startWithConsumerKey:kTwiterAppKey
     
                                    consumerSecret:kTwiterAppSecret];
    
    [Fabric with:@[[Twitter sharedInstance]]];
}




- (void)sendTweetWithText:(NSString *)text completion:(TWTRNetworkCompletion)completion
{
    [self sendTweetWithText:text mediaIds:nil completion:completion];
}

- (void)sendTweetWithText:(NSString *)text pictures:(NSArray <NSData *> *)pictures completion:(TWTRNetworkCompletion)completion
{
    
    if (pictures.count == 0) {
        NSAssert(NO, @"至少要有一张图片");
    }if (pictures.count > 4) {
        NSAssert(NO, @"一次最多上传四张图片");
    }

    [pictures enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BOOL flag = (file_type_number(obj) == FileTypeJpg || file_type_number(obj) == FileTypePng || file_type_number(obj) == FileTypeBmp);
        
        NSAssert(flag, @"图片只能为jpg、png、bmp格式");
    }];
    
    
    [self uploadPicture:pictures completion:^(NSArray<NSDictionary *> *result, NSArray<NSString *> *media_ids, NSError *error) {
       
        if (error) {
            completion ? completion(nil, nil, error) : nil;
            return ;
        }
        
        [self sendTweetWithText:text mediaIds:media_ids completion:completion];
        
    }];
}


- (void)sendTweetWithText:(NSString *)text gif:(NSData *)gifData completion:(TWTRNetworkCompletion)completion
{
    if (!gifData) {
        NSAssert(NO, @"Gif图片不存在");
    }
    
    NSAssert(file_type_number(gifData) == FileTypeGif, @"图片只能为gif格式");
    
    [self uploadPicture:@[gifData] completion:^(NSArray<NSDictionary *> *result, NSArray<NSString *> *media_ids, NSError *error) {
        
        if (error) {
            completion ? completion(nil, nil, error) : nil;
            return ;
        }
        
        [self sendTweetWithText:text mediaIds:media_ids completion:completion];
        
    }];

}

- (void)sendTweetWithText:(NSString *)text video:(NSData *)dataVideo MIMEType:(NSString *)MIMEType completion:(TWTRNetworkCompletion)completion
{
    [self uploadVideo:dataVideo MIMEType:MIMEType completion:^(NSURLResponse * _Nullable response, NSData * _Nullable responseData, NSError * _Nullable error) {
        
        if (error) {
            completion ? completion(nil, nil, error) : nil;
            return ;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:0
                              error:&jsonError];
        
        [self sendTweetWithText:text mediaIds:@[json[@"media_id_string"]] completion:completion];
    }];
}


#pragma mark - Private Methods


//https://dev.twitter.com/rest/reference/post/statuses/update 接口文档

- (void)sendTweetWithText:(NSString *)text mediaIds:(NSArray <NSString *> *)mediaIds completion:(TWTRNetworkCompletion)completion
{
    if(![[Twitter sharedInstance] session]) {
        NSAssert(NO, @"TW未授权");
        return;
    }
    
    
    NSString *method = @"POST";
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:text forKey:@"status"];
    
    mediaIds ? [parameter setObject:[mediaIds componentsJoinedByString:@","] forKey:@"media_ids"] : nil;
    

    NSError *error;
    NSURLRequest *request = [[Twitter sharedInstance].APIClient URLRequestWithMethod:method URL:kSendTweetURL parameters:parameter error:&error];

    NSAssert(!error || request, @"创建请求失败");
    
    [[Twitter sharedInstance].APIClient sendTwitterRequest:request completion:completion];
}


//https://dev.twitter.com/rest/media/uploading-media.html#imageupload 接口文档

- (void)uploadVideo:(NSData *)dataVideo MIMEType:(NSString *)MIMEType completion:(TWTRNetworkCompletion)completion
{

    if(![[Twitter sharedInstance] session]) {
        NSAssert(NO, @"TW未授权");
        return;
    }
    
    
    TWTRAPIClient *client = [[Twitter sharedInstance] APIClient];
    
    NSError *error;
    NSString *requestMethod = @"POST";
    __block NSString *mediaID;
    
    
    // First call with command INIT
    __block NSDictionary *parameter =  @{
                                       @"command": @"INIT",
                                       @"media_type": MIMEType,
                                       @"total_bytes": @(dataVideo.length).stringValue
                                       };
    
    [client sendTwitterRequest:[client URLRequestWithMethod:requestMethod URL:kUploadMediaURL parameters:parameter error:&error] completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        
        if (error) {
            completion ? completion(urlResponse, responseData, error) : nil;
            return ;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:0
                              error:&jsonError];
        
        // Second call with command APPEND
        parameter = @{
                      @"command" : @"APPEND",
                      @"media_id" : mediaID = [json objectForKey:@"media_id_string"],
                      @"segment_index" : @"0",
                      @"media" : [dataVideo base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                      };
        
        [client sendTwitterRequest:[client URLRequestWithMethod:requestMethod URL:kUploadMediaURL parameters:parameter error:&error] completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
            
            if (error) {
                completion ? completion(urlResponse, responseData, error) : nil;
                return ;
            }
        
            // Third call with command FINALIZE
            parameter = @{
                          @"command" : @"FINALIZE",
                          @"media_id" : mediaID
                          };
            
            [client sendTwitterRequest:[client URLRequestWithMethod:requestMethod URL:kUploadMediaURL parameters:parameter error:&error] completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
                
                if (error) {
                    completion ? completion(urlResponse, responseData, error) : nil;
                    return ;
                }
                
                completion ? completion(urlResponse, responseData, error) : nil;

            }];
   
        }];
        
    }];
}

- (void)uploadPicture:(NSArray <NSData *> *)pictures completion:(void(^)(NSArray <NSDictionary *> *result, NSArray <NSString *> *media_ids, NSError *error))completion
{
    
    if(![[Twitter sharedInstance] session]) {
        NSAssert(NO, @"TW未授权");
        return;
    }
    
    
    __block NSMutableArray *record = [NSMutableArray array];
    __block NSMutableArray *media_ids = [NSMutableArray array];
    
    [pictures enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        NSDictionary *parameter = @{
//                                    @"media": @"x",
                                    @"media_data": [obj base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],
                                    };
        
        NSError *error;
        [[Twitter sharedInstance].APIClient sendTwitterRequest:[[Twitter sharedInstance].APIClient URLRequestWithMethod:@"POST" URL:kUploadMediaURL parameters:parameter error:&error] completion:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
            
            if (error) {
                completion ? completion(record, media_ids, error) : nil;
                return ;
            }
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:0
                                  error:&jsonError];
            [record addObject:json];
            [media_ids addObject:json[@"media_id_string"]];
            
            if (record.count == pictures.count) {
                completion ? completion(record, media_ids, error) : nil;
            }
            
        }];
        
    }];
    
}

@end
