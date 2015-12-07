//
//  Data.h
//  intelligent
//
//  Created by chliam on 15/12/2.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property(strong,nonatomic)NSString *lightControlServerURL;

@property(strong,nonatomic)NSString *cameraServerURL;
@property(strong,nonatomic)NSString *cameraServerAppid;
@property(strong,nonatomic)NSString *cameraServerAuth;

+(Data *)instance;

@end
