#import "DiningView.h"
#import "JSONRequests.h"
#import "Tools.h"
#import "NameFormatter.h"

#define MENU_ITEM_CELL_HEIGHT 20.0
#define CLOSED_CELL_HEIGHT 32.0
#define LOCATION_CELL_HEIGHT 45.0


#pragma mark - Dining View

@interface DiningView () {
    /** Dictionary of menus keyed with meal names. */
    NSDictionary *menus;
    
    /** Text view containing description for current location. */
    UITextView *description;
}
@end

@implementation DiningView

#pragma mark - Initialization

NSArray *meals;
+ (void)initialize {
    meals = @[@"Breakfast", @"Lunch", @"Dinner"]; // TODO: Brunch?
}

// Initial setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    description = [self formattedCellTextView];
    [self.refreshControl addTarget:self action:@selector(requestMenuIgnoreCache) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Data updates

- (void)showDetailForLocation:(NSString *)location {
    [super showDetailForLocation:location];
    [activityIndicator startAnimating];
    [self requestMenuWithCache:YES];
}

/** Called by refresh control. */
- (void)requestMenuIgnoreCache {
    [self requestMenuWithCache:NO];
}

/** Fetch the menu on a background thread, and update view when done. */
- (void)requestMenuWithCache:(BOOL)useCache {
    dispatch_async(BACKGROUND_THREAD, ^{
        
        // Fetch menu from API
        NSError *menuError = nil, *descriptionError = nil;
        NSDictionary *updatedMenus = [JSONRequests fetchMenusForDiningLocation:locationID error:&menuError useCache:useCache];
        NSString *descriptionText = [JSONRequests fetchDescriptionForLocation:locationID error:&descriptionError];
        
        // Update view or report error
        dispatch_async(APPLICATION_THREAD, ^{
            if (menuError) [self displayAlertForError:menuError withHandler:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            else menus = updatedMenus;
            
            if (!descriptionError)
                description.text = descriptionText;
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [activityIndicator stopAnimating];
        });
    });
}

#pragma mark - Display and interaction

// Provide a particular cell to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    // Meal menus
    if (indexPath.section < [meals count]) {
        Menu *menu = [menus objectForKey:[meals objectAtIndex:(indexPath.section)]];
        NSString *cellType = menu.closed ? @"ClosedCell" : @"MenuItemCell";
        NSString *cellText = menu.closed ? @"Closed" : [menu menuItemForIndex:(int)indexPath.row].name;
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
        cell.textLabel.text = cellText;
        cell.textLabel.textColor = [UIColor cornellGrayColor];
    }
    
    // Description
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
        description.frame = CGRectMake(cell.contentView.bounds.origin.x + DETAIL_TABLE_MARGIN,
                                    cell.contentView.bounds.origin.y,
                                    cell.contentView.bounds.size.width - DETAIL_TABLE_MARGIN * 2,
                                    cell.contentView.bounds.size.height);
        [cell.contentView addSubview:description];
    }
    
    cell.backgroundColor = [UIColor cornellTanColor];
    
    return cell;
}

// Provide the height of a particular cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [meals count]) {
        Menu *menu = [menus objectForKey:[meals objectAtIndex:(indexPath.section)]];
        return menu.closed ? CLOSED_CELL_HEIGHT : MENU_ITEM_CELL_HEIGHT;
    } else {
        CGSize size = [description sizeThatFits:CGSizeMake(self.tableView.bounds.size.width - DETAIL_TABLE_MARGIN * 2, FLT_MAX)];
        return size.height;
    }
}

// Provide number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [meals count]) {
        Menu *menu = [menus objectForKey:[meals objectAtIndex:(section)]];
        return menu.closed ? 1 : [menu menuItemCount];
    }
    else return 1; // description section
}

// Provide number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sections = 0;
    if (menus) {
        sections += [meals count];
        if ([description.text length] > 0) {
            sections += 1;
        }
    }
    
    return sections;
}

// Provide section titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < [meals count])
        return [meals objectAtIndex:section];
    else
        return @"Description";
}

@end


#pragma mark - Menu Data Types

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
    if (self = [super init]) {
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
    return (int)[menuItems count];
}

@end
