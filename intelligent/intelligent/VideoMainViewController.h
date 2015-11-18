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
@property (weak, nonatomic) IBOutlet UIView *viewWaitContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitIndicator;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;

//@property (weak, nonatomic) IBOutlet UIButton *btnUp;
//@property (weak, nonatomic) IBOutlet UIButton *btnUp;
//@property (weak, nonatomic) IBOutlet UIButton *btnUp;
//@property (weak, nonatomic) IBOutlet UIButton *btnUp;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnUpClick:(id)sender;
- (IBAction)btnLeftClick:(id)sender;
- (IBAction)btnDownClick:(id)sender;
- (IBAction)btnRightClick:(id)sender;

@end
