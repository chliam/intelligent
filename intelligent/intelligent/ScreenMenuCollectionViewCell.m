//
//  ScreenMenuCollectionViewCell.m
//  intelligent
//
//  Created by chliam on 16/1/5.
//  Copyright © 2016年 chliam. All rights reserved.
//

#import "ScreenMenuCollectionViewCell.h"
#import "Define.h"

@implementation ScreenMenuCollectionViewCell

-(void)awakeFromNib{
    self.btnMenu.backgroundColor = MAIN_COLOR;
    self.btnMenu.layer.cornerRadius = 32.0;
    self.btnMenu.layer.masksToBounds = YES;
}

@end
