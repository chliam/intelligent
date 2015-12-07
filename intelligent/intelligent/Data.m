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

//@property(strong,nonatomic)NSString *cameraServerURL;
//@property(strong,nonatomic)NSString *cameraServerAppid;
//@property(strong,nonatomic)NSString *cameraServerAuth;
@implementation Data
{
    NSString *_lightControlServerURL;
    NSString *_cameraServerURL;
    NSString *_cameraServerAppid;
    NSString *_cameraServerAuth;
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

@end
