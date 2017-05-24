//
//  AppDelegate.m
//  SocketServer
//
//  Created by Johnson on 2017/5/11.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncSocket.h"
#import "Defines.h"

@interface AppDelegate () <GCDAsyncSocketDelegate>

@end

@implementation AppDelegate
{
    GCDAsyncSocket *_serverSocket;
    NSMutableArray <GCDAsyncSocket *> *_arrayClientSockets;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    
    /**
     此处使用GCDAsyncSocket作为服务端进行测试;
     默认主要用户连接7777端口就一直发消息;
     此Demo的UI逻辑使用的是AsyncSocket作为服务端;
     
     可分别测试;
     */
    
    _arrayClientSockets = [NSMutableArray array];
    
    _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err;
    if (![_serverSocket acceptOnPort:kGCDAsyncSocketServerPort error:&err] || err) {
        NSLog(@"端口监听开启失败");
    };

    
    [self sendMsg];
    
    
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Methods

NSInteger number = 0;

- (void)sendMsg
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        sleep(1);
        number++;
        
        [_arrayClientSockets enumerateObjectsUsingBlock:^(GCDAsyncSocket * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj writeData:[[NSString stringWithFormat:@"this is msg %@ #", @(number)] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:0];
        }];
        
        number > 0 ? [self sendMsg] : nil;
    });
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket;
{
    [_arrayClientSockets addObject:newSocket];
    
    [newSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
{
    [sock readDataWithTimeout:-1 tag:0];
}

@end
