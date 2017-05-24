//
//  ViewController.m
//  GCDSokect
//
//  Created by Johnson on 2017/5/18.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "Defines.h"



@interface ViewController ()<GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextField *labelIp;
@property (weak, nonatomic) IBOutlet UITextField *labelPort;
@property (weak, nonatomic) IBOutlet UITextField *labelMsg;

@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (nonatomic, strong) NSMutableString *contentStr;
@end

@implementation ViewController
{
    GCDAsyncSocket *_clientSocket;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelIp.text = [kIp stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    self.labelPort.text = @(kPort).stringValue;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _clientSocket = _clientSocket ?: [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

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
    [_clientSocket writeData:data withTimeout:30 tag:0];
    [_clientSocket readDataWithTimeout:-1 tag:0];
}

#pragma mark - SocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;
{
    NSLog(@"连接成功");
    [_clientSocket readDataWithTimeout:-1 tag:0];
    
    [sock performBlock:^{
        if (![sock enableBackgroundingOnSocket]) {
            ShowLocalNotificationAndIfMsgIs963PerformExit3(@"后台运行失败");
        }
    }];
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
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

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
{
    
}

@end
