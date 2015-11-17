//
//  VideoMainViewController.m
//  intelligent
//
//  Created by chliam on 15/11/17.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "VideoMainViewController.h"
#import "mindnet/MindNet.h"
#import "DeviceModel.h"
#import <qysdk/QYType.h>
#import "CameraTableViewCell.h"

@interface VideoMainViewController ()
{
    NSMutableArray* deviceArray;
}

@end

@implementation VideoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

-(void) getDeviceList
{
    
    [[MindNet sharedManager] getDeviceSuccess:^(NSArray *ret) {
        deviceArray=[NSMutableArray array];
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
                                               [self.tableDevice reloadData];
                                           } ];
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


@end
