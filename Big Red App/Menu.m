#import "Menu.h"


@implementation MenuItem

- (id)initWithName:(NSString *)name category:(NSString *)category {
    self = [super init];
    if (self) {
        _name = name;
        _category = category;
    }
    return self;
}

@end


@interface Menu () {
    NSMutableArray *menuItems;
}
@end

@implementation Menu

- (id)init {
    self = [super init];
    if (self) {
        _closed = false;
        menuItems = [NSMutableArray new];
    }
    return self;
}

- (void)addMenuItem:(MenuItem *)menuItem {
    [menuItems addObject:menuItem];
}

- (MenuItem *)menuItemForIndex:(int)index {
    return [menuItems objectAtIndex:index];
}

- (int)menuItemCount {
    return [menuItems count];
}


@end
