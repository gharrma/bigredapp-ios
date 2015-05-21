#import <Foundation/Foundation.h>

// Convenient names for application/background thread getters
#define BACKGROUND_THREAD (dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
#define APPLICATION_THREAD (dispatch_get_main_queue())

// Useful error identifiers
#define JSON_ERROR (@"Malformed JSON object")
#define NO_MENU_FOUND (@"No menu found")
#define NETWORK_ERROR (@"Network error")

@import UIKit;
@interface UIColor (ExtraColors)
+ (UIColor *)cornellRedColor;
+ (UIColor *)cornellTanColor;
@end

@interface NSDate (ExtraDateFormats)
+ (NSAttributedString *)getLatestUpdateString;
@end
