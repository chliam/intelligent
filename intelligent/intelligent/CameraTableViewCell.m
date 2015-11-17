//
//  CameraTableViewCell.m
//  intelligent
//
//  Created by chliam on 15/11/17.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import "CameraTableViewCell.h"

@implementation CameraTableViewCell
{
    DeviceModel *_device;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(DeviceModel*)Device{
    return _device;
}

-(void)setDevice:(DeviceModel *)Device{
    _device=Device;
    self.lbName.text = [NSString stringWithFormat:@"%lld",_device.device_id];
    if (!_device.status) {
        self.lbStatus.text=@"在线";
        self.lbStatus.textColor=[UIColor whiteColor];
        self.lbName.textColor=[UIColor whiteColor];
    }else
    {
        self.lbStatus.text=@"离线";
        self.lbStatus.textColor=[UIColor grayColor];
        self.lbName.textColor=[UIColor grayColor];
    }
}

@end
