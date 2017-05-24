//
//  ViewController.m
//  SocketUdpServer
//
//  Created by Johnson on 2017/5/18.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"

@implementation ViewController
{
    AsyncUdpSocket *_socketServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _socketServer = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *error;
    BOOL flag = [_socketServer bindToAddress:@"192.168.3.106" port:8888 error:&error];
    [_socketServer receiveWithTimeout:-1 tag:0];
    if (!flag || error) {
        NSLog(@"绑定失败 %@", error);
    }
    
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)clickSendMsg:(id)sender {
    
    BOOL flag = [_socketServer sendData:[@"7777777777" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"192.168.3.106" port:7777 withTimeout:30 tag:0];
    if (!flag) {
        NSLog(@"发送失败");
    }
}


/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag;
{

}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error;
{

}

/**
 * Called when the socket has received the requested datagram.
 *
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 *
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port;
{
    [sock receiveWithTimeout:-1 tag:tag];
    NSLog(@"msg:%@, %@ %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], host, @(port));
    return YES;
}

/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error;
{

}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock;
{

}


@end
