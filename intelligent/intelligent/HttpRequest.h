//
//  HttpRequest.h
//  intelligent
//
//  Created by chliam on 15/12/1.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponesResult.h"

#define BACKGROUNDQUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define MAINQUEUE dispatch_get_main_queue()

typedef void (^waitRequestAction)();
typedef void (^finishRequestAction)(ResponesResult *responesResult);

@interface HttpRequest : NSObject

+(HttpRequest *)Instance;

+(void)httpPostJsonData:(NSString*)uri body:(NSMutableDictionary *)bodyDic params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction;

+(void)httpPostData:(NSString*)uri body:(NSData *)bodyData params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction;

+(void)httpGetJsonData:(NSString*)uri body:(NSMutableDictionary *)bodyDic params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction;

@end

