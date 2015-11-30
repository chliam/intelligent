//
//  LightViewController.m
//  intelligent
//
//  Created by chliam on 15/11/26.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "LightViewController.h"




@interface LightViewController ()

@end

@implementation LightViewController
{
    SVGKImageView *contentView;
    UITapGestureRecognizer* tapGestureRecognizer;
    CALayer* lastTappedLayer;
    CGFloat lastTappedLayerOriginalBorderWidth;
    CGColorRef lastTappedLayerOriginalBorderColor;
    NSDictionary *allLayers;
    
    NSDictionary *hitControlLightDic; //key＝layerId  value = lightIdList
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    hitControlLightDic = @{@"zt":@[@"cc",@"dd"]};
    
    //    SVGKImage *image = [SVGKImage imageNamed:@"Lion"];
    //    SVGKFastImageView *imgView = [[SVGKFastImageView alloc] initWithSVGKImage:image];
    //    [self.view addSubview:imgView];
    
    //    NSString* longURL = @"http://172.16.3.186:3000/svg/Showroom.svg";
    //    NSURL* url = [NSURL URLWithString:longURL];
    //    SVGKImage* newImage = [SVGKImage imageWithContentsOfURL:url];
    
    SVGKImage* newImage = [SVGKImage imageNamed:@"Showroom"];
    
    
    float scaleX = self.view.frame.size.width/newImage.size.width;
    float scaleY = self.view.frame.size.height/newImage.size.height;
    float scale = MIN(scaleX, scaleY);
    newImage.size = CGSizeApplyAffineTransform(newImage.size, CGAffineTransformMakeScale(scale,scale));
    
    CGRect frame =CGRectMake(0, (self.view.frame.size.height-newImage.size.height)/2, newImage.size.width, newImage.size.height);
    contentView = [[SVGKLayeredImageView alloc] initWithFrame:frame];
    [contentView setImage:newImage];
    //self.contentView = [[SVGKLayeredImageView alloc] initWithSVGKImage:newImage];
    [self.view addSubview:contentView];
    
    //    CGRect frame = self.contentView.frame;
    //    frame.origin.y = (self.view.frame.size.height-frame.size.height)/2;
    //    self.contentView.frame = frame;
    
    
    if( tapGestureRecognizer == nil )
    {
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    [contentView addGestureRecognizer:tapGestureRecognizer];
    
    allLayers = [newImage dictionaryOfLayers];
    NSLog(@"%@",allLayers);
    
    //   CALayer* absoluteLayer = [newImage layerWithIdentifier:@"xt"];
    //    if( [absoluteLayer isKindOfClass:[CAShapeLayer class]] )
    //    {
    //        CAShapeLayer* shapeLayer = (CAShapeLayer*) absoluteLayer;
    //        shapeLayer.fillColor = [UIColor redColor].CGColor;
    //    }
    
}


-(void) deselectTappedLayer
{
    if( lastTappedLayer != nil )
    {
        lastTappedLayer.borderWidth = lastTappedLayerOriginalBorderWidth;
        lastTappedLayer.borderColor = lastTappedLayerOriginalBorderColor;
        if( [lastTappedLayer isKindOfClass:[CAShapeLayer class]] )
        {
            CAShapeLayer* shapeLayer = (CAShapeLayer*) lastTappedLayer;
            shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
        }
    }
    
    lastTappedLayer = nil;
}

-(void) handleTapGesture:(UITapGestureRecognizer*) recognizer
{
    CGPoint p = [recognizer locationInView:self.view];
    CALayer* layerForHitTesting;
    layerForHitTesting = contentView.layer;
    CALayer* hitLayer = [layerForHitTesting hitTest:p];
    if( hitLayer == lastTappedLayer )
    {
        [self deselectTappedLayer];
    }
    else
    {
        [self deselectTappedLayer];
        lastTappedLayer = hitLayer;
        if( lastTappedLayer != nil )
        {
            for (NSString *key in allLayers) {
                if ([lastTappedLayer isEqual:allLayers[key]]) {
                    NSLog(@"hiting.. %@",key);
                }
            }
            
            
            if( [lastTappedLayer isKindOfClass:[CAShapeLayer class]] )
            {
                CAShapeLayer* shapeLayer = (CAShapeLayer*) lastTappedLayer;
                shapeLayer.fillColor = [UIColor redColor].CGColor;
            }
            
            lastTappedLayerOriginalBorderColor = lastTappedLayer.borderColor;
            lastTappedLayerOriginalBorderWidth = lastTappedLayer.borderWidth;
            lastTappedLayer.borderColor = [UIColor greenColor].CGColor;
            lastTappedLayer.borderWidth = 3.0;
        }
    }
}

- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
