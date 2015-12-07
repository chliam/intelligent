//
//  LightViewController.h
//  intelligent
//
//  Created by chliam on 15/11/26.
//  Copyright © 2015年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"

@interface LightViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *svgContainer;

@property (weak, nonatomic) IBOutlet UIView *viewSettingContainer;
@property (weak, nonatomic) IBOutlet UIView *viewSetting;
@property (weak, nonatomic) IBOutlet UILabel *lbSettingTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbServerURL;
@property (weak, nonatomic) IBOutlet UITextField *txtServerURL;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelSetting;


- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnSettingClick:(id)sender;
- (IBAction)btnSaveSettingClick:(id)sender;
- (IBAction)btnCancelSettingClick:(id)sender;

- (IBAction)txtServerURLBeginEditing:(id)sender;
- (IBAction)txtServerURLEndEditing:(id)sender;


@end
