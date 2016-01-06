//
//  Data.h
//  intelligent
//
//  Created by chliam on 15/12/2.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARRAY_SOURCE_INPUT @[@"VIDEO",@"VGA",@"DVI",@"HDMI"]
#define ARRAY_PLAN @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"]
#define ARRAY_PICTURE @[@"亮度",@"对比度",@"色彩",@"锐度"]

@interface Data : NSObject

@property(strong,nonatomic)NSString *lightControlServerURL;
@property(strong,nonatomic)NSString *cameraServerURL;
@property(strong,nonatomic)NSString *cameraServerAppid;
@property(strong,nonatomic)NSString *cameraServerAuth;

@property(strong,nonatomic)NSString *screenServerURL;
@property(strong,nonatomic)NSString *screenServerPort;
@property(strong,nonatomic)NSString *screenInput;
@property(strong,nonatomic)NSString *screenPlan;
@property(nonatomic)int screenRowNum;
@property(nonatomic)int screenColNum;


+(Data *)instance;

@end
