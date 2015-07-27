#import <Foundation/Foundation.h>
@import UIKit;

// Convenient names for application/background thread getters
#define BACKGROUND_THREAD (dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
#define APPLICATION_THREAD (dispatch_get_main_queue())


@interface UIColor (ExtraColors)
+ (UIColor *)cornellRedColor;
+ (UIColor *)cornellTanColor;
+ (UIColor *)cornellGrayColor;
@end


@interface UIViewController (Alerts)

/** Display an alert to the user explaining any network/menu errors encountered. */
- (void)displayAlertForError:(NSError *)error withHandler:(void (^)(void))handler;

@end
