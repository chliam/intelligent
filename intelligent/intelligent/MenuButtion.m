//
//  MenuButtion.m
//  intelligent
//
//  Created by chliam on 15/4/23.
//  Copyright (c) 2015年 chliam. All rights reserved.
//

#import "MenuButtion.h"

@implementation MenuButtion
{
    UIImageView *mBgImageView;
    UIImageView *mMenuImageVIew;
    UILabel *mTitleLabel;
    UIView *mOverlayView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat mWidth=self.frame.size.width;
    CGFloat mHeight=self.frame.size.height;
    mBgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight)];
    mBgImageView.contentMode=UIViewContentModeScaleAspectFill;
    mBgImageView.image=[UIImage imageNamed:@"bg_menu"];
    mMenuImageVIew=[[UIImageView alloc] initWithFrame:CGRectMake((mWidth-112)/2, 20, 112, 112)];
    mMenuImageVIew.contentMode=UIViewContentModeScaleAspectFit;
    mMenuImageVIew.image=[UIImage imageNamed:@"menu2"];
    mTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 126, mWidth, 30)];
    mTitleLabel.textColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    mTitleLabel.textAlignment=NSTextAlignmentCenter;
    mTitleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:24];
    mTitleLabel.text=@"居室控制";
    self.titleLabel.text=@"";
    [self addSubview:mBgImageView];
    [self addSubview:mMenuImageVIew];
    [self addSubview:mTitleLabel];
    
    mOverlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight)];
    mOverlayView.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
    [self addSubview:mOverlayView];
    mOverlayView.alpha=0;
    
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
}

-(void)initTitleAndImg:(NSString*)title imgName:(NSString*)imgName
{
    if (mMenuImageVIew) {
        mMenuImageVIew.image=[UIImage imageNamed:imgName];
    }
    if (mTitleLabel) {
        mTitleLabel.text=title;
    }
}

-(void)btnClick:(id)sender
{
    mOverlayView.alpha=1.0;
    [UIView animateWithDuration:0.05 animations:^{
        mOverlayView.alpha=0.0;
    }];
}

@end
