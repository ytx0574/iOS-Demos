










 - (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
iOS VoIP系统的挂起使用上面方法对NSInputStream/NSOutputStream回调;

Version <= iOS7:

1. 非0退出确定会重连, 系统帮你把App重启了(可通过Cycript连接App), 但是无论什么在任务管理器中杀掉, 连接都会断开;
2. 断网再恢复网络, 此时会断开并且不会重连(网络变化可利用10s重连);
3. 如果用户没有在任务栏杀掉, 重启自动连接;
4. 后台执行时间<10s, 而且如果上一次后台没有执行完, 下一次将接着执行; 


Version >= iOS8:
    直接提示"Legacy VoIP background mode is deprecated and no longer supported", 当应用在后台时收不到任何消息通知. 只有再次打开时, 该方法才会回调并且把之前发送的所有消息整合成一条, 所以iOS8以上的VoIP建议使用PushKit.




上面测试分为iOS_Socket自实现VoIP, 以及使用GCDAsyncSocket实现的VoIP, 得到的测试结果一样
