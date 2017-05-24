//
//  ViewController.m
//  SocketServer
//
//  Created by Johnson on 2017/5/11.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "AsyncSocket.h"
#import "Aspects.h"
#import "Defines.h"


@interface ViewController ()
@property (nonatomic, strong) NSMutableString *contentStr;
@end

@implementation ViewController
{
    AsyncSocket *_receiveSocket;
    NSMutableArray <AsyncSocket *> *_arraySendSockets; //可用来存储发消息过来的socket链接
    AsyncSocket *_currentSendSocket;        //当前选择发送的socket
    __weak IBOutlet NSTextField *_textFieldSendMsg;
    __weak IBOutlet NSClipView *_clipViewRecvMsgs;
    __unsafe_unretained IBOutlet NSTextView *_textViewRecvMsgs;
    __weak IBOutlet NSMenu *_menuWithConnected;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arraySendSockets = [NSMutableArray array];

    //创建接收端, 开启端口监听
    _receiveSocket = [[AsyncSocket alloc] initWithDelegate:self userData:0];
    NSError *err = nil;
    [_receiveSocket acceptOnPort:kAsyncSocketServerPort error:&err];
    NSLog(@"端口开启");
    
    
//    [_textFieldSendMsg keyDown:nil];
    
    [_textFieldSendMsg aspect_hookSelector:@selector(selectText:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        
        [self clickSend:nil];
    } error:nil];
    
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)clickSend:(id)sender {

    if (!_currentSendSocket) {
        NSLog(@"当前没有任何一个连接保持");
    }
    
    [_currentSendSocket writeData:[_textFieldSendMsg.stringValue dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:0];
    
}


#pragma mark - Methods

- (void)selectItem:(NSMenuItem *)item
{
    _currentSendSocket = _arraySendSockets[[item.keyEquivalent integerValue]];
}

#pragma mark - Delegate

//客户端链接
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
{
    
    //客户端连接的是时候 保存客户端的socket, 可能需要回发消息给客户端/
    [_arraySendSockets addObject:newSocket];
    
    
    //添加item
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@:%@-连接", newSocket.connectedHost, @(newSocket.connectedPort)] action:@selector(selectItem:) keyEquivalent:@(_arraySendSockets.count - 1).stringValue];
    [_menuWithConnected addItem:item];
    [_menuWithConnected performActionForItemAtIndex:_arraySendSockets.count - 1];
    _currentSendSocket = newSocket;
    
    
    //发起对客户端的socket的监听
    [newSocket readDataWithTimeout:-1 tag:0];
    NSLog(@"客户端连接成功 %@", newSocket);
}


//收到客户端的消息
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    self.contentStr = self.contentStr ?: [@"" mutableCopy];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self.contentStr appendString:[NSString stringWithFormat:@"Recv-%@:%@  %@\n", sock.connectedHost, @(sock.connectedPort), str]];
    
    _textViewRecvMsgs.string = self.contentStr;

    //每次都滚动到最后面
    [_clipViewRecvMsgs scrollPoint:NSMakePoint(0, 99999999)];
    
    //继续监听客户端发送的消息
    [sock readDataWithTimeout:-1 tag:0];
}

//发出消息成功
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送成功");
    
    self.contentStr = self.contentStr ?: [@"" mutableCopy];
    
    [self.contentStr appendString:[NSString stringWithFormat:@"Send-%@:%@  %@\n", sock.connectedHost, @(sock.connectedPort), _textFieldSendMsg.stringValue]];
    
    _textViewRecvMsgs.string = self.contentStr;
    
    _textFieldSendMsg.stringValue = @"";
    
    //每次都滚动到最后面
    [_clipViewRecvMsgs scrollPoint:NSMakePoint(0, 99999999)];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
{
    NSLog(@"连接将要断开: %@", err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
{
    //可主动重连客户端

    NSMenuItem *item = [_menuWithConnected itemAtIndex:[_arraySendSockets indexOfObject:sock]];
    item.title = [item.title stringByReplacingOccurrencesOfString:@"连接" withString:@"断开"];
    
    
    
    [[[_arraySendSockets reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(AsyncSocket * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (obj.isConnected) {
            [_menuWithConnected performActionForItemAtIndex:idx];
            *stop = YES;
        }
        
    }];
    
}

@end
