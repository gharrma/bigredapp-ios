#import "Menu.h"


/** Keeps a list of menu items for a particular meal.
    Menu items (represented as strings) are kept in arrays representing food categories. 
    These arrays are held in the itemGroups ivar, accessed by the group name (e.g. "Soup Station"). */
@implementation Menu

- (id)init {
    self = [super init];
    if (self) {
        self.closed = false;
        self.itemGroups = [NSMutableDictionary new];
    }
    return self;
}

@end
