

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
//#import "SVProgressHUD.h"

#define LOADING_DIALOG_BG [UIColor colorWithRed:218.0/255 green:97.0/255 blue:0.0/255 alpha:0.8]

@interface Dialog : NSObject<MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

+ (Dialog *)Instance;
+ (void)showProgress:(UIViewController *)controller;
+ (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText;
+ (void)hideProgress;

//提示对话框
+ (void)alert:(NSString *)message;
+ (void)alertWithDelegate:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate;
+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (void)alertWithTitleAndDelegate:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate;
+ (void)alertWithYesNoOption:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate;

//类似于Android一个显示框效果
+ (void)toast:(UIViewController *)controller withMessage:(NSString *) message;
+ (void)toast:(NSString *)message;
//+ (void)simpleToast:(NSString *)message;
//+ (void)hideSimpleToast;
//显示在屏幕中间
+ (void)toastCenter:(NSString *)message;
//带进度条
+ (void)progressToast:(NSString *)message;

//带遮罩效果的进度条
- (void)gradient:(UIViewController *)controller seletor:(SEL)method;

//显示遮罩
- (void)showProgress:(UIViewController *)controller;

//关闭遮罩
- (void)hideProgress;

//带说明的进度条
- (void)progressWithLabel:(UIViewController *)controller seletor:(SEL)method;

//显示带说明的进度条
- (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText;
- (void)showCenterProgressWithLabel:(NSString *)labelText;
+(void)hideAllHud;
@end
