//
//  ViewController.m
//  ThirdShare
//
//  Created by Johnson on 2017/6/8.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "NSObject+CallBack.h"
#import "NSObject+Tools.h"
#import "TwitterManager.h"



#define ResetOrigin(x, y, view)                             view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height)

#define ResetSize(size, view)                               view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, size.width, size.height)


#define ConvertInstanceClass(Class, instance)               ((Class *)instance)

#define ShowAlert(msg, second)                              [self showAlert:nil message:msg delay:second]



#define kFBLocalTokenPath                                   [NSHomeDirectory() stringByAppendingString:@"/Library/FBToken"]


@interface ViewController () <FBSDKSharingDelegate>

@end

@implementation ViewController
{
    NSArray *_arrayShareItemTitles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     
     https://developers.facebook.com/docs/ios                 FBSDK下载地址
     https://developers.facebook.com/docs/sharing/ios         FB文档链接
     https://developers.facebook.com/apps/188914071634418/dashboard/   FB应用创建与管理
     
     //facebook
     //应用编号 188914071634418
     //应用秘钥 dbafa2e2473692f193c78edb498b858d
     //客户端口令 4f3a3136b1252185d354769a75f46229
     
     
     
     //https://github.com/crashlytics/cannonball-ios                 TWSDK GitHub下载地址， 另可通过cocoapods下载安装历史版本（默认为最新版本）
     //https://dev.twitter.com/rest/reference                        REST API
     //https://github.com/twitter/twurl                              REST API 命令行工具(测试)
     //https://dev.twitter.com/twitterkit/ios/overview               官网教程
     //https://twittercommunity.com/t/about-the-twitter-kit-sdk-category/32494   官方论坛
     //http://blog.csdn.net/cctvzxxz1/article/details/44623237       csdn找的一个教程
     //https://apps.twitter.com/app/13888574/permissions             TW应用创建与管理
     
     本Demo对应的版本 兼容iOS7  高版本的的SDK另外提供了TWTRComposerViewController进行发推文
     - Fabric, 1.5.5
     - TwitterCore, 1.8.1
     - TwitterKit, 1.8.1
     
     
     //@"2376631388-RkwJUnlqgiV0ZdzVer1nKY9jvotJcJjtMxTX2uw";
     //@"4spfBGr2Me94K8GsnVvbgtBjLlosA8QQyTPxFiwG5dwwQ";
     
     //消费者密钥（API密钥）	KMJq3P036rhiKcbMFGYitzVKr （管理密钥和访问令牌）
     //回调网址	无
     //回调网址锁定	号码
     //用Twitter登录	是的
     //应用专用身份	验证https://api.twitter.com/oauth2/token
     //请求令牌URL	https://api.twitter.com/oauth/request_token
     //授权网址	https://api.twitter.com/oauth/authorize
     //访问令牌URL	https://api.twitter.com/oauth/access_token
     
     */
    
    
    [self setUp_FB];
    [self setUp_TW];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods

- (void)setUp_TW
{
    //twiter自提供的按钮登录；
    TWTRLogInButton* logInButton =  [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error) {
                                         
        if (error.code == 1) {
            ShowAlert(@"取消TW授权登录", 1.f);
        }
        else if (error) {
            NSLog(@"登录 失败 %@", error);
            ShowAlert(@"使用TW授权登录失败", 1.f);
        }else {
            //授权登录成功
            
            NSString *msg = [NSString stringWithFormat:@"使用TW登录成功, 不必再次登录%@", session];
            
            ShowAlert(msg, 1.f);
            
            NSLog(@"signed in as %@", [session userName]);
        }
        
    }];
    
    ResetOrigin(0, 200, logInButton);
    
    [self.view addSubview:logInButton];
}

- (void)setUp_FB
{
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = (id)self;
    ResetOrigin(0, 33, loginButton);
    [self.view addSubview:loginButton];
    
    
    FBSDKLikeButton *likeButton = [[FBSDKLikeButton alloc] init];
    likeButton.soundEnabled = YES;
    likeButton.objectID = @"xxx";  //针对某条文章点赞
    [likeButton setTitle:@"对某ID为xxx的文章点赞" forState:UIControlStateNormal];
    ResetOrigin(0, 66, likeButton);
    ResetSize(loginButton.frame.size, likeButton);
    [self.view addSubview:likeButton];
    
    
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://www.twitter.com"];
    
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    [shareButton setTitle:[NSString stringWithFormat:@"分享链接%@", content.contentURL] forState:UIControlStateNormal];
    ResetOrigin(0, 99, shareButton);
    ResetSize(loginButton.frame.size, shareButton);
    [self.view addSubview:shareButton];
    
    
//    FBSDKSendButton *sendButton = [[FBSDKSendButton alloc] init];
//    sendButton.shareContent = content;
//    ResetOrigin(0, 133, sendButton);
//    [self.view addSubview:sendButton];
    
    
    
    
    _arrayShareItemTitles = @[
                              @"Share Link",
                              @"Share Photo",
                              @"Share Video",
                              @"Share Open Graph",
                              @"Share Media",
                              @"取消",
                              ];
}



#pragma mark - Click
- (IBAction)clickTWLogin:(id)sender {
    
    //应用管理必须填写回调的URL， 否则无法使用网页登录
    
    //不管是使用网页还是app登录， 都会自动登上系统的twiter账户， 下一次登录的时候该方法不再生效
    //和FB不一样的是，Twitter的登录方式为web或者系统Twitter账号， 跟你下载的官方TwitterApp没有任何关联； 而且也不用担心授权过期的问题
    //由于使用系统的授权没有任何提示， 所以最好给出明确的提示 要使用系统的Twitter账号
    
    
    if ([Twitter sharedInstance].session) {
        ShowAlert(@"已使用过TW授权登录", 1.f);
        return;
    }
    
    //一旦授权过后再次调用这个方法，UI将没有任何提示， 直接给出回调
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        
        if (error.code == 1) {
            ShowAlert(@"取消TW授权登录", 1.f);
        }
        else if (error) {
            NSLog(@"登录 失败 %@", error);
            ShowAlert(@"使用TW授权登录失败", 1.f);
        }else {
            //授权登录成功
        
            NSString *msg = [NSString stringWithFormat:@"使用TW登录成功, 并添加到系统的Twitter账户%@", session];
            
            ShowAlert(msg, 1.f);
            
            NSLog(@"signed in as %@", [session userName]);
        }
        
    }];
    
}


- (IBAction)clickTWShare:(id)sender {

//    //此种方式，只能发送文字，但是UI上会显示用户头像，发送回执以Delegate的形式返回，需要登录时的TWTRSession；
//    //TWTRComposerViewController对象有高版本（>=8.0）的TwitterKit中得到
//    
//    TWTRComposerViewController *composerVC = [[TWTRComposerViewController alloc] initWithUserID:_twitterSesstion.userID];
//    composerVC.delegate = (id)self;
//    composerVC.theme = [[TWTRComposerTheme alloc] initWithThemeType:TWTRComposerThemeTypeLight];
//    [self presentViewController:composerVC animated:YES completion:nil];
    
    
    ShowAlert(@"此方式必须登录系统内置的Twitter账户，否则无法发送", 1.f);
    
    //通用形式， 中间小窗弹出；调用的是系统的Twitter账号发推文，如果系统账号没有登录，则无法发出；
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setText:@"xxxxxxxx"];
    [composer setURL:[NSURL URLWithString:@"https://www.google.com"]];
    [composer setImage:[UIImage imageNamed:@"ShareImage"]];
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultDone) {
            NSLog(@"send success");
            ShowAlert(@"已发布到Twitter", 1.f);
        }else if (result == TWTRComposerResultCancelled) {
            ShowAlert(@"取消发布到Twitter", 1.f);
        }
    }];
}


- (IBAction)clickTwSendText:(id)sender {
    
    NSString *msg = [@">>>>>>>>>>" stringByAppendingFormat:@"%ld", random() % 33235];
    
    ShowAlert(([NSString stringWithFormat:@"发送文字：%@到Twitter", msg]), 1.f);
    
    [[[TwitterManager alloc] init] sendTweetWithText:msg completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        ShowAlert((!connectionError ? @"发送成功" : [NSString stringWithFormat:@"发送失败：%@", connectionError]), connectionError ? 5 : 1);
        
    }];
}

- (IBAction)clickTwSendTextAndImages:(id)sender {
    NSString *msg = [@"惺惺惜惺惺想寻" stringByAppendingFormat:@"%ld", random() % 33235];
    
    ShowAlert(([NSString stringWithFormat:@"发送文字：%@，和两张图片到Twitter", msg]), 1.f);
    
    [[[TwitterManager alloc] init] sendTweetWithText:msg
                                            pictures:@[
                                                       [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShareImage@2x" ofType:@"png"]],
                                                       [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShareImage@2x" ofType:@"png"]],
                                                       
                                                       ]
                                          completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                                              ShowAlert((!connectionError ? @"发送成功" : [NSString stringWithFormat:@"发送失败：%@", connectionError]), connectionError ? 5 : 1);
        
    }];
}

- (IBAction)clickTwSendTextAndGif:(id)sender {
    NSString *msg = [@"++++++++++++https://www.facebook.com +++++++++" stringByAppendingFormat:@"%ld", random() % 33235];
    
    ShowAlert(([NSString stringWithFormat:@"发送文字：%@，和一张Gif图到Twitter", msg]), 1.f);
    [[[TwitterManager alloc] init] sendTweetWithText:msg
                                                 gif:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gif" ofType:@"gif"]]
                                          completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                                              ShowAlert((!connectionError ? @"发送成功" : [NSString stringWithFormat:@"发送失败：%@", connectionError]), connectionError ? 5 : 1);

                                          }];

}

- (IBAction)clickTwSendTextAndVideo:(id)sender {
    NSString *msg = [@"https://www.facebookcom kk" stringByAppendingFormat:@"%ld", random() % 33235];;
    
    ShowAlert(([NSString stringWithFormat:@"发送文字：%@，和视频到Twitter", msg]), 1.f);

//    @"video/mp4"
//    @"video/quicktime"
    
    [[[TwitterManager alloc] init] sendTweetWithText:msg
                                               video:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp4"]]
                                            MIMEType:@"video/mp4"
                                          completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                                              ShowAlert((!connectionError ? @"发送成功" : [NSString stringWithFormat:@"发送失败：%@", connectionError]), connectionError ? 5 : 1);

                                          }];

}




- (IBAction)clickSysActivity:(id)sender {
    
    NSString *textToShare = @"文本内容";
    UIImage *imageToShare = [UIImage imageNamed:@"ShareImage"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://www.google.com"];
    NSArray *activityItems = @[textToShare, textToShare, imageToShare, urlToShare];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                            applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[
//                                         UIActivityTypePostToFacebook,
//                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop,
                                         UIActivityTypeOpenInIBooks
                                         ];
    
    
    activityVC.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        // 此处Facebook未登录的情况下分享失败不会给任何原因
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ 分享%@", activityType, completed ? @"成功" : @"失败"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
        NSLog(@"completionWithItemsHandler %@  %d  %@  %@", activityType, completed, returnedItems, activityError);
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
}


- (IBAction)clickFBLogin:(id)sender
{
    //    注销fb登录, 如果本地保存了token需要移除
    //    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //    [login logOut];
    
    FBSDKAccessToken *token = [NSKeyedUnarchiver unarchiveObjectWithFile:kFBLocalTokenPath];
    
    //如果token不存在，从本地取出赋值
    (token && ![FBSDKAccessToken currentAccessToken]) ? [FBSDKAccessToken setCurrentAccessToken:token] : nil;
    
    //如果快要过期 重新获取token
    NSUInteger expirationDays = [[FBSDKAccessToken currentAccessToken].expirationDate timeIntervalSinceDate:[NSDate date]] / 24 / 60 / 60;
    
    expirationDays < 1 ?  [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        //重新缓存token
    }] : nil;
    
    
    if (![FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        //        仅授予读取权限；
        //        [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        //
        //        }];
        
        //发布和读取权限都有
        [login logInWithPublishPermissions:@[@"publish_actions"]
                        fromViewController:self
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                       if (error) {
                                           
                                           NSLog(@"发起授权错误， 一般为SDK调用错误 %@", error);
                                           
                                       }else {
                                           
                                           //cancel
                                           if (result.isCancelled) {
                                               
                                               ShowAlert(@"取消使用FB授权登录", 1.f);
                                               
                                               NSLog(@"用户取消授权");
                                           }
                                           //success;
                                           else if (result.token && [result.token.permissions containsObject:@"publish_actions"]) {
                                               NSString *msg = [NSString stringWithFormat:@"使用FB授权登录成功%@", result];
                                               ShowAlert(msg, 1.f);
                                               
                                               [NSKeyedArchiver archiveRootObject:result.token toFile:kFBLocalTokenPath];
                                               
                                               //                                               appID
                                               //                                               declinedPermissions
                                               //                                               expirationDate
                                               //                                               permissions
                                               //                                               refreshDate
                                               //                                               tokenString
                                               //                                               userID
                                               
                                           }else {
                                               NSString *msg = [NSString stringWithFormat:@"使用FB授权登录失败%@", error];
                                               ShowAlert(msg, 1.f);
                                               NSLog(@"授权失败， 具体原因参考 返回结果：%@", result);
                                           }
                                       }
                                       
                                   }];
    }else {
        ShowAlert(@"已使用FB授权登录，退出请点击左边的Log Out按钮", 1.f);
    }
}

- (IBAction)clickFBShare:(id)sender
{
    NSURL *shareLinkURL    = [NSURL URLWithString:@"https://www.google.com"];
    UIImage *sharePhoto    = [UIImage imageNamed:@"ShareImage"];
    
    
    void(^actionHandle)(UIAlertAction *action) = ^(UIAlertAction *action) {
        
        //所有的content都支持FBSDKSharingContent协议，测试仅FBSDKShareLinkContent.contentURL有效
        __block id<FBSDKSharingContent> content = nil;
        
        switch ([_arrayShareItemTitles indexOfObject:action.title]) {
            case 0:
            {
                //如果链接是百度或是google之类的， 发出去的内容会打开一部分，  效果不错
                //如果是个普通链接，就是存文本的形式；
                content = [[FBSDKShareLinkContent alloc] init];
                ConvertInstanceClass(FBSDKShareLinkContent, content).quote = shareLinkURL.absoluteString;
            }
                break;
            case 01:
            {
                content = [[FBSDKSharePhotoContent alloc] init];
                ConvertInstanceClass(FBSDKSharePhotoContent, content).photos = @[[FBSDKSharePhoto photoWithImage:sharePhoto userGenerated:YES]];
            }
                break;
            case 02:
            {
                UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
                //                pickerVC.allowsEditing = YES;
                //                pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //                pickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                pickerVC.mediaTypes = @[@"public.movie"];//[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                pickerVC.delegate = (id)self;
                
                __weak typeof(self) wself = self;
                pickerVC.callBack = ^(UIImage *image, NSDictionary *info) {
                    
                    NSURL *url;
                    if (image) {
                        
                        //只选择图片
                    }else if (info) {
                        //选择视频
                        url = info[UIImagePickerControllerReferenceURL];
                        
                        //必须配置本地相册访问权限, 发出去的同时没法获取发送进度;    Tips: 网络环境差，发送很慢。。。
                        //会显示由什么应用发布，链接需要在fb后台的app管理里面配置
                        content = [[FBSDKShareVideoContent alloc] init];
                        ConvertInstanceClass(FBSDKShareVideoContent, content).video = [FBSDKShareVideo videoWithVideoURL:url previewPhoto:[FBSDKSharePhoto photoWithImage:sharePhoto userGenerated:YES]];
                        
                        [FBSDKShareAPI shareWithContent:content delegate:wself];
                        
                    }else {
                        //取消选择
                        NSLog(@"取消选择");
                    }
                    
                };
                [self presentViewController:pickerVC animated:YES completion:nil];
                
                
                //直接终止，block里面分享
                return ;
            }
                break;
            case 03:
            {
                
                //https://developers.facebook.com/docs/sharing/opengraph/ios
                //没看出是个什么东西；
                NSDictionary *properties = @{
                                             @"og:type": @"books.book",
                                             @"og:title": @"A Game of Thrones",
                                             @"og:description": @"In the frozen wastes to the north of Winterfell, sinister and supernatural forces are mustering.",
                                             @"books:isbn": @"0-553-57340-3",
                                             };
                FBSDKShareOpenGraphObject *object = [FBSDKShareOpenGraphObject objectWithProperties:properties];
                
                FBSDKShareOpenGraphAction *action = [[FBSDKShareOpenGraphAction alloc] init];
                action.actionType = @"books.reads";
                [action setObject:object forKey:@"books:book"];
                
                content = [[FBSDKShareOpenGraphContent alloc] init];
                ConvertInstanceClass(FBSDKShareOpenGraphContent, content).action = action;
                ConvertInstanceClass(FBSDKShareOpenGraphContent, content).previewPropertyName =  @"books:book";
            }
                break;
            case 04:
            {
                
                //无法分享，分享后无任何回调通知  iPad和iPhone5s  iOS10都无法分享，FB版本为95.0
                
                //                用户使用的 iOS 版本至少应为 7.0。
                //                分享内容的用户应安装 iOS 版 Facebook 客户端版本 52.0 或更高版本。
                //                每个照片和视频元素的大小必须小于 12MB。
                //                用户最多可以分享 1 个视频加 29 张照片，或最多分享 30 张照片。
                
                content = [[FBSDKShareMediaContent alloc] init];
                ConvertInstanceClass(FBSDKShareMediaContent, content).media = @[
                                                                                [FBSDKSharePhoto photoWithImage:sharePhoto userGenerated:YES],
                                                                                [FBSDKSharePhoto photoWithImage:sharePhoto userGenerated:YES],
                                                                                ];
            }
                break;
                
            default:
                //取消
                return;
                break;
        }
        
        content.contentURL = shareLinkURL;
        
        //直接分享， 不再跳转到fb
        [FBSDKShareAPI shareWithContent:content delegate:self];
        
        
        //        //会跳转到fb，显示它的UI进行分享，不好用
        //        [FBSDKShareDialog showFromViewController:self
        //                                     withContent:content
        //                                        delegate:nil];
        
    };
    
    
    
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Share" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [_arrayShareItemTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *aciton = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:actionHandle];
        
        [vc addAction:aciton];
        
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    ShowAlert(@"FB分享成功", 2.f);
    NSLog(@"Posted OG action with id: %@， %@", results.description, [sharer shareContent]);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    ShowAlert(@"FB分享失败", 2.f);
    NSLog(@"Error: %@,  %@", error.description, [sharer shareContent]);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    ShowAlert(@"FB取消分享", 2.f);
    NSLog(@"Canceled share");
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
{
    picker.callBack(image, editingInfo);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
{
    picker.callBack(nil, info);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    picker.callBack(nil, nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error;
{
    
    NSString *msg = [NSString stringWithFormat:@"%@  %@", result.isCancelled ? @"取消使用FB登录" : [NSString stringWithFormat:@"使用FB登录成功%@", result], error ? error : nil];
    ShowAlert(msg, 1.f);
    NSLog(@"%@: %@ %@", NSStringFromSelector(_cmd), result, error ? error : nil);
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;
{
    ShowAlert(@"退出FB登录", 2);
    [[NSFileManager defaultManager] removeItemAtPath:kFBLocalTokenPath error:nil];
    
    NSLog(@"%@:", NSStringFromSelector(_cmd));
}


- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton;
{
    NSLog(@"%@:", NSStringFromSelector(_cmd));
    return YES;
}



//#pragma mark - TWTRComposerViewControllerDelegate
//
//- (void)composerDidCancel:(TWTRComposerViewController *)controller;
//{
//    [[[UIAlertView alloc] initWithTitle:@"TW分享取消" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    
//}
//
//- (void)composerDidSucceed:(TWTRComposerViewController *)controller withTweet:(TWTRTweet *)tweet;
//{
//    [[[UIAlertView alloc] initWithTitle:@"TW分享成功" message:tweet.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
//    NSLog(@"%@ %@", NSStringFromSelector(_cmd), tweet);
//}
//
//- (void)composerDidFail:(TWTRComposerViewController *)controller withError:(NSError *)error;
//{
//    [[[UIAlertView alloc] initWithTitle:@"TW分享失败" message:error.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}

@end
