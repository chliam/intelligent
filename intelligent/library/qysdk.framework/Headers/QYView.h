//
//  QYView.h
//  qysdk
//
//  Created by yj on 15/9/25.
//  Copyright © 2015年 yj. All rights reserved.
//

#ifndef QYView_h
#define QYView_h
#include "QYType.h"
#import <UIKit/UIKit.h>

@protocol QYViewDelegate <NSObject>


@optional
//  断开通知
-(void)onDisConnect:(QY_DISCONNECT_REASON) reason;

//  音量回调通知
-(void)onVolumeChange:(double) voiceValue;

//  回放时间通知
-(void)onReplayTimeChange:(struct tm) time;

//  画布显示画面通知
-(void)onVideoSizeChange:(int) width height:(int) height;

// 录像事件
-(void)onRecordStatus:(QY_RECORD_STATUS) statues;

@end



@interface QYView:NSObject

// 图像宽
-(int) GetWidth;

// 图象高
-(int) GetHeigh;

// 开始启动view
- (void) StartConnectCallBack:(void (^)(int32_t ret)) callback;

-(void) SetEventDelegate:(id<QYViewDelegate>) delegate;
// 查询24小时索引
- (void) GetStoreFileIndex: (QY_DAY *) day callBackWithDayTime:(void (^)(int32_t ret,QYTimeIndex* time)) callback;
// 云台控制 
- (void) CtrlPtz: (int)duration action: (enum QY_PTZ_TYPE) action callBack:(void (^)(int32_t ret)) callback;

// 音频控制 mode 0: 打开视频和音频1: 只打开视频2: 只打开音频
- (void) CtrlAudio: (int) mode callBack:(void (^)(int32_t ret)) callback;

// 控制回放0:是停止  1：播放
- (void) CtrlReplayTime: (QY_TIME) ttm ctrl:(int) ctrl callBack:(void (^)(int32_t ret)) callback;

// 对讲
-(void) CtrlTalk:(BOOL) talkend;

// 截图
-(int)Capture:(NSString*) savePath;

// 设置画面
-(void)SetCanvas:(UIView*) canvas;

// 关闭页面
- (void) Release;

@end

#endif /* QYView_h */
