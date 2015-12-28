#import <UIKit/UIKit.h>

#define DETAIL_TABLE_MARGIN 11.0


@interface DetailViewBase : UITableViewController {
    NSString *locationID, *locationName;
    
    /** Indicates initial loading of the view contents. */
    UIActivityIndicatorView *activityIndicator;
    
    /** Displays the date of the information displayed in the detail view. */
    UILabel *headerDetailLabel;
}

/** Select a new dining location, and request its menu/info. */
- (void)showDetailFor:(NSString *)location withHeaderDetail:(BOOL)hasHeaderDetail;

/** Return a text view suitable for display inside a table cell. */
- (UITextView *)formattedCellTextView;

@end
