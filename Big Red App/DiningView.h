#import "DetailViewBase.h"
#import <UIKit/UIKit.h>


/** Encapsulates the name and category of a single menu item. */
@interface MenuItem : NSObject
@property (readonly) NSString *name, *category;

- (id)initWithName:(NSString *)name category:(NSString *)category;

@end

/** Contains the items on a menu for a single meal. */
@interface Menu : NSObject
@property bool closed;

- (void)addMenuItem:(MenuItem *)menuItem;
- (MenuItem *)menuItemForIndex:(int)index;
- (int)menuItemCount;

@end


/** Controls the table that displays the menu for a particular dining location. */
@interface DiningView : DetailViewBase
@end
