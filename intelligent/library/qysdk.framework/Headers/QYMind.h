//
//  QYMind.h
//  qysdk
//
//  Created by 吴怡顺 on 15/11/2.
//  Copyright © 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYType.h"

@interface QYMind : NSObject
-(id)initWithSession:(int) session;

/*思维盒*/
/*查询容器设备下IPC列表*/
-(int) MindGetIpcList:(long long)DeviceId list:(NSMutableArray*) IpcList;

/* 摄像头绑定 */
-(int)MindIpcBind:(long long) DeviceId IpcInfo:(QY_IPC_INFO) IpcInfo account:(char *) Accout passowrd:(char *)Password;

/* 摄像头解绑 */
-(int)MindIpcUBind:(long long) DeviceId Mode:(int) Mode Num:(int)ListNum IPC:(QY_IPC_INFO *)IpcList;


@end
