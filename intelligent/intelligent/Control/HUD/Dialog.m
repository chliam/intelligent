
#import "Dialog.h"
#import "MBProgressHUD.h"
#import <unistd.h>
//#import "SPAppDelegate.h"
//#import ""

@implementation Dialog

static Dialog *instance = nil;

+ (Dialog *)Instance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [self new];
        }
    }
    return instance;
}

+ (void)showProgress:(UIViewController *)controller
{
    [[Dialog Instance] showProgress:controller withLabel:@"Loading.."];
}

+ (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText
{
    [[Dialog Instance] showProgress:controller withLabel:labelText];
}

+ (void)hideProgress
{
    [[Dialog Instance] hideProgress];
}

+ (void)alert:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"消息"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
    
}

+ (void)alertWithDelegate:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate{
    UIAlertView *mAlertView = [[UIAlertView alloc] initWithTitle:@"消息"
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    mAlertView.tag =tag;
    [mAlertView show];
    
    
}

+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

+ (void)alertWithTitleAndDelegate:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate{
    UIAlertView *mAlertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    mAlertView.tag =tag;
    [mAlertView show];
}

+ (void)alertWithYesNoOption:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate{
    UIAlertView *mAlertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:@"NO"
                                               otherButtonTitles:@"YES", nil];
    mAlertView.tag =tag;
    [mAlertView show];
}

+ (void)toast:(UIViewController *)controller withMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (void)toast:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.color = LOADING_DIALOG_BG;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (void)toastCenter:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = -20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (void)progressToast:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDAnimationZoomOut;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = -20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+(void)hideAllHud{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)gradient:(UIViewController *)controller seletor:(SEL)method {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    //	HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

- (void)showProgress:(UIViewController *)controller {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.userInteractionEnabled = NO;
    //    HUD.dimBackground = YES;
    HUD.color = LOADING_DIALOG_BG;
    HUD.delegate = self;
    [HUD show:YES];
}

- (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.delegate = self;
    //    HUD.dimBackground = YES;
    HUD.color = LOADING_DIALOG_BG;
    HUD.labelText = labelText;
    [HUD show:YES];
}

- (void)showCenterProgressWithLabel:(NSString *)labelText
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    HUD = [[MBProgressHUD alloc] initWithView:window];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    // HUD.dimBackground = YES;
    HUD.color = LOADING_DIALOG_BG;
    HUD.userInteractionEnabled = NO;
    HUD.labelText = labelText;
    [HUD show:YES];
}

- (void)hideProgress {
    [HUD hide:YES];
}

- (void)progressWithLabel:(UIViewController *)controller seletor:(SEL)method {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.delegate = self;
    //HUD.labelText = @"数据加载中...";
    [HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
    sleep(3);
}

- (void)myProgressTask {
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
}

- (void)myMixedTask {
    sleep(2);
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Progress";
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Cleaning up";
    sleep(2);
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Completed";
    sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    expectedLength = [response expectedContentLength];
    currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    currentLength += [data length];
    HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
