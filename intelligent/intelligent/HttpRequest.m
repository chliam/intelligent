//
//  HttpRequest.m
//  intelligent
//
//  Created by chliam on 15/12/1.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "HttpRequest.h"



@implementation HttpRequest

static HttpRequest *_instance;
static dispatch_once_t onceToken;

+(HttpRequest *)Instance
{
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [HttpRequest new];
        }
    });
    return _instance;
}

+(void)httpPostJsonData:(NSString*)uri body:(NSMutableDictionary *)bodyDic params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction
{
    [[HttpRequest Instance] httpPostJsonData:uri body:bodyDic params:params waitAction:waitAction finishAction:finishAction];
}

+(void)httpPostData:(NSString*)uri body:(NSData *)bodyData params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction
{
    [[HttpRequest Instance] httpPostData:uri body:bodyData params:params waitAction:waitAction finishAction:finishAction];
}

+(void)httpGetJsonData:(NSString*)uri body:(NSMutableDictionary *)bodyDic params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction
{
    [[HttpRequest Instance] httpGetJsonData:uri body:bodyDic params:params waitAction:waitAction finishAction:finishAction];
}

-(void)httpPostJsonData:(NSString*)uri body:(NSMutableDictionary *)bodyDic params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction{
    if (waitAction) {
        waitAction();
    }
    dispatch_async(BACKGROUNDQUEUE,^{
        NSString *url = [self getUrlWithParams:uri params:params];
        NSData *jsonData = nil;
        if(bodyDic)
        {
            jsonData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
        }
        ResponesResult *responseResult = [self requestData:url data:jsonData contentType:@"application/json" httpMethod:@"POST"];
        if (responseResult) {
            dispatch_async(MAINQUEUE,^{
                if (finishAction) {
                    finishAction(responseResult);
                }
            });
        }
    });
}

-(void)httpPostData:(NSString*)uri body:(NSData *)bodyData params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction{
    if (waitAction) {
        waitAction();
    }
    dispatch_async(BACKGROUNDQUEUE,^{
        NSString *url = [self getUrlWithParams:uri params:params];
        ResponesResult *responseResult = [self requestData:url data:bodyData contentType:@"application/json" httpMethod:@"POST"];
        if (responseResult) {
            dispatch_async(MAINQUEUE,^{
                if (finishAction) {
                    finishAction(responseResult);
                }
            });
        }
    });
}

-(void)httpGetJsonData:(NSString*)uri body:(NSMutableDictionary *)bodyDic params:(NSDictionary*)params waitAction:(waitRequestAction)waitAction finishAction:(finishRequestAction)finishAction{
    if (waitAction) {
        waitAction();
    }
    dispatch_async(BACKGROUNDQUEUE,^{
        NSString *url = [self getUrlWithParams:uri params:params];
        NSData *jsonData = nil;
        if(bodyDic)
        {
            jsonData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
        }
        ResponesResult *responseResult = [self requestData:url data:jsonData contentType:@"application/json" httpMethod:@"Get"];
        if (responseResult) {
            dispatch_async(MAINQUEUE,^{
                if (finishAction) {
                    finishAction(responseResult);
                }
            });
        }
    });
}

-(ResponesResult*)requestData:(NSString*)uri data:(NSData*)data contentType:(NSString*)contentType httpMethod:(NSString*)method {
    NSURL* url = [NSURL URLWithString:uri];
    NSMutableURLRequest* request  = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:(20)];
    [request setHTTPMethod:method];
    //[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    if(data)
    {
        //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];

    }
    
    NSHTTPURLResponse *callResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&callResponse error:&error];
    ResponesResult *response = [ResponesResult new];
    NSString *value =[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",value);
    response.statusCode = [callResponse statusCode];
    if ([callResponse statusCode] == 200)
    {
        response.isSuccess = YES;
        response.error  = nil;
        response.value = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    }
    else if ([callResponse statusCode] == 500)
    {
        response.isSuccess = NO;
        response.value = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *error =[response.value objectForKey:@"error"];
        if (error) {
            response.isSuccess = NO;
            response.message = [error objectForKey:@"errno"];
        }
    }
    else
    {
        response.isSuccess = NO;
        response.error  = error;
        if (error) {
            response.message = error.localizedDescription;
        }else{
            response.message = @"unknow";
        }
        
    }
    
    return response;
}


#pragma mark -- Construct url
-(NSString*)getUrlWithParams:(NSString*)uri params:(NSDictionary*)params
{
    NSString *url =[NSString stringWithFormat:@"%@",uri];
    BOOL isBlank = false;
    for (int i=0; i<[[params allKeys] count]; i++) {
        NSString *bstring ;
        NSString *value =[params objectForKey:[[params allKeys] objectAtIndex:i]];
        isBlank = [self isBlankString:value];
        if (i==0) {
            bstring = [NSString stringWithFormat:@"?%@=%@",[[params allKeys] objectAtIndex:i],isBlank?@"null":value];
            
        }else{
            NSString *value=[params objectForKey:[[params allKeys] objectAtIndex:i]];
            bstring = [NSString stringWithFormat:@"&%@=%@",[[params allKeys] objectAtIndex:i],isBlank?@"null":value];
        }
        url= [url stringByAppendingString:bstring];
    }
    return url;
}

-(BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] &&
        [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end

