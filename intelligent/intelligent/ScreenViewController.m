//
//  ScreenViewController.m
//  intelligent
//
//  Created by chliam on 16/1/5.
//  Copyright © 2016年 chliam. All rights reserved.
//

#import "ScreenViewController.h"
#import "ScreenCollectionViewCell.h"
#import "ScreenMenuCollectionViewCell.h"
#import "Define.h"

#define ARRAY_SCREEN_MENU @[@"开机",@"关机",@"单屏",@"拼接",@"输入",@"图像",@"预案",@"界面"]


@implementation ScreenViewController
{
    int mScreenColNum;
    int mScreenRowNum;
    int mSelectColStart;
    int mSelectColEnd;
    int mSelectRowStart;
    int mSelectRowEnd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: Cache
    mScreenColNum = 4;
    mScreenRowNum = 5;
    mSelectColStart = 0;
    mSelectRowStart = 0;
    mSelectColEnd = 0;
    mSelectRowEnd = 0;
}

- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (IBAction)btnScreenClick:(UIButton*)sender {
    int col = (int)floor(sender.tag/1000);
    int row = sender.tag%100;
    if (mSelectRowEnd == mSelectRowStart && mSelectColEnd == mSelectColStart) {
        col > mSelectColStart ? (mSelectColEnd = col) : (mSelectColStart = col);
        row > mSelectRowStart ? (mSelectRowEnd = row) : (mSelectRowStart = row);
    }else{
        mSelectColStart =col;
        mSelectColEnd = col;
        mSelectRowStart = row;
        mSelectRowEnd = row;
    }
    
    for (int col=0; col<mScreenRowNum; col++) {
        for (int row=0; row<mScreenColNum; row++) {
            ScreenCollectionViewCell *cell = (ScreenCollectionViewCell*)[self.colScreen cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:col]];
            [self updateScreenCollectionViewCell:cell row:row col:col];
        }
    }
}

- (IBAction)btnMenuClick:(UIButton*)sender {
    if (sender.tag == 7) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  20, 304, 216)];
        picker.delegate = self;
        picker.tag = sender.tag;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"界面设置" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            mScreenRowNum = (int)[picker selectedRowInComponent:0]+1;
            mScreenColNum = (int)[picker selectedRowInComponent:2]+1;
            mSelectColStart = 0;
            mSelectRowStart = 0;
            mSelectColEnd = 0;
            mSelectRowEnd = 0;
            [self.colScreen reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alertController.view addSubview:picker];
        [alertController addAction:ok];
        [alertController addAction:cancel];
        
        /*
         * Support only iphone
         *
         [self presentViewController:alertController animated:YES completion:^{
         [picker selectRow:mScreenRowNum-1 inComponent:0 animated:NO];
         [picker selectRow:mScreenColNum-1 inComponent:1 animated:NO];
         }];
         */
        
        [picker selectRow:mScreenRowNum-1 inComponent:0 animated:NO];
        [picker selectRow:mScreenColNum-1 inComponent:2 animated:NO];
        UIPopoverPresentationController *alertPopoverPresentationController = alertController.popoverPresentationController;
        UIButton *imagePickerButton = (UIButton*)sender;
        alertPopoverPresentationController.sourceRect = imagePickerButton.frame;
        alertPopoverPresentationController.sourceView = sender;
        
        [self showDetailViewController:alertController sender:sender];
    }
}

#pragma mark
#pragma mark UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:self.colScreen]) {
        return mScreenRowNum;
    }else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.colScreen]) {
        return mScreenColNum;
    }else {
        return [ARRAY_SCREEN_MENU count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.colScreen]){
        ScreenCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScreenCollectionViewCell" forIndexPath:indexPath];
        [cell.btnScreen setTitle:[NSString stringWithFormat:@"%d:%d",(int)indexPath.section+1,(int)indexPath.row+1] forState:UIControlStateNormal];
        [cell.btnScreen setTag:indexPath.section * 1000+indexPath.row];
        [cell.btnScreen addTarget:self action:@selector(btnScreenClick:) forControlEvents:UIControlEventTouchUpInside];
        [self updateScreenCollectionViewCell:cell row:(int)indexPath.row col:(int)indexPath.section];
        return cell;
    }else{
        ScreenMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScreenMenuCollectionViewCell" forIndexPath:indexPath];
        [cell.btnMenu setTitle:[ARRAY_SCREEN_MENU objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [cell.btnMenu setTag:indexPath.row];
        [cell.btnMenu addTarget:self action:@selector(btnMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 80;
    CGFloat height = 80;
    if ([collectionView isEqual:self.colScreen]) {
        width = collectionView.frame.size.width / mScreenColNum - 2;
        height = collectionView.frame.size.height / mScreenRowNum - 2;
    }else {
        width = collectionView.frame.size.width / [ARRAY_SCREEN_MENU count] -10;
        height = collectionView.frame.size.height - 2;
    }
    return CGSizeMake(width, height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.colScreen]) {
        return UIEdgeInsetsMake(1, 1, 1, 1);
    }else {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
}


#pragma mark - UIPickerView Delegate method
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 7) {
        return 3;
    }
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 7) {
        if (component == 1) {
            return 1;
        }
        return 15;
    }
    return 1;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    if (pickerView.tag == 7) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%d",(int)row+1];
            label.textAlignment = NSTextAlignmentRight;
        } else if (component == 1) {
            label.text = @"X";
            label.textAlignment = NSTextAlignmentCenter;
        } else if (component == 2) {
            label.text = [NSString stringWithFormat:@"%d",(int)row+1];
            label.textAlignment = NSTextAlignmentLeft;
        }
        
    }
    return label;
}

#pragma mark - private func
-(void)updateScreenCollectionViewCell:(ScreenCollectionViewCell*)cell row:(int)row col:(int)col{
    if (cell) {
        if (row >= mSelectRowStart && row <= mSelectRowEnd && col >= mSelectColStart && col <= mSelectColEnd)
        {
            cell.btnScreen.backgroundColor = [UIColor blueColor];
            [cell.btnScreen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            cell.btnScreen.backgroundColor = [UIColor grayColor];
            [cell.btnScreen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

@end
