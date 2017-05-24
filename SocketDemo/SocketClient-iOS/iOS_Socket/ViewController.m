//
//  ViewController.m
//  iOS_Socket
//
//  Created by Johnson on 21/04/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "AsyncSocket.h"
#import "Defines.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *labelIp;
@property (weak, nonatomic) IBOutlet UITextField *labelPort;
@property (weak, nonatomic) IBOutlet UITextField *labelMsg;

@property (weak, nonatomic) IBOutlet UITextView *textViewContent;

@property (nonatomic, strong) NSMutableArray *socketArray;
@property (nonatomic, strong) NSMutableString *contentStr;
@end

@implementation ViewController
{
    AsyncSocket *_clientSocket;
    NSInteger _reconnectCount;
//    AsyncSocket *_serverSocket;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socketArray = [NSMutableArray array];

    self.labelIp.text = [kIp stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    self.labelPort.text = @(kPort).stringValue;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reconnectSocket
{
    [self clickConnect:nil];
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        [self clickSend:nil];
    }
    return YES;
}

#pragma mark - Click

- (IBAction)clickConnect:(id)sender {
    
    _clientSocket = _clientSocket ?: [[AsyncSocket alloc] initWithDelegate:self];
    if (_clientSocket.isConnected) {
        return;
    }
    
    NSError *error = nil;
    [_clientSocket disconnect];
    BOOL flag = [_clientSocket connectToHost:self.labelIp.text onPort:self.labelPort.text.intValue error:&error];
    if (!flag || error) {
        NSLog(@"连接不成功 %@", error);
    }
}

- (IBAction)clickSend:(id)sender {

    NSData *data = [self.labelMsg.text dataUsingEncoding:NSUTF8StringEncoding];

    //发送并监听服务端返回的消息
    [_clientSocket writeData:data withTimeout:10 tag:0];
    [_clientSocket readDataWithTimeout:-1 tag:0];
}


#pragma mark - SocketDelegate

//服务器连接时使用, 一般用不到. 通常是客户端主动重连, 而不是服务端主动
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
{
//    [self.socketArray addObject:newSocket];
    
    [newSocket readDataWithTimeout:-1 tag:0];
}


-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.contentStr = self.contentStr ?: [@"" mutableCopy];
    
    [self.contentStr appendString:[NSString stringWithFormat:@"Recv-%@:%@  %@\n", sock.connectedHost, @(sock.connectedPort), msg]];
    
    self.textViewContent.text = self.contentStr;
    
    if (self.textViewContent.contentSize.height > self.textViewContent.bounds.size.height) {
        [self.textViewContent setContentOffset:CGPointMake(0, self.textViewContent.contentSize.height - self.textViewContent.bounds.size.height) animated:YES];
    }
    
    
    //继续监听服务端发送的消息
    [sock readDataWithTimeout:-1 tag:0];
    
    ShowLocalNotificationAndIfMsgIs963PerformExit3(msg);
}


//连接成功
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"iOS_Socket------------------------------------------------连接成功！");
    
    //主动监听服务端过来的消息
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;
{
    NSLog(@"iOS_Socket------------------------------------------------发送成功");
    self.contentStr = self.contentStr ?: [@"" mutableCopy];
    
    [self.contentStr appendString:[NSString stringWithFormat:@"Send-%@:%@  %@\n", sock.connectedHost, @(sock.connectedPort), self.labelMsg.text]];
    
    self.textViewContent.text = self.contentStr;
    
    self.labelMsg.text = @"";

    
    if (self.textViewContent.contentSize.height > self.textViewContent.bounds.size.height) {
        [self.textViewContent setContentOffset:CGPointMake(0, self.textViewContent.contentSize.height - self.textViewContent.bounds.size.height) animated:YES];
    }

}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
{
    NSLog(@"iOS_Socket------------------------------------------------ 连接将要断开: %@", err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
{
    NSLog(@"iOS_Socket------------------------------------------------连接已经断开");
    
    //可选择主动连接服务器, 亦可让服务器主动连接自己, 这里主动连接服务器
//    [sock acceptOnPort:333 error:&error];
    
    if (_reconnectCount < kReconnectMax) {
        
        NSError *error;
        [_clientSocket connectToHost:self.labelIp.text onPort:self.labelPort.text.intValue error:&error];
        if (error) {
            NSLog(@"重连失败 %@", error);
        }
        
        _reconnectCount++;
    }else {
        _reconnectCount = 0;
    }
    
}

@end
