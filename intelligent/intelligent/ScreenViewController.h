//
//  ScreenViewController.h
//  intelligent
//
//  Created by chliam on 16/1/5.
//  Copyright © 2016年 chliam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

- (IBAction)btnBackClick:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *colScreen;
@property (weak, nonatomic) IBOutlet UICollectionView *colMenu;

@end
