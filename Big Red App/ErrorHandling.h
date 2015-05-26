#import <Foundation/Foundation.h>
@import UIKit;


enum CustomErrors {
    JSON_ERROR, NO_MENU_FOUND
};

@interface NSError (ExtraErrors)
+ (NSError *)jsonError;
+ (NSError *)noMenuFound;
@end


@interface ErrorHandling : NSObject

/** Display an alert to the user explaining any network/menu errors encountered. */
+ (void)displayAlertForError:(NSError *)error fromViewController:(UIViewController *)viewController;

@end
