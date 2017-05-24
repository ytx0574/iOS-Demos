//
//  Defines.h
//  GCDSokect
//
//  Created by Johnson on 2017/5/19.
//  Copyright © 2017年 Johnson. All rights reserved.
//



#define kIp                     @"http://192.168.3.106"
#define kPort                   7777


#define kReconnectMax           3



//展示本地通知,当msg==963时,exit(3)  通知必须有权限才能发出
#define ShowLocalNotificationAndIfMsgIs963PerformExit3(msg) \
\
dispatch_async(dispatch_get_main_queue(), ^{ \
UILocalNotification *localNotif = [[UILocalNotification alloc] init];\
localNotif.alertBody = msg;\
localNotif.alertAction = NSLocalizedString(@"Accept Call", nil);\
localNotif.soundName = @"alarmsound.caf";\
localNotif.applicationIconBadgeNumber = 11;\
[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];\
\
NSLog(@"GCDSokect------------------------------------------------- msg: %@", msg);\
if ([msg integerValue] == 963) {\
exit(3);\
}\
});


