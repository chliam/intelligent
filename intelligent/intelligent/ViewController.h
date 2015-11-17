//
//  ViewController.h
//  intelligent
//
//  Created by chliam on 15/4/23.
//  Copyright (c) 2015年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuButtion.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewMenuContainer;
@property (weak, nonatomic) IBOutlet UIView *viewJiaTing;
@property (weak, nonatomic) IBOutlet UIView *viewSheQu;
@property (weak, nonatomic) IBOutlet UIView *viewShangQuan;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnSheQu;
@property (weak, nonatomic) IBOutlet UIButton *btnShangQuan;
@property (weak, nonatomic) IBOutlet UIButton *btnJiaTing;

@property (weak, nonatomic) IBOutlet MenuButtion *menu1_1;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_2;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_3;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_4;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_5;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_6;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_7;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_8;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_9;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_10;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_11;
@property (weak, nonatomic) IBOutlet MenuButtion *menu1_12;

@property (weak, nonatomic) IBOutlet MenuButtion *menu2_1;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_2;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_3;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_4;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_5;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_6;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_7;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_8;
@property (weak, nonatomic) IBOutlet MenuButtion *menu2_9;

@property (weak, nonatomic) IBOutlet MenuButtion *menu3_1;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_2;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_3;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_4;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_5;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_6;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_7;
@property (weak, nonatomic) IBOutlet MenuButtion *menu3_8;


@property (weak, nonatomic) IBOutlet UIView *viewWaitContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitIndicator;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;


- (IBAction)btnMenuClick:(id)sender;

- (IBAction)menu1Click:(id)sender;

- (IBAction)btnSheQuClick:(id)sender;
- (IBAction)btnShangQuanClick:(id)sender;
- (IBAction)btnJiaTingClick:(id)sender;

- (IBAction)btnOnTouch:(id)sender;


@end

