//
//  VideoMainViewController.h
//  intelligent
//
//  Created by chliam on 15/11/17.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
#import <qysdk/QYType.h>
#import <qysdk/QYView.h>

@interface VideoMainViewController : UIViewController<QYViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewDeviceContainer;
@property (weak, nonatomic) IBOutlet UIView *viewPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tableDevice;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceContainerCollspe;

@property (weak, nonatomic) IBOutlet UIView *viewSettingContainer;
@property (weak, nonatomic) IBOutlet UIView *viewSetting;
@property (weak, nonatomic) IBOutlet UILabel *lbSettingTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbURL;
@property (weak, nonatomic) IBOutlet UITextField *txtURL;
@property (weak, nonatomic) IBOutlet UILabel *lbAppid;
@property (weak, nonatomic) IBOutlet UITextField *txtAppid;
@property (weak, nonatomic) IBOutlet UILabel *lbAuth;
@property (weak, nonatomic) IBOutlet UITextField *txtAuth;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelSetting;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnSetingClick:(id)sender;
- (IBAction)btnCllospeClick:(id)sender;
- (IBAction)btnExpandClick:(id)sender;

- (IBAction)btnSaveSettingClick:(id)sender;
- (IBAction)btnCancelSettingClick:(id)sender;
- (IBAction)txtBeginEditing:(id)sender;
- (IBAction)txtEndEditing:(id)sender;

@end
