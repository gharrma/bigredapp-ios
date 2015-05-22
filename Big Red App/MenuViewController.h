#import <UIKit/UIKit.h>


@interface MenuViewController : UITableViewController

/** Select a new dining location, and request its menu. */
- (void)showMenuForLocation:(NSString *)location;

@end
