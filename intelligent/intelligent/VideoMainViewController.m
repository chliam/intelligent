//
//  VideoMainViewController.m
//  intelligent
//
//  Created by chliam on 15/11/17.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "VideoMainViewController.h"
#import "mindnet/MindNet.h"
#import "CameraTableViewCell.h"

@interface VideoMainViewController ()
{
    NSMutableArray* deviceArray;
    QYView* video;
    QYView* talk;
    QYView* replay;
}

@end

@implementation VideoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewWaitContainer.alpha=0.9;
    self.waitLabel.text=@"正在查询设备..";
    [self.waitIndicator startAnimating];
    self.viewDeviceContainer.hidden = YES;
    if(![[MindNet sharedManager] hasLogin])
    {
        [[MindNet sharedManager] loginSession:^(int32_t ret) {
            if(ret==0)
            {
                [self getDeviceList];
            }
        }];
    }
    else
    {
        [self getDeviceList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)btnUpClick:(id)sender {
    if (video) {
        [video CtrlPtz:0 action:QY_MOVE_UP callBack:^(int32_t ret) { }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            [video CtrlPtz:0 action:QY_STOP callBack:^(int32_t ret) { }];
        });
    }
}

- (IBAction)btnLeftClick:(id)sender {
    if (video) {
        [video CtrlPtz:0 action:QY_MOVE_LEFT callBack:^(int32_t ret) { }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            [video CtrlPtz:0 action:QY_STOP callBack:^(int32_t ret) { }];
        });
    }
}

- (IBAction)btnDownClick:(id)sender {
    if (video) {
        [video CtrlPtz:0 action:QY_MOVE_DOWN callBack:^(int32_t ret) { }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            [video CtrlPtz:0 action:QY_STOP callBack:^(int32_t ret) { }];
        });
    }
}

- (IBAction)btnRightClick:(id)sender {
    if (video) {
        [video CtrlPtz:0 action:QY_MOVE_RIGHT callBack:^(int32_t ret) { }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            [video CtrlPtz:0 action:QY_STOP callBack:^(int32_t ret) { }];
        });
    }
}

-(void) getDeviceList
{
    
    [[MindNet sharedManager] getDeviceSuccess:^(NSArray *ret) {
        deviceArray=[NSMutableArray array];
        if (ret.count>0) {
            for(int i=0; i<ret.count; i++)
            {
                QY_DEVICE_INFO deviceinfo;
                NSValue* valueObj =[ret objectAtIndex:i];
                [valueObj getValue:&deviceinfo];
                DeviceModel * device =[DeviceModel new];
                device.device_id=deviceinfo.deviceID;
                device.status=deviceinfo.status;
                //device.subDeviceList=[NSMutableArray array];
                //[deviceArray addObject:device];
                [[MindNet sharedManager]getChanelwithDevid:device
                                               withsuccess:^(NSArray *ret) {
                                                   QY_CHANNEL_INFO chanel;
                                                   for(NSValue* valueObj in ret)
                                                   {
                                                       [valueObj getValue:&chanel];
                                                       
                                                       DeviceModel * chanleDevice =[DeviceModel new];
                                                       chanleDevice.device_id=chanel.channelID;
                                                       chanleDevice.status=chanel.status;
                                                       [deviceArray addObject:chanleDevice];
                                                   }
                                                   if (i==ret.count-1) {
                                                       [self.tableDevice reloadData];
                                                       [self.waitIndicator stopAnimating];
                                                       self.viewWaitContainer.alpha=0;
                                                       self.viewDeviceContainer.hidden = NO;
                                                   }
                                               } ];
            }
        }else{
            [self.waitIndicator stopAnimating];
            self.viewWaitContainer.alpha=0;
            self.viewDeviceContainer.hidden = NO;
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (deviceArray) {
        return  3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CameraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CameraTableViewCellIdentifier"];
    if(!cell){
        cell =[[CameraTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CameraTableViewCellIdentifier"];
    }
    [cell setDevice:[deviceArray objectAtIndex:0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceModel *device=deviceArray[indexPath.section];
    
    if(device && device.status)
    {
        self.viewWaitContainer.alpha=0.9;
        self.waitLabel.text=@"正在连接..";
        [self.waitIndicator startAnimating];
        [[MindNet sharedManager] createVideoView:device.device_id callback:^(int32_t ret, QYView *view) {
            if(ret==0)
            {
                video=view;
                [video SetEventDelegate:self];
                [video SetCanvas:self.viewPlayer];
            }
            [self.waitIndicator stopAnimating];
            self.viewWaitContainer.alpha=0;
        }];
    }
}


@end
