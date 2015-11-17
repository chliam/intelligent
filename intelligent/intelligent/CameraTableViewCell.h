//
//  CameraTableViewCell.h
//  intelligent
//
//  Created by chliam on 15/11/17.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

@interface CameraTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

@property (strong, nonatomic) IBOutlet DeviceModel *Device;

@end
