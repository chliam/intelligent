//
//  Data.m
//  intelligent
//
//  Created by chliam on 15/12/2.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "Data.h"

#define LightControlServerURLCacheKey @"LightControlServerURLCacheKey"
#define CameraServerURLCacheKey @"CameraServerURLCacheKey"
#define CameraServerAppidCacheKey @"CameraServerAppidCacheKey"
#define CameraServerAuthCacheKey @"CameraServerAuthCacheKey"

#define SCREENServerURLCacheKey @"SCREENServerURLCacheKey"
#define SCREENServerPORTCacheKey @"SCREENServerPORTCacheKey"
#define SCREENIPUTCacheKey @"SCREENIPUTCacheKey"
#define SCREENPLANCacheKey @"SCREENPLANCacheKey"
#define SCREENROWNUMCacheKey @"SCREENROWNUMCacheKey"
#define SCREENCOLNUMCacheKey @"SCREENCOLNUMCacheKey"

@implementation Data
{
    NSString *_lightControlServerURL;
    NSString *_cameraServerURL;
    NSString *_cameraServerAppid;
    NSString *_cameraServerAuth;
    
    NSString *_screenServerURL;
    NSString *_screenServerPort;
    NSString *_screenInput;
    NSString *_screenPlan;
    int _screenRowNum;
    int _screenColNum;
}

static Data * dataManager=nil;
+(Data *)instance{
    @synchronized(self)
    {
        if (dataManager == nil) {
            dataManager = [[Data alloc] init];
        }
    }
    return dataManager;
}

-(id)init{
    self = [super init];
    if (self) {
        NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
        id mLightControlServerURL=[mUserDefaults objectForKey:LightControlServerURLCacheKey];
        if (mLightControlServerURL) {
            _lightControlServerURL=[NSString stringWithFormat:@"%@",mLightControlServerURL];
        }else{
            _lightControlServerURL=@"http://172.16.3.186:3000";;
        }
        
        id mCameraServerURLL=[mUserDefaults objectForKey:CameraServerURLCacheKey];
        if (mCameraServerURLL) {
            _cameraServerURL=[NSString stringWithFormat:@"%@",mCameraServerURLL];
        }else{
            _cameraServerURL=@"117.28.255.16";
        }
        
        id mCameraServerAppid=[mUserDefaults objectForKey:CameraServerAppidCacheKey];
        if (mCameraServerAppid) {
            _cameraServerAppid=[NSString stringWithFormat:@"%@",mCameraServerAppid];
        }else{
            _cameraServerAppid=@"wholeally";
        }
        
        id mCameraServerAuth=[mUserDefaults objectForKey:CameraServerAuthCacheKey];
        if (mCameraServerAuth) {
            _cameraServerAuth=[NSString stringWithFormat:@"%@",mCameraServerAuth];
        }else{
            _cameraServerAuth=@"czFYScb5pAu+Ze7rXhGh/1IBvfvPWHBZfhr/Gnq1U2/fF5Y3QVq111IBvfvPWHBZfhr/Gnq1U28f8vVVUCUM60yqjrrwJvdss3WNn7/G5ik=";
        }
        
        id mScreenServerURL=[mUserDefaults objectForKey:SCREENServerURLCacheKey];
        if (mScreenServerURL) {
            _screenServerURL=[NSString stringWithFormat:@"%@",mScreenServerURL];
        }else{
            _screenServerURL=@"172.16.3.4";
        }
        
        id mScreenServerPort=[mUserDefaults objectForKey:SCREENServerPORTCacheKey];
        if (mScreenServerPort) {
            _screenServerPort=[NSString stringWithFormat:@"%@",mScreenServerPort];
        }else{
            _screenServerPort=@"15000";
        }
        
        id mScreenInput=[mUserDefaults objectForKey:SCREENIPUTCacheKey];
        if (mScreenInput) {
            _screenInput=[NSString stringWithFormat:@"%@",mScreenInput];
        }else{
            _screenInput=[ARRAY_SOURCE_INPUT objectAtIndex:0];
        }
        
        id mScreenPlan=[mUserDefaults objectForKey:SCREENPLANCacheKey];
        if (mScreenPlan) {
            _screenPlan=[NSString stringWithFormat:@"%@",mScreenPlan];
        }else{
            _screenPlan=[ARRAY_PLAN objectAtIndex:0];
        }
        
        id mScreenRowNum=[mUserDefaults objectForKey:SCREENROWNUMCacheKey];
        if (mScreenRowNum) {
            _screenRowNum=[mScreenRowNum intValue];
        }else{
            _screenRowNum=4;
        }
        
        id mScreenColNum=[mUserDefaults objectForKey:SCREENCOLNUMCacheKey];
        if (mScreenColNum) {
            _screenColNum=[mScreenColNum intValue];
        }else{
            _screenColNum=4;
        }
    }
    return self;
}

-(NSString*)lightControlServerURL{
    return _lightControlServerURL;
}

-(void)setLightControlServerURL:(NSString *)lightControlServerURL{
    _lightControlServerURL = lightControlServerURL;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:lightControlServerURL forKey:LightControlServerURLCacheKey];
    [mUserDefaults synchronize];
}

-(NSString*)cameraServerURL{
    return _cameraServerURL;
}

-(void)setCameraServerURL:(NSString *)cameraServerURL{
    _cameraServerURL = cameraServerURL;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_cameraServerURL forKey:CameraServerURLCacheKey];
    [mUserDefaults synchronize];
}

-(NSString*)cameraServerAppid{
    return _cameraServerAppid;
}

-(void)setCameraServerAppid:(NSString *)cameraServerAppid{
    _cameraServerAppid = cameraServerAppid;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_cameraServerAppid forKey:CameraServerAppidCacheKey];
    [mUserDefaults synchronize];
}

-(NSString*)cameraServerAuth{
    return _cameraServerAuth;
}

-(void)setCameraServerAuth:(NSString *)cameraServerAuth{
    _cameraServerAuth = cameraServerAuth;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_cameraServerAuth forKey:CameraServerAuthCacheKey];
    [mUserDefaults synchronize];
}


-(NSString*)screenServerURL{
    return _screenServerURL;
}

-(void)setScreenServerURL:(NSString *)screenServerURL{
    _screenServerURL = screenServerURL;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_screenServerURL forKey:SCREENServerURLCacheKey];
    [mUserDefaults synchronize];
}

-(NSString*)screenServerPort{
    return _screenServerPort;
}

-(void)setScreenServerPort:(NSString *)screenServerPort{
    _screenServerPort = screenServerPort;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_screenServerPort forKey:SCREENServerPORTCacheKey];
    [mUserDefaults synchronize];
}

-(NSString*)screenInput{
    return _screenInput;
}

-(void)setScreenInput:(NSString *)screenInput{
    _screenInput = screenInput;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_screenInput forKey:SCREENIPUTCacheKey];
    [mUserDefaults synchronize];
}

-(NSString*)screenPlan{
    return _screenPlan;
}

-(void)setScreenPlan:(NSString *)screenPlan{
    _screenPlan = screenPlan;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:_screenPlan forKey:SCREENPLANCacheKey];
    [mUserDefaults synchronize];
}

-(int)screenRowNum{
    return _screenRowNum;
}

-(void)setScreenRowNum:(int)screenRowNum{
    _screenRowNum = screenRowNum;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults  setValue:[NSString stringWithFormat:@"%d",_screenRowNum] forKey:SCREENROWNUMCacheKey];
    [mUserDefaults synchronize];
}

-(int)screenColNum{
    return _screenColNum;
}

-(void)setScreenColNum:(int)screenColNum{
    _screenColNum = screenColNum;
    
    NSUserDefaults *mUserDefaults = [NSUserDefaults standardUserDefaults];
    [mUserDefaults setValue:[NSString stringWithFormat:@"%d",_screenColNum] forKey:SCREENCOLNUMCacheKey];
    [mUserDefaults synchronize];
}

@end
