//
//  ScreenPictureTableViewCell.m
//  intelligent
//
//  Created by chliam on 16/1/6.
//  Copyright © 2016年 chliam. All rights reserved.
//

#import "ScreenPictureTableViewCell.h"
#import "Define.h"

@implementation ScreenPictureTableViewCell

-(void)awakeFromNib{
    [self.btnAdd setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    self.btnAdd.layer.cornerRadius = 14.0;
    self.btnAdd.layer.borderColor = MAIN_COLOR.CGColor;
    self.btnAdd.layer.borderWidth = 1.0;
    self.btnAdd.layer.masksToBounds = YES;
    [self.btnReduce setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    self.btnReduce.layer.cornerRadius = 14.0;
    self.btnReduce.layer.borderColor = MAIN_COLOR.CGColor;
    self.btnReduce.layer.borderWidth = 1.0;
    self.btnReduce.layer.masksToBounds = YES;
}

@end
