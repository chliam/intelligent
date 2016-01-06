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
#import "ScreenPictureTableViewCell.h"
#import "Data.h"
#import "Dialog.h"

#define ARRAY_SCREEN_MENU @[@"开机",@"关机",@"单屏",@"拼接",@"输入",@"图像",@"预案",@"界面"]

@implementation ScreenViewController
{
//    NSString *mCurrentInput;
//    NSString *mCurrentPlan;
//    int mScreenColNum;
//    int mScreenRowNum;
    int mSelectColStart;
    int mSelectColEnd;
    int mSelectRowStart;
    int mSelectRowEnd;
    
    CGRect viewSettingOriFrame;
    CGRect viewSettingEditFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbSettingTitle.backgroundColor = MAIN_COLOR;
    self.lbServerURL.textColor = MAIN_COLOR;
    self.txtServerURL.layer.borderWidth = 1.0;
    self.txtServerURL.layer.borderColor = MAIN_COLOR.CGColor;
    self.lbServerPort.textColor = MAIN_COLOR;
    self.txtServerPort.layer.borderWidth = 1.0;
    self.txtServerPort.layer.borderColor = MAIN_COLOR.CGColor;
    [self.btnSaveSetting setBackgroundColor:MAIN_COLOR];
    [self.btnCancelSetting setBackgroundColor:MAIN_COLOR];
    viewSettingOriFrame = self.viewSetting.frame;
    viewSettingEditFrame = CGRectMake(viewSettingOriFrame.origin.x, viewSettingOriFrame.origin.y-60, viewSettingOriFrame.size.width, viewSettingOriFrame.size.height);
    self.txtServerURL.delegate = self;
    self.txtServerPort.delegate = self;
    [self.txtServerURL addTarget:self action:@selector(txtBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self.txtServerURL addTarget:self action:@selector(txtEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [self.txtServerPort addTarget:self action:@selector(txtBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self.txtServerPort addTarget:self action:@selector(txtEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    self.txtServerURL.text = [Data instance].screenServerURL;
    self.txtServerPort.text = [Data instance].screenServerPort;
    
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
    
    for (int col=0; col<[Data instance].screenRowNum; col++) {
        for (int row=0; row<[Data instance].screenColNum; row++) {
            ScreenCollectionViewCell *cell = (ScreenCollectionViewCell*)[self.colScreen cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:col]];
            [self updateScreenCollectionViewCell:cell row:row col:col];
        }
    }
}

- (IBAction)btnSettingClick:(id)sender {
    self.viewSettingContainer.alpha = 0;
    self.viewSettingContainer.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSettingContainer.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnSaveSettingClick:(id)sender {    
    [self.txtServerURL resignFirstResponder];
    if (self.txtServerURL.text.length<1) {
        [Dialog alert:@"主机地址不能为空！"];
    }
    else if (self.txtServerPort.text.length<1) {
        [Dialog alert:@"主机端口不能为空！"];
    }
    else
    {
        [Data instance].screenServerURL = self.txtServerURL.text;
        [Data instance].screenServerPort = self.txtServerPort.text;
        [UIView animateWithDuration:0.3 animations:^{
            self.viewSettingContainer.alpha = 0;
        } completion:^(BOOL finished) {
            self.viewSettingContainer.hidden = YES;
        }];
    }
}

- (IBAction)btnCancelSettingClick:(id)sender {
    [self.txtServerURL resignFirstResponder];
    [self.txtServerPort resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSettingContainer.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewSettingContainer.hidden = YES;
    }];
    
}

- (IBAction)txtBeginEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSetting.frame = viewSettingEditFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)txtEndEditing:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSetting.frame = viewSettingOriFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnMenuClick:(UIButton*)sender {
    if (sender.tag == 4) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  20, 304, 216)];
        picker.delegate = self;
        picker.tag = sender.tag;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入设置" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Data instance].screenInput = [ARRAY_SOURCE_INPUT objectAtIndex:[picker selectedRowInComponent:0]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alertController.view addSubview:picker];
        [alertController addAction:ok];
        [alertController addAction:cancel];
        [picker selectRow:[ARRAY_SOURCE_INPUT indexOfObject:[Data instance].screenInput] inComponent:0 animated:NO];
        UIPopoverPresentationController *alertPopoverPresentationController = alertController.popoverPresentationController;
        alertPopoverPresentationController.sourceRect = CGRectMake(sender.frame.origin.x-22, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
        alertPopoverPresentationController.sourceView = sender;
        [self showDetailViewController:alertController sender:sender];
    }
    else if (sender.tag == 5){
        UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, 304, 320)];
        table1.delegate = self;
        table1.dataSource = self;
        table1.tag = sender.tag;
        table1.allowsSelection = NO;
        table1.separatorStyle = UITableViewCellSeparatorStyleNone;
        table1.backgroundColor = [UIColor clearColor];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"图像设置" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alertController.view addSubview:table1];
        [alertController addAction:cancel];
        UIPopoverPresentationController *alertPopoverPresentationController = alertController.popoverPresentationController;
        alertPopoverPresentationController.sourceRect = CGRectMake(sender.frame.origin.x-22, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
        alertPopoverPresentationController.sourceView = sender;
        [self showDetailViewController:alertController sender:sender];
    }
    else if (sender.tag == 6) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  20, 304, 216)];
        picker.delegate = self;
        picker.tag = sender.tag;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"预案设置" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Data instance].screenPlan = [ARRAY_PLAN objectAtIndex:[picker selectedRowInComponent:0]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alertController.view addSubview:picker];
        [alertController addAction:ok];
        [alertController addAction:cancel];
        [picker selectRow:[ARRAY_PLAN indexOfObject:[Data instance].screenPlan] inComponent:0 animated:NO];
        UIPopoverPresentationController *alertPopoverPresentationController = alertController.popoverPresentationController;
        alertPopoverPresentationController.sourceRect = CGRectMake(sender.frame.origin.x-22, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
        alertPopoverPresentationController.sourceView = sender;
        [self showDetailViewController:alertController sender:sender];
    }
    else if (sender.tag == 7) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  20, 304, 216)];
        picker.delegate = self;
        picker.tag = sender.tag;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"界面设置" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Data instance].screenRowNum = (int)[picker selectedRowInComponent:0]+1;
            [Data instance].screenColNum = (int)[picker selectedRowInComponent:2]+1;
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
        
        [picker selectRow:[Data instance].screenRowNum-1 inComponent:0 animated:NO];
        [picker selectRow:[Data instance].screenColNum-1 inComponent:2 animated:NO];
        UIPopoverPresentationController *alertPopoverPresentationController = alertController.popoverPresentationController;
        alertPopoverPresentationController.sourceRect = CGRectMake(sender.frame.origin.x-22, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
        alertPopoverPresentationController.sourceView = sender;
        
        [self showDetailViewController:alertController sender:sender];
    }
}

#pragma mark
#pragma mark UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:self.colScreen]) {
        return [Data instance].screenRowNum;
    }else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.colScreen]) {
        return [Data instance].screenColNum;
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
        width = collectionView.frame.size.width / [Data instance].screenColNum - 2;
        height = collectionView.frame.size.height / [Data instance].screenRowNum - 2;
    }else {
        width = collectionView.frame.size.width / [ARRAY_SCREEN_MENU count] -10;
        height = collectionView.frame.size.height - 2;
    }
    return CGSizeMake(width, height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark uitableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ARRAY_PICTURE count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScreenPictureTableViewCell"];
    if(!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScreenPictureTableViewCell" owner:self options:nil];
        if ([nib count]>0){
            cell = [nib objectAtIndex:0];
        }
    }
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.lbTitle.text = [ARRAY_PICTURE objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerView Delegate method
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 7) {
        return 3;
    }
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 4) {
        return [ARRAY_SOURCE_INPUT count];
    }
    else if (pickerView.tag == 6) {
        return [ARRAY_PLAN count];
    }
    else if (pickerView.tag == 7) {
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
    label.textAlignment = NSTextAlignmentCenter;
    if (pickerView.tag == 4) {
        label.text = [ARRAY_SOURCE_INPUT objectAtIndex:row];
    }
    else if (pickerView.tag == 6) {
        label.text = [ARRAY_PLAN objectAtIndex:row];
    }
    else if (pickerView.tag == 7) {
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%d",(int)row+1];
            label.textAlignment = NSTextAlignmentRight;
        } else if (component == 1) {
            label.text = @"X";
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
