//
//  VideoMainViewController.h
//  intelligent
//
//  Created by chliam on 15/11/17.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewPlayer;

@property (weak, nonatomic) IBOutlet UITableView *tableDevice;


- (IBAction)btnBackClick:(id)sender;

@end
