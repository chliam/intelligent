//
//  ResponesResult.h
//  intelligent
//
//  Created by chliam on 15/12/1.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponesResult : NSObject


@property(strong, nonatomic) NSError *error;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSDictionary *value;
@property(nonatomic)BOOL isSuccess;
@property(nonatomic)NSInteger statusCode;

@end
