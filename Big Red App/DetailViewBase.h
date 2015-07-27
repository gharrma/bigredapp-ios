#import <UIKit/UIKit.h>

#define DETAIL_TABLE_MARGIN 11.0


@interface DetailViewBase : UITableViewController {
    NSString *locationID, *locationName;
    
    /** Indicates initial loading of the view contents. */
    UIActivityIndicatorView *activityIndicator;
}

/** Select a new dining location, and request its menu/info. */
- (void)showDetailForLocation:(NSString *)location;

/** Return a text view suitable for display inside a table cell. */
- (UITextView *)formattedCellTextView;

@end
