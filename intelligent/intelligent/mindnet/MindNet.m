//
//  MindNet.m
//  sdkDemo
//
//  Created by 吴怡顺 on 15/9/29.
//  Copyright © 2015年 吴怡顺. All rights reserved.
//

#import "MindNet.h"
#import <qysdk/QYSession.h>
#import "DeviceModel.h"
#import <qysdk/QYView.h>
#import "Data.h"

@interface MindNet()<QYSessionDelegate>
{
    QYSession* session;
    QYView* talkView;
    QYView* replayView;
}
@end


@implementation MindNet

+ (MindNet *)sharedManager
{
    static MindNet *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc]initWithSession];
    });
    return sharedInstance;
}

-(id)initWithSession
{
    self=[super init];
    return self;
}


- (void)loginSession:(void (^)(int32_t ret)) callback
{
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [QYSession InitSDK: QY_LOG_INFO];
    session = [[QYSession alloc] init];
    NSLog(@"start login");
    [session SetServer:[Data instance].cameraServerURL port: 39100];

    //此接口现在登陆失败，成功登陆sdk账户名和密码需要联系厂商获取
    [session ViewerLogin:[Data instance].cameraServerAppid
                    auth:[Data instance].cameraServerAuth callBack:^(int32_t ret) {
//                        ret = 0; //TODO:Remove
                        if(ret==0)
                        {
                            _hasLogin=YES;
                            [session SetEventDelegate:self];
                        }
                        callback(ret);
                        NSLog(@"login complate: %d", ret);
                    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [session Release];
}

- (void)getDeviceSuccess:(void (^)(NSArray *ret))success
{
//    //TODO:Remove
//    QY_DEVICE_INFO deviceinfo = {1000000287000, 1};
//    NSMutableArray *array = [NSMutableArray new];
//    [array addObject:[NSValue valueWithBytes:&deviceinfo objCType:@encode(QY_DEVICE_INFO)]];
//    success(array);
    
    [session GetDeviceListcallBackWithArray:^(int32_t ret, NSMutableArray *array) {
        if(ret==0)
        {
            success(array);
        }
        else
        {
            success(nil);
        }
    }];
}

-(void)getChanelwithDevid:(DeviceModel*) device
              withsuccess:(void(^)(NSArray *ret)) success
{
    [session GetChannelList:device.device_id callBackWithArray:^(int32_t ret, NSMutableArray *array) {
        if(ret==0)
        {
            success(array);
        }
        else
        {
//            //TODO:Remove
//            QY_CHANNEL_INFO channelInfo = {1000000287001, 1,1};
//            array = [NSMutableArray arrayWithObjects:[NSValue valueWithBytes:&channelInfo objCType:@encode(QY_CHANNEL_INFO)], nil];
//            success(array);
            
            success(nil);
        }
    }];
    
}

////查询天概要索引
//-(QY_DAYS_INDEX)getDayList:(long long) devid
//                    yearData:(int) year
//                   monthData:(int) month
//                  cloundData:(BOOL) clound
//{
//    QY_DAYS_INDEX searchResult={0};
//    [session GetStoreFileListDayIndex:devid
//                                 year:year
//                                month:month
//                                cloud:clound
//                            daysIndex:&searchResult];
//
//    return searchResult;
//
//}


-(void)createVideoView:(long long) devid  callback:(void(^)(int32_t ret,QYView* view)) callback
{
    QYView* videoView= [session CreateView:devid];
    [videoView StartConnectCallBack:^(int32_t ret) {
        if(ret==0)
        {
            callback(ret,videoView);
        }
        else
        {
            callback(ret,nil);
        }
    }];
}

-(void)createTalkView:(long long) devid  callback:(void(^)(int32_t ret,QYView* view)) callback
{
    QYView* videoView= [session CreateTalkView:devid];
    [videoView StartConnectCallBack:^(int32_t ret) {
        if(ret==0)
        {
            callback(ret,videoView);
        }
        else
        {
            callback(ret,nil);
        }
    }];
    
}


//创建回放房间
-(void)createReplayView:(long long) devid
             CloudStroe:(BOOL) hasColund
               callback:(void(^)(int32_t ret,QYView* view)) callback
{
    
    QYView* videoView= [session CreateRePlayView:devid mode:hasColund];
    [videoView StartConnectCallBack:^(int32_t ret) {
        if(ret==0)
        {
            callback(ret,videoView);
        }
        else
        {
            callback(ret,nil);
        }
    }];
    
}

@end
