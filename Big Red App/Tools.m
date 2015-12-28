#import "Tools.h"
@import UIKit;


static UIColor *cornellRed, *cornellTan, *cornellGray;

@implementation UIColor (ExtraColors)
+ (UIColor *)cornellRedColor {
    // #b31b1b
    if (!cornellRed) cornellRed = [UIColor colorWithRed:179.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0];
    return cornellRed;
}
+ (UIColor *)cornellTanColor {
    // Officially this should be #d8d2c9, but it looks better a bit brighter
    if (!cornellTan) cornellTan = [UIColor colorWithRed:226.0/255.0 green:218.0/255.0 blue:207.0/255.0 alpha:1.0];
    return cornellTan;
}
+ (UIColor *)cornellGrayColor {
    // #222222
    if (!cornellGray) cornellGray = [UIColor colorWithWhite:34.0/255.0 alpha:1.0];
    return cornellGray;
}
@end


@implementation UIViewController (Alerts)

- (void)displayAlertForError:(NSError *)error withHandler:(void (^)(void))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hmmm :/" message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *__strong action) { if (handler) handler(); }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
