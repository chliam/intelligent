//
//  ScreenPictureTableViewCell.h
//  intelligent
//
//  Created by chliam on 16/1/6.
//  Copyright © 2016年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenPictureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnReduce;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *lbSpliter;

@end
