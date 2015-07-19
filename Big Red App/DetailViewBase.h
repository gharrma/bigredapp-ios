#import <UIKit/UIKit.h>

@interface DetailViewBase : UITableViewController {
    NSString *locationID, *locationName;
    
    /** Indicates initial loading of the view contents. */
    UIActivityIndicatorView *activityIndicator;
}

/** Select a new dining location, and request its menu/info. */
- (void)showDetailForLocation:(NSString *)location;

@end
