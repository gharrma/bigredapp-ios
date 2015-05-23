#import <UIKit/UIKit.h>


/** Controls the table that displays the menu for a particular dining location. */
@interface MenuViewController : UITableViewController

/** Select a new dining location, and request its menu. */
- (void)showMenuForLocation:(NSString *)location;

@end
