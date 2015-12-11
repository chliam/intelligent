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
    
    NSMutableDictionary *lightStatesDic; //key=lightId value=isLightOpen
    NSMutableDictionary *lightLayersDic; //key=lightId value=lightLayerId
    
    NSDictionary *hitControlLightDic; //key＝layerId  value = lightIdList
    UIColor *lightOpenColor;
    UIColor *lightCloseColor;
    UIColor *doorOpenColor;
    UIColor *doorCloseColor;
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
        doorCloseColor = [UIColor lightGrayColor];
        lightOpenColor = [UIColor yellowColor];
        doorOpenColor = [UIColor blueColor];
        
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
                                                                         @"tyyuan":@false,
                                                                         @"hjbf_ds_ty":@false,
                                                                         @"zhdc_ds_ty":@false,
                                                                         @"zhsq_ds_ty":@false,
                                                                         @"wlw_ds_ty":@false,
                                                                         @"zhzw_ds_ty":@false,
                                                                         @"zhcs_ds_ty":@false,
                                                                         @"qyxxq_ds_ty":@false,
                                                                         @"zhjj_ds_ty":@false,
                                                                         @"xt_ds_ty":@false,
                                                                         @"ggaq_ds_ty":@false,
                                                                         @"zhjt_ds_ty":@false,
                                                                         @"hd6_ds_ty":@false,
                                                                         @"tyyuan_ds_ty":@false}];
        
        lightLayersDic = [NSMutableDictionary dictionaryWithDictionary:@{@"hjbf":@"hjbf",
                                                                         @"zhdc":@"zhdc",
                                                                         @"zhsq":@"zhsq",
                                                                         @"wlw":@"wlw",
                                                                         @"zhzw":@"zhzw",
                                                                         @"zhcs":@"zhcs",
                                                                         @"qyxxq":@"qyxxq",
                                                                         @"zhjj":@"zhjj",
                                                                         @"xt":@"xt",
                                                                         @"ggaq":@"ggaq",
                                                                         @"zhjt":@"zhjt",
                                                                         @"hd6":@"hd6",
                                                                         @"tyyuan":@"tyyuan",
                                                                         @"hjbf_ds_ty":@"btn_hjbf_ds_ty-hjbf_dj",
                                                                         @"zhdc_ds_ty":@"btn_zhdc_ds_ty-zhdc_dj",
                                                                         @"zhsq_ds_ty":@"btn_zhsq_ds_ty-zhsq_dj",
                                                                         @"wlw_ds_ty":@"btn_wlw_ds_ty-wlw_dj",
                                                                         @"zhzw_ds_ty":@"btn_zhzw_ds_ty-zhzw_dj",
                                                                         @"zhcs_ds_ty":@"btn_zhcs_ds_ty-zhcs_dj",
                                                                         @"qyxxq_ds_ty":@"btn_qyxxq_ds_ty-qyxxq_dj",
                                                                         @"zhjj_ds_ty":@"btn_zhjj_ds_ty-zhjj_dj",
                                                                         @"xt_ds_ty":@"btn_xt_ds_ty-xt_dj",
                                                                         @"ggaq_ds_ty": @"btn_ggaq_ds_ty-ggaq_dj",
                                                                         @"zhjt_ds_ty":@"btn_zhjt_ds_ty-zhjt_dj",
                                                                         @"hd6_ds_ty":@"btn_hd6_ds_ty-hd6_dj",
                                                                         @"tyyuan_ds_ty":@"btn_tyyuan_ds_ty-tyyuan_dj"}];
        
        hitControlLightDic = @{@"hjbf":@[@"hjbf",@"hjbf_ds_ty"],
                               @"zhdc":@[@"zhdc",@"zhdc_ds_ty"],
                               @"zhsq":@[@"zhsq",@"zhsq_ds_ty"],
                               @"wlw":@[@"wlw",@"wlw_ds_ty"],
                               @"zhzw":@[@"zhzw",@"zhzw_ds_ty"],
                               @"zhcs":@[@"zhcs",@"zhcs_ds_ty"],
                               @"qyxxq":@[@"qyxxq",@"qyxxq_ds_ty"],
                               @"zhjj":@[@"zhjj",@"zhjj_ds_ty"],
                               @"xt":@[@"xt",@"xt_ds_ty"],
                               @"ggaq":@[@"ggaq",@"ggaq_ds_ty"],
                               @"zhjt":@[@"zhjt",@"zhjt_ds_ty"],
                               @"hd6":@[@"hd6",@"hd6_ds_ty"],
                               @"tyyuan":@[@"tyyuan",@"tyyuan_ds_ty"],
                               @"txt_hjbf":@[@"hjbf",@"hjbf_ds_ty"],
                               @"text3676":@[@"hjbf",@"hjbf_ds_ty"],
                               @"txt_zhdc":@[@"zhdc",@"zhdc_ds_ty"],
                               @"text3718":@[@"zhdc",@"zhdc_ds_ty"],
                               @"txt_zhsq":@[@"zhsq",@"zhsq_ds_ty"],
                               @"text3742":@[@"zhsq",@"zhsq_ds_ty"],
                               @"txt_wlw":@[@"wlw",@"wlw_ds_ty"],
                               @"text3724":@[@"wlw",@"wlw_ds_ty"],
                               @"txt_zhzw":@[@"zhzw",@"zhzw_ds_ty"],
                               @"text3730":@[@"zhzw",@"zhzw_ds_ty"],
                               @"txt_zhcs":@[@"zhcs",@"zhcs_ds_ty"],
                               @"text3712":@[@"zhcs",@"zhcs_ds_ty"],
                               @"txt_qyxxq":@[@"qyxxq",@"qyxxq_ds_ty"],
                               @"text3706":@[@"qyxxq",@"qyxxq_ds_ty"],
                               @"txt_zhjj":@[@"zhjj",@"zhjj_ds_ty"],
                               @"text3700":@[@"zhjj",@"zhjj_ds_ty"],
                               @"txt_xt":@[@"xt",@"xt_ds_ty"],
                               @"text3682":@[@"xt",@"xt_ds_ty"],
                               @"txt_ggaq":@[@"ggaq",@"ggaq_ds_ty"],
                               @"text3670":@[@"ggaq",@"ggaq_ds_ty"],
                               @"txt_zhjt":@[@"zhjt",@"zhjt_ds_ty"],
                               @"text3688":@[@"zhjj",@"zhjt_ds_ty"],
                               @"txt_hd6":@[@"hd6",@"hd6_ds_ty"],
                               @"text3736":@[@"hd6",@"hd6_ds_ty"],
                               @"txt_tyyuan":@[@"tyyuan",@"tyyuan_ds_ty"],
                               @"text3694":@[@"tyyuan",@"tyyuan_ds_ty"],
                               @"btn_hjbf_ds_ty-hjbf_dj":@[@"hjbf_ds_ty"],
                               @"btn_zhdc_ds_ty-zhdc_dj":@[@"zhdc_ds_ty"],
                               @"btn_zhsq_ds_ty-zhsq_dj":@[@"zhsq_ds_ty"],
                               @"btn_wlw_ds_ty-wlw_dj":@[@"wlw_ds_ty"],
                               @"btn_zhzw_ds_ty-zhzw_dj":@[@"zhzw_ds_ty"],
                               @"btn_zhcs_ds_ty-zhcs_dj":@[@"zhcs_ds_ty"],
                               @"btn_qyxxq_ds_ty-qyxxq_dj":@[@"qyxxq_ds_ty"],
                               @"btn_zhjj_ds_ty-zhjj_dj":@[@"zhjj_ds_ty"],
                               @"btn_xt_ds_ty-xt_dj":@[@"xt_ds_ty"],
                               @"btn_ggaq_ds_ty-ggaq_dj":@[@"ggaq_ds_ty"],
                               @"btn_zhjt_ds_ty-zhjt_dj":@[@"zhjt_ds_ty"],
                               @"btn_hd6_ds_ty-hd6_dj":@[@"hd6_ds_ty"],
                               @"btn_tyyuan_ds_ty-tyyuan_dj":@[@"tyyuan_ds_ty"],
                               @"group_G_All":@[@"hjbf",@"zhdc",@"zhsq",@"wlw",@"zhzw",@"zhcs",@"qyxxq",@"zhjj",@"xt",@"ggaq",@"zhjt",@"hd6",@"tyyuan",@"hjbf_ds_ty",@"zhdc_ds_ty",@"zhsq_ds_ty",@"wlw_ds_ty",@"zhzw_ds_ty",@"zhcs_ds_ty",@"qyxxq_ds_ty",@"zhjj_ds_ty",@"xt_ds_ty",@"ggaq_ds_ty",@"zhjt_ds_ty",@"hd6_ds_ty",@"tyyuan_ds_ty"],
                               
                               @"group_G1":@[@"hjbf",@"xt",@"ggaq",@"zhjt",@"tyyuan",@"hjbf_ds_ty",@"xt_ds_ty",@"ggaq_ds_ty",@"zhjt_ds_ty",@"tyyuan_ds_ty"],
                               
                               @"group_G2":@[@"zhdc",@"zhsq",@"wlw",@"zhzw",@"zhcs",@"qyxxq",@"zhjj",@"hd6",@"zhdc_ds_ty",@"zhsq_ds_ty",@"wlw_ds_ty",@"zhzw_ds_ty",@"zhcs_ds_ty",@"qyxxq_ds_ty",@"zhjj_ds_ty",@"hd6_ds_ty"]};
        
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
            // 缩放手势
            UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
            [contentView addGestureRecognizer:pinchGestureRecognizer];
            // 移动手势
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
            [contentView addGestureRecognizer:panGestureRecognizer];
            
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
            for (NSString *devID in lightStatesDic.allKeys) {
                NSString *layerID = [lightLayersDic objectForKey:devID];
                if ([openArr containsObject:devID]) {
                    [lightStatesDic setValue:@true forKey:devID];
                    CALayer* layer = [allLayersDic objectForKey:layerID];
                    if (layer && [layer isKindOfClass:[CAShapeLayer class]]) {
                        CAShapeLayer* shapeLayer = (CAShapeLayer*)layer;
                        if ([layerID containsString:@"_ds_ty"]) {
                            shapeLayer.fillColor = doorOpenColor.CGColor;
                        }else{
                            shapeLayer.fillColor = lightOpenColor.CGColor;
                        }
                    }
                }else{
                    [lightStatesDic setValue:@false forKey:devID];
                    CALayer* layer = [allLayersDic objectForKey:layerID];
                    if (layer && [layer isKindOfClass:[CAShapeLayer class]]) {
                        CAShapeLayer* shapeLayer = (CAShapeLayer*)layer;
                        if ([layerID containsString:@"_ds_ty"]) {
                            shapeLayer.fillColor = doorCloseColor.CGColor;
                        }else{
                            shapeLayer.fillColor = lightCloseColor.CGColor;
                        }
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
        BOOL allClose = true;
        for (NSString *key in controlLightArr) {
            if ([[lightStatesDic objectForKey:key]  isEqual: @true]) {
                allClose = false;
            }
        }
        for (NSString *key in controlLightArr) {
            if (allClose == true) {
                [tmpLightStatesDic setObject:@true forKey:key];
            }else{
                [tmpLightStatesDic setObject:@false forKey:key];
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

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end
