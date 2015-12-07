//
//  ViewController.m
//  intelligent
//
//  Created by chliam on 15/4/23.
//  Copyright (c) 2015年 chliam. All rights reserved.
//

#import "ViewController.h"
#import "VideoMainViewController.h"
#import "LightViewController.h"
#import "Dialog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.menu1_1 initTitleAndImg:@"居室控制" imgName:@"menu1"];
    [self.menu1_2 initTitleAndImg:@"智能照明" imgName:@"menu2"];
    [self.menu1_3 initTitleAndImg:@"电器控制" imgName:@"menu3"];
    [self.menu1_4 initTitleAndImg:@"红外控制" imgName:@"menu4"];
    [self.menu1_5 initTitleAndImg:@"设备控制" imgName:@"menu5"];
    [self.menu1_6 initTitleAndImg:@"浇灌控制" imgName:@"menu6"];
    [self.menu1_7 initTitleAndImg:@"门窗检测" imgName:@"menu7"];
    [self.menu1_8 initTitleAndImg:@"监控检测" imgName:@"menu8"];
    [self.menu1_9 initTitleAndImg:@"场景控制" imgName:@"menu9"];
    [self.menu1_10 initTitleAndImg:@"定时查询" imgName:@"menu10"];
    [self.menu1_11 initTitleAndImg:@"视频监控" imgName:@"menu11"];
    [self.menu1_12 initTitleAndImg:@"历史查询" imgName:@"menu12"];
    
    [self.menu2_1 initTitleAndImg:@"物业通知" imgName:@"menu2_1"];
    [self.menu2_2 initTitleAndImg:@"物业报修" imgName:@"menu2_2"];
    [self.menu2_3 initTitleAndImg:@"物业沟通" imgName:@"menu2_3"];
    [self.menu2_4 initTitleAndImg:@"小区社群" imgName:@"menu2_4"];
    [self.menu2_5 initTitleAndImg:@"访客记录" imgName:@"menu2_5"];
    [self.menu2_6 initTitleAndImg:@"邮件快递" imgName:@"menu2_6"];
    [self.menu2_7 initTitleAndImg:@"预约服务" imgName:@"menu2_7"];
    [self.menu2_8 initTitleAndImg:@"小区活动" imgName:@"menu2_8"];
    [self.menu2_9 initTitleAndImg:@"房屋租售" imgName:@"menu2_9"];
    
    [self.menu3_1 initTitleAndImg:@"万达影院" imgName:@"menu3_1"];
    [self.menu3_2 initTitleAndImg:@"赶集网" imgName:@"menu3_2"];
    [self.menu3_3 initTitleAndImg:@"淘宝" imgName:@"menu3_3"];
    [self.menu3_4 initTitleAndImg:@"京东" imgName:@"menu3_4"];
    [self.menu3_5 initTitleAndImg:@"泉州天气" imgName:@"menu3_5"];
    [self.menu3_6 initTitleAndImg:@"携程" imgName:@"menu3_6"];
    [self.menu3_7 initTitleAndImg:@"搜房网" imgName:@"menu3_7"];
    [self.menu3_8 initTitleAndImg:@"添加更多.." imgName:@"menu3_8"];
}



- (IBAction)btnMenuClick:(id)sender {
    //[self addOverlay:sender];
    if (self.viewMenuContainer.alpha<0.1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.viewMenuContainer.alpha=1.0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.viewMenuContainer.alpha=0.0;
        }];
    }
}

- (IBAction)menu1Click:(id)sender {
    if ([sender isEqual:self.menu1_11])
    {
        VideoMainViewController *controller =  [self.storyboard instantiateViewControllerWithIdentifier:@"VideoMainViewController"];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    else if ([sender isEqual:self.menu1_2])
    {
        LightViewController *controller =  [self.storyboard instantiateViewControllerWithIdentifier:@"LightViewController"];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    else
    {
        [Dialog showProgress:self withLabel:@"正在加载数据.."];
        [UIView animateWithDuration:0.3 animations:^{
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2 animations:^{
            } completion:^(BOOL finished) {
                [Dialog hideProgress];
                [Dialog alert:@"数据加载失败，请稍后再试!"];
            }];
        }];
    }
}

- (IBAction)btnSheQuClick:(id)sender {
    //[self addOverlay:sender];
    self.lbTitle.text=@"智慧社区";
    self.viewShangQuan.alpha=0.0;
    self.viewJiaTing.alpha=0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSheQu.alpha=1.0;
    } completion:^(BOOL finished) {
        self.viewMenuContainer.alpha=0.0;
    }];
}

- (IBAction)btnShangQuanClick:(id)sender {
    //[self addOverlay:sender];
    self.lbTitle.text=@"智慧商圈";
    self.viewSheQu.alpha=0.0;
    self.viewJiaTing.alpha=0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewShangQuan.alpha=1.0;
    } completion:^(BOOL finished) {
        self.viewMenuContainer.alpha=0.0;
    }];
    
}

- (IBAction)btnJiaTingClick:(id)sender {
    //[self addOverlay:sender];
    self.lbTitle.text=@"智慧家庭";
    self.viewShangQuan.alpha=0.0;
    self.viewSheQu.alpha=0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewJiaTing.alpha=1.0;
    } completion:^(BOOL finished) {
        self.viewMenuContainer.alpha=0.0;
    }];
}

- (IBAction)btnOnTouch:(id)sender {
    [self addOverlay:sender];
}

-(void)addOverlay:(id)sender
{
    UIButton *mBtn=(UIButton*)sender;
    UIView *mOverlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, mBtn.frame.size.width, mBtn.frame.size.height)];
    mOverlayView.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
    [mBtn addSubview:mOverlayView];
    [UIView animateWithDuration:0.05 animations:^{
        mOverlayView.alpha=0;
    } completion:^(BOOL finished) {
        [mOverlayView removeFromSuperview];
    }];
}

@end
