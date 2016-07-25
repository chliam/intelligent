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
#import "Dialog.h"
#import "Define.h"
#import "Data.h"

@interface VideoMainViewController ()
{
    NSMutableArray* deviceArray;
    QYView* video;
    QYView* talk;
    QYView* replay;
    CGRect deviceViewShowFrame;
    CGRect deviceViewHideFrame;
    CGRect playerViewOriFrame;
    CGRect playerViewFullFrame;
    DeviceModel *currenDevice;
    
    CGRect viewSettingOriFrame;
    CGRect viewSettingEditFrame;
}

@end

@implementation VideoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbSettingTitle.backgroundColor = MAIN_COLOR;
    self.lbURL.textColor = MAIN_COLOR;
    self.txtURL.layer.borderWidth = 1.0;
    self.txtURL.layer.borderColor = MAIN_COLOR.CGColor;
    self.lbAppid.textColor = MAIN_COLOR;
    self.txtAppid.layer.borderWidth = 1.0;
    self.txtAppid.layer.borderColor = MAIN_COLOR.CGColor;
    self.lbAuth.textColor = MAIN_COLOR;
    self.txtAuth.layer.borderWidth = 1.0;
    self.txtAuth.layer.borderColor = MAIN_COLOR.CGColor;
    [self.btnSaveSetting setBackgroundColor:MAIN_COLOR];
    [self.btnCancelSetting setBackgroundColor:MAIN_COLOR];
    viewSettingOriFrame = self.viewSetting.frame;
    viewSettingEditFrame = CGRectMake(viewSettingOriFrame.origin.x, viewSettingOriFrame.origin.y-66, viewSettingOriFrame.size.width, viewSettingOriFrame.size.height);
    self.txtURL.text = [Data instance].cameraServerURL;
    self.txtAppid.text = [Data instance].cameraServerAppid;
    self.txtAuth.text = [Data instance].cameraServerAuth;
    
    deviceViewShowFrame = self.viewDeviceContainer.frame;
    deviceViewHideFrame = CGRectMake(deviceViewShowFrame.origin.x+deviceViewShowFrame.size.width, deviceViewShowFrame.origin.y, deviceViewShowFrame.size.width, deviceViewShowFrame.size.height);
    playerViewOriFrame = self.viewPlayer.frame;
    playerViewFullFrame = CGRectMake(playerViewOriFrame.origin.x, playerViewOriFrame.origin.y, playerViewOriFrame.size.width+deviceViewShowFrame.size.width, playerViewOriFrame.size.height);
    
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress1.minimumPressDuration = 0.3; //定义按的时间
    [self.btnLeft addGestureRecognizer:longPress1];
    
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress2.minimumPressDuration = 0.3; //定义按的时间
    [self.btnRight addGestureRecognizer:longPress2];
    
    UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress3.minimumPressDuration = 0.3; //定义按的时间
    [self.btnUp addGestureRecognizer:longPress3];
    
    UILongPressGestureRecognizer *longPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress4.minimumPressDuration = 0.3; //定义按的时间
    [self.btnDown addGestureRecognizer:longPress4];
    
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeCollapseDeviceView:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.viewDeviceContainer addGestureRecognizer:recognizer];
    
    [Dialog showProgress:self withLabel:@"正在查询设备.."];
    self.viewDeviceContainer.hidden = YES;
    [[MindNet sharedManager] loginSession:^(int32_t ret) {
        if(ret==0)
        {
            [self getDeviceList];
        }
        else
        {
            self.viewDeviceContainer.hidden = NO;
            [Dialog hideProgress];
            [Dialog alert:@"查询设备失败!"];
        }
    }];
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
    [self connectDevice];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (video) {
        [video Release];
        video = nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)appHasGoneInBackround:(UIApplication *)application
{
    if (video) {
        [video Release];
        video = nil;
    }
}

- (void)appHasGoneInForeground:(UIApplication *)application
{
    [[MindNet sharedManager] loginSession:^(int32_t ret) {
        if(ret==0)
        {
            [self connectDevice];
        }
        
    }];
}

- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)btnSetingClick:(id)sender {
    self.viewSettingContainer.alpha = 0;
    self.viewSettingContainer.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSettingContainer.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (IBAction)btnCllospeClick:(id)sender {
    [self collapseDeviceView];
}

- (IBAction)btnExpandClick:(id)sender {
    [self expandDeviceView];
}

- (IBAction)btnSaveSettingClick:(id)sender {
    [self.txtURL resignFirstResponder];
    if (self.txtURL.text.length<1) {
        [Dialog alert:@"URL不能为空！"];
    }
    else if (self.txtAppid.text.length<1) {
        [Dialog alert:@"APPID不能为空！"];
    }
    else if (self.txtAuth.text.length<1) {
        [Dialog alert:@"AUTH不能为空！"];
    }
    else
    {
        [Data instance].cameraServerURL = self.txtURL.text;
        [Data instance].cameraServerAppid = self.txtAppid.text;
        [Data instance].cameraServerAuth = self.txtAuth.text;
        [UIView animateWithDuration:0.3 animations:^{
            self.viewSettingContainer.alpha = 0;
        } completion:^(BOOL finished) {
            self.viewSettingContainer.hidden = YES;
        }];
        if (video) {
            [video Release];
            video = nil;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
           
            [Dialog showProgress:self withLabel:@"正在查询设备.."];
            [[MindNet sharedManager] loginSession:^(int32_t ret) {
                if(ret==0)
                {
                    [self getDeviceList];
                }
                else
                {
                    [Dialog hideProgress];
                    [Dialog alert:@"查询设备失败!"];
                    deviceArray = [NSMutableArray new];
                    [self.tableDevice reloadData];
                }
            }];
        });
    }

}

- (IBAction)btnCancelSettingClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSettingContainer.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewSettingContainer.hidden = YES;
    }];
}

- (IBAction)txtBeginEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSetting.frame = viewSettingEditFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)txtEndEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSetting.frame = viewSettingOriFrame;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) getDeviceList
{
    
    [[MindNet sharedManager] getDeviceSuccess:^(NSArray *ret) {
        deviceArray=[NSMutableArray array];
        if (ret.count>0)
        {
            for(int i=0; i<ret.count; i++)
            {
                QY_DEVICE_INFO deviceinfo;
                NSValue* valueObj =[ret objectAtIndex:i];
                [valueObj getValue:&deviceinfo];
                DeviceModel * device =[DeviceModel new];
                device.device_id=deviceinfo.deviceID;
                device.status=deviceinfo.status;
                [[MindNet sharedManager]getChanelwithDevid:device
                                               withsuccess:^(NSArray *retChanel) {
                                                   QY_CHANNEL_INFO chanel;
                                                   for(NSValue* valueObj in retChanel)
                                                   {
                                                       [valueObj getValue:&chanel];
                                                       
                                                       DeviceModel * chanleDevice =[DeviceModel new];
                                                       chanleDevice.device_id=chanel.channelID;
                                                       chanleDevice.status=chanel.status;
                                                       [deviceArray addObject:chanleDevice];
                                                   }
                                                   if (i==ret.count-1) {
                                                       [self.tableDevice reloadData];
                                                       self.viewDeviceContainer.hidden = NO;
                                                       [Dialog hideProgress];
                                                   }
                                               } ];
            }
        }
        else
        {
            [self.tableDevice reloadData];
            self.viewDeviceContainer.hidden = NO;
            [Dialog hideProgress];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (deviceArray) {
        return  deviceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CameraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CameraTableViewCellIdentifier"];
    if(!cell){
        cell =[[CameraTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CameraTableViewCellIdentifier"];
    }
    [cell setDevice:[deviceArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currenDevice=deviceArray[indexPath.row];
    [self connectDevice];
}


-(void)handleSwipeCollapseDeviceView:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [self collapseDeviceView];
    }
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if([[gestureRecognizer view] isEqual:self.btnLeft])
        {
            [video CtrlPtz:0 action:QY_MOVE_LEFT callBack:^(int32_t ret) {
                
            }];
        }
        else if([[gestureRecognizer view] isEqual:self.btnRight])
        {
            [video CtrlPtz:0 action:QY_MOVE_RIGHT callBack:^(int32_t ret) {
                
            }];
        }
        else if([[gestureRecognizer view] isEqual:self.btnDown])
        {
            [video CtrlPtz:0 action:QY_MOVE_DOWN callBack:^(int32_t ret) {
                
            }];
        }
        else if([[gestureRecognizer view] isEqual:self.btnUp])
        {
            [video CtrlPtz:0 action:QY_MOVE_UP callBack:^(int32_t ret) {
                
            }];
        }
    }
    else if([gestureRecognizer state]==UIGestureRecognizerStateEnded)
    {
        
        if([[gestureRecognizer view] isKindOfClass:[UIButton class]])
        {
            [video CtrlPtz:0 action:QY_STOP callBack:^(int32_t ret) {
                
            }];
            [(UIButton*)[gestureRecognizer view] setSelected:false];
        }
    }
}

-(void)connectDevice{
    if(currenDevice && currenDevice.status)
    {
        if(video){
            [video Release];
            video = nil;
        }
        [Dialog showProgress:self withLabel:@"正在连接.."];
        [[MindNet sharedManager] createVideoView:currenDevice.device_id callback:^(int32_t ret, QYView *view) {
            [Dialog hideProgress];
            if(ret==0)
            {
                video=view;
                [video SetEventDelegate:self];
                [video SetCanvas:self.viewPlayer];
            }
            else
            {
                [Dialog alert:@"连接失败!"];
            }
        }];
    }
}

-(void)expandDeviceView{
    self.viewDeviceContainerCollspe.hidden = YES;
    self.viewDeviceContainer.hidden = NO;
    [UIView animateWithDuration:0.6 animations:^{
        self.viewDeviceContainer.frame = deviceViewShowFrame;
    } completion:^(BOOL finished) {
        self.viewPlayer.frame = playerViewOriFrame;
    }];
}

-(void)collapseDeviceView{
    [UIView animateWithDuration:0.6 animations:^{
        self.viewDeviceContainer.frame = deviceViewHideFrame;
    } completion:^(BOOL finished) {
        self.viewDeviceContainerCollspe.hidden = NO;
        self.viewDeviceContainer.hidden = YES;
        self.viewPlayer.frame = playerViewFullFrame;
    }];
}

@end
