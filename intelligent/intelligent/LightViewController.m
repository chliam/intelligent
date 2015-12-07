//
//  LightViewController.m
//  intelligent
//
//  Created by chliam on 15/11/26.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "LightViewController.h"
#import "HttpRequest.h"
#import "Dialog.h"
#import "Define.h"
#import "Data.h"

@implementation LightViewController
{
    NSString *serverURL;
    NSString *loadSvgURL;
    NSString *getLightStatesURL;
    NSString *setLightStatesURL;
    SVGKImageView *contentView;
    SVGKImage* svgImage;
    UITapGestureRecognizer* tapGestureRecognizer;
    NSDictionary *allLayersDic;
    
    NSMutableDictionary *lightStatesDic; //key=lightLayerId value=isLightOpen
    NSDictionary *hitControlLightDic; //key＝layerId  value = lightIdList
    UIColor *lightOpenColor;
    UIColor *lightCloseColor;
    NSTimer *cycleLoadTimer;
    BOOL isServerOK;
    CGRect viewSettingOriFrame;
    CGRect viewSettingEditFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Dialog showProgress:self withLabel:@"正在加载设备布局.."];
    dispatch_async(BACKGROUNDQUEUE, ^{
        self.lbSettingTitle.backgroundColor = MAIN_COLOR;
        self.lbServerURL.textColor = MAIN_COLOR;
        self.txtServerURL.layer.borderWidth = 1.0;
        self.txtServerURL.layer.borderColor = MAIN_COLOR.CGColor;
        [self.btnSaveSetting setBackgroundColor:MAIN_COLOR];
        [self.btnCancelSetting setBackgroundColor:MAIN_COLOR];
        viewSettingOriFrame = self.viewSetting.frame;
        viewSettingEditFrame = CGRectMake(viewSettingOriFrame.origin.x, viewSettingOriFrame.origin.y-60, viewSettingOriFrame.size.width, viewSettingOriFrame.size.height);
        
        lightCloseColor = [UIColor lightGrayColor];
        lightOpenColor = [UIColor yellowColor];
        lightStatesDic = [NSMutableDictionary dictionaryWithDictionary:@{@"hjbf":@false,
                                                                         @"zhdc":@false,
                                                                         @"zhsq":@false,
                                                                         @"wlw":@false,
                                                                         @"zhzw":@false,
                                                                         @"zhcs":@false,
                                                                         @"qyxxq":@false,
                                                                         @"zhjj":@false,
                                                                         @"xt":@false,
                                                                         @"ggaq":@false,
                                                                         @"zhjt":@false,
                                                                         @"hd6":@false,
                                                                         @"tyyuan":@false}];
        
        hitControlLightDic = @{@"hjbf":@[@"hjbf"],
                               @"zhdc":@[@"zhdc"],
                               @"zhsq":@[@"zhsq"],
                               @"wlw":@[@"wlw"],
                               @"zhzw":@[@"zhzw"],
                               @"zhcs":@[@"zhcs"],
                               @"qyxxq":@[@"qyxxq"],
                               @"zhjj":@[@"zhjj"],
                               @"xt":@[@"xt"],
                               @"ggaq":@[@"ggaq"],
                               @"zhjt":@[@"zhjt"],
                               @"hd6":@[@"hd6"],
                               @"tyyuan":@[@"tyyuan"],
                               @"txt_hjbf":@[@"hjbf"],
                               @"text3676":@[@"hjbf"],
                               @"txt_zhdc":@[@"zhdc"],
                               @"text3718":@[@"zhdc"],
                               @"txt_zhsq":@[@"zhsq"],
                               @"text3742":@[@"zhsq"],
                               @"txt_wlw":@[@"wlw"],
                               @"text3724":@[@"wlw"],
                               @"txt_zhzw":@[@"zhzw"],
                               @"text3730":@[@"zhzw"],
                               @"txt_zhcs":@[@"zhcs"],
                               @"text3712":@[@"zhcs"],
                               @"txt_qyxxq":@[@"qyxxq"],
                               @"text3706":@[@"qyxxq"],
                               @"txt_zhjj":@[@"zhjj"],
                               @"text3700":@[@"zhjj"],
                               @"txt_xt":@[@"xt"],
                               @"text3682":@[@"xt"],
                               @"txt_ggaq":@[@"ggaq"],
                               @"text3670":@[@"ggaq"],
                               @"txt_zhjt":@[@"zhjt"],
                               @"text3688":@[@"zhjj"],
                               @"txt_hd6":@[@"hd6"],
                               @"text3736":@[@"hd6"],
                               @"txt_tyyuan":@[@"tyyuan"],
                               @"text3694":@[@"tyyuan"]};
        
        loadSvgURL = [NSString stringWithFormat:@"%@/svg/Showroom.svg",[Data instance].lightControlServerURL];
        getLightStatesURL = [NSString stringWithFormat:@"%@/realtime/getinterfacedata",[Data instance].lightControlServerURL];
        setLightStatesURL = [NSString stringWithFormat:@"%@/realtime/setstatus",[Data instance].lightControlServerURL];
        self.txtServerURL.text = [Data instance].lightControlServerURL;
        svgImage = [SVGKImage imageNamed:@"Showroom"];
        float scaleX = self.view.frame.size.width/svgImage.size.width;
        float scaleY = self.view.frame.size.height/svgImage.size.height;
        float scale = MIN(scaleX, scaleY);
        svgImage.size = CGSizeApplyAffineTransform(svgImage.size, CGAffineTransformMakeScale(scale,scale));
        CGRect frame =CGRectMake(0, (self.view.frame.size.height-svgImage.size.height)/2, svgImage.size.width, svgImage.size.height);
        
        dispatch_async(MAINQUEUE, ^{
            contentView = [[SVGKLayeredImageView alloc] initWithFrame:frame];
            [contentView setImage:svgImage];
            [self.svgContainer addSubview:contentView];
            
            if( tapGestureRecognizer == nil )
            {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            }
            [contentView addGestureRecognizer:tapGestureRecognizer];
            allLayersDic = [svgImage dictionaryOfLayers];
            for (NSString *key in lightStatesDic) {
                CALayer* layer = [allLayersDic objectForKey:key];
                if (layer && [layer isKindOfClass:[CAShapeLayer class]]) {
                    CAShapeLayer* shapeLayer = (CAShapeLayer*)layer;
                    shapeLayer.fillColor = lightCloseColor.CGColor;
                }
            }
            [Dialog hideProgress];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                [self loadLightStatus:NO];
                [self startCycleLoad];
            });
            
        });
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInBackround:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self startCycleLoad];
    if (cycleLoadTimer) {
        [cycleLoadTimer fire];
    }
}

-(void)viewWillDisappear:(BOOL)animated{    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopCycleLoad];
}

- (void)appHasGoneInBackround:(UIApplication *)application
{
    [self stopCycleLoad];
}

- (void)appHasGoneInForeground:(UIApplication *)application
{
    [self startCycleLoad];
    if (cycleLoadTimer) {
        [cycleLoadTimer fire];
    }
}

-(void) handleTapGesture:(UITapGestureRecognizer*) recognizer
{
    CGPoint p = [recognizer locationInView:self.view];
    CALayer* layerForHitTesting = contentView.layer;
    CALayer* hitLayer = [layerForHitTesting hitTest:p];
    
    for (NSString *key in allLayersDic) {
        if ([hitLayer isEqual:allLayersDic[key]]) {
            NSLog(@"hiting.. %@",key);
            [self setLightStatus:key];
            return;
        }
    }
}

- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)btnSettingClick:(id)sender {
    self.viewSettingContainer.alpha = 0;
    self.viewSettingContainer.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSettingContainer.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnSaveSettingClick:(id)sender {
    
    [self.txtServerURL resignFirstResponder];
    if (self.txtServerURL.text.length<1) {
        [Dialog alert:@"服务地址不能为空！"];
    }else
    {
        [Data instance].lightControlServerURL = self.txtServerURL.text;
        [UIView animateWithDuration:0.3 animations:^{
            self.viewSettingContainer.alpha = 0;
        } completion:^(BOOL finished) {
            self.viewSettingContainer.hidden = YES;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            getLightStatesURL = [NSString stringWithFormat:@"%@/realtime/getinterfacedata",[Data instance].lightControlServerURL];
            setLightStatesURL = [NSString stringWithFormat:@"%@/realtime/setstatus",[Data instance].lightControlServerURL];
            [self loadLightStatus:NO];
        });
    }
}

- (IBAction)btnCancelSettingClick:(id)sender {
    [self.txtServerURL resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSettingContainer.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewSettingContainer.hidden = YES;
    }];
    
}

- (IBAction)txtServerURLBeginEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSetting.frame = viewSettingEditFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)txtServerURLEndEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSetting.frame = viewSettingOriFrame;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)loadSVG {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), BACKGROUNDQUEUE, ^{
        NSString* longURL = @"http://172.16.3.186:3000/svg/Showroom.svg";
        NSURL* url = [NSURL URLWithString:longURL];
        svgImage = [SVGKImage imageWithContentsOfURL:url];
        float scaleX = self.view.frame.size.width/svgImage.size.width;
        float scaleY = self.view.frame.size.height/svgImage.size.height;
        float scale = MIN(scaleX, scaleY);
        svgImage.size = CGSizeApplyAffineTransform(svgImage.size, CGAffineTransformMakeScale(scale,scale));
        if (contentView) {
            dispatch_async(MAINQUEUE,^{
                [contentView setImage:svgImage];
                allLayersDic = [svgImage dictionaryOfLayers];
            });
        }
    });
}

-(void)loadLightStatus:(BOOL)autoLoad {
    [HttpRequest  httpGetJsonData:getLightStatesURL body:nil params:nil waitAction:^{
        if (!autoLoad) {
            [Dialog showProgress:self withLabel:@"正在查询设备状态.."];
        }
    } finishAction:^(ResponesResult *responesResult) {
        if (!autoLoad) {
            [Dialog hideProgress];
        }
        if (responesResult.statusCode == 200 || responesResult.statusCode == 500) {
            isServerOK = YES;
        }else{
            isServerOK = NO;
        }
        if (responesResult.isSuccess) {
            
            NSArray *openArr = [[responesResult.value objectForKey:@"status"] allKeys];
            for (NSString *key in lightStatesDic.allKeys) {
                if ([openArr containsObject:key]) {
                    [lightStatesDic setValue:@true forKey:key];
                    CALayer* layer = [allLayersDic objectForKey:key];
                    if (layer && [layer isKindOfClass:[CAShapeLayer class]]) {
                        CAShapeLayer* shapeLayer = (CAShapeLayer*)layer;
                        shapeLayer.fillColor = lightOpenColor.CGColor;
                    }
                }else{
                    [lightStatesDic setValue:@false forKey:key];
                    CALayer* layer = [allLayersDic objectForKey:key];
                    if (layer && [layer isKindOfClass:[CAShapeLayer class]]) {
                        CAShapeLayer* shapeLayer = (CAShapeLayer*)layer;
                        shapeLayer.fillColor = lightCloseColor.CGColor;
                    }
                }
            }
        }else{
            
            if (!autoLoad) {
                [Dialog alertWithTitle:@"查询失败" andMessage:responesResult.message];
            }
        }
    }];
}

-(void)setLightStatus:(NSString*)hitLayerKey{
    NSArray *controlLightArr = [hitControlLightDic objectForKey:hitLayerKey];
    if (controlLightArr) {
        NSMutableDictionary *tmpLightStatesDic = [NSMutableDictionary dictionaryWithDictionary:lightStatesDic];
        BOOL allOpen = true;
        for (NSString *key in controlLightArr) {
            if ([[lightStatesDic objectForKey:key]  isEqual: @false]) {
                allOpen = false;
            }
        }
        for (NSString *key in controlLightArr) {
            if (allOpen == true) {
                [tmpLightStatesDic setObject:@false forKey:key];
            }else{
                [tmpLightStatesDic setObject:@true forKey:key];
            }
        }
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpLightStatesDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *postString = [NSString stringWithFormat:@"list=%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [HttpRequest httpPostData:setLightStatesURL body:[postString dataUsingEncoding:NSUTF8StringEncoding] params:nil waitAction:^{
            [Dialog showProgress:self withLabel:@"正在设置设备状态.."];
        } finishAction:^(ResponesResult *responesResult) {
            if (responesResult.isSuccess) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadLightStatus:YES];
                    [Dialog hideProgress];
                });
            }else{
                [Dialog alertWithTitle:@"设置失败" andMessage:responesResult.message];
                [Dialog hideProgress];
            }
        }];
    }
}

-(void)startCycleLoad{
    [self stopCycleLoad];
    cycleLoadTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoLoadLightStatus) userInfo:nil repeats:YES];
}

-(void)stopCycleLoad{
    if (cycleLoadTimer) {
        [cycleLoadTimer invalidate];
        cycleLoadTimer = nil;
    }
}

-(void)autoLoadLightStatus{
    if (isServerOK) {
        [self loadLightStatus:YES];
    }
}

@end
