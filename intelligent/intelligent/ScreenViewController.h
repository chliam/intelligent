//
//  ScreenViewController.h
//  intelligent
//
//  Created by chliam on 16/1/5.
//  Copyright © 2016年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *colScreen;
@property (weak, nonatomic) IBOutlet UICollectionView *colMenu;

@property (weak, nonatomic) IBOutlet UIView *viewSettingContainer;
@property (weak, nonatomic) IBOutlet UIView *viewSetting;
@property (weak, nonatomic) IBOutlet UILabel *lbSettingTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbServerURL;
@property (weak, nonatomic) IBOutlet UITextField *txtServerURL;
@property (weak, nonatomic) IBOutlet UILabel *lbServerPort;
@property (weak, nonatomic) IBOutlet UITextField *txtServerPort;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelSetting;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnSettingClick:(id)sender;
- (IBAction)btnSaveSettingClick:(id)sender;
- (IBAction)btnCancelSettingClick:(id)sender;

@end
